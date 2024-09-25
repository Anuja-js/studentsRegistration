import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/user.dart';
import '../utils/database_helper.dart';

class UserDetailsEdit extends StatefulWidget {
  final User user;
  final String appBarTitle;

  const UserDetailsEdit(this.user, this.appBarTitle, {super.key});

  @override
  State<StatefulWidget> createState() {
    // ignore: no_logic_in_create_state
    return UserDetailsEditState(user, appBarTitle);
  }
}

class UserDetailsEditState extends State<UserDetailsEdit> {
  DatabaseHelper helper = DatabaseHelper();
  final ImagePicker _picker = ImagePicker();
  String appBarTitle;
  User user;

  TextEditingController nameController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? _imagePath;
  final formKey = GlobalKey<FormState>();

  UserDetailsEditState(this.user, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    nameController.text = user.name ?? '';
    qualificationController.text = user.qualification ?? '';
    ageController.text = user.age?.toString() ?? '';
    phoneController.text = user.phone?.toString() ?? '';
    descriptionController.text = user.description ?? '';
    _imagePath = user.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle,style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white),
          onPressed: () {
            moveToLastScreen();
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            child: Image.asset(
              "assets/images/background.jpeg",
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 15,
            left: 15,
            right: 15,
            bottom: 15,
            child: Form(
              key: formKey,
              child: ListView(
                physics: const ScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
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
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Image.file(
                            File(_imagePath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                          : const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () async {
                      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                      if (pickedFile != null) {
                        setState(() {
                          _imagePath = pickedFile.path;
                        });
                      }
                    },
                  ),
                  buildTextFormField(nameController, 'Name', updateName),
                  buildTextFormField(qualificationController, 'Qualification', updateQualification),
                  buildTextFormField(ageController, 'Age', updateAge, keyboardType: TextInputType.number),
                  buildTextFormField(phoneController, 'Phone', updatePhone, keyboardType: TextInputType.number),
                  buildTextFormField(descriptionController, 'Description', updateDescription),
                  const SizedBox(height: 55,),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 19,
            left: 10,
            right: 10,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                foregroundColor: MaterialStateProperty.all(Colors.white),

              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Text(
                  appBarTitle == 'Add Student' ? 'Save Student' :'Update Student' ,
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _save();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextFormField(
      TextEditingController controller,
      String label,
      Function onChanged, {
        TextInputType keyboardType = TextInputType.text,
      }) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(fontSize: 18.0),
        keyboardType: keyboardType,
        onChanged: (value) {
          onChanged();
        },
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black),
          fillColor: Colors.grey,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 2),
          ),
        ),
        validator: (value) {
    if (value == null || value.isEmpty) {
    return "Please Enter $label";
    }
    if (label == 'Phone' && !RegExp(r'^\d{10}$').hasMatch(value)) {
    return "Phone number must be 10 digits";
    }
    if (label == 'Age' && !RegExp(r'^\d{1,3}$').hasMatch(value)) {
    return "Age must be at most 3 digits";
    }
    return null;
    },
      ),
    );
  }

  void updateName() {
    user.name = nameController.text;
  }

  void updateQualification() {
    user.qualification = qualificationController.text;
  }

  void updateAge() {
    user.age = int.parse(ageController.text);
  }

  void updatePhone() {
    user.phone = int.parse(phoneController.text);
  }

  void updateDescription() {
    user.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();
    user.imagePath = _imagePath;
    if (kDebugMode) {
      print(user.imagePath);
    }
    if (appBarTitle == 'Add Student') {
      await helper.insertUser(user);
    } else {
      await helper.updateUser(user);
    }
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
