import 'package:json_annotation/json_annotation.dart';

part 'course_history.g.dart';

@JsonSerializable(
    includeIfNull: false
)
class CourseHistory {
  final int? id;

  @JsonKey(name: 'table_name')
  String? tableName;

  @JsonKey(name: 'course_name')
  String courseName;

  @JsonKey(name: 'action')
  String? action;

  @JsonKey(name: 'occurred_at')
  DateTime? occurredAt;

  @JsonKey(name: 'user_id')
  String? userId;

  CourseHistory({
    this.id,
    this.tableName,
    required this.courseName,
    this.action,
    this.occurredAt,
    this.userId,
  });

  factory CourseHistory.fromJson(Map<String, dynamic> json) => _$CourseHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$CourseHistoryToJson(this);

  @override
  String toString() {
    return "CourseHistory #$id";
  }
}
