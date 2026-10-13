import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/models/auth/auth_state.model.dart';
import 'package:immich_mobile/providers/auth.provider.dart';
import 'package:immich_mobile/widgets/forms/login/login_form.dart';
import 'package:mocktail/mocktail.dart';

import '../../../unit/presentation/presentation_context.dart';

class _MockAuthNotifier extends StateNotifier<AuthState> with Mock implements AuthNotifier {
  _MockAuthNotifier()
    : super(
        const AuthState(
          deviceId: '',
          userId: '',
          userEmail: '',
          name: '',
          profileImagePath: '',
          isAdmin: false,
          isAuthenticated: false,
        ),
      );
}

void main() {
  late PresentationContext context;
  late _MockAuthNotifier authNotifier;

  setUp(() async {
    context = await PresentationContext.create();
    authNotifier = _MockAuthNotifier();
    when(() => authNotifier.validateServerUrl(any())).thenThrow(Exception('unreachable'));
  });
  tearDown(() => context.dispose());

  testWidgets('empty server URL shows one error and does not contact the server', (tester) async {
    // The logo spins forever, so mute its ticker to let the harness settle.
    await tester.pumpTestWidget(
      context,
      TickerMode(enabled: false, child: LoginForm()),
      overrides: [authProvider.overrideWith((ref) => authNotifier)],
    );

    await tester.tap(find.text('Next'));
    await tester.pump();

    expect(find.text('Enter a server URL'), findsOneWidget);

    // Toasts are queued, so a second one would only appear after the first expires.
    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(seconds: 5));

    expect(find.text('Server is not reachable'), findsNothing);
    verifyNever(() => authNotifier.validateServerUrl(any()));
  });
}
