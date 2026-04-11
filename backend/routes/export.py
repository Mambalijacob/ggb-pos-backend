from flask import Blueprint, Response
from backend.models.sale import Sale
import csv
import io

export_bp = Blueprint("export", __name__)

@export_bp.route("/sales")
def export_sales():
    output = io.StringIO()
    writer = csv.writer(output)

    writer.writerow(["Item", "Qty", "Total"])

    for s in Sale.query.all():
        writer.writerow([s.item, s.qty, s.total])

    output.seek(0)

    return Response(
        output,
        mimetype="text/csv",
        headers={"Content-Disposition": "attachment;filename=sales.csv"}
    )