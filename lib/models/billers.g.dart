// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billers.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Billers _$BillersFromJson(Map<String, dynamic> json) => Billers(
      biller_name: json['biller_name'] as String,
      biller_id: json['biller_id'] as String,
      logo_url: json['logo_url'] as String,
    );

Map<String, dynamic> _$BillersToJson(Billers instance) => <String, dynamic>{
      'biller_name': instance.biller_name,
      'biller_id': instance.biller_id,
      'logo_url': instance.logo_url,
    };
