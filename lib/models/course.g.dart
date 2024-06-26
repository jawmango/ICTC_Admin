// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'course.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Course _$CourseFromJson(Map<String, dynamic> json) => Course(
      id: json['id'] as int?,
      programId: json['program_id'] as int?,
      trainerId: json['trainer_id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String?,
      cost: json['cost'] as int,
      duration: json['duration'] as String?,
      schedule: json['schedule'] as String?,
      venue: json['venue'] as String?,
      startDate: json['start_date'] == null
          ? null
          : DateTime.parse(json['start_date'] as String),
      endDate: json['end_date'] == null
          ? null
          : DateTime.parse(json['end_date'] as String),
    )..students = json['students'];

Map<String, dynamic> _$CourseToJson(Course instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('program_id', instance.programId);
  writeNotNull('trainer_id', instance.trainerId);
  val['title'] = instance.title;
  writeNotNull('description', instance.description);
  val['cost'] = instance.cost;
  writeNotNull('duration', instance.duration);
  writeNotNull('schedule', instance.schedule);
  writeNotNull('venue', instance.venue);
  writeNotNull('start_date', instance.startDate?.toIso8601String());
  writeNotNull('end_date', instance.endDate?.toIso8601String());
  writeNotNull('students', instance.students);
  return val;
}
