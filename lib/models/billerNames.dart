import 'package:json_annotation/json_annotation.dart';
part 'billerNames.g.dart';

@JsonSerializable()
class BillerNames {
  String name;
  BillerNames({required this.name});
  factory BillerNames.fromJson(Map<String, dynamic> data) =>
      _$BillerNamesFromJson(data);
  Map<String, dynamic> toJson() => _$BillerNamesToJson(this);
}
