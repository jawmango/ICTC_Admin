import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ictc_admin/models/course.dart';
import 'package:ictc_admin/models/payment.dart';
import 'package:ictc_admin/models/program.dart';
import 'package:ictc_admin/models/trainer.dart';
import 'package:ictc_admin/models/register.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';


class AdsImageForm extends StatefulWidget {
  const AdsImageForm({super.key,});

  @override
  State<AdsImageForm> createState() => _AdsImageFormState();
}

class _AdsImageFormState extends State<AdsImageForm> {
  late Future<String?> imageUrl;

  @override
  void initState() {
    super.initState();
    imageUrl = getImageUrl();
  }

  Future<String?> getImageUrl() async {
    try {
      final url = await Supabase.instance.client.storage
          .from('images')
          .createSignedUrl('advertisment/ads.png', 60);
      return url;
    } catch (e) {
      return null;
    }
  }

  //download method
  Future<void> downloadImage() async {
  try {
    final url = await Supabase.instance.client.storage
        .from('images')
        .createSignedUrl('advertisment/ads.png', 60);
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
                 // select an image
                            final image = await FilePicker.platform.pickFiles(
                                type: FileType.custom, allowedExtensions: ['png']);
                            if (image == null) {
                              return;
                            }
          
                            // upload image to supabase
                            final supa = Supabase.instance.client;
          
                            print(
                                "advertisment/ads.${image.files.first.extension}");
                            await supa.storage
                                .from('images')
                                .uploadBinary(
                                    "advertisment/ads.${image.files.first.extension}",
                                    image.files.first.bytes!,
                                    fileOptions: FileOptions(upsert: true))
                                .whenComplete(() {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text("Image uploaded successfully!")));
                              setState(() {
                                imageUrl = getImageUrl();
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
              future: imageUrl,
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


