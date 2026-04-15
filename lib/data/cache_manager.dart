import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  static final CacheManager instance = CacheManager._internal();
  late Box _cacheBox;
  bool _initialized = false;

  CacheManager._internal();

  Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _cacheBox = await Hive.openBox('sfwf_cache');
    _initialized = true;
  }

  void set(String key, dynamic value,
      {Duration ttl = const Duration(minutes: 10)}) {
    final entry = CacheEntry(value, DateTime.now().add(ttl));
    _cacheBox.put(key, entry);
  }

  dynamic get(String key) {
    final entry = _cacheBox.get(key) as CacheEntry?;
    if (entry != null && entry.expiry.isAfter(DateTime.now())) {
      return entry.value;
    }
    return null;
  }

  void remove(String key) => _cacheBox.delete(key);
  void clear() => _cacheBox.clear();
}

class CacheEntry {
  final dynamic value;
  final DateTime expiry;
  CacheEntry(this.value, this.expiry);
}
