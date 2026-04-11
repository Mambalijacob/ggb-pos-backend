from flask import Blueprint, request, jsonify
from backend.models.db import db
from backend.models.expense import Expense
from flask_jwt_extended import jwt_required

expenses_bp = Blueprint("expenses", __name__)

@expenses_bp.route("/", methods=["POST"])
@jwt_required()
def add_expense():
    data = request.json

    expense = Expense(
        title=data["title"],
        amount=data["amount"]
    )

    db.session.add(expense)
    db.session.commit()

    return jsonify({"message": "Expense added"})


@expenses_bp.route("/", methods=["GET"])
@jwt_required()
def get_expenses():
    data = Expense.query.all()

    return jsonify([
        {"title": e.title, "amount": e.amount}
        for e in data
    ])