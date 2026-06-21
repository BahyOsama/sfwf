import 'package:flutter_test/flutter_test.dart';
import 'package:sfwf/sfwf.dart';

void main() {
  group('SFWFConfig Tests', () {
    test('SFWFConfig can be instantiated with defaults', () {
      const config = SFWFConfig(
        appName: 'Test App',
        baseUrl: 'https://test.com',
      );
      expect(config.appName, 'Test App');
      expect(config.baseUrl, 'https://test.com');
      expect(config.seoDefaults, isA<SeoDefaults>());
      expect(config.ssrMode, SsrMode.hybrid);
      expect(config.enableAI, false);
      expect(config.enablePwa, true);
      expect(config.cacheDuration, const Duration(minutes: 5));
    });

    test('SFWFConfig with all parameters', () {
      const config = SFWFConfig(
        appName: 'Advanced',
        baseUrl: 'https://advanced.com',
        seoDefaults: SeoDefaults(titleSuffix: ' | Advanced'),
        ssrMode: SsrMode.prerenderOnly,
        enableAI: true,
        openAiApiKey: 'sk-test',
        cacheDuration: Duration(hours: 1),
        enablePwa: false,
      );
      expect(config.ssrMode, SsrMode.prerenderOnly);
      expect(config.enableAI, true);
      expect(config.openAiApiKey, 'sk-test');
      expect(config.enablePwa, false);
    });

    test('SeoDefaults has correct default values', () {
      const defaults = SeoDefaults();
      expect(defaults.titleSuffix, ' | SFWF');
      expect(defaults.defaultDescription,
          'Built with Smart Flutter Web Framework');
      expect(defaults.defaultImage, '/default-og.png');
      expect(defaults.twitterHandle, '@sfwf');
    });
  });

  group('SeoData Tests', () {
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

    test('SeoData merge with structured data', () {
      const base = SeoData();
      const other = SeoData(structuredData: {'@type': 'WebPage'});
      final merged = base.merge(other);
      expect(merged.structuredData, {'@type': 'WebPage'});
    });

    test('SeoData all fields null by default', () {
      const data = SeoData();
      expect(data.title, isNull);
      expect(data.description, isNull);
      expect(data.image, isNull);
      expect(data.structuredData, isNull);
    });
  });

  group('Router Tests', () {
    test('RoutePath can be created', () {
      const path = RoutePath('/test', params: {'id': '123'});
      expect(path.path, '/test');
      expect(path.params['id'], '123');
    });

    test('RoutePath with query params', () {
      const path = RoutePath('/search', queryParams: {'q': 'flutter'});
      expect(path.path, '/search');
      expect(path.queryParams['q'], 'flutter');
    });

    test('RoutePath toString works', () {
      const path = RoutePath('/about');
      expect(path.toString(), contains('RoutePath'));
    });
  });

  group('RouteDefinition Tests', () {
    test('RouteDefinition can be created', () {
      const def = RouteDefinition(path: '/user/:id', name: 'user');
      expect(def.path, '/user/:id');
      expect(def.name, 'user');
    });

    test('RouteDefinition with meta', () {
      const def = RouteDefinition(
        path: '/admin',
        meta: {'requiresAuth': true},
      );
      expect(def.meta, {'requiresAuth': true});
    });
  });

  group('Middleware Tests', () {
    test('RouterMiddleware can add guards', () {
      RouterMiddleware.addGuard((ctx, route) async => true);
      expect(RouterMiddleware.guards.length, 1);
      RouterMiddleware.guards.clear();
    });

    test('RouterMiddleware can add preProcessors', () {
      RouterMiddleware.addMiddleware((ctx, route) async {});
      expect(RouterMiddleware.preProcessors.length, 1);
      RouterMiddleware.preProcessors.clear();
    });
  });

  group('Device Tests', () {
    test('DeviceType enum exists', () {
      expect(DeviceType.mobile, isA<DeviceType>());
      expect(DeviceType.tablet, isA<DeviceType>());
      expect(DeviceType.desktop, isA<DeviceType>());
    });

    test('DeviceType values are distinct', () {
      expect(DeviceType.mobile, isNot(DeviceType.desktop));
      expect(DeviceType.mobile, isNot(DeviceType.tablet));
    });
  });

  group('Cache Tests', () {
    test('CacheEntry stores value and expiry', () {
      final expiry = DateTime.now().add(const Duration(minutes: 5));
      final entry = CacheEntry('test value', expiry);
      expect(entry.value, 'test value');
      expect(entry.expiry, expiry);
    });

    test('CacheEntry serialization roundtrip', () {
      final expiry = DateTime.now().add(const Duration(hours: 1));
      final entry = CacheEntry('serialized', expiry);
      final json = entry.toJson();
      final restored = CacheEntry.fromJson(json);
      expect(restored.value, 'serialized');
      expect(restored.expiry.toIso8601String(), expiry.toIso8601String());
    });
  });

  group('StateBridge Tests', () {
    test('SimpleStateBridge can update state', () {
      final bridge = SimpleStateBridge<int>(0);
      expect(bridge.notifier.value, 0);
      bridge.update(42);
      expect(bridge.notifier.value, 42);
    });

    test('SimpleStateBridge get state', () {
      final bridge = SimpleStateBridge<String>('hello');
      expect(bridge.state, 'hello');
    });
  });

  group('SsrMode Tests', () {
    test('SsrMode values exist', () {
      expect(SsrMode.off, isA<SsrMode>());
      expect(SsrMode.ssrOnly, isA<SsrMode>());
      expect(SsrMode.hybrid, isA<SsrMode>());
      expect(SsrMode.prerenderOnly, isA<SsrMode>());
    });
  });
}
