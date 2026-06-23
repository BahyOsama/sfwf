import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class CacheManager {
  static final CacheManager instance = CacheManager._internal();
  late Box<String> _cacheBox;
  bool _initialized = false;

  CacheManager._internal();

  Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    _cacheBox = await Hive.openBox<String>('sfwf_cache');
    _initialized = true;
  }

  void set(String key, dynamic value, {Duration ttl = const Duration(minutes: 10)}) {
    final entry = CacheEntry(value, DateTime.now().add(ttl));
    _cacheBox.put(key, jsonEncode(entry.toJson()));
  }

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

  void remove(String key) => _cacheBox.delete(key);

  Future<void> clear() => _cacheBox.clear();
}

class CacheEntry {
  final dynamic value;
  final DateTime expiry;

  CacheEntry(this.value, this.expiry);

  Map<String, dynamic> toJson() => {
        'value': value,
        'expiry': expiry.toIso8601String(),
      };

  factory CacheEntry.fromJson(Map<String, dynamic> json) => CacheEntry(
        json['value'],
        DateTime.parse(json['expiry']),
      );
}
