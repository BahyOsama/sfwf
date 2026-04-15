import 'dart:io';
import 'package:xml/xml.dart';

class SitemapGenerator {
  static Future<void> generate(
    String baseUrl,
    List<String> routes,
    String outputPath,
  ) async {
    final urlset = XmlElement(
      XmlName('urlset'),
      [
        XmlAttribute(
            XmlName('xmlns'), 'http://www.sitemaps.org/schemas/sitemap/0.9')
      ],
      [], // children فارغة في البداية
    );

    for (final route in routes) {
      final loc = XmlElement(XmlName('loc'), [], [XmlText('$baseUrl$route')]);
      final lastmod = XmlElement(
          XmlName('lastmod'), [], [XmlText(DateTime.now().toIso8601String())]);
      final changefreq =
          XmlElement(XmlName('changefreq'), [], [XmlText('weekly')]);
      final priority = XmlElement(XmlName('priority'), [], [XmlText('0.8')]);

      final url =
          XmlElement(XmlName('url'), [], [loc, lastmod, changefreq, priority]);
      urlset.children.add(url);
    }

    final doc = XmlDocument([urlset]);
    await File(outputPath).writeAsString(doc.toXmlString(pretty: true));
  }
}
