// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Register _$RegisterFromJson(Map<String, dynamic> json) => Register(
      id: (json['id'] as num?)?.toInt(),
      studentId: (json['student_id'] as num).toInt(),
      courseId: (json['course_id'] as num).toInt(),
      status: json['is_approved'] as bool,
      eval: json['eval_status'] as bool? ?? false,
      cert: json['cert_status'] as bool? ?? false,
      attend: json['attend_status'] as bool? ?? false,
      bill: json['bill_status'] as bool? ?? false,
      paymentStatus: json['payment_status'] as bool?,
    );

Map<String, dynamic> _$RegisterToJson(Register instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['student_id'] = instance.studentId;
  val['course_id'] = instance.courseId;
  val['is_approved'] = instance.status;
  val['cert_status'] = instance.cert;
  writeNotNull('payment_status', instance.paymentStatus);
  val['eval_status'] = instance.eval;
  val['attend_status'] = instance.attend;
  val['bill_status'] = instance.bill;
  return val;
}
