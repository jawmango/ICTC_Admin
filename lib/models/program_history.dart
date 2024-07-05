import 'package:json_annotation/json_annotation.dart';

part 'program_history.g.dart';

@JsonSerializable(
    includeIfNull: false
)
class ProgramHistory{
  final int? id;

  @JsonKey(name: 'table_name')
  String? tableName;

  @JsonKey(name: 'program_name')
  String programName;

  @JsonKey(name: 'action')
  String? action;

  @JsonKey(name: 'occurred_at')
  DateTime? occurredAt;

  @JsonKey(name: 'user_id')
  String userId;

  @JsonKey(name: 'user_email')
  String? userEmail;

  ProgramHistory({
    this.id,
    this.tableName,
    required this.programName,
    this.action,
    this.occurredAt,
    required this.userId,
    this.userEmail,
  });

  factory ProgramHistory.fromJson(Map<String, dynamic> json) => _$ProgramHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$ProgramHistoryToJson(this);

  @override
  String toString() {
    return "ProgramHistory #$id";
  }
}
