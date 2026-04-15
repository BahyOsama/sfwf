import 'dart:developer';

import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:puppeteer/puppeteer.dart';

Future<void> main() async {
  final browser = await puppeteer.launch(headless: true);
  final router = Router();

  router.get('/<.*>', (shelf.Request req) async {
    final path = req.url.path;
    final page = await browser.newPage();
    try {
      await page.goto('http://localhost:8080$path', wait: Until.networkIdle);
      final content = await page.content;
      return shelf.Response.ok(content, headers: {'content-type': 'text/html'});
    } finally {
      await page.close();
    }
  });

  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(router.call);
  final server = await io.serve(handler, 'localhost', 3000);
  log('Dart SSR server on http://${server.address.host}:${server.port}');
}
