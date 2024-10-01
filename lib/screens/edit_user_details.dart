import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:studentsregistration/screens/home_screen.dart';

import '../customs/constants.dart';

class UserDetailsEdit extends StatefulWidget {
  final String appBarTitle;
  final documentSnapshot;

  UserDetailsEdit(
    this.appBarTitle, {
    required this.documentSnapshot,
  });

  @override
  State<StatefulWidget> createState() {
    return UserDetailsEditState();
  }
}

class UserDetailsEditState extends State<UserDetailsEdit> {
  TextEditingController nameController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  Uint8List? imageBytes;
  File? imagefile;
  bool isPress = false;
  String? image;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.appBarTitle == "Edit User") {
      nameController.text = widget.documentSnapshot["studentName"];
      qualificationController.text = widget.documentSnapshot["studyProgram"];
      descriptionController.text = widget.documentSnapshot["studentId"];
      ageController.text = widget.documentSnapshot["age"];
      phoneController.text = widget.documentSnapshot["phone"];
      image = widget.documentSnapshot["image"];
    }
    super.initState();
  }

  Future<String> uploadImage(Uint8List imageBytes) async {
    // Create a reference to Firebase Storage
    final storageRef = FirebaseStorage.instance.ref();

    // Create a unique file name for the image
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    // Create a reference for the image
    Reference imageRef = storageRef.child('images/$fileName');

    // Define metadata with content type as image
    final metadata = SettableMetadata(
        contentType: 'image/jpeg'); // or 'image/png' based on your image format

    // Upload the image with metadata
    await imageRef.putData(imageBytes, metadata);

    // Get the download URL
    String downloadUrl = await imageRef.getDownloadURL();

    return downloadUrl; // Return the download URL
  }

  // Future<String> imageToBase64(Uint8List imageBytes) async {
  //   // base64 encode the bytes
  //   String base64String = base64.encode(imageBytes);
  //   return base64String;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/background.jpeg",
              fit: BoxFit.fill,
            ),
          ),
          Positioned.fill(
            child: Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      try {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.image,
                          allowMultiple: false,
                          withData: true, // Ensure byte data is included
                        );

                        if (result != null) {
                          imageBytes = result.files.first
                              .bytes; // Handle image as bytes (for both web and mobile)

                          setState(() {});
                        } else {
                          print("User canceled the picker");
                        }
                      } catch (e) {
                        print("Error during file picking: $e");
                      }
                    },
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        sh10,
                        CircleAvatar(
                          backgroundColor: Colors.black,
                          radius: 50,
                          child: widget.appBarTitle == "Edit User"
                              ? image != ""
                                  ? SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.network(
                                          widget.documentSnapshot["image"]!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.camera_alt_outlined,
                                      color: Colors.white)
                              : imageBytes != null
                                  ? SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: Image.memory(
                                          imageBytes!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                                  : const Icon(Icons.camera_alt_outlined,
                                      color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  buildTextFormField(nameController, 'Name'),
                  buildTextFormField(descriptionController, 'Student ID'),
                  buildTextFormField(
                    qualificationController,
                    'Study Program',
                  ),
                  buildTextFormField(ageController, 'Age',
                      keyboardType: TextInputType.number),
                  buildTextFormField(phoneController, 'Phone',
                      keyboardType: TextInputType.number),
                  const SizedBox(height: 55),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 15,right: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      DocumentReference documentReference = FirebaseFirestore
                          .instance
                          .collection("Students")
                          .doc(nameController.text);

                      String imageUrl = "";

                      if (imageBytes != null) {
                        imageUrl = await uploadImage(imageBytes!);
                      }
                      Map<String, dynamic> student = {
                        "studentName": nameController.text,
                        "studentId": descriptionController.text,
                        "studyProgram": qualificationController.text,
                        "age": ageController.text,
                        "phone": phoneController.text,
                        "image": imageUrl
                      };

                      if (widget.appBarTitle == "Edit User") {
                        try {
                          await FirebaseFirestore.instance
                              .collection("Students")
                              .doc(widget.documentSnapshot["studentName"])
                              .delete();

                          await documentReference.set(student).whenComplete(() {
                            print("Student data updated");
                          });
                        } catch (e) {
                          print("Error updating data: $e");
                        }
                      } else {
                        try {
                          await documentReference.set(student).whenComplete(() {
                            print("Student data saved");
                          });
                        } catch (e) {
                          print(
                              "Error saving data: $e"); // Detailed error logging
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Error saving student: $e')));
                        }
                      }

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (ctx) {
                        return const HomePage();
                      }));
                    }
                  },
                  child: Text(widget.appBarTitle == 'Add Student'
                      ? 'Save Student'
                      : 'Update Student'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFormField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 18.0),
        keyboardType: keyboardType,
        onChanged: (value) {},
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          fillColor: Colors.grey,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter $label";
          }
          if (label == 'Phone' && !RegExp(r'^\d{10}$').hasMatch(value)) {
            return "Phone number must be 10 digits";
          }
          if (label == 'Age' && !RegExp(r'^\d{1,3}$').hasMatch(value)) {
            return "Age must be a valid number";
          }
          return null;
        },
      ),
    );
  }
}
