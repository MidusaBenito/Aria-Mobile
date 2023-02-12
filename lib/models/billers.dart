import 'package:json_annotation/json_annotation.dart';
part 'billers.g.dart';

@JsonSerializable()
class Billers {
  String biller_name, biller_id, logo_url;

  Billers(
      {required this.biller_name,
      required this.biller_id,
      required this.logo_url});
  factory Billers.fromJson(Map<String, dynamic> data) =>
      _$BillersFromJson(data);
  Map<String, dynamic> toJson() => _$BillersToJson(this);
}
