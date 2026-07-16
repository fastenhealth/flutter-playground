import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_playground/main.dart';

void main() {
  test('uses the shared Fasten test public ID', () {
    expect(customerPublicId, startsWith('public_test_'));
  });
}
