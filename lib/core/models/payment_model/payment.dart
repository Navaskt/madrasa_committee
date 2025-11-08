import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment.freezed.dart';
part 'payment.g.dart';

@freezed
abstract class Payment with _$Payment {
  const factory Payment({
    required String id,
    required String memberId,
    required int amount, // AED
    required int month, // 1-12
    required int year, // e.g., 2025
    required DateTime createdAt,
    @Default('') String note,
  }) = _Payment;

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);
}
