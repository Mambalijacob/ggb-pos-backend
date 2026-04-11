from flask import Blueprint, request, jsonify
from backend.models.db import db
from backend.models.sale import Sale

sync_bp = Blueprint("sync", __name__)

@sync_bp.route("/sales", methods=["POST"])
def sync_sales():
    data = request.json

    for item in data["sales"]:
        sale = Sale(
            item=item["item"],
            qty=item["qty"],
            price=item["price"],
            total=item["qty"] * item["price"]
        )
        db.session.add(sale)

    db.session.commit()

    return jsonify({"message": "Synced"})