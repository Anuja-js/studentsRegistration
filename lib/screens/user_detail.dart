// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studentsregistration/customs/constants.dart';
import 'package:studentsregistration/screens/edit_user_details.dart';

class UserDetails extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final documentSnapshot;

  const UserDetails(this.documentSnapshot , {super.key,});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}
Uint8List? imageBytes;
class _UserDetailsState extends State<UserDetails> {

  @override
  void initState() {
    super.initState();
  }
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
            left:  10, top: 20,

            child:   widget.documentSnapshot["image"]!= ""
                ? ClipRRect(borderRadius: BorderRadius.circular(100),
              child: Image.network(
                widget.documentSnapshot["image"],width: 75,height: 75,fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 20),
                      SizedBox(height: 10),
                      Text('Failed load',
                          style: TextStyle(fontSize: 10, color: Colors.black)),
                    ],
                  );
                },
              ),
            )
                : const CircleAvatar(radius: 40,
              backgroundColor: Colors.grey,
              child: Icon(Icons.person), // Placeholder icon
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height/7.5,
            left: 20,
            right: 20,
            bottom: 20,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                sh20,
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
                  navigateToDetail(
                  documentSnapshot: widget.documentSnapshot,
                  'Edit User',
                );
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
                            content: const Text(
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
      showSnackbar(context, 'User Deleted Successfully');
       documentReference.delete();
      Navigator.of(context).pop();

      setState(() {
      });
    } catch (e) {
      showSnackbar(context, 'Error deleting user: $e');
    }
  }
  void navigateToDetail(String title, {required documentSnapshot}) async {
     await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserDetailsEdit(documentSnapshot: documentSnapshot, title),
      ),
    );

  }
}
