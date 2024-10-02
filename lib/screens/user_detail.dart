// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:studentsregistration/customs/constants.dart';
import 'package:studentsregistration/screens/edit_user_details.dart';
import 'package:studentsregistration/screens/home_screen.dart';

class UserDetails extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final documentSnapshot;

  const UserDetails(
    this.documentSnapshot, {
    super.key,
  });

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
        centerTitle: true,
        title: Text(
          widget.documentSnapshot["studentName"],
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (ctx) {
              return const HomePage();
            }));
          },
          icon: const Icon(Icons.arrow_back_outlined),
          color: white,
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
              )),
          SizedBox(
            width: MediaQuery.of(context).size.width,
          ),
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                sh50,
                widget.documentSnapshot["image"] != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(
                          widget.documentSnapshot["image"],
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.red, size: 20),
                                SizedBox(height: 10),
                                Text('Failed load',
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.black)),
                              ],
                            );
                          },
                        ),
                      )
                    : const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person), // Placeholder icon
                      ),
                sh20,
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    'Name:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  sw20,
                  Text(
                    widget.documentSnapshot["studentName"],
                    style: const TextStyle(fontSize: 16),
                  ),
                ]),
                sh16,
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    'Id:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  sw20,
                  Text(
                    widget.documentSnapshot["studentId"],
                    style: const TextStyle(fontSize: 16),
                  ),
                ]),
                sh16,
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    'Qualification:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  sw20,
                  Text(
                    widget.documentSnapshot["studyProgram"],
                    style: const TextStyle(fontSize: 16),
                  ),
                ]),
                sh16,
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text(
                    'Age:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  sw20,
                  Text(
                    widget.documentSnapshot["age"],
                    style: const TextStyle(fontSize: 16),
                  ),
                ]),
                sh16,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Phone:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    sw10,
                    Text(
                      widget.documentSnapshot["phone"],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                sh50,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                          foregroundColor: Colors.white),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text('Edit'),
                      ),
                    ),
                    sw20,
                    ElevatedButton(
                      onPressed: () {
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
                                      onPressed: () async {
                                        delete(context,
                                            name: widget.documentSnapshot[
                                                "studentName"]);
                                      },
                                      child: const Text("Delete")),
                                ],
                              );
                            });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void delete(BuildContext context, {required String name}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Students").doc(name);
    try {
      showSnackbar(context, 'User Deleted Successfully');
      documentReference.delete();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
        return const HomePage();
      }));

      setState(() {});
    } catch (e) {
      showSnackbar(context, 'Error deleting user: $e');
    }
  }

  void navigateToDetail(String title, {required documentSnapshot}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserDetailsEdit(documentSnapshot: documentSnapshot, title),
      ),
    );
  }
}
