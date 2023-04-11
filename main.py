from flask import Flask, request, jsonify, json
import pandas as pd
import numpy as np
from sklearn.preprocessing import OneHotEncoder
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.model_selection import train_test_split
import os

app = Flask(__name__)

# Load the configuration from the config.json file
with open('config.json') as f:
    config = json.load(f)

algorithm = config['algorithm']

dataset = pd.read_csv('C:\dataset.csv')
history_file = 'C:\history.csv'

history = pd.DataFrame(columns=['user_id', 'title', 'BookCategory'])

dataset['features'] = dataset['title'] + ' ' + dataset['author'] + ' ' + dataset['BookCategory'] + ' ' + dataset['Book_Description']

encoder = OneHotEncoder()
book_categories = encoder.fit_transform(dataset[['BookCategory']])
dt_features = book_categories
knn_features = book_categories

cm = CountVectorizer().fit_transform(dataset['features'])
cs = cosine_similarity(cm)

train_df, test_df = train_test_split(dataset, test_size=0.2, random_state=42)

dt_classifier = DecisionTreeClassifier()
dt_classifier.fit(dt_features[train_df.index], train_df['title'])

knn_classifier = KNeighborsClassifier()
knn_classifier.fit(knn_features[train_df.index], train_df['title'])

if os.path.isfile(history_file):
    history = pd.read_csv(history_file)

@app.route('/get_books', methods=['POST'])
def get_books():
    # Parse JSON request data
    data = request.get_json()
    user_id = data['user_id']

    # Check if the user has borrowed books before
    if user_id in history['user_id'].unique():
        # Get recommendations based on the last borrowing
        recommended_books = get_last_borrowed_recommendations(user_id, history)
    else:
        recommended_books = recommend_books('', algorithm, history)

    return jsonify(recommended_books=recommended_books), 200

def get_last_borrowed_recommendations(user_id, history):
    # Get the user's last borrowed book
    last_borrowed_book = history[history['user_id'] == user_id].tail(1)['title'].values[0]

    # Use content-based filtering to recommend similar books
    recommended_books = recommend_books(last_borrowed_book, 'content_based', history)

    return recommended_books

def recommend_books(title, algorithm, history):
    # Initialize an empty list to store recommended books
    recommended_books = []

    # Get the index of the book with the given title
    book_index = dataset[dataset['title'] == title].index.values[0]

    if algorithm == 'content_based':
        # Use content-based filtering to recommend similar books
        # Get the cosine similarity scores of the book with other books
        scores = list(enumerate(cs[book_index]))

        # Sort the scores in descending order
        scores = sorted(scores, key=lambda x: x[1], reverse=True)

        # Get the top 10 most similar books
        top_scores = scores[1:11]

        # Get the indices of the top 10 most similar books
        top_indices = [i[0] for i in top_scores]

        # Get the titles of the top 10 most similar books
        recommended_books = list(dataset['title'].iloc[top_indices].values)

    elif algorithm == 'decision_tree':
        # Use Decision Tree to recommend books
        # Get the book category of the given title
        book_category = dataset[dataset['title'] == title]['BookCategory'].values[0]

        # One-hot encode the book category
        book_category_encoded = encoder.transform([[book_category]])

        # Predict the titles of the recommended books using Decision Tree
        predicted_titles = dt_classifier.predict(book_category_encoded)

        # Convert the predicted titles to a list and remove the given title if it is in the list
        recommended_books = list(predicted_titles)
        if title in recommended_books:
            recommended_books.remove(title)

    elif algorithm == 'knn':
        # Use KNN to recommend books
        # Get the book category of the given title
        book_category = dataset[dataset['title'] == title]['BookCategory'].values[0]

        # One-hot encode the book category
        book_category_encoded = encoder.transform([[book_category]])

        # Predict the titles of the recommended books using KNN
        predicted_titles = knn_classifier.kneighbors(book_category_encoded, n_neighbors=11)[1][0][1:]

        # Convert the predicted titles to a list and remove the given title if it is in the list
        recommended_books = list(train_df['title'].iloc[predicted_titles])
        if title in recommended_books:
            recommended_books.remove(title)

    # Return the top 5 recommended books

    return recommended_books[:5]

if __name__ == '__main__':
    app.run(debug=True)



