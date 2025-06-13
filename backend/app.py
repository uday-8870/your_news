from flask import Flask, jsonify, request
from flask_cors import CORS
from datetime import datetime # Import datetime

app = Flask(__name__)
CORS(app)

# In-memory storage for posts (reset every time server restarts)
# Added 'id' and 'created_at' for consistency with Flutter model
posts = [
    {
        "id": 1,
        "title": "First News",
        "content": "This is the first post",
        "imageUrl": "https://via.placeholder.com/150",
        "created_at": datetime.utcnow().isoformat() + 'Z' # ISO format with Z for UTC
    },
    {
        "id": 2,
        "title": "Second News",
        "content": "This is the second post",
        "imageUrl": "https://via.placeholder.com/150",
        "created_at": datetime.utcnow().isoformat() + 'Z'
    }
]

# Dummy login for demonstration purposes
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if data.get('email') == 'admin@example.com' and data.get('password') == 'admin':
        return jsonify({'token': 'valid_token'}), 200
    return jsonify({'error': 'Invalid credentials'}), 401

# Get all posts
@app.route('/posts', methods=['GET'])
def get_posts():
    return jsonify(posts)

# Add a new post
@app.route('/add_post', methods=['POST'])
def add_post():
    data = request.get_json()
    # Assign a simple incremental ID for new posts
    new_id = len(posts) + 1
    post = {
        "id": new_id,
        "title": data.get('title'),
        "content": data.get('content'),
        "imageUrl": data.get('imageUrl', ''),  # Optional, ensure it's handled
        "created_at": datetime.utcnow().isoformat() + 'Z' # Add created_at for new posts
    }
    posts.append(post)
    return jsonify({'message': 'Post added successfully'}), 200

# Run the app
if __name__ == '__main__':
    app.run(debug=True) # Run in debug mode for easier development