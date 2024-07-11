import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    contactCon = TextEditingController(text: widget.trainee?.contactNumber);
    emailCon = TextEditingController(text: widget.trainee?.email);
    
  }

  final formKey = GlobalKey<FormState>();
  late TextEditingController firstNameCon, lastNameCon, contactCon, emailCon;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Row(
            children: <Widget>[
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
                  placeholder: "e.g. John",
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

              // LAST NAME
              Flexible(
                child: CupertinoTextFormFieldRow(
                  controller: lastNameCon,
                  prefix: const Row(
                    children: [
                      Text("Last Name",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                              fontWeight: FontWeight.w400)),
                      SizedBox(width: 12),
                    ],
                  ),
                  // padding: EdgeInsets.only(left: 90),
                  placeholder: "e.g. De La Cruz",
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
            ],
          ),

          //EMAIL ADDRESS
          CupertinoTextFormFieldRow(
            controller: emailCon,

            prefix: const Row(
              children: [
                Text("Email Address",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
                SizedBox(width: 24),
              ],
            ),
            // padding: EdgeInsets.only(left: 90),
            placeholder: "e.g. jdoe@gmail.com (N/A if none)",
            placeholderStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black45,
              fontWeight: FontWeight.w400,
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

          // CONTACT NUMBER

          CupertinoTextFormFieldRow(
            controller: contactCon,

            prefix: const Row(
              children: [
                Text("Contact Number",
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        fontWeight: FontWeight.w400)),
                SizedBox(width: 12),
              ],
            ),
            // padding: EdgeInsets.only(left: 90),
            placeholder: "e.g. 09123456789 (N/A if none)",
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
          
          const SizedBox(height: 20),
          Row(
            children: [
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
          )
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
        
        Trainee trainee = Trainee(
          id: widget.trainee?.id,
          firstName: firstNameCon.text,
          lastName: lastNameCon.text,
          contactNumber: contactCon.text,
          email: emailCon.text,
        );

        print(trainee.toJson());

        supabase.from('student').upsert(trainee.toJson()).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Successfully added trainee."),
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
                content: Text("Successfully deleted registration ${widget.trainee!.toString()}."),
                backgroundColor: Colors.orangeAccent,
              )
            );

            Navigator.of(context).pop();

          }).onError((err, st) {
            print(err.toString());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Error deleting registration: ${widget.trainee!.toString()}. Please try again."),
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
