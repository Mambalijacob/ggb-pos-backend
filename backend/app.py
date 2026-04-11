import os
import logging
from flask import Flask, jsonify
from flask_cors import CORS
from flask_jwt_extended import JWTManager
from backend.config import Config
from backend.models.db import db

# ================= IMPORT ROUTES =================
from backend.routes.auth import auth_bp
from backend.routes.inventory import inventory_bp
from backend.routes.sales import sales_bp
from backend.routes.expenses import expenses_bp
from backend.routes.sync import sync_bp
from backend.routes.analytics import analytics_bp
from backend.routes.export import export_bp
from backend.routes.ai import ai_bp
from backend.routes.reorder import reorder_bp


# ================= LOGGING =================
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger("GGB-POS")


# ================= APP FACTORY =================
def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # ================= CORS (FIXED FOR WEB + ANDROID) =================
    CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)

    @app.after_request
    def after_request(response):
        response.headers["Access-Control-Allow-Origin"] = "*"
        response.headers["Access-Control-Allow-Headers"] = "Content-Type,Authorization"
        response.headers["Access-Control-Allow-Methods"] = "GET,POST,PUT,DELETE,OPTIONS"
        return response

    # ================= JWT =================
    JWTManager(app)

    # ================= DB =================
    db.init_app(app)

    # ================= ROOT =================
    @app.route("/", methods=["GET"])
    def home():
        return jsonify({
            "message": "GGB POS Backend Running",
            "status": "success"
        }), 200

    # ================= HEALTH (FIX RENDER 404 ISSUE) =================
    @app.route("/health", methods=["GET"])
    def health():
        return jsonify({"status": "ok"}), 200

    # ================= API HEALTH =================
    @app.route("/api/health", methods=["GET"])
    def api_health():
        return jsonify({"status": "api ok"}), 200

    # ================= REGISTER ROUTES =================
    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(inventory_bp, url_prefix="/api/inventory")
    app.register_blueprint(sales_bp, url_prefix="/api/sales")
    app.register_blueprint(expenses_bp, url_prefix="/api/expenses")
    app.register_blueprint(sync_bp, url_prefix="/api/sync")
    app.register_blueprint(analytics_bp, url_prefix="/api/analytics")
    app.register_blueprint(export_bp, url_prefix="/api/export")
    app.register_blueprint(ai_bp, url_prefix="/api/ai")
    app.register_blueprint(reorder_bp, url_prefix="/api/reorder")

    # ================= ERROR HANDLERS =================
    @app.errorhandler(404)
    def not_found(e):
        return jsonify({"error": "Resource not found"}), 404

    @app.errorhandler(500)
    def server_error(e):
        db.session.rollback()
        return jsonify({"error": "Internal server error"}), 500

    # ================= DB INIT =================
    with app.app_context():
        try:
            db.create_all()
            logger.info("Database initialized successfully")
        except Exception as e:
            logger.error(f"DB INIT ERROR: {e}")

    return app


# ================= RUN =================
app = create_app()

if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    debug = os.getenv("DEBUG", "false").lower() == "true"

    logger.info(f"Starting server on port {port}")
    app.run(host="0.0.0.0", port=port, debug=debug)