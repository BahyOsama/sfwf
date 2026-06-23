import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlogPost {
  final String slug;
  final String title;
  final String description;
  final String category;
  final String readTime;
  final IconData icon;
  final String body;
  final String author;
  final String date;

  const BlogPost({
    required this.slug,
    required this.title,
    required this.description,
    required this.category,
    required this.readTime,
    required this.icon,
    required this.body,
    required this.author,
    required this.date,
  });
}

class BlogState {
  final List<BlogPost> all;
  final String searchQuery;
  final String? categoryFilter;

  const BlogState({
    required this.all,
    this.searchQuery = '',
    this.categoryFilter,
  });

  List<BlogPost> get filtered {
    var result = all;
    if (categoryFilter != null) {
      result = result.where((p) => p.category == categoryFilter).toList();
    }
    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result
          .where((p) =>
              p.title.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q))
          .toList();
    }
    return result;
  }

  List<String> get categories => all.map((p) => p.category).toSet().toList()..sort();

  BlogState copyWith({String? searchQuery, String? Function()? categoryFilter}) {
    return BlogState(
      all: all,
      searchQuery: searchQuery ?? this.searchQuery,
      categoryFilter: categoryFilter != null ? categoryFilter() : this.categoryFilter,
    );
  }
}

class BlogNotifier extends Notifier<BlogState> {
  @override
  BlogState build() => const BlogState(all: _allPosts);

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategoryFilter(String? category) {
    state = state.copyWith(categoryFilter: () => category);
  }

  static const _allPosts = [
    BlogPost(
      slug: 'flutter-web-2026-guide',
      title: 'Flutter Web in 2026: The Complete Guide',
      description:
          'Discover why Flutter web has become the go-to framework for building production web apps. Covers SEO, performance, and real-world case studies.',
      category: 'Flutter Web',
      readTime: '5 min read',
      icon: Icons.web,
      author: 'Flutter Team',
      date: 'Jan 15, 2026',
      body:
          'Flutter Web has evolved significantly since its early days. In 2026, it stands as a mature platform for building complex web applications. This comprehensive guide covers everything from setup to deployment.\n\n'
          '**Why Flutter Web in 2026?**\n'
          'With the introduction of SFWF and other frameworks, Flutter Web now offers SEO optimization, server-side rendering, and PWA support out of the box. The ecosystem has matured to support enterprise-grade applications.\n\n'
          '**Key Improvements:**\n'
          '- WASM support for near-native performance\n'
          '- Improved loading times with tree shaking\n'
          '- Better DevTools for debugging\n'
          '- Enhanced accessibility features\n'
          '- Seamless integration with popular backend services\n\n'
          '**Getting Started**\n'
          'The easiest way to start is with SFWF, which provides all the tools you need for production-grade Flutter Web apps. Simply add the dependency and start building.',
    ),
    BlogPost(
      slug: 'seo-flutter-web',
      title: 'Why SEO Matters for Flutter Web Apps',
      description:
          'Learn how to make your Flutter web app search-engine friendly with dynamic meta tags, structured data, and server-side rendering.',
      category: 'SEO',
      readTime: '4 min read',
      icon: Icons.search,
      author: 'Bahy Osama',
      date: 'Jan 10, 2026',
      body:
          'Search Engine Optimization is often overlooked by Flutter web developers, yet it is critical for discoverability.\n\n'
          '**Why SEO Matters**\n'
          'Over 90% of web traffic comes from search engines. Without proper SEO, your Flutter web app might as well be invisible to potential users.\n\n'
          '**How SFWF Handles SEO:**\n'
          '- Dynamic meta tags per page (title, description, keywords, Open Graph)\n'
          '- JSON-LD structured data injection for rich snippets\n'
          '- Automatic sitemap.xml and robots.txt generation\n'
          '- Server-side rendering with Puppeteer\n'
          '- Canonical URLs and noindex support\n\n'
          '**Best Practices**\n'
          'Always set unique titles and descriptions per page. Use structured data for products, articles, and FAQs. Generate sitemaps automatically with each build.',
    ),
    BlogPost(
      slug: 'pwa-flutter-tutorial',
      title: 'Building PWA with Flutter: Complete Tutorial',
      description:
          'Step-by-step guide to adding Progressive Web App support to your Flutter web project with service workers and manifests.',
      category: 'PWA',
      readTime: '7 min read',
      icon: Icons.phonelink,
      author: 'Bahy Osama',
      date: 'Dec 28, 2025',
      body:
          'Progressive Web Apps bridge the gap between web and native experiences. This tutorial walks through the complete process.\n\n'
          '**What is a PWA?**\n'
          'A Progressive Web App is a web application that can be installed on a user\'s device, work offline, and provide a native-like experience.\n\n'
          '**Step 1: Service Worker**\n'
          'SFWF automatically generates a service worker with cache versioning. The service worker handles offline support and asset caching.\n\n'
          '**Step 2: Manifest**\n'
          'Create a web/manifest.json with your app name, icons, and theme colors. SFWF includes PWA configuration in the build process.\n\n'
          '**Step 3: Offline Strategy**\n'
          'Implement stale-while-revalidate for assets and cache-first for API responses. Use the CacheManager for fine-grained control.',
    ),
    BlogPost(
      slug: 'flutter-web-performance',
      title: 'Performance Optimization for Flutter Web',
      description:
          'Tips and techniques to optimize your Flutter web app for speed using lazy loading, image optimization, and code splitting.',
      category: 'Performance',
      readTime: '6 min read',
      icon: Icons.speed,
      author: 'Flutter Team',
      date: 'Dec 20, 2025',
      body:
          'Performance is paramount for user retention and conversion rates. Here are the key optimization techniques for Flutter Web.\n\n'
          '**1. Lazy Loading**\n'
          'Use SFWF\'s LazyLoader to defer non-critical widgets and images. This reduces initial bundle size and improves First Contentful Paint.\n\n'
          '**2. Image Optimization**\n'
          'Use the ImageOptimizer to convert images to WebP, resize to appropriate dimensions, and compress without visible quality loss. This can reduce image sizes by 60-80%.\n\n'
          '**3. Code Splitting**\n'
          'Split your application into smaller chunks that load on demand. Use deferred imports for heavy packages.\n\n'
          '**4. Tree Shaking**\n'
          'Ensure you import only what you need. SFWF\'s modular architecture helps keep your bundle small.\n\n'
          '**5. Caching**\n'
          'Implement proper caching strategies with CacheManager and Service Workers for instant loading on repeat visits.',
    ),
    BlogPost(
      slug: 'ssr-flutter',
      title: 'Server-Side Rendering with Flutter',
      description:
          'Implement SSR in Flutter web apps using Puppeteer. Improve initial load time and SEO with pre-rendered HTML.',
      category: 'SSR',
      readTime: '8 min read',
      icon: Icons.dns,
      author: 'Bahy Osama',
      date: 'Dec 15, 2025',
      body:
          'Server-Side Rendering solves two major Flutter web problems: slow initial load and poor SEO indexing.\n\n'
          '**How SSR Works in SFWF**\n'
          'SFWF uses Puppeteer to render your Flutter app on the server, producing static HTML that search engines can index. The HTML is then hydrated on the client for interactivity.\n\n'
          '**Setup**\n'
          '```\n'
          'dart run sfwf serve --port=8080\n'
          '```\n\n'
          '**Pre-rendering**\n'
          'For static routes, pre-render at build time:\n'
          '```\n'
          'dart run sfwf build --prerender\n'
          '```\n\n'
          '**Hybrid Mode**\n'
          'Use hybrid rendering where some routes are pre-rendered and others are rendered on-demand.',
    ),
    BlogPost(
      slug: 'state-management-flutter-web',
      title: 'State Management in Flutter Web',
      description:
          'Compare Riverpod, Bloc, and Provider for Flutter web. Best practices for scalable state management in large web applications.',
      category: 'State Management',
      readTime: '6 min read',
      icon: Icons.account_tree,
      author: 'Flutter Team',
      date: 'Dec 10, 2025',
      body:
          'Choosing the right state management solution is crucial for scalable Flutter web apps.\n\n'
          '**Why Riverpod?**\n'
          'Riverpod 3.x offers several advantages over other solutions:\n'
          '- Compile-time safety (no runtime ProviderNotFoundException)\n'
          '- Better testability with ProviderContainer\n'
          '- Support for async providers and family modifiers\n'
          '- No BuildContext dependency\n\n'
          '**Comparison**\n'
          '| Feature | Riverpod | Bloc | Provider |\n'
          '|---------|----------|------|----------|\n'
          '| Compile safety | ✅ | ❌ | ❌ |\n'
          '| Testability | ✅ Excellent | ✅ Good | ⚠️ Moderate |\n'
          '| Boilerplate | Low | High | Low |\n'
          '| Learning curve | Medium | High | Low |\n\n'
          '**Integration with SFWF**\n'
          'SFWF works seamlessly with Riverpod. Use ProviderScope at the root and inject providers throughout your app.',
    ),
  ];
}

final blogProvider = NotifierProvider<BlogNotifier, BlogState>(BlogNotifier.new);

final blogPostBySlugProvider = Provider.family<BlogPost?, String>((ref, slug) {
  final state = ref.watch(blogProvider);
  try {
    return state.all.firstWhere((p) => p.slug == slug);
  } catch (_) {
    return null;
  }
});
