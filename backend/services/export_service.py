from reportlab.platypus import SimpleDocTemplate, Paragraph, Spacer
from reportlab.lib.styles import getSampleStyleSheet
import os
import datetime


class ExportService:

    @staticmethod
    def generate_sales_report(data):
        try:
            filename = f"sales_report_{datetime.datetime.now().timestamp()}.pdf"
            filepath = os.path.join("tmp", filename)

            os.makedirs("tmp", exist_ok=True)

            doc = SimpleDocTemplate(filepath)
            styles = getSampleStyleSheet()

            elements = []

            elements.append(Paragraph("GGB POS Sales Report", styles["Title"]))
            elements.append(Spacer(1, 10))

            for item in data:
                line = f"{item.get('name')} - Qty: {item.get('qty')} - Total: {item.get('total')}"
                elements.append(Paragraph(line, styles["Normal"]))
                elements.append(Spacer(1, 5))

            doc.build(elements)

            return filepath

        except Exception as e:
            return {"error": str(e)}