import 'package:flutter_test/flutter_test.dart';
import 'package:sfwf/router/smart_router.dart';

void main() {
  test('RoutePath parsing works', () {
    final path = RoutePath('/user/123', params: {'tab': 'profile'});
    expect(path.path, '/user/123');
    expect(path.params['tab'], 'profile');
  });
}
