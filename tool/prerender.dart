import 'dart:io';

import 'package:puppeteer/puppeteer.dart';

Future<void> main(List<String> args) async {
  final routes = args.isNotEmpty ? args : <String>['/', '/about'];
  const baseUrl = 'http://localhost:8080';
  final outputDir = Directory('build/web');

  if (!await outputDir.exists()) {
    stderr.writeln('❌ Build directory not found. Run `flutter build web` first.');
    exit(1);
  }

  stdout.writeln('🚀 Starting pre-rendering for ${routes.length} routes...');
  final browser = await puppeteer.launch(headless: true, args: ['--no-sandbox']);
  int success = 0;
  int failed = 0;

  for (final route in routes) {
    stdout.writeln('📄 Pre-rendering $route');
    final page = await browser.newPage();
    try {
      await page.goto('$baseUrl$route', wait: Until.networkIdle);
      final content = await page.content;
      final routePath = route == '/' ? '' : route;
      final file = File('${outputDir.path}$routePath/index.html');
      await file.create(recursive: true);
      await file.writeAsString(content ?? '');
      stdout.writeln('  ✅ Saved to ${file.path}');
      success++;
    } catch (e) {
      stderr.writeln('  ❌ Error pre-rendering $route: $e');
      failed++;
    } finally {
      await page.close();
    }
  }

  await browser.close();
  stdout.writeln('✅ Pre-rendering completed. $success succeeded, $failed failed.');
}
