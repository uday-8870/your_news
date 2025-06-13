
from flask import Blueprint, request, jsonify
from models import db, Post, User
from flask_jwt_extended import jwt_required, get_jwt_identity
import datetime

post_bp = Blueprint('post', __name__)

@post_bp.route('/post', methods=['POST'])
@jwt_required()
def create_post():
    data = request.json
    user_id = get_jwt_identity()
    new_post = Post(title=data['title'], content=data['content'], image_url=data.get('image_url'), author_id=user_id)
    db.session.add(new_post)
    db.session.commit()
    return jsonify({"message": "Post created"}), 201

@post_bp.route('/posts', methods=['GET'])
def get_posts():
    posts = Post.query.all()
    return jsonify([{
        "id": post.id,
        "title": post.title,
        "content": post.content,
        "image_url": post.image_url,
        "created_at": post.created_at,
        "author_id": post.author_id
    } for post in posts]), 200

@post_bp.route('/post/<int:post_id>', methods=['GET'])
def get_post(post_id):
    post = Post.query.get_or_404(post_id)
    return jsonify({
        "id": post.id,
        "title": post.title,
        "content": post.content,
        "image_url": post.image_url,
        "created_at": post.created_at,
        "author_id": post.author_id
    }), 200
