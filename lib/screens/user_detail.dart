// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:studentsregistration/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:studentsregistration/models/user.dart';
import 'package:studentsregistration/screens/edit_user_details.dart';
import 'package:studentsregistration/utils/database_helper.dart';

class UserDetails extends StatefulWidget {
  final documentSnapshot;

  const UserDetails(this.documentSnapshot , {super.key,});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.documentSnapshot["studentName"],style: const TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
      ),
      body: Stack(

        children: [
          Positioned(
              top: 0,
              left:0,
              right: 0,
              bottom: 0,
              child: Image.asset("assets/images/background.jpeg",fit: BoxFit.fill,)),
          Positioned(
            left:  MediaQuery.of(context).size.width/2.55, top: 20,

            child:   CircleAvatar(
              backgroundColor: Colors.black,
              radius: 50,
              child:
                  const Icon(Icons.person,color: Colors.white),

            ),),
          Positioned(
            top: MediaQuery.of(context).size.height/7.5,
            left: 20,
            right: 20,
            bottom: 20,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Name:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.documentSnapshot["studentName"],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16), const Text(
                  'Id:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.documentSnapshot["studentId"],
                  style: const TextStyle(fontSize: 16),
                ),   const SizedBox(height: 16),
                const Text(
                  'Qualification:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.documentSnapshot["studyProgram"],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Age:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.documentSnapshot["age"],
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Phone:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.documentSnapshot["phone"],
                  style: const TextStyle(fontSize: 16),
                ),


              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height/4.5,
            left: 25,
            right: 25,
            child:
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ElevatedButton(

                onPressed: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //
                  //   builder: (context) => UserDetailsEdit("user", "Edit User"),
                  // ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text('Edit'),
                ),
              ),
              const SizedBox(width: 10,),
              ElevatedButton(
                onPressed: ()
                  {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Delete...?"),
                            content: Text(
                                "Are you sure?  will be deleted?"),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel")),
                              TextButton(
                                  onPressed: () async{
                                    delete(context,name: widget.documentSnapshot["studentName"]);
                                     Navigator.of(context).pop();
                                  },
                                  child: const Text("Delete")),
                            ],
                          );
                        });


                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text('Delete'),
                ),
              ),
            ],
          ),)
        ],

      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void delete(BuildContext context, {required String name}) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection("Students")
        .doc(name);
    try {
      await documentReference.delete();
      showSnackbar(context, 'User Deleted Successfully');
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pop();

      setState(() {
      });
    } catch (e) {
      showSnackbar(context, 'Error deleting user: $e');
    }
  }
}
