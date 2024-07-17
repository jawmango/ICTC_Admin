import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ictc_admin/models/program.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProgramForm extends StatefulWidget {

  const ProgramForm({super.key, this.program});

  final Program? program;

  @override
  State<ProgramForm> createState() => _ProgramFormState();

}

class _ProgramFormState extends State<ProgramForm> {
  late Future<String?> programUrl = getImageUrl();

  Future<String?> getImageUrl() async {
    try {
      final url = await Supabase.instance.client.storage
          .from('programs')
          .createSignedUrl('${widget.program?.id}/program.png', 60);
      return url;
    } catch (e) {
      return null;
    }
  }
  late bool isHiddenCon;
  @override
  void initState() {
    super.initState();

    print("program ${widget.program?.id}");

    isHiddenCon = widget.program?.isHidden ?? false;
    progTitleCon = TextEditingController(text: widget.program?.title);
    progDescriptionCon =
        TextEditingController(text: widget.program?.description);

  }

  final formKey = GlobalKey<FormState>();
  late TextEditingController progTitleCon, progDescriptionCon;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: CupertinoTextFormFieldRow(
              controller: progTitleCon,
              prefix: const Row(
                children: [
                  Text("Program Title",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                  SizedBox(width: 12),
                ],
              ),
              // padding: EdgeInsets.only(left: 90),
              placeholder: "e.g. Microcredentials",
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
              controller: progDescriptionCon,
              expands: true,
              keyboardType: TextInputType.multiline,
              minLines: null,
              maxLines: null,
              prefix: const Row(
                children: [
                  Text("Description",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400)),
                  SizedBox(width: 22),
                ],
              ),
              // padding: EdgeInsets.only(left: 90),
              placeholder: "Program Description",
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
          SizedBox(height: 6),
    Row(
      children: [
        Checkbox(
          value: isHiddenCon,
          onChanged: (value) {
            setState(() {
              isHiddenCon = value ?? false;
            });
          },
        ),
        Text(
          'Hidden',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
      ],
    ),
          if (widget.program != null)
          Material(
            color: Colors.black12,
            child: InkWell(
              splashColor: Colors.black26,
              onTap: () async {
                // select an image
                            final image = await FilePicker.platform.pickFiles(
                                type: FileType.custom, allowedExtensions: ['png']);
                            if (image == null) {
                              return;
                            }
          
                            // upload image to supabase
                            final supa = Supabase.instance.client;
          
                            print(
                                "${widget.program?.id}/program.${image.files.first.extension}");
                            await supa.storage
                                .from('programs')
                                .uploadBinary(
                                    "${widget.program?.id}/program.${image.files.first.extension}",
                                    image.files.first.bytes!,
                                    fileOptions: FileOptions(upsert: true))
                                .whenComplete(() {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Image uploaded successfully!")));
                              setState(() {
                                programUrl = getImageUrl();
                              });
                            });
              },
              child: Container(
                color: Colors.transparent,
                height: 40,
                width: MediaQuery.of(context).size.width * 0.2,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Upload Image",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (widget.program != null)
          Container(
            // IMAGE
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width * 0.2,
            height: 360,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
            ),
            child: FutureBuilder<String?>(
              future: programUrl,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final url = snapshot.data!;
                  return Image.network(
                    url,
                    fit: BoxFit.cover,
                  );
                }

                return const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline_rounded),
                      SizedBox(width: 5),
                      Text('Add a picture.'),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              // Expanded(child: SizedBox(child: cancelButton())),
              if (widget.program != null)
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
        Program program = Program(
          id: widget.program?.id,
          title: progTitleCon.text,
          description: progDescriptionCon.text,
          isHidden: isHiddenCon,
        );

        print(program.toJson());

        supabase.from('program').upsert(program.toJson()).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Successfully added program: ${program.title}."),
              backgroundColor: Colors.green,
            ));

          Navigator.of(context).pop();
        }).onError((err, st) {
          print(err);
          print(st);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Unsuccessful adding program. Please try again."),
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
          final id = widget.program!.id!;
          
          supabase.from('program').delete().eq('id', id).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Successfully deleted program ${widget.program!.toString()}."),
                backgroundColor: Colors.orangeAccent,
              )
            );

            Navigator.of(context).pop();

          }).onError((err, st) {
            print(err.toString());
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  "Error deleting program: ${widget.program!.toString()}. Please try again."),
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
