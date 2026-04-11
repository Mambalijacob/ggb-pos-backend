from .db import db
from datetime import datetime

class Expense(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100))
    amount = db.Column(db.Float)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)