// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentsregistration/screens/edit_user_details.dart';
import 'package:studentsregistration/screens/user_detail.dart';
import 'login_screen.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  bool isPress = true;
  TextEditingController textControl = TextEditingController();
  List<DocumentSnapshot> userList = [];
  List<DocumentSnapshot> filteredList = [];
  @override
  void initState() {
    super.initState();
    fetchStudents();
  }
  void fetchStudents() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Students").get();
    setState(() {
      userList = querySnapshot.docs;
      filteredList = userList;
    });
  }
  void filterSearch(String query) {
    List<DocumentSnapshot> searchList = [];
    if (query.isNotEmpty) {
      searchList = userList
          .where((student) => student["studentName"]
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    } else {
      searchList = userList;
    }
    setState(() {
      filteredList = searchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Students",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isPress = !isPress;
                });
              },
              icon: isPress
                  ? const Icon(
                      Icons.grid_4x4_outlined,
                      color: Colors.white,
                    )
                  : const Icon(Icons.list_alt_outlined, color: Colors.white)),
          IconButton(
            onPressed: () async {
              logout(context);
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextField(
                controller: textControl,
                onChanged: (value) {
                  filterSearch(value);
                },
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search...',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
            )),
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
          isPress ? getUsersList() : getUserGridView()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            return UserDetailsEdit(
              "Add Student",
              documentSnapshot: null,
            );
          }));
        },
        tooltip: 'Add Student',
        child: const Icon(Icons.add),
      ),
    );
  }

  // Show users as a list view
  Widget getUsersList() {
    return ListView.builder(
      physics: const ScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: filteredList.length, // Use filteredList
      itemBuilder: (BuildContext context, int position) {
        DocumentSnapshot documentSnapshot = filteredList[position];

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          child: Card(
            color: Colors.transparent,
            elevation: 2.0,
            child: ListTile(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              leading: imageBytes != null
                  ? CircleAvatar(
                      backgroundColor: Colors.grey, // Fallback color
                      backgroundImage: NetworkImage(documentSnapshot["image"]))
                  : const CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Icon(Icons.person), // Placeholder icon
                    ),
              title: Text(
                documentSnapshot["studentName"],
                style: const TextStyle(color: Colors.black),
              ),
              subtitle: Text(documentSnapshot["studyProgram"]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.black54),
                    onPressed: () {
                      navigateToDetail('Edit User',
                          documentSnapshot: documentSnapshot);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.black54),
                    onPressed: () {
                      showDeleteDialog(context, documentSnapshot);
                    },
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserDetails(documentSnapshot)));
              },
            ),
          ),
        );
      },
    );
  }

  // Show users as a grid view
  Widget getUserGridView() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      physics: const ScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemCount: filteredList.length, // Use filteredList
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (BuildContext context, int position) {
        DocumentSnapshot documentSnapshot = filteredList[position];
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => UserDetails(documentSnapshot)));
          },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.transparent,
            elevation: 2.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  imageBytes != null
                      ? CircleAvatar(
                          backgroundColor: Colors.grey, // Fallback color
                          backgroundImage:
                              NetworkImage(documentSnapshot["image"]),
                        )
                      : const CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(Icons.person), // Placeholder icon
                        ),
                  const SizedBox(height: 20),
                  Text(
                    documentSnapshot["studentName"],
                    style: const TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    documentSnapshot["studyProgram"],
                    style: const TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.black54),
                        onPressed: () {
                          navigateToDetail('Edit User',
                              documentSnapshot: documentSnapshot);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.black54),
                        onPressed: () {
                          showDeleteDialog(context, documentSnapshot);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void showDeleteDialog(
      BuildContext context, DocumentSnapshot documentSnapshot) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete...?"),
          content: const Text("Are you sure? This will be deleted."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _delete(context, name: documentSnapshot["studentName"]);
                Navigator.of(context).pop(); // Dismiss dialog after deletion
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void navigateToDetail(String title, {required documentSnapshot}) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            UserDetailsEdit(documentSnapshot: documentSnapshot, title),
      ),
    );
    if (result) {
      setState(() {});
    }
  }

  void _delete(BuildContext context, {required String name}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Students").doc(name);
    try {
      showSnackbar(context, 'User Deleted Successfully');
      await documentReference.delete();
      setState(() {});
    } catch (e) {
      showSnackbar(context, 'Error deleting user: $e');
    }
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void logout(BuildContext ctx) async {
    showDialog(
        context: ctx,
        builder: (ctx1) {
          return AlertDialog(
            title: const Text("Logout"),
            content: const Text("Do you want to logout......?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx1).pop();
                  },
                  child: const Text("Close")),
              TextButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();

                    final shared = await SharedPreferences.getInstance();
                    await shared.setBool('isLoggedIn', false);
                    showSnackbar(context, "Logout User succesfully");
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (ctx) {
                      return const LoginScreen();
                    }));
                  },
                  child: const Text("Logout")),
            ],
          );
        });
  }
}
