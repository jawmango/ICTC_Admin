import 'package:json_annotation/json_annotation.dart';

part 'registration_history.g.dart';



@JsonSerializable(
    includeIfNull: false
)
class RegistrationHistory {
  final int? id;

  @JsonKey(name: 'table_name')
  String? tableName;

  @JsonKey(name: 'action')
  String? action;

  @JsonKey(name: 'occurred_at')
  DateTime? occurredAt;

  @JsonKey(name: 'user_id')
  String userId;

  @JsonKey(name: 'user_email')
  String userEmail;

  @JsonKey(name: 'student_id')
  int studentId;

  @JsonKey(name: 'course_id')
  int courseId;

  @JsonKey(name: 'course_name')
  String courseName;

  @JsonKey(name: 'student_name')
  String studentName;


  RegistrationHistory({
    this.id,
    this.tableName,
    this.action,
    this.occurredAt,
    required this.userId,
    required this.userEmail,
    required this.studentId,
    required this.courseId,
    required this.courseName,
    required this.studentName,
  });

  factory RegistrationHistory.fromJson(Map<String, dynamic> json) => _$RegistrationHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationHistoryToJson(this);

  @override
  String toString() {
    return "RegistrationHistory #$id";
  }
}
