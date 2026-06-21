import 'package:flutter_test/flutter_test.dart';
import 'package:sfwf/seo/seo_controller.dart';

void main() {
  test('SeoData merge works', () {
    const base = SeoData(title: 'Base');
    const other = SeoData(description: 'Desc');
    final merged = base.merge(other);
    expect(merged.title, 'Base');
    expect(merged.description, 'Desc');
  });

  test('SeoData merge with all fields', () {
    const base = SeoData(
      title: 'Title',
      description: 'Desc',
      image: '/img.png',
      structuredData: {'key': 'value'},
    );
    final merged = base.merge(const SeoData());
    expect(merged.title, 'Title');
    expect(merged.description, 'Desc');
    expect(merged.image, '/img.png');
    expect(merged.structuredData, {'key': 'value'});
  });

  test('SeoData merge override', () {
    const base = SeoData(title: 'Old', description: 'Old Desc');
    const other = SeoData(title: 'New', description: 'New Desc');
    final merged = base.merge(other);
    expect(merged.title, 'New');
    expect(merged.description, 'New Desc');
  });
}
