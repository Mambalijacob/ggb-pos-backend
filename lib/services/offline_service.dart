import 'db_service.dart';

class OfflineService {
  static Future<void> addToCart(Map<String, dynamic> item) async {
    final db = await DBService.init();
    await db.insert("cart", item);
  }

  static Future<List<Map<String, dynamic>>> getCart() async {
    final db = await DBService.init();
    return await db.query("cart");
  }

  static Future<void> clearCart() async {
    final db = await DBService.init();
    await db.delete("cart");
  }
}
