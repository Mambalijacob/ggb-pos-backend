from backend.models.db import db
from backend.models.sale import Sale


class SyncService:

    @staticmethod
    def sync_sales(sales_data):
        try:
            for s in sales_data:
                sale = Sale(
                    product_id=s["product_id"],
                    quantity=s["quantity"],
                    total=s["total"],
                    profit=s.get("profit", 0)
                )
                db.session.add(sale)

            db.session.commit()

            return {"message": "Sync successful"}

        except Exception as e:
            db.session.rollback()
            return {"error": str(e)}