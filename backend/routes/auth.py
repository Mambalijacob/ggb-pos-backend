from flask import Blueprint, request, jsonify
from backend.models.db import db
from backend.models.user import User
from werkzeug.security import generate_password_hash, check_password_hash
from flask_jwt_extended import create_access_token

auth_bp = Blueprint("auth", __name__)

@auth_bp.route("/register", methods=["POST"])
def register():
    data = request.json

    if User.query.filter_by(username=data["username"]).first():
        return jsonify({"error": "User exists"}), 409

    user = User(
        username=data["username"],
        password=generate_password_hash(data["password"]),
        role="cashier"
    )

    db.session.add(user)
    db.session.commit()

    return jsonify({"message": "Registered"})


@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.json

    user = User.query.filter_by(username=data["username"]).first()

    if user and check_password_hash(user.password, data["password"]):
        token = create_access_token(identity=str(user.id))
        return jsonify({"access_token": token})

    return jsonify({"error": "Invalid credentials"}), 401