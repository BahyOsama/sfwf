#!/usr/bin/env dart

import 'dart:io';

import 'package:args/args.dart';
import 'package:sfwf/ai/ai_analyzer.dart';
import 'package:sfwf/prerender/prerender_cli.dart';
import 'package:sfwf/seo/sitemap_generator.dart';
import 'package:sfwf/seo/robots_generator.dart';
import 'package:sfwf/performance/image_optimizer.dart';
import 'package:sfwf/performance/service_worker.dart';
import 'package:sfwf/ssr/ssr_server.dart' as server;

Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addFlag('prerender', abbr: 'p', help: 'Enable pre-rendering on build')
    ..addFlag('analyze', abbr: 'a', help: 'Run AI analysis after build')
    ..addFlag('optimize-images', help: 'Optimize all images in assets')
    ..addFlag('generate-sw', help: 'Generate Service Worker for PWA')
    ..addOption('port',
        abbr: 'P', help: 'Port for serve command', defaultsTo: '3000')
    ..addOption('base-url',
        help: 'Base URL for sitemap', defaultsTo: 'https://example.com')
    ..addFlag('help', abbr: 'h', help: 'Show help', defaultsTo: false);

  final results = parser.parse(arguments);
  final command =
      results.arguments.isNotEmpty ? results.arguments.first : 'help';

  if (results['help'] as bool) {
    _printHelp();
    return;
  }

  switch (command) {
    case 'create':
      if (results.arguments.length < 2) {
        stderr.writeln('Usage: sfwf create <project_name>');
        exit(1);
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

/// Finds the Flutter project root by looking for lib/main.dart.
/// Falls back to example/lib/main.dart if not found in current dir.
String? _findProjectRoot() {
  if (File('lib/main.dart').existsSync()) return '.';
  if (File('example/lib/main.dart').existsSync()) return 'example';
  return null;
}

/// Extracts asset directory paths from pubspec.yaml.
List<String> _getAssetDirsFromPubspec() {
  final pubspec = File('pubspec.yaml');
  if (!pubspec.existsSync()) return [];

  final lines = pubspec.readAsLinesSync();
  final assets = <String>[];
  bool inAssets = false;

  for (final line in lines) {
    final trimmed = line.trimLeft();
    if (inAssets) {
      if (!trimmed.startsWith('- ')) {
        inAssets = false;
        continue;
      }
      final path = trimmed.substring(2).trim();
      if (path.endsWith('/')) {
        assets.add(path);
      } else if (!path.endsWith('.dart')) {
        assets.add(path.substring(0, path.lastIndexOf('/') + 1));
      }
    } else if (trimmed == 'assets:') {
      inAssets = true;
    }
  }
  return assets.toSet().toList();
}

/// Ensures consistent forward-slash paths for asset references.
String _relativeAssetPath(String dir) {
  return dir.replaceAll('\\', '/');
}

void _printHelp() {
  stdout.writeln('''
Smart Flutter Web Framework (SFWF) CLI v2.0.0

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
    stderr.writeln('Directory "$name" already exists.');
    exit(1);
  }
  await projectDir.create();
  await _createDirectoryStructure(projectDir);
  await _writeTemplateFiles(projectDir);
  stdout.writeln('Project "$name" created successfully!');
  stdout.writeln('Next steps:\n  cd $name\n  flutter pub get\n  sfwf build');
}

Future<void> _createDirectoryStructure(Directory base) async {
  await Directory('${base.path}/lib/pages').create(recursive: true);
  await Directory('${base.path}/lib/providers').create(recursive: true);
  await Directory('${base.path}/assets/images').create(recursive: true);
  await Directory('${base.path}/assets/icons').create(recursive: true);
  await Directory('${base.path}/web').create(recursive: true);
}

Future<void> _writeTemplateFiles(Directory base) async {
  final name = base.path.split(Platform.isWindows ? '\\' : '/').last;

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
      defaultDescription: 'Built with Smart Flutter Web Framework',
    ),
    ssrMode: SsrMode.hybrid,
    enableAI: false,
  );

  runApp(ProviderScope(
    child: SFWFApp(
      config: config,
      routes: {
        '/': (ctx) => const HomePage(),
        '/about': (ctx) => const AboutPage(),
      },
    ),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final seo = SeoController.of(context);
    seo.updatePage(const SeoData(
      title: 'Home',
      description: 'Welcome to my SFWF website',
    ));
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome to SFWF')),
      body: const Center(child: Text('High performance, perfect SEO, unmatched UX!')),
    );
  }
}

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    SeoController.of(context).updatePage(const SeoData(
      title: 'About',
      description: 'Learn about the power of SFWF',
    ));
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('SFWF goes beyond JavaScript')),
    );
  }
}
''');

  await File('${base.path}/web/index.html').writeAsString('''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>SFWF App</title>
  <script>
    window.__SFWF_STATE__ = null;
  </script>
</head>
<body>
  <script src="main.dart.js" defer></script>
</body>
</html>
''');
}

Future<void> _build({
  bool prerender = false,
  bool analyze = false,
  bool optimizeImages = false,
  bool generateSw = false,
}) async {
  // Auto-detect project root
  final projectDir = _findProjectRoot();
  if (projectDir == null) {
    stderr.writeln('No Flutter project found. Run this command from a Flutter project directory.');
    stderr.writeln('  - Create a new project: sfwf create my_app && cd my_app');
    stderr.writeln('  - Or use the example app: cd example && dart run ../bin/sfwf.dart build');
    exit(1);
  }
  if (projectDir != '.') {
    stderr.writeln('No lib/main.dart found in current directory.');
    stderr.writeln('Changing to "$projectDir/" directory...');
    Directory.current = projectDir;
  }

  stdout.writeln('Building Flutter web app...');
  final result = await Process.run('flutter', ['build', 'web', '--release'],
      runInShell: true);
  if (result.exitCode != 0) {
    stderr.writeln('Build failed: ${result.stderr}');
    exit(1);
  }
  stdout.writeln('Build complete.');

  if (optimizeImages) {
    stdout.writeln('Optimizing images...');
    final assetDirs = _getAssetDirsFromPubspec();
    if (assetDirs.isEmpty) {
      stderr.writeln('No asset directories declared in pubspec.yaml.');
      stderr.writeln('Add assets to your pubspec.yaml under flutter:');
      stderr.writeln('  flutter:');
      stderr.writeln('    assets:');
      stderr.writeln('      - assets/images/');
    } else {
      for (final dir in assetDirs) {
        final source = Directory(dir);
        if (await source.exists()) {
          final outDir = 'build/web/assets/${_relativeAssetPath(dir)}';
          stdout.writeln('  Optimizing $dir -> $outDir');
          await ImageOptimizer.optimizeAll(dir, outDir);
        } else {
          stdout.writeln('  Skipping $dir (not found)');
        }
      }
    }
  }
  if (prerender) {
    stdout.writeln('Pre-rendering routes...');
    await PrerenderCli.prerenderRoutes(['/', '/about'], 'http://localhost:8080', 'build/web');
  }
  if (generateSw) {
    stdout.writeln('Generating Service Worker...');
    await ServiceWorkerGenerator.generate('build/web');
  }
  if (analyze) {
    await _analyze();
  }
  stdout.writeln('Build complete. Output in build/web/');
}

Future<void> _serve({int port = 3000}) async {
  stdout.writeln('Starting SFWF SSR server on port $port...');

  // Auto-detect build directory
  var buildDir = Directory('build/web');
  var buildDirPath = buildDir.absolute.path;
  if (!await buildDir.exists()) {
    final exampleDir = Directory('example/build/web');
    final exampleDirPath = exampleDir.absolute.path;
    if (await exampleDir.exists()) {
      stderr.writeln('No build/web found in current directory.');
      stderr.writeln('Using "$exampleDirPath"...');
      Directory.current = 'example';
      buildDirPath = exampleDirPath;
    } else {
      stderr.writeln('Build directory not found. Run `sfwf build` first.');
      exit(1);
    }
  }

  await server.startSsrServer(buildDirPath: buildDirPath, port: port);
}

Future<void> _analyze() async {
  stdout.writeln('Running AI analysis...');
  final analyzer = AIAnalyzer(openAiKey: Platform.environment['OPENAI_API_KEY']);
  final htmlFile = File('build/web/index.html');
  if (await htmlFile.exists()) {
    final html = await htmlFile.readAsString();
    final report = await analyzer.analyzePage(html, '/');
    stdout.writeln(report.toString());
  } else {
    stderr.writeln('No built site found. Run `sfwf build` first.');
  }
}

Future<void> _generateSitemap(String baseUrl) async {
  final routes = ['/', '/about'];
  await SitemapGenerator.generate(baseUrl, routes, 'build/web/sitemap.xml');
  await RobotsGenerator.generate('$baseUrl/sitemap.xml', 'build/web/robots.txt');
  stdout.writeln('Sitemap and robots.txt generated in build/web/');
}
