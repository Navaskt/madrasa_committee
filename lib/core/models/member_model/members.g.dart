// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'members.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Member _$MemberFromJson(Map<String, dynamic> json) => _Member(
  uid: json['uid'] as String,
  name: json['name'] as String? ?? '',
  email: json['email'] as String? ?? '',
  phone: json['phone'] as String? ?? '',
  address: json['address'] as String? ?? '',
  monthlyFee: (json['monthlyFee'] as num?)?.toInt() ?? 0,
  isAdmin: json['isAdmin'] as bool? ?? false,
);

Map<String, dynamic> _$MemberToJson(_Member instance) => <String, dynamic>{
  'uid': instance.uid,
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'address': instance.address,
  'monthlyFee': instance.monthlyFee,
  'isAdmin': instance.isAdmin,
};
