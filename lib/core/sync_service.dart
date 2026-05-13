import 'package:flutter/foundation.dart';

import '../services/api_service.dart';
import 'database_helper.dart';

class SyncService {
  static Future<void> sync(String token) async {
    final unsynced = await DatabaseHelper.getUnsynced();

    if (unsynced.isEmpty) return;

    try {
      await ApiService.syncSales(token, unsynced);

      for (var s in unsynced) {
        await DatabaseHelper.markSynced(s['id']);
      }
    } catch (e) {
      debugPrint("Sync failed: $e");
    }
  }
}
