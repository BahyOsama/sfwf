class OfflineProvider {
  static Future<dynamic> fetchOrCache(String url, Duration ttl) async {
    throw UnsupportedError('OfflineProvider is not supported on this platform');
  }
}
