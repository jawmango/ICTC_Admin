import 'package:ictc_admin/models/course.dart';
import 'package:ictc_admin/models/program.dart';
import 'package:ictc_admin/models/payment.dart';
import 'package:ictc_admin/models/trainee.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'net_income.g.dart';

@JsonSerializable(includeIfNull: false)
class NetIncome {
  final int? id;

  @JsonKey(name: 'program_id')
  int programId;

  @JsonKey(name: 'course_id')
  int courseId;

  @JsonKey(name: 'total_income')
  double totalIncome;

  @JsonKey(name: 'total_expense')
  double totalExpense;

  @JsonKey(name: 'total_net')
  double totalNet;

  NetIncome(
      {this.id,
      required this.programId,
      required this.courseId,
      required this.totalIncome,
      required this.totalExpense,
      required this.totalNet});

  factory NetIncome.fromJson(Map<String, dynamic> json) =>
      _$NetIncomeFromJson(json);

  Map<String, dynamic> toJson() => _$NetIncomeToJson(this);

  @override
  String toString() {
    return "NetIncome #$id";
  }
}
