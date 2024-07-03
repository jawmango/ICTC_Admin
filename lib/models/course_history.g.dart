// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourseHistory _$CourseHistoryFromJson(Map<String, dynamic> json) =>
    CourseHistory(
      id: (json['id'] as num?)?.toInt(),
      tableName: json['table_name'] as String?,
      courseName: json['course_name'] as String,
      action: json['action'] as String?,
      occurredAt: json['occurred_at'] == null
          ? null
          : DateTime.parse(json['occurred_at'] as String),
      userId: json['user_id'] as String?,
    );

Map<String, dynamic> _$CourseHistoryToJson(CourseHistory instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('table_name', instance.tableName);
  val['course_name'] = instance.courseName;
  writeNotNull('action', instance.action);
  writeNotNull('occurred_at', instance.occurredAt?.toIso8601String());
  writeNotNull('user_id', instance.userId);
  return val;
}
