import 'package:ariaquickpay/models/billers.dart';
import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';

@JsonSerializable(explicitToJson: true)
class Category {
  String category_name, category_id;
  List<Billers> category_billers;

  Category(
      {required this.category_name,
      required this.category_id,
      required this.category_billers});
  factory Category.fromJson(Map<String, dynamic> data) =>
      _$CategoryFromJson(data);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
