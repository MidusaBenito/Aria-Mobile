// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'due_dates.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

myCalendarDataResponse _$myCalendarDataResponseFromJson(
        Map<String, dynamic> json) =>
    myCalendarDataResponse(
      due_date: json['due_date'] as String,
      bill_name: (json['bill_name'] as List<dynamic>)
          .map((e) => BillerNames.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$myCalendarDataResponseToJson(
        myCalendarDataResponse instance) =>
    <String, dynamic>{
      'due_date': instance.due_date,
      'bill_name': instance.bill_name.map((e) => e.toJson()).toList(),
    };
