import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfwf/sfwf.dart';
import 'pages/home_page.dart';
import 'pages/projects_page.dart';
import 'pages/blog_page.dart';
import 'pages/blog_detail_page.dart';
import 'pages/contact_page.dart';
import 'pages/not_found_page.dart';
import 'pages/project_detail_page.dart';

void main() {
  const config = SFWFConfig(
    appName: 'SFWF Showcase',
    baseUrl: 'https://github.com/BahyOsama/sfwf',
    seoDefaults: SeoDefaults(
      titleSuffix: ' | SFWF Showcase',
      defaultDescription:
          'A production-ready Flutter web app built with Smart Flutter Web Framework - SEO, SSR, PWA.',
      defaultImage: 'https://github.com/BahyOsama/sfwf/og-image.png',
      twitterHandle: '@sfwf',
    ),
    ssrMode: SsrMode.hybrid,
    enableAI: false,
    enablePwa: true,
    supportedLocales: [Locale('en'), Locale('ar')],
  );

  runApp(
    ProviderScope(
      child: SFWFApp(
        config: config,
        routes: {
          '/': (ctx) => const HomePage(),
          '/projects': (ctx) => const ProjectsPage(),
          '/blog': (ctx) => const BlogPage(),
          '/contact': (ctx) => const ContactPage(),
          '/projects/:id': (ctx) {
            final args = ModalRoute.of(ctx)?.settings.arguments;
            final params = args is Map<String, String> ? args : <String, String>{};
            return ProjectDetailPage(projectId: params['id'] ?? '0');
          },
          '/blog/:slug': (ctx) {
            final args = ModalRoute.of(ctx)?.settings.arguments;
            final params = args is Map<String, String> ? args : <String, String>{};
            return BlogDetailPage(postId: params['slug'] ?? '0');
          },
        },
        routeDefinitions: [
          const RouteDefinition(path: '/projects/:id', name: '/projects/:id'),
          const RouteDefinition(path: '/blog/:slug', name: '/blog/:slug'),
        ],
        notFoundBuilder: (ctx) => const NotFoundPage(),
        customTransitions: {
          '/': _fadeTransition,
          '/projects': _slideUpTransition,
        },
        lifecycleHooks: [LoggerHook()],
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.indigo,
          brightness: Brightness.light,
        ),
      ),
    ),
  );
}

Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(opacity: animation, child: child);
}

Widget _slideUpTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
    child: child,
  );
}
