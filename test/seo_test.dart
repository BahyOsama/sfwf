import 'package:flutter_test/flutter_test.dart';
import 'package:sfwf/seo/seo_controller.dart';

void main() {
  test('SeoData merge works', () {
    final base = SeoData(title: 'Base');
    final other = SeoData(description: 'Desc');
    final merged = base.merge(other);
    expect(merged.title, 'Base');
    expect(merged.description, 'Desc');
  });
}
