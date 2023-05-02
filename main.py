import json
import os

import numpy as np
import pandas as pd
import pymysql
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.model_selection import train_test_split
from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import OneHotEncoder
from sklearn.tree import DecisionTreeClassifier
from flask import Flask, jsonify, request

# Initialize the Flask app
app = Flask(__name__)

# Load configuration from a file
with open('config.json') as f:
    config = json.load(f)

# Set the algorithm to use
algorithm = config.get('algorithm', 'knn')

# Load the book data from a MySQL database
conn = pymysql.connect(
    host='localhost',
    user='root',
    password='123',
    db='slbms'
)

cursor = conn.cursor()

# Modify the SQL query to include a left join with the "reservation" table
cursor.execute("""
SELECT book.id, book.bookTitle, author.authorName, genre.genreName, book.editionNumber, book.numberOfPages, book.copyWriteYear
FROM book
JOIN books_authors ON book.id = books_authors.bookId
JOIN author ON books_authors.authorId = author.id
JOIN books_genres ON book.id = books_genres.bookId
JOIN genre ON books_genres.genreId = genre.id
JOIN book_stock ON book_stock.bookId = book.id
LEFT JOIN reservation ON reservation.bookStockIdId = book_stock.id
""")

# Load the book data into a pandas DataFrame
book_data = pd.DataFrame(cursor.fetchall(), columns=['id', 'title', 'author', 'category', 'edition_number', 'num_pages', 'copywrite_year'])

# Preprocess the dataset
encoder = OneHotEncoder()
book_categories = encoder.fit_transform(book_data[['category']])
dt_features = book_categories
knn_features = book_categories

cm = CountVectorizer().fit_transform(
    book_data['title'] + ' ' + book_data['author'] + ' ' + book_data['category'])
cs = cosine_similarity(cm)

# Train the models on the entire dataset
dt_classifier = DecisionTreeClassifier()
dt_classifier.fit(dt_features, book_data['title'])

knn_classifier = KNeighborsClassifier()
knn_classifier.fit(knn_features, book_data['title'])

# Load the borrowing history from a CSV file
history_file = 'history.csv'
if os.path.isfile(history_file):
    history = pd.read_csv(history_file)
else:
    history = pd.DataFrame(columns=['user_id', 'title', 'category'])


# Define the API endpoint to get book recommendations
@app.route('/get_books', methods=['POST'])
def get_books():
    # Parse the JSON request data
    data = request.get_json()
    user_id = data.get('user_id')

    # Check if the user has made any reservations before
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM reservation WHERE userIdId = %s", (user_id,))
    reservations = cursor.fetchall()

    if reservations:
        borrow_history = [row[3] for row in reservations]
        borrow_history_idx = [book_data.index[book_data['title'] == book][0] for book in borrow_history]
        borrow_history_scores = np.sum(cs[borrow_history_idx, :], axis=0)
        cf_top_idx = np.argsort(borrow_history_scores)[::-1][:5]
        cf_top_books = list(book_data.iloc[cf_top_idx][['id', 'title', 'author', 'category', 'edition_number', 'num_pages', 'copywrite_year']])

        # Combine the top recommendations from each algorithm
        top_books = cf_top_books
    else:
        # User has not made any reservations before, recommend random books
        cursor.execute("SELECT id, bookTitle,copyWriteYear, subject, editionNumber,numberOfPages FROM book ORDER BY RAND() LIMIT 7")
        random_books = [row for row in cursor.fetchall()]

        top_books = random_books

    # Return the recommended books
    return jsonify({'books': top_books})


# Define the API endpoint to record a book borrowing event
@app.route('/borrow_book', methods=['POST'])
def borrow_book():
    # Parse the JSON request data
    data = request.get_json()
    user_id = data.get('user_id')
    title = data.get('title')
    category = data.get('category')

    # Record the borrowing event in the borrowing history
    history.loc[len(history)] = [user_id, title, category]
    history.to_csv(history_file, index=False)

    return jsonify({'status': 'success'})


if __name__ == '__main__':
    app.run(debug=True)
