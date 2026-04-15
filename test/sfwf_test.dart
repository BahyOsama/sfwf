import 'package:flutter_test/flutter_test.dart';
import 'package:sfwf/sfwf.dart';

void main() {
  group('SFWF Configuration Tests', () {
    test('SFWFConfig can be instantiated', () {
      final config = SFWFConfig(
        appName: 'Test App',
        baseUrl: 'https://test.com',
      );
      expect(config.appName, 'Test App');
      expect(config.baseUrl, 'https://test.com');
      expect(config.seoDefaults, isA<SeoDefaults>());
    });

    test('SeoDefaults has correct default values', () {
      const defaults = SeoDefaults();
      expect(defaults.titleSuffix, ' | SFWF');
      expect(defaults.defaultDescription,
          'Built with Smart Flutter Web Framework');
      expect(defaults.defaultImage, '/default-og.png');
      expect(defaults.twitterHandle, '@sfwf');
    });

    test('SeoData merge works correctly', () {
      const base = SeoData(title: 'Base Title');
      const other = SeoData(description: 'Other Description');
      final merged = base.merge(other);
      expect(merged.title, 'Base Title');
      expect(merged.description, 'Other Description');
    });

    test('SeoData merge overrides with non-null values', () {
      const base = SeoData(title: 'Base', description: 'Base Desc');
      const other = SeoData(title: 'New Title');
      final merged = base.merge(other);
      expect(merged.title, 'New Title');
      expect(merged.description, 'Base Desc');
    });
  });

  group('Router Tests', () {
    test('RoutePath can be created', () {
      const path = RoutePath('/test', params: {'id': '123'});
      expect(path.path, '/test');
      expect(path.params['id'], '123');
    });

    test('RoutePath toString works', () {
      const path = RoutePath('/about');
      expect(path.toString(), 'RoutePath(/about, {})');
    });
  });

  group('Device Tests', () {
    test('DeviceType enum exists', () {
      expect(DeviceType.mobile, isA<DeviceType>());
      expect(DeviceType.tablet, isA<DeviceType>());
      expect(DeviceType.desktop, isA<DeviceType>());
    });
  });

  group('Cache Tests', () {
    test('CacheEntry stores value and expiry', () {
      final expiry = DateTime.now().add(const Duration(minutes: 5));
      final entry = CacheEntry('test value', expiry);
      expect(entry.value, 'test value');
      expect(entry.expiry, expiry);
    });
  });
}
