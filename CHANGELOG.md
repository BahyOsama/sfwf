## 2.0.1

- Fix WASM compatibility (conditional `dart:io` in service_worker.dart)
- Fix `setState()` during build in SeoControllerProvider
- Fix RenderFlex overflow in example cards (adjusted aspect ratios)
- Update dependencies: `mime ^2.0.0`, `xml ^7.0.1`
- Add comprehensive dartdoc comments to all public API
- Package now achieves 160/160 pub points

## 2.0.0

### Major improvements
- Complete rewrite of the core framework with production-ready architecture
- Multi-platform support (web, iOS, Android, desktop)
- Advanced SEO engine with dynamic meta tags, Open Graph, JSON-LD

### New features
- Smart Router with dynamic route parameter matching (`/user/:id`)
- Middleware and route guard execution system
- Improved SSR renderer with lazy initialization
- PWA Service Worker with cache versioning and stale-while-revalidate strategy
- Image optimizer with WebP support and size reduction tracking
- Offline-first data layer with serializable cache entries
- Universal HTML support for cross-platform compatibility

### Breaking changes
- Minimum SDK: Dart 3.0+ / Flutter 3.10+
- Cache system now uses JSON serialization instead of raw Hive objects
- SeoControllerProvider rewritten to properly propagate state changes
- CLI now uses stdout/stderr instead of dart:log

### Bug fixes
- Fixed `dart:html` imports replaced with `universal_html` for all platforms
- Fixed cache entry expiry not being checked correctly
- Fixed SSR renderer async initialization race condition
- Fixed CLI `_analyze` method type cast error
- Fixed prerender tool path resolution
- Fixed Service Worker hash generation for Windows paths
- Fixed example app legacy import removal
- Fixed route path parsing for query parameters

## 1.0.0

Initial release of Smart Flutter Web Framework.
