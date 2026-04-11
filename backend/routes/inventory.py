from flask import Blueprint, request, jsonify
from flask_jwt_extended import jwt_required
from backend.models.db import db
from backend.models.inventory import Inventory

inventory_bp = Blueprint("inventory", __name__)

# ✅ GET ALL INVENTORY (WITH LOW STOCK FLAG)
@inventory_bp.route("/", methods=["GET"])
@jwt_required()
def get_inventory():
    items = Inventory.query.all()

    return jsonify([
        {
            "id": i.id,
            "name": i.name,
            "price": i.price,
            "quantity": i.quantity,
            "low_stock": i.quantity < 10  # 🔥 LOW STOCK FLAG
        } for i in items
    ])


# ✅ ADD NEW ITEM
@inventory_bp.route("/", methods=["POST"])
@jwt_required()
def add_item():
    data = request.json

    if not data.get("name") or not data.get("price"):
        return jsonify({"error": "Name and price required"}), 400

    # Prevent duplicates
    existing = Inventory.query.filter_by(name=data["name"]).first()
    if existing:
        return jsonify({"error": "Item already exists"}), 409

    item = Inventory(
        name=data["name"],
        price=float(data["price"]),
        quantity=int(data.get("quantity", 0))
    )

    db.session.add(item)
    db.session.commit()

    return jsonify({"message": "Item added successfully"})


# ✅ UPDATE ITEM
@inventory_bp.route("/<int:item_id>", methods=["PUT"])
@jwt_required()
def update_item(item_id):
    data = request.json

    item = Inventory.query.get(item_id)
    if not item:
        return jsonify({"error": "Item not found"}), 404

    item.name = data.get("name", item.name)
    item.price = float(data.get("price", item.price))
    item.quantity = int(data.get("quantity", item.quantity))

    db.session.commit()

    return jsonify({"message": "Item updated"})


# ✅ DELETE ITEM
@inventory_bp.route("/<int:item_id>", methods=["DELETE"])
@jwt_required()
def delete_item(item_id):
    item = Inventory.query.get(item_id)

    if not item:
        return jsonify({"error": "Item not found"}), 404

    db.session.delete(item)
    db.session.commit()

    return jsonify({"message": "Item deleted"})


# ✅ LOW STOCK ONLY (FOR ALERTS / AI)
@inventory_bp.route("/low-stock", methods=["GET"])
@jwt_required()
def low_stock_items():
    items = Inventory.query.filter(Inventory.quantity < 10).all()

    return jsonify([
        {
            "id": i.id,
            "name": i.name,
            "quantity": i.quantity
        } for i in items
    ])