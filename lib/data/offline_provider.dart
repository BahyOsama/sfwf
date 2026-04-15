import 'package:http/http.dart' as http;
import 'cache_manager.dart';

class OfflineProvider {
  static Future<dynamic> fetchOrCache(String url, Duration ttl) async {
    final cached = CacheManager.instance.get(url);
    if (cached != null) return cached;

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = response.body;
      CacheManager.instance.set(url, data, ttl: ttl);
      return data;
    }
    throw Exception('Failed to load data');
  }
}
