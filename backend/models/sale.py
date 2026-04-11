from .db import db
from datetime import datetime

class Sale(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    item = db.Column(db.String(100))
    qty = db.Column(db.Integer)
    price = db.Column(db.Float)
    total = db.Column(db.Float)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)