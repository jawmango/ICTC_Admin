// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'net_income.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetIncome _$NetIncomeFromJson(Map<String, dynamic> json) => NetIncome(
      id: (json['id'] as num?)?.toInt(),
      programId: (json['program_id'] as num).toInt(),
      courseId: (json['course_id'] as num).toInt(),
      totalIncome: (json['total_income'] as num).toDouble(),
      totalExpense: (json['total_expense'] as num).toDouble(),
      totalNet: (json['total_net'] as num).toDouble(),
    );

Map<String, dynamic> _$NetIncomeToJson(NetIncome instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['program_id'] = instance.programId;
  val['course_id'] = instance.courseId;
  val['total_income'] = instance.totalIncome;
  val['total_expense'] = instance.totalExpense;
  val['total_net'] = instance.totalNet;
  return val;
}
