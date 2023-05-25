import os
import json
import numpy as np
import pandas as pd
import pymysql
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from flask import Flask, jsonify, request
from sklearn.metrics import precision_score, recall_score, f1_score

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

    # Initialize recommended_books as an empty list
    recommended_books = []

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
        WHERE reservation.userId = %s
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
            query = borrowing_history[query_idx]['title'] + ' ' + borrowing_history[query_idx]['author'] + ' ' + \
                    borrowing_history[query_idx]['category']
            query_vec = cm[query_idx]
            sims = cosine_similarity(query_vec, cm).flatten()
            sim_scores = list(zip(range(len(sims)), sims))
            sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
            sim_scores = sim_scores[1:8]
            book_indices = [i for i, _ in sim_scores]
            recommended_books = [book_data.iloc[book_idx].to_dict() for book_idx in book_indices]
        elif algorithm == 'decision-tree':
            # Get the user's last borrowed book
            last_borrowed_book = borrowing_history[-1]

            # Query decision tree model with last_borrowed_book's author, title, and category features
            query_feature = np.array(
                [last_borrowed_book['author'], last_borrowed_book['title'], last_borrowed_book['category']]).reshape(1,
                                                                                                                     -1)
            predicted_id = dt_model.predict(query_feature)[0]

            # Get recommended book(s) based on predicted ID
            recommended_books = book_data[book_data['id'] == predicted_id][
                ['id', 'bookTitle', 'authorName', 'category', 'editionNumber', 'numberOfPages', 'copyWriteYear']].to_dict(
                'records')
        elif algorithm == 'k-nn':
            # Get the user's last borrowed book
            last_borrowed_book = borrowing_history[-1]

            # Query k-NN model with last_borrowed_book's author, title, and category features
            query_feature = np.array(
                [last_borrowed_book['author'], last_borrowed_book['title'], last_borrowed_book['category']]).reshape(1,
                                                                                                                     -1)
            distances, indices = knn_model.kneighbors(query_feature)

            # Get recommended book(s) based on the most similar books
            recommended_books = []
            for i in range(1, len(distances)):
                book_id = book_data.iloc[indices[0][i]]['id']
                book_title = book_data.iloc[indices[0][i]]['bookTitle']
                book_author = book_data.iloc[indices[0][i]]['authorName']
                book_category = book_data.iloc[indices[0][i]]['category']
                book_edition_number = book_data.iloc[indices[0][i]]['editionNumber']
                book_num_pages = book_data.iloc[indices[0][i]]['numberOfPages']
                book_copywrite_year = book_data.iloc[indices[0][i]]['copyWriteYear']
                recommended_books.append(
                    {'id': book_id, 'title': book_title, 'author': book_author, 'category': book_category,
                     'edition_number': book_edition_number, 'num_pages': book_num_pages,
                     'copywrite_year': book_copywrite_year})

        # Combine the list of recommended books with the list of borrowed books
        all_books = recommended_books

        return jsonify({'books': all_books})


    else:

        # User has not made any reservations before, recommend random books

        cursor.execute("SELECT id, bookTitle, copyWriteYear, subject, editionNumber, numberOfPages FROM book ORDER BY RAND() LIMIT 7")

        random_books = [{
            "id": row[0],
            "title": row[1],
            "copyWriteYear": row[2],
            "subject": row[3],
            "editionNumber": row[4],
            "numberOfPages": row[5]

        }
            for row in cursor.fetchall()]

        # Return the recommended books


        # Return the recommended books
        return jsonify({'books': random_books})

def train_models():
    # Split the data into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(cm, book_data['category'], test_size=0.2, random_state=42)

    # Train the decision tree model
    dt_model.fit(X_train, y_train)

    # Train the k-NN model
    knn_model.fit(X_train, y_train)

    # Test the decision tree model
    dt_predictions = dt_model.predict(X_test)
    dt_accuracy = accuracy_score(y_test, dt_predictions)
    dt_precision = precision_score(y_test, dt_predictions, average='weighted')
    dt_recall = recall_score(y_test, dt_predictions, average='weighted')
    dt_f1 = f1_score(y_test, dt_predictions, average='weighted')

    # Test the k-NN model
    knn_predictions = knn_model.predict(X_test)
    knn_accuracy = accuracy_score(y_test, knn_predictions)
    knn_precision = precision_score(y_test, knn_predictions, average='weighted')
    knn_recall = recall_score(y_test, knn_predictions, average='weighted')
    knn_f1 = f1_score(y_test, knn_predictions, average='weighted')

    # Print the decision tree model results
    print(f"Decision Tree Model Results: ")
    print(f"Accuracy: {dt_accuracy}")
    print(f"Precision: {dt_precision}")
    print(f"Recall: {dt_recall}")
    print(f"F1-score: {dt_f1}\n")

    # Print the k-NN model results
    print(f"k-NN Model Results: ")
    print(f"Accuracy: {knn_accuracy}")
    print(f"Precision: {knn_precision}")
    print(f"Recall: {knn_recall}")
    print(f"F1-score: {knn_f1}\n")

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
    train_models() # print decision tree and k-NN model results
    app.run(debug=True) # start the Flask app
