import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

/// Manages in-memory and persistent caching with TTL-based expiry.
class CacheManager {
  /// Singleton instance of [CacheManager].
  static final CacheManager instance = CacheManager._internal();
  late Box<String> _cacheBox;
  bool _initialized = false;

  CacheManager._internal();

  /// Initializes the Hive cache box. Safe to call multiple times.
  Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _cacheBox = await Hive.openBox<String>('sfwf_cache');
    _initialized = true;
  }

  /// Stores a value with an optional TTL (default 10 minutes).
  void set(String key, dynamic value, {Duration ttl = const Duration(minutes: 10)}) {
    final entry = CacheEntry(value, DateTime.now().add(ttl));
    _cacheBox.put(key, jsonEncode(entry.toJson()));
  }

  /// Retrieves a cached value by key, or `null` if expired or missing.
  dynamic get(String key) {
    final raw = _cacheBox.get(key);
    if (raw == null) return null;
    try {
      final entry = CacheEntry.fromJson(jsonDecode(raw));
      if (entry.expiry.isAfter(DateTime.now())) {
        return entry.value;
      }
      remove(key);
    } catch (_) {
      remove(key);
    }
    return null;
  }

  /// Removes a single entry from the cache by key.
  void remove(String key) => _cacheBox.delete(key);

  /// Clears all cached entries.
  Future<void> clear() => _cacheBox.clear();
}

/// A cache entry holding a value and its expiration time.
class CacheEntry {
  /// The cached value.
  final dynamic value;

  /// The date and time when this entry expires.
  final DateTime expiry;

  /// Creates a [CacheEntry] with the given [value] and [expiry].
  CacheEntry(this.value, this.expiry);

  /// Serializes this entry to a JSON-compatible map.
  Map<String, dynamic> toJson() => {
        'value': value,
        'expiry': expiry.toIso8601String(),
      };

  /// Creates a [CacheEntry] from a JSON map.
  factory CacheEntry.fromJson(Map<String, dynamic> json) => CacheEntry(
        json['value'],
        DateTime.parse(json['expiry']),
      );
}
