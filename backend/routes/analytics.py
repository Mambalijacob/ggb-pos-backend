from flask import Blueprint, jsonify
from backend.models.db import db
from backend.models.sale import Sale
from backend.models.expense import Expense
from sqlalchemy import func

analytics_bp = Blueprint("analytics", __name__)

@analytics_bp.route("/summary")
def summary():
    total_sales = db.session.query(func.sum(Sale.total)).scalar() or 0
    total_expenses = db.session.query(func.sum(Expense.amount)).scalar() or 0

    return jsonify({
        "sales": total_sales,
        "expenses": total_expenses,
        "profit": total_sales - total_expenses
    })


@analytics_bp.route("/daily_trend")
def trend():
    data = (
        db.session.query(func.date(Sale.created_at), func.sum(Sale.total))
        .group_by(func.date(Sale.created_at))
        .all()
    )

    return jsonify([
        {"date": str(d[0]), "sales": float(d[1])}
        for d in data
    ])