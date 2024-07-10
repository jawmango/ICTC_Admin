import 'package:json_annotation/json_annotation.dart';

part 'register.g.dart';

@JsonSerializable(
    includeIfNull: false
)
class Register {
  final int? id;

  @JsonKey(name: 'student_id')
  int studentId;

  @JsonKey(name: 'course_id')
  int courseId;

  @JsonKey(name: 'is_approved')
  bool status;

  @JsonKey(name: 'cert_status')
  bool cert;

  @JsonKey(name: 'eval_status')
  bool eval;

  @JsonKey(name: 'attend_status')
  bool attend;

  @JsonKey(name: 'bill_status')
  bool bill;

  Register({
    this.id,
    required this.studentId,
    required this.courseId,
    required this.status,
    this.eval = false,
    this.cert = false,
    this.attend = false,
    this.bill = false,
  });

  factory Register.fromJson(Map<String, dynamic> json) => _$RegisterFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterToJson(this);

  @override
  String toString() {
    return '$studentId.firstName $studentId.lastName';
  }
}
