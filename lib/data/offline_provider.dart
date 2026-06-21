import 'package:http/http.dart' as http;
import 'cache_manager.dart';

/// Provides offline-first network requests with cached fallback.
class OfflineProvider {
  /// Fetches from network, caching the response; returns cached data on failure.
  static Future<dynamic> fetchOrCache(String url, Duration ttl) async {
    final cached = CacheManager.instance.get(url);
    if (cached != null) return cached;

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = response.body;
        CacheManager.instance.set(url, data, ttl: ttl);
        return data;
      }
      throw Exception('Failed to load data: ${response.statusCode}');
    } catch (e) {
      final cached = CacheManager.instance.get(url);
      if (cached != null) return cached;
      rethrow;
    }
  }
}
