import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ictc_admin/models/course.dart';
import 'package:ictc_admin/models/program.dart';
import 'package:ictc_admin/models/trainer.dart';
import 'package:ictc_admin/models/register.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';


class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key, this.course, this.register,});

  final Course? course;
  final Register? register;

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  late Future<String?> receiptUrl;

  @override
  void initState() {
    super.initState();
    receiptUrl = getImageUrl();
  }

  Future<String?> getImageUrl([String? path]) async {
    try {
      final url = await Supabase.instance.client.storage
          .from('receipts')
          .createSignedUrl('${widget.register?.id}/receipt.png', 60);
      return url;
    } catch (e) {
      return null;
    }
  }

  //download method
  Future<void> downloadImage() async {
  try {
    final url = await Supabase.instance.client.storage
        .from('receipts')
        .createSignedUrl('${widget.register?.id}/receipt.png', 60);
    if (url != null) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch image URL.")));
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching image URL.")));
  }
}

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Existing image upload widget
          Material(
            color: Colors.black12,
            child: InkWell(
              splashColor: Colors.black26,
              onTap: () async {
                // Select an image
                final result = await FilePicker.platform.pickFiles(
                    type: FileType.custom, allowedExtensions: ['png']);

                if (result == null || result.files.isEmpty) {
                  return;
                }

                final file = result.files.first;
                final bytes = file.bytes;
                final extension = file.extension;

                if (bytes == null || extension == null) {
                  return;
                }

                // Upload image to Supabase
                final supa = Supabase.instance.client;
                final path = "${widget.register?.id}/receipt.$extension";

                await supa.storage
                    .from('receipts')
                    .uploadBinary(path, bytes,
                        fileOptions: const FileOptions(upsert: true))
                    .whenComplete(() {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Image uploaded successfully!")));

                  setState(() {
                    receiptUrl = getImageUrl(path); // Update receiptUrl with new image URL
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
          SizedBox(height: 10),
          // Container for displaying uploaded image
          Container(
            margin: EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black12),
            ),
            child: FutureBuilder<String?>(
              future: receiptUrl,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final url = snapshot.data!;
                  return GestureDetector(
                    onTap: downloadImage,
                    child: Image.network(
                      url,
                      fit: BoxFit.cover,
                    ),
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
        ],
      ),
    );
  }
}


