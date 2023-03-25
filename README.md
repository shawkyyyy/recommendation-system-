# Introduction
This program is a Python Flask application that provides book recommendations and allows users to borrow books. It uses a dataset of books that includes information such as the title, author, book category, and book description. The program preprocesses the dataset by combining features, one-hot encoding book categories, and calculating cosine similarity scores for content-based recommendation. It then trains a decision tree and a KNN model using the one-hot encoded book categories as features. The program provides API endpoints that allow users to borrow books, get their borrowing history, and get book recommendations based on their borrowing history. The program uses Flask, pandas, numpy, scikit-learn, and other Python libraries to implement these functionalities.

# Libraries

Flask: A micro web framework for building web applications in Python.

pandas: A library for data manipulation and analysis. It provides data structures and functions for working with structured data, including tabular data.

numpy: A library for numerical computation in Python. It provides functions for working with arrays and matrices, as well as mathematical functions and random number generation.

scikit-learn: A library for machine learning in Python. It provides a wide range of machine learning algorithms and tools for data preprocessing, model selection, and evaluation.

To download these libraries, you can use pip, which is a package manager for Python. Here are the commands to download the libraries:

Flask: pip install Flask

pandas: pip install pandas

numpy: pip install numpy

scikit-learn: pip install scikit-learn


# Database 
The dataset used in the Python Flask application is a collection of books that includes information such as the book title, author, book category, book description and book_id. The dataset is in CSV format and is loaded into a pandas DataFrame object in the application.
In order to use the dataset for machine learning models and book recommendations, the dataset is preprocessed in the Python Flask application. The preprocessing steps include:

#### Combining Features: The title, author, BookCategory, and Book_Description columns are combined into a single column called combined_features. This is done to create a bag of words representation of the text data.

#### One-Hot Encoding: The BookCategory column is one-hot encoded, creating a set of new columns for each book category with binary values indicating whether a book belongs to that category or not. This is done to convert categorical data into numerical data that can be used in machine learning models.

#### Calculating Cosine Similarity Scores: The combined_features column is used to calculate cosine similarity scores between each pair of books in the dataset. Cosine similarity is a measure of similarity between two vectors, and in this case, it is used to measure the similarity between the bag of words representations of the book descriptions.

The preprocessed dataset is used to train machine learning models for book recommendations, including a decision tree and a KNN model. The one-hot encoded book categories are used as features in these models, and they are trained to predict the book categories of new books based on their features. The cosine similarity scores are used to provide content-based recommendations to users, based on the similarity between their borrowing history and the book descriptions in the dataset.

# Flask Routes

### /get_books - GET method:

This route is used to get book recommendations for a user.
The route expects a JSON request with a user_id field that contains the ID of the user for whom recommendations are being requested.
If the user has borrowed books before, the route calls the get_last_borrowed_recommendations function to get recommendations based on the last book they borrowed.
If the user has not borrowed any books before, the route generates random recommendations using the recommend_books function and the Decision Tree algorithm.
The recommended books are returned as a JSON response.

```
{
    "user_id": 1
    }

```

```
Output:
{
    "recommended_books": [
        [
            "A Clash of Kings (A Song of Ice and Fire #2)",
            0.6388698797869515
        ],
        [
            "The Name of God is Mercy",
            0.635667270027247
        ],
        [
            "The Book of Mormon",
            0.6342504698290696
        ],
        [
            "Becoming Wise: An Inquiry into the Mystery and Art of Living",
            0.6305405544650841
        ],
        [
            "The Age of Genius: The Seventeenth Century and the Birth of the Modern Mind",
            0.6304301557490736
        ]
    ]
}
```


### /borrow - POST method:

This route is used to borrow a book.
The route expects a JSON request with user_id, title, and BookCategory fields that contain the ID of the user borrowing the book, the title of the book being borrowed, and the book category of the book being borrowed, respectively.
The history DataFrame is updated with the borrowed book information.
A success message is returned as a JSON response.

```
{
    "user_id": 1,
    "title": "The Black Maria"
    }

```

```
Output:
{
    "message": "Book borrowed successfully."
}
```


### /post_history - POST method:

This route is used to get the borrowing history of a user.
The route expects a JSON request with a user_id field that contains the ID of the user whose borrowing history is being requested.
The history DataFrame is filtered to only include rows where the user_id matches the requested user ID.
The filtered history is returned as a JSON response.
To use these routes, you would need to make requests to the appropriate URL with the appropriate HTTP method and JSON data. For example, to get book recommendations for a user with ID 123, you would send a GET request to the URL http://localhost:5000/get_books with a JSON payload of { "user_id": "123" }. The Flask application would then return a JSON response with a list of recommended books.

```
{
    "user_id": 1
    
    }



```

```
Output:
[{"user_id":1,"title":"Olio","BookCategory":"Crime, Thriller & Mystery"},{"user_id":1,"title":"The Black
Maria","BookCategory":null}]
```

# How to run the project?
1. Clone or download the project repository to your local machine.
2. Install all the required libraries mentioned in the requirements.txt file with the command pip install -r requirements.txt.
3. Make sure that you have the necessary data files and resources required by the application, such as the book dataset and any API keys required for external services.
4. Open a terminal or command prompt and navigate to the project directory.
5. Run the Flask application by executing the command python app.py or flask run.
6. Once the application starts running, go to your browser and type in the URL provided by Flask, usually http://127.0.0.1:5000/.
7. The application should now be up and running, and you can use it by interacting with the user interface or calling the API endpoints programmatically.

