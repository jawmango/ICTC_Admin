// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationHistory _$RegistrationHistoryFromJson(Map<String, dynamic> json) =>
    RegistrationHistory(
      id: (json['id'] as num?)?.toInt(),
      tableName: json['table_name'] as String?,
      action: json['action'] as String?,
      occurredAt: json['occurred_at'] == null
          ? null
          : DateTime.parse(json['occurred_at'] as String),
      userId: json['user_id'] as String,
      userEmail: json['user_email'] as String,
      studentId: (json['student_id'] as num).toInt(),
      courseId: (json['course_id'] as num).toInt(),
    );

Map<String, dynamic> _$RegistrationHistoryToJson(RegistrationHistory instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('table_name', instance.tableName);
  writeNotNull('action', instance.action);
  writeNotNull('occurred_at', instance.occurredAt?.toIso8601String());
  val['user_id'] = instance.userId;
  val['user_email'] = instance.userEmail;
  val['student_id'] = instance.studentId;
  val['course_id'] = instance.courseId;
  return val;
}
