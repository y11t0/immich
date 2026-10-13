import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:immich_mobile/widgets/forms/login/login_form.dart';

import '../../../unit/presentation/presentation_context.dart';

void main() {
  late PresentationContext context;

  setUp(() async => context = await PresentationContext.create());
  tearDown(() => context.dispose());

  testWidgets('shows only the empty server URL toast when Next is tapped without a URL', (tester) async {
    await tester.pumpTestWidget(
      context,
      // The logo rotates forever, so mute its ticker to let the tree settle.
      Material(child: TickerMode(enabled: false, child: LoginForm())),
    );

    final next = find.text('Next');
    await tester.ensureVisible(next);
    await tester.tap(next);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Enter a server URL'), findsOneWidget);
    // Every error toast renders this icon, so a second toast from a connection attempt would add another.
    expect(find.byIcon(Icons.error_outline_rounded), findsOneWidget);

    // Let the toast expire so no timers are left pending.
    await tester.pump(const Duration(seconds: 5));
  });
}
