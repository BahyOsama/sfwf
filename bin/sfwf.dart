#!/usr/bin/env dart

import 'dart:developer';
import 'dart:io';
import 'package:args/args.dart';
import 'package:sfwf/ai/ai_analyzer.dart';
import 'package:sfwf/prerender/prerender_cli.dart';
import 'package:sfwf/seo/sitemap_generator.dart';
import 'package:sfwf/seo/robots_generator.dart';
import 'package:sfwf/performance/image_optimizer.dart';
import 'package:sfwf/performance/service_worker.dart';

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('prerender', abbr: 'p', help: 'Enable pre-rendering on build')
    ..addFlag('analyze', abbr: 'a', help: 'Run AI analysis after build')
    ..addFlag('optimize-images', help: 'Optimize all images in assets')
    ..addFlag('generate-sw', help: 'Generate Service Worker for PWA')
    ..addOption('port',
        abbr: 'P', help: 'Port for serve command', defaultsTo: '3000')
    ..addOption('base-url',
        help: 'Base URL for sitemap', defaultsTo: 'https://example.com');

  final results = parser.parse(arguments);
  final command =
      results.arguments.isNotEmpty ? results.arguments.first : 'help';

  switch (command) {
    case 'create':
      if (results.arguments.length < 2) {
        log('Usage: sfwf create <project_name>');
        return;
      }
      await _createProject(results.arguments[1]);
      break;
    case 'build':
      final prerender = results['prerender'] as bool;
      final analyze = results['analyze'] as bool;
      final optimize = results['optimize-images'] as bool;
      final genSw = results['generate-sw'] as bool;
      await _build(
          prerender: prerender,
          analyze: analyze,
          optimizeImages: optimize,
          generateSw: genSw);
      break;
    case 'serve':
      final port = results['port'] as String;
      await _serve(port: int.parse(port));
      break;
    case 'analyze':
      await _analyze();
      break;
    case 'sitemap':
      final baseUrl = results['base-url'] as String;
      await _generateSitemap(baseUrl);
      break;
    default:
      _printHelp();
  }
}

void _printHelp() {
  log('''
🚀 Smart Flutter Web Framework (SFWF) CLI -超越 JS/TS 的终极方案

Usage:
  sfwf create <name>          Create a new SFWF project
  sfwf build [--prerender] [--analyze] [--optimize-images] [--generate-sw]  Build the project
  sfwf serve [--port]         Start the SSR server
  sfwf analyze                Run AI SEO analysis on built site
  sfwf sitemap [--base-url]   Generate sitemap.xml from routes

Examples:
  sfwf create my_website
  cd my_website && sfwf build --prerender --analyze --optimize-images
  sfwf serve --port=8080
''');
}

Future<void> _createProject(String name) async {
  final projectDir = Directory(name);
  if (await projectDir.exists()) {
    log('❌ Directory "$name" already exists.');
    return;
  }
  await projectDir.create();
  await _createDirectoryStructure(projectDir);
  await _writeTemplateFiles(projectDir);
  log('✅ Project "$name" created successfully!');
  log('Next steps:\n  cd $name\n  flutter pub get\n  sfwf build');
}

Future<void> _createDirectoryStructure(Directory base) async {
  await Directory('${base.path}/lib/pages').create(recursive: true);
  await Directory('${base.path}/lib/providers').create(recursive: true);
  await Directory('${base.path}/assets/images').create(recursive: true);
  await Directory('${base.path}/assets/icons').create(recursive: true);
  await Directory('${base.path}/web').create(recursive: true);
}

Future<void> _writeTemplateFiles(Directory base) async {
  final name = base.path.split('/').last;
  // pubspec.yaml
  await File('${base.path}/pubspec.yaml').writeAsString('''
name: $name
description: A new SFWF project.
version: 1.0.0

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  sfwf: ^2.0.0
  flutter_riverpod: ^2.4.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
''');
  // lib/main.dart
  await File('${base.path}/lib/main.dart').writeAsString('''
import 'package:flutter/material.dart';
import 'package:sfwf/sfwf.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  final config = SFWFConfig(
    appName: '$name',
    baseUrl: 'https://yourdomain.com',
    seoDefaults: const SeoDefaults(
      titleSuffix: ' | $name',
      defaultDescription: 'Built with SFWF -超越 JS/TS',
    ),
    ssrMode: SsrMode.hybrid,
    enableAI: false,
  );

  runApp(ProviderScope(child: SFWFApp(
    config: config,
    routes: {
      '/': (ctx) => const HomePage(),
      '/about': (ctx) => const AboutPage(),
    },
  )));
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final seo = SeoController.of(context);
    seo.updatePage(const SeoData(title: 'الصفحة الرئيسية', description: 'أسرع تجربة ويب مع Flutter'));
    return Scaffold(
      appBar: AppBar(title: const Text('مرحباً في SFWF')),
      body: const Center(child: Text('أداء خرافي، SEO مثالي، تجربة مستخدم لا تُقهر!')),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SeoController.of(context).updatePage(const SeoData(title: 'حول', description: 'تعرف على قوة SFWF'));
    return Scaffold(appBar: AppBar(title: const Text('حول')), body: const Center(child: Text('هذا الإطار يفوق JavaScript بمراحل')));
  }
}
''');
  // web/index.html template with hydration script
  await File('${base.path}/web/index.html').writeAsString('''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SFWF App</title>
  <script>
    // Hydration state placeholder
    window.__SFWF_STATE__ = null;
  </script>
</head>
<body>
  <script src="main.dart.js" defer></script>
</body>
</html>
''');
}

Future<void> _build(
    {bool prerender = false,
    bool analyze = false,
    bool optimizeImages = false,
    bool generateSw = false}) async {
  log('🔨 Building Flutter web app...');
  final result = await Process.run('flutter', ['build', 'web', '--release']);
  if (result.exitCode != 0) {
    log('❌ Build failed: ${result.stderr}');
    return;
  }
  log('✅ Build complete.');

  if (optimizeImages) {
    log('🖼️ Optimizing images...');
    await ImageOptimizer.optimizeAll(
        'assets/images', 'build/web/assets/images');
  }
  if (prerender) {
    log('📄 Pre-rendering routes...');
    await PrerenderCli.prerenderRoutes(
        ['/', '/about'], 'http://localhost:8080', 'build/web');
  }
  if (generateSw) {
    log('⚙️ Generating Service Worker...');
    await ServiceWorkerGenerator.generate('build/web');
  }
  if (analyze) {
    await _analyze();
  }
  log('🎉 Build complete. Output in build/web/');
}

Future<void> _serve({int port = 3000}) async {
  log('🌐 Starting SFWF SSR server on port $port...');
  // Use Node.js server by default (more stable)
  await Process.start('node', ['server/node_server.js', '--port=$port'],
      runInShell: true);
}

Future<void> _analyze() async {
  log('🤖 Running AI analysis...');
  final analyzer =
      AIAnalyzer(openAiKey: Platform.environment['OPENAI_API_KEY']);
  final htmlFile = File('build/web/index.html');
  if (await htmlFile.exists()) {
    final html = await htmlFile.readAsString();
    final report = await analyzer.analyzePage(html, '/');
    log(report as String);
  } else {
    log('⚠️ No built site found. Run `sfwf build` first.');
  }
}

Future<void> _generateSitemap(String baseUrl) async {
  final routes = ['/', '/about']; // يمكن قراءتها من ملف التوجيهات تلقائياً
  await SitemapGenerator.generate(baseUrl, routes, 'build/web/sitemap.xml');
  await RobotsGenerator.generate(
      '$baseUrl/sitemap.xml', 'build/web/robots.txt');
  log('✅ Sitemap and robots.txt generated in build/web/');
}
