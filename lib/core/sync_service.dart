import '../services/api_service.dart';
import 'database_helper.dart';

class SyncService {
  static Future<void> sync() async {
    final unsynced = await DatabaseHelper.getUnsynced();

    if (unsynced.isEmpty) return;

    try {
      await ApiService.syncSales(unsynced);

      for (var s in unsynced) {
        await DatabaseHelper.markSynced(s['id']);
      }
    } catch (e) {
      print("Sync failed: $e");
    }
  }
}
