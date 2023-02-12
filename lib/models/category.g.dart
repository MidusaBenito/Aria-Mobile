// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      category_name: json['category_name'] as String,
      category_id: json['category_id'] as String,
      category_billers: (json['category_billers'] as List<dynamic>)
          .map((e) => Billers.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'category_name': instance.category_name,
      'category_id': instance.category_id,
      'category_billers':
          instance.category_billers.map((e) => e.toJson()).toList(),
    };
