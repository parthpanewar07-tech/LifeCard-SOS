import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:life_card_and_sos/features/home/dashboard_view.dart';
import 'package:life_card_and_sos/models/user_profile.dart';
import 'package:life_card_and_sos/shared/providers.dart';

class MockProfileNotifier extends ProfileNotifier {
  final UserProfile profile;
  MockProfileNotifier(this.profile);

  @override
  Future<UserProfile> build() async => profile;
}

void main() {
  testWidgets('DashboardView renders greeting name and blood group card', (WidgetTester tester) async {
    const mockProfile = UserProfile(
      fullName: 'John Doe',
      bloodGroup: 'O- Negative',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileProvider.overrideWith(() => MockProfileNotifier(mockProfile)),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: DashboardView(),
          ),
        ),
      ),
    );

    // Wait for the state to load and UI to settle
    await tester.pumpAndSettle();

    // Check greeting details
    expect(find.text('Good morning,'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);

    // Check blood group card values
    expect(find.text('Blood Group'), findsOneWidget);
    expect(find.text('O- Negative'), findsOneWidget);
  });

  testWidgets('DashboardView renders Not Specified when blood group is empty', (WidgetTester tester) async {
    const mockProfile = UserProfile(
      fullName: 'John Doe',
      bloodGroup: '',
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          profileProvider.overrideWith(() => MockProfileNotifier(mockProfile)),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: DashboardView(),
          ),
        ),
      ),
    );

    // Wait for the state to load and UI to settle
    await tester.pumpAndSettle();

    // Check greeting details
    expect(find.text('Good morning,'), findsOneWidget);
    expect(find.text('John Doe'), findsOneWidget);

    // Check blood group card values
    expect(find.text('Blood Group'), findsOneWidget);
    expect(find.text('Not Specified'), findsOneWidget);
  });
}
