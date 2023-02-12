import 'package:json_annotation/json_annotation.dart';
import 'package:ariaquickpay/models/billerNames.dart';
part 'due_dates.g.dart';

@JsonSerializable(explicitToJson: true)
class myCalendarDataResponse {
  String due_date;
  List<BillerNames> bill_name;

  myCalendarDataResponse({required this.due_date, required this.bill_name});

  factory myCalendarDataResponse.fromJson(Map<String, dynamic> data) =>
      _$myCalendarDataResponseFromJson(data);
  Map<String, dynamic> toJson() => _$myCalendarDataResponseToJson(this);
}
