import 'dart:developer';
import 'dart:io';
import 'package:puppeteer/puppeteer.dart';

Future<void> main(List<String> args) async {
  final routes = args.isNotEmpty ? args : ['/', '/about'];
  final baseUrl = 'http://localhost:8080';
  final outputDir = Directory('build/web');

  final browser = await puppeteer.launch(headless: true);
  for (final route in routes) {
    log('📄 Pre-rendering $route');
    final page = await browser.newPage();
    try {
      await page.goto('$baseUrl$route', wait: Until.networkIdle);
      final content = await page.content;
      final routePath = route == '/' ? '' : route;
      final file = File('${outputDir.path}$routePath/index.html');
      await file.create(recursive: true);
      await file.writeAsString(content!);
    } catch (e) {
      log('❌ Error pre-rendering $route: $e');
    } finally {
      await page.close();
    }
  }
  await browser.close();
  log('✅ Pre-rendering completed.');
}
