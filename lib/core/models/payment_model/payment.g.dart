// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
  id: json['id'] as String,
  memberId: json['memberId'] as String,
  amount: (json['amount'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  year: (json['year'] as num).toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  note: json['note'] as String? ?? '',
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
  'id': instance.id,
  'memberId': instance.memberId,
  'amount': instance.amount,
  'month': instance.month,
  'year': instance.year,
  'createdAt': instance.createdAt.toIso8601String(),
  'note': instance.note,
};
