class CacheManager {
  static final CacheManager instance = CacheManager._internal();
  final _store = <String, _Entry>{};

  CacheManager._internal();

  Future<void> init() async {}

  void set(String key, dynamic value, {Duration ttl = const Duration(minutes: 10)}) {
    _store[key] = _Entry(value, DateTime.now().add(ttl));
  }

  dynamic get(String key) {
    final entry = _store[key];
    if (entry == null) return null;
    if (entry.expiry.isAfter(DateTime.now())) {
      return entry.value;
    }
    _store.remove(key);
    return null;
  }

  void remove(String key) => _store.remove(key);

  Future<void> clear() async {
    _store.clear();
  }
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

class _Entry {
  final dynamic value;
  final DateTime expiry;

  _Entry(this.value, this.expiry);
}
