import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ictc_admin/models/course.dart';
import 'package:ictc_admin/models/program.dart';
import 'package:ictc_admin/models/trainer.dart';
import 'package:ictc_admin/models/trainee.dart';
import 'package:ictc_admin/models/register.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:file_picker/file_picker.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key, this.register});

  final Register? register;

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {



  final formKey = GlobalKey<FormState>();
  Course? selectedCourse;
  Trainee? selectedTrainee;
 
  @override
  void initState() {
    super.initState();


    if (widget.register != null) {
      Supabase.instance.client
          .from('course')
          .select()
          .eq('id', widget.register!.courseId)
          .limit(1)
          .withConverter((data) => Course.fromJson(data.first))
          .then((value) => setState(() => selectedCourse = value));
      Supabase.instance.client
          .from('student')
          .select()
          .eq('id', widget.register!.studentId)
          .limit(1)
          .withConverter((data) => Trainee.fromJson(data.first))
          .then((value) => setState(() => selectedTrainee = value));
    }
  }

  // void selectionChanged(DateRangePickerSelectionChangedArgs args) {
  //   setState(() {
  //     startDateCon = DateFormat.yMMMMd('en_US').format(args.value.startDate);
  //     endDateCon = DateFormat.yMMMMd('en_US')
  //         .format(args.value.endDate ?? args.value.startDate);
  //   });
  // }

  Future<List<Course>> fetchCourses({String? filter}) async {
    final supabase = Supabase.instance.client;
    List<Course> courses = await supabase
        .from('course')
        .select()
        .withConverter((data) => data.map((e) => Course.fromJson(e)).toList());

    return filter == null
        ? courses
        : courses.where((element) => element.title.contains(filter)).toList();
  }

  Future<List<Trainee>> fetchTrainees({String? filter}) async {
    final supabase = Supabase.instance.client;
    List<Trainee> trainees;
    trainees = await supabase
        .from('student')
        .select()
        .withConverter((data) => data.map((e) => Trainee.fromJson(e)).toList());

    return filter == null
        ? trainees
        : trainees
            .where((element) => element.toString().contains(filter))
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownSearch<Course>(
            asyncItems: (filter) => fetchCourses(),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                isDense: true,
                prefixIcon: const Icon(
                  Icons.school,
                  size: 15,
                  color: Color(0xff153faa),
                ),
                labelText: "Course",
                labelStyle: const TextStyle(fontSize: 14),
                filled: false,
              ),
            ),
            onChanged: (value) => setState(() => selectedCourse = value),
            selectedItem: selectedCourse,
            popupProps: const PopupProps.dialog(showSearchBox: true),
            compareFn: (item1, item2) => item1.id == item2.id,
            validator: (value) {
              if (value == null) {
                return "Select a course.";
              }

              return null;
            },
          ),
          const SizedBox(
            height: 6,
          ),
          DropdownSearch<Trainee>(
            asyncItems: (filter) => fetchTrainees(),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                labelText: "Student",
                contentPadding: const EdgeInsets.all(0),
                prefixIcon: const Icon(
                  Icons.person,
                  size: 15,
                  color: Color(0xff153faa),
                ),
                labelStyle: const TextStyle(fontSize: 14),
                isDense: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: false,
              ),
            ),
            onChanged: (value) => setState(() => selectedTrainee = value),
            selectedItem: selectedTrainee,
            popupProps: const PopupProps.dialog(showSearchBox: true),
            compareFn: (item1, item2) => item1.id == item2.id,
            validator: (value) {
              if (value == null) {
                return "Select a student.";
              }

              return null;
            },
          ),
               const SizedBox(height: 20),
          Row(
            children: [
              // Expanded(child: SizedBox(child: cancelButton())),
              if (widget.register != null)
                Expanded(
                  flex: 1,
                  child: SizedBox(child: deleteButton()),
                ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: SizedBox(child: saveButton()),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget saveButton() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.pressed)) {
            return Colors.greenAccent;
          }
          return Colors.green;
        }),
      ),
      onPressed: () {
        final supabase = Supabase.instance.client;

        if (!formKey.currentState!.validate()) {
          return;
        }
        
        Register register = Register(
          id: widget.register?.id,
          courseId: selectedCourse!.id!,
          studentId: selectedTrainee!.id,
          status: false,
          eval: false,
          cert: false,
          attend: false,
          bill: false,
        );

        print(register.toJson());

        supabase.from('registration').upsert(register.toJson()).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Successfully added registration."),
              backgroundColor: Colors.green,
            ));

          Navigator.of(context).pop();
        }).onError((err, st) {
          print(err);
          print(st);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Unsuccessful adding registration. Please try again."),
            backgroundColor: Colors.redAccent,
          ));
        });
      },
      child: const Text(
        "Save",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );

  }
  
  Widget deleteButton() {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.white70;
            }
            return const Color.fromARGB(255, 226, 226, 226);
          }),
        ),
        onPressed: () {
          final supabase = Supabase.instance.client;
          final id = widget.register!.id!;
          
          supabase.from('registration').delete().eq('id', id).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Successfully deleted registration ${widget.register!.toString()}."),
                backgroundColor: Colors.orangeAccent,
              )
            );

            Navigator.of(context).pop();

          }).onError((err, st) {
            print(err.toString());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Error deleting registration: ${widget.register!.toString()}. Please try again."),
              backgroundColor: Colors.redAccent,
            ));
          });
        },
        child: const Text(
          "Delete",
          style: TextStyle(color: Colors.black87),
        ));
  }
}
