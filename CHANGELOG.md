## 2.0.7

- Fix `ProcessException` in CLI build command: add `runInShell: true` for Windows PATH resolution
- Fix CLI build/serve: auto-detect project root (`lib/main.dart` or `example/lib/main.dart`)
- Fix image optimizer: scan `pubspec.yaml` for declared asset paths instead of hardcoded directories
- Add `OptimizedImage` widget supporting `asset`, `network`, `file`, and `memory` image sources with max-dimension constraints
- Export `OptimizedImage` from public API
- Zero `flutter analyze` issues; 27/27 tests pass

## 2.0.6

- Fix WASM compatibility for `cache_manager.dart` (conditional export to break `hive_flutter→path_provider→dart:io` chain with in-memory stub)
- Zero `dart analyze` issues across main + example packages
- 28/28 tests pass; web build + WASM dry run succeed
- Pub score stays at 160/160 (no platform/WASM warnings)

## 2.0.5

- Fix Web platform compatibility (replace `universal_html` → `package:web` to break `dart:io` chain)
- Fix WASM compatibility (conditional export for `offline_provider.dart` to break `hive→path_provider→dart:io` chain)
- Remove `universal_html` dependency (unused; saves ~4 transitive deps)
- Add `web` dependency for platform-compatible DOM operations
- Zero `dart analyze` issues across main + example packages
- 28/28 tests pass; web build + WASM dry run succeed
- Pub score now 160/160 (no platform/WASM warnings)

## 2.0.4

- Fix conditional `dart:io` in image_optimizer.dart (WASM compatibility)
- Fix conditional `puppeteer` import in ssr_renderer.dart (Android/iOS support)
- Fix homepage URL (sfwf.dev → GitHub)
- Fix `setState()` during build in SeoControllerProvider
- Complete enterprise production-ready example:
  - Add web/index.html + manifest.json (PWA)
  - Fix contact form with real HTTP POST, proper email validation
  - Fix blog page with working onTap navigation
  - Fix 404 page with AppLayout + SEO
  - Fix layout back button (pushNamed not pushNamedAndRemoveUntil)
  - Fix project detail fallback as static const
  - Remove dead code (seoTitle param)
  - Add blog detail page
  - Add widget test
  - Show contact info on all platforms

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
