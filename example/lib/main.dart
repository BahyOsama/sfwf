import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sfwf/sfwf.dart';
import 'pages/home_page.dart';
import 'pages/projects_page.dart';
import 'pages/contact_page.dart';

void main() {
  final config = SFWFConfig(
    appName: 'Bahy Developer',
    baseUrl: 'https://bahy.dev',
    seoDefaults: const SeoDefaults(
      titleSuffix: ' | Bahy Developer',
      defaultDescription:
          'World-class Flutter developer. High-performance mobile apps.',
      defaultImage: '/assets/default-og.png',
      twitterHandle: '@bahydev',
    ),
    ssrMode: SsrMode.hybrid,
    enableAI: true,
  );

  runApp(ProviderScope(
      child: SFWFApp(
    config: config,
    routes: {
      '/': (ctx) => const HomePage(),
      '/projects': (ctx) => const ProjectsPage(),
      '/contact': (ctx) => const ContactPage(),
    },
    lifecycleHooks: [LoggerHook()],
  )));
}
