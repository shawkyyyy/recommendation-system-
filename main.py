import os
import json
import numpy as np
import pandas as pd
import pymysql
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
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

cursor.execute("""
SELECT book.id, book.bookTitle, author.authorName, genre.genreName, book.editionNumber, book.numberOfPages, book.copyWriteYear
FROM book
JOIN books_authors ON book.id = books_authors.bookId
JOIN author ON books_authors.authorId = author.id
JOIN books_genres ON book.id = books_genres.bookId
JOIN genre ON books_genres.genreId = genre.id
JOIN book_stock ON book_stock.bookId = book.id
LEFT JOIN reservation ON reservation.bookStockId = book_stock.id
WHERE book_stock.bookStock > 0
""")
# Load the book data into a pandas DataFrame
book_data = pd.DataFrame(cursor.fetchall(), columns=['id', 'title', 'author', 'category', 'edition_number', 'num_pages', 'copywrite_year'])

# Preprocess the dataset
cm = CountVectorizer().fit_transform(
    book_data['title'] + ' ' + book_data['author'] + ' ' + book_data['category'])
cs = cosine_similarity(cm)

# Define the decision tree model
dt_model = DecisionTreeClassifier()

# Define the k-NN model
knn_model = KNeighborsClassifier(n_neighbors=5)

# Define the API endpoint to get book recommendations
@app.route('/get_books', methods=['POST'])
def get_books():
    # Parse the JSON request data
    data = request.get_json()
    user_id = data.get('user_id')
    algorithm = data.get('algorithm')

    # Fetch the borrowing history for the user
    cursor.execute("""
        SELECT book.id, book.bookTitle, author.authorName, genre.genreName, book.editionNumber, book.numberOfPages, book.copyWriteYear
        FROM book
        JOIN books_authors ON book.id = books_authors.bookId
        JOIN author ON books_authors.authorId = author.id
        JOIN books_genres ON book.id = books_genres.bookId
        JOIN genre ON books_genres.genreId = genre.id
        JOIN book_stock ON book_stock.bookId = book.id
        LEFT JOIN reservation ON reservation.bookStockId = book_stock.id
        WHERE reservation.userId = %s AND book_stock.bookStock > 0
    """, (user_id,))
    history_data = cursor.fetchall()

    # Convert the borrowing history data to a list of books with borrowing dates and due dates
    borrowing_history = []
    for row in history_data:
        book = {
            'id': row[0],
            'title': row[1],
            'author': row[2],
            'category': row[3],
            'edition_number': row[4],
            'num_pages': row[5],
            'copywrite_year': row[6],
        }
        borrowing_history.append(book)

    if borrowing_history:
        # User has borrowed books before, recommend books based on the selected algorithm
        if algorithm == 'content-based':
            # Implement the content-based recommendation algorithm
            query_idx = len(borrowing_history) - 1
            query = borrowing_history[query_idx]['title'] + ' ' + borrowing_history[query_idx]['author'] + ' ' + borrowing_history[query_idx]['category']
            query_vec = cm[query_idx]
            sims = cosine_similarity(query_vec, cm).flatten()
            sim_scores = list(zip(range(len(sims)), sims))
            sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
            sim_scores = sim_scores[1:8]
            book_indices = [i for i, _ in sim_scores]
            recommended_books = book_data.iloc[book_indices][['id', 'title', 'author', 'category', 'edition_number', 'num_pages', 'copywrite_year']].to_dict('records')
        elif algorithm == 'decision-tree':
            # Implement the decision tree recommendation algorithm
            features = book_data[['edition_number', 'num_pages', 'copywrite_year']].values
            target = book_data['category'].values
            dt_model.fit(features, target)
            query_feature = np.array([borrowing_history[-1]['edition_number'], borrowing_history[-1]['num_pages'], borrowing_history[-1]['copywrite_year']]).reshape(1, -1)
            predicted_category = dt_model.predict(query_feature)[0]
            recommended_books = book_data[book_data['category'] == predicted_category][['id', 'title', 'author', 'category', 'edition_number', 'num_pages', 'copywrite_year']].head(7).to_dict('records')
        elif algorithm == 'k-nn':
            # Implement the k-NN recommendation algorithm
            features = book_data[['edition_number', 'num_pages', 'copywrite_year']].values
            target = book_data['category'].values
            knn_model.fit(features, target)
            query_feature = np.array([borrowing_history[-1]['edition_number'], borrowing_history[-1]['num_pages'], borrowing_history[-1]['copywrite_year']]).reshape(1, -1)
            predicted_category = knn_model.predict(query_feature)[0]
            recommended_books = book_data[book_data['category'] == predicted_category][['id', 'title', 'author', 'category', 'edition_number', 'num_pages', 'copywrite_year']].head(7).to_dict('records')

        # Combine the list of recommended books with the list of borrowed books
        all_books = borrowing_history + recommended_books

        return jsonify({'books': all_books})
    else:
        # User has not made any reservations before, recommend random books
        cursor.execute(
            "SELECT id, bookTitle,copyWriteYear, subject, editionNumber,numberOfPages FROM book ORDER BY RAND() LIMIT 7")
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
    cursor.execute(
        "SELECT id FROM book_stock WHERE bookId = (SELECT id FROM book WHERE bookTitle = %s) AND bookStock > 0 LIMIT 1",
        (title,))
    book_stock_id = cursor.fetchone()[0]
    cursor.execute(
        "INSERT INTO reservation (userId, bookStockId, reservationDate, dueDate) VALUES (%s, %s, NOW(), NOW() + INTERVAL 7 DAY)",
        (user_id, book_stock_id))
    conn.commit()

    return jsonify({'status': 'success'})

# Define the API endpoint to update the recommendation algorithm configuration
@app.route('/update_config', methods=['POST'])
def update_config():
    # Parse the JSON request data
    data = request.get_json()
    algorithm_id = int(data.get('algorithmId'))

    # Update the configuration settings for the recommendation algorithm
    if algorithm_id == 1:
        # Update configuration settings for content-based recommendation algorithm
        app.config['RECOMMENDATION_ALGORITHM'] = 'content-based'
    elif algorithm_id == 2:
        # Update configuration settings for decision tree recommendation algorithm
        app.config['RECOMMENDATION_ALGORITHM'] = 'decision-tree'
    elif algorithm_id == 3:
        # Update configuration settings for k-NN recommendation algorithm
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
