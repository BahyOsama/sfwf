# Smart Flutter Web Framework (SFWF) v2.0

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
| 10 | **Plugin conflicts** | `dart:html` fails on mobile | universal_html + PluginFallback |

---

## 📦 Installation

```yaml
dependencies:
  sfwf: ^2.0.0
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
│   ├── seo_controller.dart # Dynamic meta tags & JSON-LD
│   ├── seo_provider.dart
│   ├── sitemap_generator.dart
│   └── robots_generator.dart
├── ssr/
│   ├── ssr_renderer.dart  # Puppeteer SSR
│   └── ssr_client.dart    # Client-side hydration
├── ai/
│   ├── ai_analyzer.dart   # OpenAI SEO analysis
│   └── ai_suggestions.dart
├── data/
│   ├── cache_manager.dart # TTL-based caching
│   ├── offline_provider.dart
│   └── state_bridge.dart  # Simple state management
├── device/
│   ├── device_detector.dart # Mobile/Tablet/Desktop detection
│   └── adaptive_builder.dart
├── performance/
│   ├── lazy_loader.dart
│   ├── image_optimizer.dart # WebP + resize + compress
│   └── service_worker.dart  # PWA Service Worker
├── plugins/
│   └── compatibility_layer.dart
├── prerender/
│   └── prerender_cli.dart
├── sfwf.dart               # Main export barrel
└── sfwf_web.dart           # Web plugin registration
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
  baseUrl: 'https://example.com',
  seoDefaults: SeoDefaults(
    titleSuffix: ' | My App',
    defaultDescription: 'My app description',
    defaultImage: 'https://example.com/og.png',
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

## 📄 License

MIT
