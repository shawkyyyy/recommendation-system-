import json
import os

import numpy as np
import pandas as pd
import pymysql
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from flask import Flask, jsonify, request

# Initialize the Flask app
app = Flask(__name__, static_folder="../build", static_url_path="/")

# Load configuration from a file
with open('config.json') as f:
    config = json.load(f)

# Load the book data from a MySQL database
conn = pymysql.connect(
    host=config['db_host'],
    user=config['db_user'],
    password=config['db_password'],
    db=config['db_name']
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
LEFT JOIN reservation ON reservation.bookStockId = book_stock.id
""")

# Load the book data into a pandas DataFrame
book_data = pd.DataFrame(cursor.fetchall(), columns=['id', 'title', 'author', 'category', 'edition_number', 'num_pages', 'copywrite_year'])

# Preprocess the dataset
cm = CountVectorizer().fit_transform(
    book_data['title'] + ' ' + book_data['author'] + ' ' + book_data['category'])
cs = cosine_similarity(cm)

# Define the API endpoint to get book recommendations
@app.route('/get_books', methods=['POST'])
def get_books():
    # Parse the JSON request data
    data = request.get_json()
    user_id = data.get('user_id')

    if app.config['RECOMMENDATION_ALGORITHM'] == 'content-based':
        # Use content-based recommendation algorithm
        # ...
        # Return recommended books using content-based algorithm
        pass
    elif app.config['RECOMMENDATION_ALGORITHM'] == 'decision-tree':
        # Use decision-tree recommendation algorithm
        # ...
        # Return recommended books using decision-tree algorithm
        pass
    elif app.config['RECOMMENDATION_ALGORITHM'] == 'k-nn':
        # Use k-NN recommendation algorithm
        # ...
        # Return recommended books using k-NN algorithm
        pass
    else:
        # Invalid recommendation algorithm selected
        return jsonify({'error': 'Invalid recommendation algorithm selected'})

    # Check if the user has made any reservations before
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM reservation WHERE userId = %s", (user_id,))
    reservations = cursor.fetchall()

    if reservations:
        borrow_history = [row[3] for row in reservations]
        borrow_history_idx = [book_data.index[book_data['title'] == book][0] for book in borrow_history]
        borrow_history_scores = np.sum(cs[borrow_history_idx, :], axis=0)
        cf_top_idx = np.argsort(borrow_history_scores)[::-1][:5]
        cf_top_books = [{
            "id": row[0],
            "bookTitle": row[1],
            "copyWriteYear": row[6],
            "subject": row[3],
            "editionNumber": row[4],
            "numberOfPages": row[5]
        } for row in book_data.iloc[cf_top_idx][['id', 'title', 'author', 'category', 'edition_number', 'num_pages', 'copywrite_year']]]

        # Return the recommended books
        return jsonify({'books': cf_top_books})
    else:
        # User has not made any reservations before, recommend random books
        cursor.execute("SELECT id, bookTitle,copyWriteYear, subject, editionNumber,numberOfPages FROM book ORDER BY RAND() LIMIT 7")
        random_books = [{
            "id": row[0],
            "bookTitle": row[1],
            "copyWriteYear": row[2],
            "subject": row[3],
            "editionNumber": row[4],
            "numberOfPages": row[5]
        } for row in cursor.fetchall()]

        # Return the recommended books
        return jsonify({'books': random_books})

# Define the API endpoint to record a book borrowing event
@app.route('/borrow_book', methods=['POST'])
def borrow_book():
    # Parse the JSON request data
    data = request.get_json()
    user_id = data.get('user_id')
    title = data.get('title')
    category = data.get('category')

    # Record the borrowing event in the reservation table
    cursor = conn.cursor()
    cursor.execute("SELECT id FROM book_stock WHERE bookId = (SELECT id FROM book WHERE bookTitle = %s) AND status = 'AVAILABLE' LIMIT 1", (title,))
    book_stock_id = cursor.fetchone()[0]
    cursor.execute("INSERT INTO reservation (userIdId, bookStockId, reservationDate) VALUES (%s, %s, NOW())", (user_id, book_stock_id))
    conn.commit()

    return jsonify({'status': 'success'})

# Define the API endpoint to update the recommendation algorithm configuration
# Define the API endpoint to update the recommendation algorithm configuration
@app.route('/update_config', methods=['POST'])
def update_config():
    # Parse the JSON request data
    data = request.get_json()
    algorithm_id = int(data.get('algorithmId'))

    # Update the configuration settings for the recommendation algorithm
    if algorithm_id == 1:
        # Update configuration settings for content-based recommendation algorithm
        # ...
        # Change the recommendation algorithm to content-based
        app.config['RECOMMENDATION_ALGORITHM'] = 'content-based'
    elif algorithm_id == 2:
        # Update configuration settings for decision tree recommendation algorithm
        # ...
        # Change the recommendation algorithm to decision tree
        app.config['RECOMMENDATION_ALGORITHM'] = 'decision-tree'
    elif algorithm_id == 3:
        # Update configuration settings for k-NN recommendation algorithm
        # ...
        # Change the recommendation algorithm to k-NN
        app.config['RECOMMENDATION_ALGORITHM'] = 'k-nn'
    else:
        return jsonify({'success': False})

    # Print out the new value of the recommendation algorithm configuration setting
    algorithm = app.config['RECOMMENDATION_ALGORITHM']

    print(f"The recommendation algorithm has been changed to {algorithm}")

    return jsonify({'success': True})

# Serve the React.js app
@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def serve(path):
    if path != "" and os.path.exists(app.static_folder + "/" + path):
        return app.send_static_file(path)
    else:
        return app.send_static_file("index.html")

if __name__ == '__main__':
    app.run(debug=True)
