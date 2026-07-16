import 'package:flutter_test/flutter_test.dart';
import 'package:life_card_and_sos/models/user_profile.dart';

void main() {
  group('UserProfileAge Extension Tests', () {
    test('Calculates age correctly for standard past DOB', () {
      final dob = DateTime(1995, 6, 15);
      final profile = UserProfile(dateOfBirth: dob);

      final today = DateTime.now();
      int expectedAge = today.year - dob.year;
      if (today.month < dob.month ||
          (today.month == dob.month && today.day < dob.day)) {
        expectedAge--;
      }

      expect(profile.age, expectedAge);
    });

    test('Returns 0 when dateOfBirth is null', () {
      const profile = UserProfile(dateOfBirth: null);
      expect(profile.age, 0);
    });
  });
}
