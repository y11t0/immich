import 'package:flutter_test/flutter_test.dart';
import 'package:immich_mobile/widgets/forms/login/login_form.dart';

import '../../../unit/presentation/presentation_context.dart';

void main() {
  late PresentationContext context;

  setUp(() async => context = await PresentationContext.create());
  tearDown(() => context.dispose());

  testWidgets('shows only the empty URL toast when Next is tapped with no server URL', (tester) async {
    await tester.pumpTestWidget(context, LoginForm());

    await tester.tap(find.text('Next'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Enter a server URL'), findsOneWidget);
    expect(find.text('Server is not reachable'), findsNothing);
  });
}
