class AppConstants {
  // ================= API =================
  static const String baseUrl = "https://ggb-pos-backend.onrender.com/api";

  // ================= AUTH =================
  static const String loginEndpoint = "/auth/login";
  static const String registerEndpoint = "/auth/register";

  // ================= INVENTORY =================
  static const String inventoryEndpoint = "/inventory";

  // ================= ANALYTICS =================
  static const String summaryEndpoint = "/analytics/summary";
  static const String topProductsEndpoint = "/analytics/top_products";
  static const String dailyTrendEndpoint = "/analytics/daily_trend";
  static const String monthlyTrendEndpoint = "/analytics/monthly_trend";
  static const String predictionEndpoint = "/analytics/predict_sales";

  // ================= SALES =================
  static const String salesEndpoint = "/sync/sales";

  // ================= REORDER =================
  static const String reorderEndpoint = "/reorder";

  // ================= EXPORT =================
  static const String exportEndpoint = "/export/pdf";

  // ================= TIMEOUT =================
  static const int apiTimeout = 30; // seconds

  // ================= LOCAL STORAGE =================
  static const String dbName = "ggb_pos.db";

  // ================= TABLES =================
  static const String salesTable = "sales";
  static const String inventoryTable = "inventory";
  static const String syncTable = "sync_queue";
}
