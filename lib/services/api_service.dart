import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/constants.dart';

class ApiService {
  static String get base => AppConstants.baseUrl;

  // ========================= AUTH =========================
  static Future<Map<String, dynamic>?> login(
      String username, String password) async {
    final url = Uri.parse(base + AppConstants.loginEndpoint);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data["error"] ?? "Login failed");
    }
  }

  // ========================= INVENTORY =========================
  static Future<List<dynamic>> getInventory(String token) async {
    final url = Uri.parse(base + AppConstants.inventoryEndpoint);

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data is List) return data;
      throw Exception("Expected list, got: $data");
    } else {
      throw Exception(data["error"] ?? "Inventory failed");
    }
  }

  // ========================= SALES =========================
  static Future<void> createSale(
      String token, List<Map<String, dynamic>> cart) async {
    final url = Uri.parse(base + AppConstants.salesEndpoint);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(cart),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data["error"] ?? "Sale failed");
    }
  }

  // ========================= ANALYTICS =========================
  static Future<Map<String, dynamic>> getSummary(String token) async {
    final url = Uri.parse(base + AppConstants.summaryEndpoint);

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data["error"] ?? "Summary failed");
    }
  }

  static Future<List<dynamic>> getTopProducts(String token) async {
    final url = Uri.parse(base + AppConstants.topProductsEndpoint);

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data is List) return data;
      throw Exception("Expected list, got: $data");
    } else {
      throw Exception(data["error"] ?? "Top products failed");
    }
  }

  // ========================= AI =========================
  static Future<Map<String, dynamic>> getPrediction(String token) async {
    final url = Uri.parse(base + AppConstants.predictionEndpoint);

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data["error"] ?? "Prediction failed");
    }
  }

  // ========================= REORDER =========================
  static Future<List<dynamic>> getReorder(String token) async {
    final url = Uri.parse(base + AppConstants.reorderEndpoint);

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data is List) return data;
      throw Exception("Expected list, got: $data");
    } else {
      throw Exception(data["error"] ?? "Reorder failed");
    }
  }

  // ========================= EXPORT =========================
  static Future<String> exportPDF(String token) async {
    final url = Uri.parse(base + AppConstants.exportEndpoint);

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data["file"] ?? "";
    } else {
      throw Exception(data["error"] ?? "Export failed");
    }
  }

  // ========================= SYNC =========================
  static Future<void> syncSales(
      String token, List<Map<String, dynamic>> sales) async {
    final url = Uri.parse(base + AppConstants.salesEndpoint);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(sales),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data["error"] ?? "Sync failed");
    }
  }
}
