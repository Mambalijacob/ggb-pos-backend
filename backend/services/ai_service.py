from backend.models.db import db
from backend.models.sale import Sale
from sqlalchemy import func
import datetime


class AIService:

    @staticmethod
    def predict_next_month_sales():
        try:
            today = datetime.date.today()
            last_30_days = today - datetime.timedelta(days=30)

            total_sales = db.session.query(func.sum(Sale.total)).filter(
                Sale.date >= last_30_days
            ).scalar() or 0

            # Simple AI logic (can upgrade later)
            prediction = total_sales * 1.10  # +10% growth

            return {
                "last_30_days": total_sales,
                "prediction_next_month": round(prediction, 2)
            }

        except Exception as e:
            return {"error": str(e)}