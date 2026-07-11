import 'dart:io';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:puppeteer/puppeteer.dart';

Future<void> startSsrServer({required String buildDirPath, int port = 3000}) async {
  final buildDir = Directory(buildDirPath);
  if (!await buildDir.exists()) {
    stderr.writeln('Build directory not found: $buildDirPath');
    stderr.writeln('Run `flutter build web` first.');
    exit(1);
  }

  stdout.writeln('Launching SSR browser...');
  final browser = await puppeteer.launch(
    headless: true,
    args: ['--no-sandbox', '--disable-gpu'],
  );
  stdout.writeln('SSR browser ready');

  final router = Router();

  router.get('/<.*>', (shelf.Request req) async {
    final path = req.url.path.isEmpty ? '/index.html' : '/${req.url.path}';
    final staticFile = File('${buildDir.path}$path');

    if (await staticFile.exists()) {
      final content = await staticFile.readAsString();
      return shelf.Response.ok(content, headers: {
        'content-type': 'text/html',
        'cache-control': 'public, max-age=3600',
      });
    }

    final page = await browser.newPage();
    try {
      await page.goto('http://localhost:8080/${req.url.path}',
          wait: Until.networkIdle);
      final content = await page.content;
      return shelf.Response.ok(content ?? '', headers: {
        'content-type': 'text/html',
        'cache-control': 'public, max-age=300',
      });
    } catch (e) {
      return shelf.Response.internalServerError(
        body: 'SSR Error: $e',
      );
    } finally {
      await page.close();
    }
  });

  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(router.call);

  final server = await io.serve(handler, 'localhost', port);
  stdout.writeln('SFWF SSR server running on http://${server.address.host}:${server.port}');

  ProcessSignal.sigint.watch().listen((_) async {
    stdout.writeln('\nShutting down...');
    await browser.close();
    await server.close();
    exit(0);
  });
}