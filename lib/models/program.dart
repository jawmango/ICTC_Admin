import 'package:json_annotation/json_annotation.dart';

part 'program.g.dart';

@JsonSerializable(
  includeIfNull: false
)
class Program {
  final int? id;
  
  @JsonKey(name: "title")
  String title;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: 'is_hidden')
  bool isHidden;

  Program({
    this.id,
    required this.title,
    this.description,
    this.isHidden = false,
  });

  factory Program.fromJson(Map<String, dynamic> json) => _$ProgramFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramToJson(this);

  @override
  String toString() {
    return title;
  }

}
