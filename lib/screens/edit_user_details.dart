import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:studentsregistration/screens/home_screen.dart';

class UserDetailsEdit extends StatefulWidget {
  final String appBarTitle;
  final documentSnapshot;

   UserDetailsEdit(this.appBarTitle,  {required this.documentSnapshot,});

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
  String? _imagePath;
  final formKey = GlobalKey<FormState>();
@override
  void initState() {
  if(widget.appBarTitle=="Edit User"){
    nameController.text=widget.documentSnapshot["studentName"];
    qualificationController.text=widget.documentSnapshot["studyProgram"];
    descriptionController.text=widget.documentSnapshot["studentId"];
    ageController.text=widget.documentSnapshot["age"];
    phoneController.text=widget.documentSnapshot["phone"];

  }

  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appBarTitle,
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: moveToLastScreen,
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
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 50,
                      child: _imagePath != null
                          ? SizedBox(
                              width: 100,
                              height: 100,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  File(_imagePath!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : const Icon(Icons.camera_alt_outlined,
                              color: Colors.white),
                    ),
                    onTap: () {
                      // Add functionality to pick image
                    },
                  ),
                  buildTextFormField(nameController, 'Name'),
                  buildTextFormField(
                      descriptionController, 'Student ID'),
                  buildTextFormField(qualificationController, 'Study Program',
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
            left: 20,
            right: 20,
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

                      Map<String, dynamic> student = {
                        "studentName": nameController.text,
                        "studentId": descriptionController.text,
                        "studyProgram": qualificationController.text,
                        "age": ageController.text,
                        "phone": phoneController.text,
                      };

                     if(widget.appBarTitle=="Edit User"){
                       try {
                         await FirebaseFirestore
                             .instance
                             .collection("Students")
                             .doc(widget.documentSnapshot["studentName"]).delete();
                         await documentReference.set(student).whenComplete(() {
                           print("Student data saved");
                         });
                       } catch (e) {
                         print("Error: $e");
                       }
                     }
                     else{
                       try {
                         await documentReference.set(student).whenComplete(() {
                           print("Student data updated");
                         });
                       } catch (e) {
                         print("Error: $e");
                       }
                     }

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
                        return HomePage();
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

  Widget buildTextFormField(
      TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 18.0),
        keyboardType: keyboardType,
        onChanged: (value) {

        },
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

  void updateName() {
     }

  void updateQualification() {}

  void updateAge() {}

  void updatePhone() {}

  void updateDescription() {}

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
