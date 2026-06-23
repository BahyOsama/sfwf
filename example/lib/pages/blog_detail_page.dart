import 'package:flutter/material.dart';
import 'package:sfwf/sfwf.dart';
import '../widgets/layout.dart';

class BlogDetailPage extends StatelessWidget {
  final String postId;
  const BlogDetailPage({super.key, required this.postId});

  static const _posts = [
    _BlogPost(
      'Flutter Web in 2026: The Complete Guide',
      'Discover why Flutter web has become the go-to framework for building production web apps. We cover SEO, performance, and real-world case studies.',
      'Flutter Web', '5 min read', Icons.web,
      'Flutter Web has evolved significantly since its early days. In 2026, it stands as a mature platform for building complex web applications. This comprehensive guide covers everything from setup to deployment, including SEO optimization, performance tuning, and integration with popular backend services. Whether you are building a simple portfolio or a full-fledged SaaS platform, Flutter Web now offers the tools and ecosystem to make it happen.',
    ),
    _BlogPost(
      'Why SEO Matters for Flutter Web Apps',
      'Learn how to make your Flutter web app search-engine friendly with dynamic meta tags, structured data, and server-side rendering.',
      'SEO', '4 min read', Icons.search,
      'Search Engine Optimization is often overlooked by Flutter web developers, yet it is critical for discoverability. This article explains how SFWF handles dynamic meta tags per page, injects JSON-LD structured data for rich snippets, generates sitemap.xml and robots.txt automatically, and supports server-side rendering with Puppeteer for complete SEO coverage.',
    ),
    _BlogPost(
      'Building PWA with Flutter: Complete Tutorial',
      'Step-by-step guide to adding Progressive Web App support to your Flutter web project.',
      'PWA', '7 min read', Icons.phonelink,
      'Progressive Web Apps bridge the gap between web and native experiences. This tutorial walks through generating service workers with cache versioning, creating manifest.json for install prompts, implementing offline-first strategies with CacheManager, and handling push notifications for user re-engagement.',
    ),
    _BlogPost(
      'Performance Optimization for Flutter Web',
      'Tips to optimize your Flutter web app for speed using lazy loading and code splitting.',
      'Performance', '6 min read', Icons.speed,
      'Performance is paramount for user retention and conversion rates. This guide covers lazy loading of images and components, image optimization with WebP conversion and compression, code splitting patterns for reducing initial bundle size, and using the DeviceDetector to serve appropriate assets per platform.',
    ),
    _BlogPost(
      'Server-Side Rendering with Flutter',
      'Implement SSR in Flutter web apps using Puppeteer for improved initial load time.',
      'SSR', '8 min read', Icons.dns,
      'Server-Side Rendering solves two major Flutter web problems: slow initial load and poor SEO indexing. This article details setting up the Puppeteer-based SSR renderer, pre-rendering static routes at build time, hybrid rendering strategies, and measuring the performance impact of SSR on real-world applications.',
    ),
    _BlogPost(
      'State Management in Flutter Web',
      'Compare Riverpod, Bloc, and Provider for Flutter web applications.',
      'State Management', '6 min read', Icons.account_tree,
      'Choosing the right state management solution is crucial for scalable Flutter web apps. We compare Riverpod 3.x with Bloc and Provider, examining performance on web, ease of use, testing capabilities, and integration with SFWF features like the Smart Router and caching layer.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final post = _posts.firstWhere(
      (p) => p.title.hashCode.toString() == postId,
      orElse: () => _posts.first,
    );

    SeoController.of(context).updatePage(SeoData(
      title: '${post.title} - SFWF Blog',
      description: post.description,
      ogType: 'article',
      structuredData: {
        '@context': 'https://schema.org',
        '@type': 'Article',
        'headline': post.title,
        'description': post.description,
      },
    ));

    final isDesktop = DeviceDetector.isDesktop;
    final theme = Theme.of(context);

    return AppLayout(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 80 : 24,
          vertical: 48,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back, size: 20),
                  const SizedBox(width: 8),
                  Text('Back to Blog',
                      style: TextStyle(color: theme.colorScheme.primary)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Chip(label: Text(post.category, style: const TextStyle(fontSize: 12))),
            const SizedBox(height: 12),
            Text(post.title,
                style: TextStyle(
                  fontSize: isDesktop ? 36 : 28,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Text(post.readTime,
                style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                )),
            const SizedBox(height: 24),
            Text(post.body,
                style: const TextStyle(fontSize: 16, height: 1.6)),
          ],
        ),
      ),
    );
  }
}

class _BlogPost {
  final String title;
  final String description;
  final String category;
  final String readTime;
  final IconData icon;
  final String body;
  const _BlogPost(this.title, this.description, this.category, this.readTime, this.icon, this.body);
}
