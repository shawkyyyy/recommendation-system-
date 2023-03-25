from flask import Flask, request, jsonify, json
import pandas as pd
import numpy as np
from sklearn.preprocessing import OneHotEncoder
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.model_selection import train_test_split

app = Flask(__name__)

# Load dataset
dataset = pd.read_csv('C:\dataset.csv')

# Combine features
dataset['features'] = dataset['title'] + ' ' + dataset['author'] + ' ' + dataset['BookCategory'] + ' ' + dataset[
    'Book_Description']

# One-hot encode book categories for Decision Tree and KNN
encoder = OneHotEncoder()
book_categories = encoder.fit_transform(dataset[['BookCategory']])
dt_features = book_categories
knn_features = book_categories

# Create CountVectorizer and calculate cosine similarity for content-based recommendation
cm = CountVectorizer().fit_transform(dataset['features'])
cs = cosine_similarity(cm)

# Split the dataset into training and testing sets
train_df, test_df = train_test_split(dataset, test_size=0.2, random_state=42)

# Train Decision Tree
dt_classifier = DecisionTreeClassifier()
dt_classifier.fit(dt_features[train_df.index], train_df['title'])

# Train KNN
knn_classifier = KNeighborsClassifier()
knn_classifier.fit(knn_features[train_df.index], train_df['title'])

# Initialize empty history dataframe
history = pd.DataFrame(columns=['user_id', 'title', 'BookCategory'])

# Function to get recommendations based on the user's last borrowing
def get_last_borrowed_recommendations(user_id):
    # Get the user's last borrowed book
    last_borrowed_book = history[history['user_id'] == user_id].tail(1)['title'].values[0]

    # Use content-based filtering to recommend similar books
    recommended_books = recommend_books(last_borrowed_book, 'content_based', history)

    # Return recommended books
    return recommended_books


@app.route('/get_books', methods=['GET'])
def get_books():
    # Parse JSON request data
    data = request.get_json()
    user_id = data['user_id']

    # Check if the user has borrowed books before
    if user_id in history['user_id'].unique():
        # Get recommendations based on the last borrowing
        recommended_books = get_last_borrowed_recommendations(user_id)
    else:
        # Generate random recommendations using any algorithm of your choice
        # For example, you can use the Decision Tree algorithm
        recommended_books = recommend_books('', 'decision_tree', history)

    # Return recommended books as a JSON response
    return jsonify({'recommended_books': recommended_books})



@app.route('/borrow', methods=['POST'])
def borrow():
    # Parse JSON request data
    data = request.get_json()
    user_id = data['user_id']
    title = data['title']
    book_category = data['BookCategory']

    # Add borrowed book to the history dataframe
    global history
    history = history.append({'user_id': user_id, 'title': title, 'BookCategory': book_category}, ignore_index=True)

    # Return success message as a JSON response
    return jsonify({'message': 'Book borrowed successfully.'}), 200


@app.route('/post_history', methods=['POST'])
def post_history():
    # Parse JSON request data
    data = request.get_json()
    user_id = data['user_id']

    # Filter history dataframe to get borrowing history for the specified user ID
    user_history = history[history['user_id'] == user_id]

    # Return borrowing history as a JSON response
    return user_history.to_json(orient='records'), 200



def recommend_books(title, algorithm, history):
    # Get book category and encoded features for Decision Tree and KNN
    book_category = dataset.loc[dataset['title'] == title]['BookCategory'].values[0]
    encoded_book_category = encoder.transform([[book_category]])
    dt_row = encoded_book_category.toarray()
    knn_row = encoded_book_category

    # Get book ID for content-based recommendation
    book_id = dataset[dataset.title == title]['book_id'].values[0]

    if algorithm == 'decision_tree':
        # Use Decision Tree to predict similar books and calculate accuracy score
        similar_indices = dt_classifier.predict_proba(dt_row)[0].argsort()[-6:-1][::-1]
        accuracy_scores = dt_classifier.predict_proba(dt_row)[0][similar_indices]
        similar_books = list(dataset.iloc[similar_indices]['title'].values)
        return list(zip(similar_books, accuracy_scores))

    elif algorithm == 'knn':
        # Use KNN to predict similar books and calculate cosine similarity scores
        similar_indices = knn_classifier.kneighbors(knn_row, n_neighbors=6, return_distance=False)[0][1:]
        similarity_scores = cosine_similarity(knn_row, knn_features[similar_indices])[0]
        similar_books = list(dataset.iloc[similar_indices]['title'].values)
        return list(zip(similar_books, similarity_scores))

    elif algorithm == 'content_based':
        # Use content-based recommendation to predict similar books and calculate cosine similarity scores
        scores = list(enumerate(cs[book_id]))
        sorted_scores = sorted(scores, key=lambda x: x[1], reverse=True)
        sorted_scores = sorted_scores[1:]
        similar_books = []
        similarity_scores = []
        j = 0
        for item in sorted_scores:
            book_id = item[0]
            book_title = dataset[dataset.book_id == book_id]['title'].values[0]
            book_category = dataset[dataset.book_id == book_id]['BookCategory'].values[0]
            # Check if the book has been borrowed by the user before and is not the same category as the current book
            if book_title not in history[history['user_id'] == user_id]['title'].values and book_category != dataset.loc[dataset['title'] == title]['BookCategory'].values[0]:
                similar_books.append(book_title)
                similarity_scores.append(item[1])
                j += 1
                if j >= 5:
                    break
        # If there are no recommendations, include borrowed books from the same category
        if len(similar_books) == 0:
            same_category_books = dataset[(dataset.BookCategory == book_category) & (dataset.title != title) & (~dataset.title.isin(history[history['user_id'] == user_id]['title']))].head(5)
            similar_books = list(same_category_books['title'].values)
            similarity_scores = [0] * len(similar_books)
        return list(zip(similar_books, similarity_scores))

    else:
        raise ValueError('Invalid algorithm specified')

user_id = 1
borrowed_title = 'Olio'
borrowed_category = 'Crime, Thriller & Mystery'
history = pd.concat([history, pd.DataFrame({'user_id': [user_id], 'title': [borrowed_title], 'BookCategory': [borrowed_category]})], ignore_index=True)

app.run(debug=True)

