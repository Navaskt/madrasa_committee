import 'package:freezed_annotation/freezed_annotation.dart';

part 'members.freezed.dart';
part 'members.g.dart';

@freezed
abstract class Member with _$Member {
  const factory Member({
    required String uid,
    @Default('') String name,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String address,
    @Default(0) int monthlyFee, // AED
    @Default(false) bool isAdmin,
  }) = _Member;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
}
