// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'program_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgramHistory _$ProgramHistoryFromJson(Map<String, dynamic> json) =>
    ProgramHistory(
      id: (json['id'] as num?)?.toInt(),
      programName: json['program_name'] as String,
      action: json['action'] as String?,
      occurredAt: json['occurred_at'] == null
          ? null
          : DateTime.parse(json['occurred_at'] as String),
      userEmail: json['user_email'] as String?,
    );

Map<String, dynamic> _$ProgramHistoryToJson(ProgramHistory instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['program_name'] = instance.programName;
  writeNotNull('action', instance.action);
  writeNotNull('occurred_at', instance.occurredAt?.toIso8601String());
  writeNotNull('user_email', instance.userEmail);
  return val;
}
