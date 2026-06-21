import 'dart:io';

class RobotsGenerator {
  static Future<void> generate(String sitemapUrl, String outputPath,
      {List<String> disallowPaths = const []}) async {
    final content = StringBuffer()
      ..writeln('User-agent: *')
      ..writeln('Allow: /');

    for (final path in disallowPaths) {
      content.writeln('Disallow: $path');
    }

    content.writeln('Sitemap: $sitemapUrl');

    final output = File(outputPath);
    await output.create(recursive: true);
    await output.writeAsString(content.toString());
  }
}
