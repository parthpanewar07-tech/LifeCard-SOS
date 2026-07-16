import 'package:freezed_annotation/freezed_annotation.dart';

part 'helpline.freezed.dart';
part 'helpline.g.dart';

@freezed
abstract class Helpline with _$Helpline {
  const factory Helpline({
    required String id,
    required String name,
    required String number,
    required String category,
    @Default(false) bool isFavorite,
    @Default('') String notes,
  }) = _Helpline;

  factory Helpline.fromJson(Map<String, dynamic> json) =>
      _$HelplineFromJson(json);
}
