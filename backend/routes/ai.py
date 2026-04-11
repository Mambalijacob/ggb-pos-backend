from flask import Blueprint, jsonify
from backend.models.db import db
from backend.models.sale import Sale
from backend.models.inventory import Inventory
from sqlalchemy import func

ai_bp = Blueprint("ai", __name__)

@ai_bp.route("/predict")
def predict():
    avg = db.session.query(func.avg(Sale.total)).scalar() or 0
    return jsonify({"predicted_next_day": float(avg)})


@ai_bp.route("/reorder")
def reorder():
    items = Inventory.query.all()

    result = []
    for i in items:
        if i.quantity < 10:
            result.append({
                "item": i.name,
                "stock": i.quantity,
                "action": "Restock"
            })

    return jsonify(result)