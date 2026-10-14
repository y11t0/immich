import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immich_mobile/widgets/forms/login/login_form.dart';

import '../../../widget_tester_extensions.dart';

void main() {
  testWidgets('shows only the empty server URL toast when Next is tapped with no URL', (tester) async {
    await tester.pumpConsumerWidget(LoginForm());

    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Enter a server URL'), findsOneWidget);
    expect(find.text('Server is not reachable'), findsNothing);

    await tester.pumpAndSettle(const Duration(seconds: 5));
  });
}
