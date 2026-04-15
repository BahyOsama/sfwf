import 'dart:io';

class RobotsGenerator {
  static Future<void> generate(String sitemapUrl, String outputPath) async {
    final content = '''
User-agent: *
Allow: /
Sitemap: $sitemapUrl
''';
    await File(outputPath).writeAsString(content);
  }
}
