import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ictc_admin/models/program.dart';
import 'package:ictc_admin/models/trainee.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class TraineesForm extends StatefulWidget {

  const TraineesForm({super.key, this.trainee});

  final Trainee? trainee;

  @override
  State<TraineesForm> createState() => _TraineesFormState();

}

class _TraineesFormState extends State<TraineesForm> {



  @override
  void initState() {
    super.initState();

    print("trainee ${widget.trainee?.id}");

    firstNameCon = TextEditingController(text: widget.trainee?.firstName);
    lastNameCon = TextEditingController(text: widget.trainee?.lastName);

  }

  final formKey = GlobalKey<FormState>();
  late TextEditingController firstNameCon, lastNameCon;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: CupertinoTextFormFieldRow(
              controller: firstNameCon,
              prefix: const Row(
                children: [
                  Text("First Name",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                  SizedBox(width: 12),
                ],
              ),
              // padding: EdgeInsets.only(left: 90),
              placeholder: "e.g. John Rodick",
              placeholderStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black45,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              decoration: BoxDecoration(
                // border: ,
                border: Border.all(
                  color: Colors.black87,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(18),
                // prefixIcon: Icon(Icons.person)
              ),
            ),
          ),

          // DESCRIPTION
          Flexible(
            child: CupertinoTextFormFieldRow(
              controller: lastNameCon,
              expands: true,
              keyboardType: TextInputType.multiline,
              minLines: null,
              maxLines: null,
              prefix: const Row(
                children: [
                  Text("Last Name",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                  SizedBox(width: 22),
                ],
              ),
              // padding: EdgeInsets.only(left: 90),
              placeholder: "Bongat",
              placeholderStyle: const TextStyle(
                fontSize: 14, //
                fontWeight: FontWeight.w400,
                color: Colors.black45,
              ),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              decoration: BoxDecoration(
                // border: ,
                border: Border.all(
                  color: Colors.black87,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(18),
                // prefixIcon: Icon(Icons.person)
              ),
            ),
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              // Expanded(child: SizedBox(child: cancelButton())),
              if (widget.trainee != null)
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
        Trainee trainee = Trainee(
          id: widget.trainee?.id,
          firstName: firstNameCon.text,
          lastName: lastNameCon.text,
          email: 'none',
        );

        print(trainee.toJson());

        supabase.from('student').upsert(trainee.toJson()).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Successfully added trainee: "),
              backgroundColor: Colors.green,
            ));

          Navigator.of(context).pop();
        }).onError((err, st) {
          print(err);
          print(st);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Unsuccessful adding trainee. Please try again."),
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
          final id = widget.trainee!.id!;
          
          supabase.from('student').delete().eq('id', id).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Successfully deleted trainee ${widget.trainee!.toString()}."),
                backgroundColor: Colors.orangeAccent,
              )
            );

            Navigator.of(context).pop();

          }).onError((err, st) {
            print(err.toString());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Error deleting trainee: ${widget.trainee!.toString()}. Please try again."),
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
