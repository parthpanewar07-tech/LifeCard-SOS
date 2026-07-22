import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    @Default('') String photoPath,
    @Default('') String fullName,
    @Default('') String nickname,
    DateTime? dateOfBirth,
    @Default('') String gender,
    @Default('') String bloodGroup,
    @Default(0.0) double height,
    @Default(0.0) double weight,
    @Default('') String nationality,
    @Default('') String address,
    @Default('') String city,
    @Default('') String district,
    @Default('') String state,
    @Default('') String country,
    @Default('') String pinCode,
    @Default('') String occupation,
    String? aadhaar,
    @Default('') String emergencyNotes,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}

extension UserProfileAge on UserProfile {
  int get age {
    if (dateOfBirth == null) return 0;
    final today = DateTime.now();
    int age = today.year - dateOfBirth!.year;
    if (today.month < dateOfBirth!.month ||
        (today.month == dateOfBirth!.month && today.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }
}
