# Smart Flutter Web Framework (SFWF) v2.5

**SFWF** is a production-ready framework that solves **10 major Flutter web problems** — SEO, Server-Side Rendering, PWA, routing, performance, and more. It's the ultimate platform for building production-grade web apps with Flutter.

---

## 🚨 The 10 Problems SFWF Solves

| # | Problem | Without SFWF | With SFWF |
|---|---------|-------------|-----------|
| 1 | **No SEO** | Search engines see a blank canvas | Dynamic meta tags, Open Graph, JSON-LD, sitemap.xml |
| 2 | **Hash-based URLs** | `#/products/123` ugly URLs | Clean URLs `/products/123` |
| 3 | **No SSR** | Slow initial load, poor SEO | Puppeteer SSR + pre-rendering |
| 4 | **Heavy bundle** | Slow first paint | Lazy loading, code splitting |
| 5 | **No PWA** | Can't install or work offline | Service Worker + manifest.json |
| 6 | **Unoptimized images** | Slow page loads | Auto resize + compress + WebP |
| 7 | **No responsive** | Desktop-only layout | DeviceDetector + AdaptiveBuilder |
| 8 | **No meta per page** | Same title everywhere | SeoController per page |
| 9 | **No offline** | No data without internet | CacheManager + OfflineProvider |
| 10 | **Plugin conflicts** | `dart:html` fails on mobile | PluginFallback |

---

## 📦 Installation

```yaml
dependencies:
  sfwf: ^2.0.5
```

## 🚀 Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:sfwf/sfwf.dart';

void main() {
  const config = SFWFConfig(
    appName: 'My App',
    baseUrl: 'https://example.com',
  );

  runApp(SFWFApp(
    config: config,
    routes: {
      '/': (ctx) => const HomePage(),
      '/about': (ctx) => const AboutPage(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // SEO meta tags for this page
    SeoController.of(context).updatePage(const SeoData(
      title: 'Home - My App',
      description: 'Welcome to My App built with SFWF',
      ogType: 'website',
      structuredData: {
        '@context': 'https://schema.org',
        '@type': 'WebSite',
        'name': 'My App',
      },
    ));

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: const Center(child: Text('Hello SFWF!')),
    );
  }
}
```

---

## 🧠 Core Features

### 1. SEO Engine
- Per-page meta tags, Open Graph, Twitter Cards
- JSON-LD structured data injection
- Auto sitemap.xml & robots.txt generation
- Canonical URLs, theme-color, noindex support

```dart
SeoController.of(context).updatePage(const SeoData(
  title: 'Product Page',
  description: 'Best product ever',
  image: 'https://example.com/product.jpg',
  keywords: 'flutter, web, seo',
  ogType: 'product',
  themeColor: '#6200EE',
  canonicalUrl: 'https://example.com/product',
  noIndex: false,
  structuredData: {
    '@context': 'https://schema.org',
    '@type': 'Product',
    'name': 'Product Name',
  },
));
```

### 2. Smart Router
- Clean URLs without `#` (hashless)
- Dynamic parameters: `/user/:id` → `{id: '123'}`
- Route guards & middleware pipeline
- Custom page transitions per route
- 404 page support

```dart
SFWFApp(
  routes: {
    '/': (ctx) => const HomePage(),
    '/products': (ctx) => const ProductsPage(),
  },
  routeDefinitions: [
    const RouteDefinition(path: '/products/:id', name: '/product-detail'),
  ],
  notFoundBuilder: (ctx) => const NotFoundPage(),
  customTransitions: {
    '/': _fadeTransition,
    '/products': _slideUpTransition,
  },
);
```

### 3. PWA Support
```bash
dart run sfwf build --generate-sw
# Generates service_worker.js with cache versioning
```

### 4. SSR & Pre-rendering
```bash
# SSR Server
dart run sfwf serve --port=8080

# Pre-render all routes
dart run sfwf build --prerender
```

### 5. Image Optimization
```bash
dart run sfwf build --optimize-images
# Auto resize to 1200px, compress to JPEG 85%, WebP support
```

### 6. Device Adaptation
```dart
if (DeviceDetector.isDesktop) {
  // Desktop layout
} else if (DeviceDetector.isTablet) {
  // Tablet layout
} else {
  // Mobile layout
}

// Or use AdaptiveBuilder
AdaptiveBuilder(
  builder: (ctx, type) {
    if (type == DeviceType.desktop) return DesktopLayout();
    return MobileLayout();
  },
);
```

### 7. Offline & Caching
```dart
// Cache with TTL
CacheManager.instance.set('key', data, ttl: Duration(hours: 1));
final cached = CacheManager.instance.get('key');

// Offline-first fetch
final data = await OfflineProvider.fetchOrCache('https://api.example.com/data',
    const Duration(minutes: 30));
```

### 8. AI-Powered SEO Analysis
```bash
export OPENAI_API_KEY=sk-xxx
dart run sfwf analyze
```

### 9. State Management
```dart
final counter = SimpleStateBridge<int>(0);
counter.update(42);
print(counter.state); // 42

// Listen to changes
counter.notifier.addListener(() => print('Changed!'));
```

### 10. Plugin Compatibility
```dart
// Works on both web and native
final result = PluginFallback.safeCall(
  webImplementation: () => /* web code */,
  fallback: () => /* native fallback */,
);
```

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── config.dart        # SFWFConfig, SeoDefaults, SsrMode
│   ├── sfwf_app.dart      # Main SFWFApp widget
│   └── lifecycle.dart     # App lifecycle hooks
├── router/
│   ├── smart_router.dart  # Clean URL router with params/guards
│   ├── route_definition.dart
│   ├── middleware.dart    # RouteGuard & Middleware typedefs
│   └── guards.dart        # AuthGuard
├── seo/
│   ├── seo_controller.dart       # Dynamic meta tags & JSON-LD
│   ├── seo_data.dart             # SeoData data class
│   ├── seo_provider.dart         # InheritedWidget provider
│   ├── dom_operations.dart       # DOM ops (conditional stub/web)
│   ├── dom_operations_stub.dart  # No-op stub for non-web
│   ├── dom_operations_web.dart   # Web DOM ops via package:web
│   ├── sitemap.dart              # Sitemap (conditional stub/io)
│   ├── sitemap_generator.dart    # Real sitemap generator
│   ├── sitemap_stub.dart         # Sitemap stub for non-io
│   ├── robots.dart               # Robots.txt (conditional stub/io)
│   ├── robots_generator.dart     # Real robots.txt generator
│   └── robots_stub.dart          # Robots.txt stub for non-io
├── ssr/
│   ├── ssr_renderer.dart         # SSR renderer (always base)
│   ├── ssr_renderer_base.dart    # Abstract SSR renderer
│   ├── ssr_renderer_puppeteer.dart # Puppeteer SSR impl
│   ├── ssr_renderer_stub.dart    # SSR stub for non-io
│   ├── ssr_client.dart           # Client-side hydration
│   ├── ssr_hydrator.dart         # Hydrator (conditional stub/web)
│   ├── ssr_hydrator_stub.dart    # No-op hydrator stub
│   └── ssr_hydrator_web.dart     # Web hydrator via package:web
├── ai/
│   ├── ai_analyzer.dart          # OpenAI SEO analysis
│   └── ai_suggestions.dart
├── data/
│   ├── cache_manager.dart        # TTL-based caching (Hive)
│   ├── offline_provider.dart     # Real offline-first fetch
│   ├── offline_provider_stub.dart# Offline stub for WASM
│   └── state_bridge.dart         # Simple state management
├── device/
│   ├── device_detector.dart      # Platform detection
│   └── adaptive_builder.dart
├── performance/
│   ├── lazy_loader.dart
│   ├── image_optimizer.dart      # Image opt (conditional stub/io)
│   ├── image_optimizer_io.dart   # Real image optimizer
│   ├── image_optimizer_stub.dart # Image opt stub for non-io
│   ├── service_worker.dart       # SW (conditional stub/io)
│   ├── service_worker_io.dart    # Real service worker gen
│   └── service_worker_stub.dart  # SW stub for non-io
├── plugins/
│   └── compatibility_layer.dart  # PluginFallback
├── prerender/
│   ├── prerender.dart            # Pre-render (conditional stub/io)
│   ├── prerender_cli.dart        # Real pre-render CLI
│   └── prerender_stub.dart       # Pre-render stub for non-io
├── sfwf.dart                     # Main export barrel
└── sfwf_web.dart                 # Web plugin registration
```

---

## 🖥️ CLI Reference

```bash
# Create a new project
dart run sfwf create my_project

# Build with all optimizations
dart run sfwf build --prerender --optimize-images --generate-sw --analyze

# Start SSR server
dart run sfwf serve --port=8080

# Generate sitemap
dart run sfwf sitemap --base-url=https://example.com

# Analyze built site
dart run sfwf analyze
```

---

## 🔧 Configuration

```dart
SFWFConfig(
  appName: 'My App',
  baseUrl: 'https://pub.dev/packages/sfwf',
  seoDefaults: SeoDefaults(
    titleSuffix: ' | My App',
    defaultDescription: 'My app description',
    defaultImage: 'https://github.com/BahyOsama/sfwf/blob/main/default-og.png',
    twitterHandle: '@myapp',
  ),
  ssrMode: SsrMode.hybrid,       // off | ssrOnly | hybrid | prerenderOnly
  enableAI: false,                 // Enable OpenAI analysis
  enablePwa: true,                 // Enable PWA features
  cacheDuration: Duration(minutes: 5),
  supportedLocales: [Locale('en')],
)
```

---

## 👨‍💻 Author

**Bahy Osama** – Full-stack Flutter developer and creator of SFWF.

| | Link |
|---|------|
| 🌐 Website | [https://appsyntro.netlify.app/](https://appsyntro.netlify.app/) |
| 📧 Email | [dev.bahy1@gmail.com](mailto:dev.bahy1@gmail.com) |
| 💼 LinkedIn | [https://www.linkedin.com/in/bahy-osama](https://www.linkedin.com/in/bahy-osama) |
| 🐙 GitHub | [https://github.com/BahyOsama](https://github.com/BahyOsama) |
| 🎨 Portfolio | [https://www.canva.com/design/DAFwCHH89oY/c6VgSlLvJ8Pp4f5AXdaWEQ/view](https://www.canva.com/design/DAFwCHH89oY/c6VgSlLvJ8Pp4f5AXdaWEQ/view?utm_content=DAFwCHH89oY&utm_campaign=designshare&utm_medium=link&utm_source=editor) |

---

## 📄 License

MIT
