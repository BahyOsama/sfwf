class SitemapGenerator {
  static Future<void> generate(
    String baseUrl,
    List<String> routes,
    String outputPath, {
    Map<String, String> priorities = const {},
    Map<String, String> frequencies = const {},
  }) {
    throw UnsupportedError(
      'SitemapGenerator.generate() requires dart:io (not available on this platform).',
    );
  }
}
