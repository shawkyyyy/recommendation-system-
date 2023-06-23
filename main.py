import os
import json
import numpy as np
import pandas as pd
import pymysql
from sklearn.metrics import accuracy_score
from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.neighbors import KNeighborsClassifier
from sklearn.tree import DecisionTreeClassifier
from flask import Flask, jsonify, request
from sklearn.preprocessing import LabelEncoder
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
book_data = pd.DataFrame(cursor.fetchall(),
                         columns=['id', 'title', 'author', 'category', 'edition_number', 'num_pages', 'copywrite_year'])

label_encoder = LabelEncoder()
book_data['author_encoded'] = label_encoder.fit_transform(book_data['author'])
book_data['category_encoded'] = label_encoder.fit_transform(book_data['category'])

# Preprocess the dataset
model = CountVectorizer()
cm = model.fit_transform(
    book_data['title'] + ' ' + book_data['author_encoded'].astype(str) + ' ' + book_data['category_encoded'].astype(
        str))
cs = cosine_similarity(cm)
# Define the decision tree model
dt_model = DecisionTreeClassifier()

# Define the k-NN model
knn_model = KNeighborsClassifier(n_neighbors=5)

# Split the data into training and testing sets and train the models
X_train, X_test, y_train, y_test = train_test_split(cm, book_data['category'], test_size=0.2, random_state=42)

# Define the parameter grid for the decision tree model
dt_param_grid = {
    'max_depth': [None, 5, 10, 15],
    'min_samples_split': [2, 5, 10],
    'criterion': ['gini', 'entropy']
}
# Perform grid search for the decision tree model
dt_model = DecisionTreeClassifier()
dt_grid_search = GridSearchCV(dt_model, dt_param_grid, scoring='accuracy', cv=5)
dt_grid_search.fit(X_train, y_train)

# Get the best decision tree model and its hyperparameters
best_dt_model = dt_grid_search.best_estimator_
best_dt_params = dt_grid_search.best_params_

# Define the parameter grid for the k-nearest neighbors model
knn_param_grid = {
    'n_neighbors': [3, 5, 7],
    'weights': ['uniform', 'distance']
}

# Perform grid search for the k-nearest neighbors model
knn_model = KNeighborsClassifier()
knn_grid_search = GridSearchCV(knn_model, knn_param_grid, scoring='accuracy', cv=5)
knn_grid_search.fit(X_train, y_train)

# Get the best k-nearest neighbors model and its hyperparameters
best_knn_model = knn_grid_search.best_estimator_
best_knn_params = knn_grid_search.best_params_

# Train the models with the best hyperparameters
best_dt_model.fit(X_train, y_train)
best_knn_model.fit(X_train, y_train)

# Make predictions using the best models
dt_predictions = best_dt_model.predict(X_test)
knn_predictions = best_knn_model.predict(X_test)

dt_model.fit(X_train, y_train)
knn_model.fit(X_train, y_train)


def train_models():
    # Test the decision tree model
    dt_predictions = best_dt_model.predict(X_test)
    dt_accuracy = accuracy_score(y_test, dt_predictions)
    dt_precision = precision_score(y_test, dt_predictions, average='weighted')
    dt_recall = recall_score(y_test, dt_predictions, average='weighted')
    dt_f1 = f1_score(y_test, dt_predictions, average='weighted')

    # Test the k-NN model
    knn_predictions = best_knn_model.predict(X_test)
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
            query = ''
            for book in borrowing_history:
                query += book['title'] + ' ' + book['author'] + ' ' + book['category'] + ' '

            query_vec = cm[len(borrowing_history) - 1]
            sims = cosine_similarity(query_vec, X_train).flatten()
            sim_scores = list(zip(range(len(sims)), sims))
            sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
            sim_scores = sim_scores[:7]  # Change the number of recommended books if needed
            book_indices = [i for i, _ in sim_scores]
            recommended_books = [book_data.iloc[book_idx].to_dict() for book_idx in book_indices]
        elif algorithm == 'decision-tree':
            # Get the unique set of borrowed books from the borrowing history
            unique_borrowed_books = [dict(t) for t in {tuple(book.items()) for book in borrowing_history}]

            if unique_borrowed_books:
                # Get the last borrowed book from the unique set of borrowed books
                last_borrowed_book = unique_borrowed_books[-1]

                # Query decision tree model with last_borrowed_book's author, title, and category features
                query_feature = [last_borrowed_book['author'] + ' ' + last_borrowed_book['title'] + ' ' + last_borrowed_book['category'] + ' ']
                query_feature = model.transform(query_feature)

                predicted_category = dt_model.predict(query_feature)[0]

                # Get recommended book(s) based on predicted category, excluding those already borrowed
                recommended_books = book_data[(book_data['category'] == predicted_category) & (
                    ~book_data['id'].isin([book['id'] for book in unique_borrowed_books]))][
                    ['id', 'title', 'author', 'category', 'edition_number', 'num_pages',
                     'copywrite_year']].drop_duplicates().head(7).to_dict('records')


        elif algorithm == 'k-nn':
            # Get the unique set of borrowed books from the borrowing history
            unique_borrowed_books = [dict(t) for t in {tuple(book.items()) for book in borrowing_history}]

            if unique_borrowed_books:
                # Get the last borrowed book from the unique set of borrowed books
                last_borrowed_book = unique_borrowed_books[-1]

                # Query k-NN model with last_borrowed_book's author, title, and category features
                query_feature = [last_borrowed_book['author'] + ' ' + last_borrowed_book['title'] + ' ' + last_borrowed_book['category'] + ' ']
                query_feature = model.transform(query_feature)

                distances, indices = knn_model.kneighbors(query_feature)

                # Get recommended book(s) based on the most similar books, excluding those already borrowed
                recommended_books = []
                for i in range(1, len(indices[0])):
                    book_idx = indices[0][i]
                    book_info = book_data.iloc[book_idx]
                    book_dict = book_info.to_dict()
                    if book_dict['id'] not in [book['id'] for book in unique_borrowed_books]:
                        recommended_books.append(book_dict)

                # If no new recommendations are available, recommend popular books instead
                if len(recommended_books) == 0:
                    popular_books = book_data.groupby('id').size().nlargest(5).index.tolist()
                    recommended_books = [book_data[book_data['id'] == book_id].to_dict('records')[0] for book_id in
                                         popular_books]

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
        return jsonify({'books': random_books})



# Serve the React.js app
@app.route("/", defaults={"path": ""})
@app.route("/<path:path>")
def serve(path):
    if path != "" and os.path.exists(app.static_folder + "/" + path):
        return app.send_static_file(path)
    else:
        return app.send_static_file("index.html")


if __name__ == '__main__':
    train_models()  # print decision tree and k-NN model results
    app.run(debug=True)  # start the Flask appy
