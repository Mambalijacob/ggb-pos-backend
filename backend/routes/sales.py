from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required
from backend.models.db import db
from backend.models.sale import Sale
from backend.models.inventory import Inventory

sales_bp = Blueprint("sales", __name__)

@sales_bp.route("/", methods=["POST"])
@jwt_required()
def create_sale():
    data = request.json

    total_sum = 0
    errors = []

    for item in data["items"]:
        name = item["name"]
        qty = int(item["qty"])
        price = float(item["price"])

        # 🔍 Find item in inventory
        inventory_item = Inventory.query.filter_by(name=name).first()

        if not inventory_item:
            errors.append(f"{name} not found")
            continue

        # ❌ Check stock
        if inventory_item.quantity < qty:
            errors.append(f"Not enough stock for {name}")
            continue

        # ✅ Deduct stock
        inventory_item.quantity -= qty

        # 💰 Save sale
        total = qty * price

        sale = Sale(
            item=name,
            qty=qty,
            price=price,
            total=total
        )

        total_sum += total
        db.session.add(sale)

    if errors:
        return jsonify({"errors": errors}), 400

    db.session.commit()

    return jsonify({
        "message": "Sale completed",
        "total": total_sum
    })