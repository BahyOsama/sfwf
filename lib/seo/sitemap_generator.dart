import 'dart:io';

import 'package:xml/xml.dart';

class SitemapGenerator {
  static Future<void> generate(
    String baseUrl,
    List<String> routes,
    String outputPath, {
    Map<String, String> priorities = const {},
    Map<String, String> frequencies = const {},
  }) async {
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0" encoding="UTF-8"');
    builder.element('urlset', nest: () {
      builder.attribute('xmlns', 'http://www.sitemaps.org/schemas/sitemap/0.9');
      for (final route in routes) {
        builder.element('url', nest: () {
          builder.element('loc', nest: '$baseUrl$route');
          builder.element('lastmod', nest: DateTime.now().toIso8601String());
          builder.element('changefreq',
              nest: frequencies[route] ?? 'weekly');
          builder.element('priority',
              nest: priorities[route] ?? '0.8');
        });
      }
    });

    final doc = builder.buildDocument();
    final output = Directory(outputPath).parent;
    if (!await output.exists()) {
      await output.create(recursive: true);
    }
    await File(outputPath).writeAsString(doc.toXmlString(pretty: true));
  }
}
