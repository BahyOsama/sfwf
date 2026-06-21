import 'package:flutter_test/flutter_test.dart';
import 'package:sfwf/router/smart_router.dart';

void main() {
  test('RoutePath parsing works', () {
    const path = RoutePath('/user/123', params: {'tab': 'profile'});
    expect(path.path, '/user/123');
    expect(path.params['tab'], 'profile');
  });

  test('RoutePath with query params', () {
    const path = RoutePath('/search', queryParams: {'q': 'flutter', 'page': '1'});
    expect(path.queryParams['q'], 'flutter');
    expect(path.queryParams['page'], '1');
  });

  test('RoutePath empty params', () {
    const path = RoutePath('/');
    expect(path.params, isEmpty);
    expect(path.queryParams, isEmpty);
  });
}
