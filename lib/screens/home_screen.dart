import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
  // List<User> userList = [];
  int count = 0;
  bool isPress = true;
  TextEditingController textControl = TextEditingController();
  @override
  void initState() {
    updateListView();
    super.initState();
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
            onPressed: () async{
             await FirebaseAuth.instance.signOut();
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
                  if (value.isNotEmpty) {
                    // var userListFuture = databaseHelper.getUserList();
                    // ignore: non_constant_identifier_names
                    // userListFuture.then((List) {
                    //   setState(() {
                    //     userList = List.where((element) => element.name!
                    //         .toUpperCase()
                    //         .contains(textControl.text.toUpperCase())).toList();
                    //     count = userList.length;
                    //   });
                    // });
                  } else {
                    updateListView();
                  }
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
          // userList.isEmpty
          //     ? const Center(
          //         child: Text(
          //         "NO STUDENTS AVAILABLE",
          //         style: TextStyle(color: Colors.black),
          //       ))
          //     :
          isPress ? getUsersListView() : getUserGridView()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (ctx) {
            return UserDetailsEdit("Add Student", documentSnapshot: null,);
          }));
        },
        tooltip: 'Add Student',
        child: const Icon(Icons.add),
      ),
    );
  }

  StreamBuilder<QuerySnapshot> getUsersListView() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Students").snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              physics: const ScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int position) {
                DocumentSnapshot documentSnapshot= snapshot.data!.docs[position];
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  child: Card(
                    color: Colors.transparent,
                    elevation: 2.0,
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      leading: const CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 25,
                        child: Icon(Icons.person, color: Colors.white),
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
                              navigateToDetail('Edit User',documentSnapshot:  documentSnapshot);
                            },
                          ),
                          IconButton(
                            icon:
                                const Icon(Icons.delete, color: Colors.black54),
                            onPressed: () {
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
          else{
        return    const CircularProgressIndicator();
          }
        });
  }

  StreamBuilder<QuerySnapshot> getUserGridView() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Students").snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (snapshot.hasData) {
             return GridView.builder(

                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                physics: const ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: count,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (BuildContext context, int position) {
                  DocumentSnapshot documentSnapshot= snapshot.data!.docs[position];
                  return InkWell(
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => UserDetails(userList[position])));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.transparent,
                      elevation: 2.0,
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.black,
                              radius: 35,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              documentSnapshot["studentName"],
                              style: const TextStyle(color: Colors.black, fontSize: 18),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              documentSnapshot["studyProgram"],
                              style:
                              const TextStyle(color: Colors.black54, fontSize: 15),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.black54),
                                  onPressed: () {
                                   navigateToDetail(documentSnapshot:documentSnapshot , 'Edit User', );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.black54),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text("Delete...?"),
                                            content:
                                            const Text("Are you sure?  will be deleted?"),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Cancel")),
                                              TextButton(
                                                  onPressed: () {
                                                    // _delete(
                                                    //     context, userList[position]);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Delete")),
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          else{
            return    const CircularProgressIndicator();
          }
        });


  }

  void navigateToDetail(String title, {required documentSnapshot}) async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserDetailsEdit( documentSnapshot:documentSnapshot,title ),
      ),
    );
    if (result) {
      updateListView();
    }
  }


  void _delete(
    BuildContext context, {required String name}
  ) async {
    DocumentReference documentReference = FirebaseFirestore
        .instance
        .collection("Students")
        .doc(name);
    try {
      showSnackbar(context, 'User Deleted Successfully');
      await documentReference.delete();

      updateListView();
    } catch (e) {
      showSnackbar(context, 'Error deleting user: $e');
    }

  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void updateListView() async {
    setState(() {

    });
  }

  logout(BuildContext ctx) async {
    final sharedprfs = await SharedPreferences.getInstance();
    // ignore: use_build_context_synchronously
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
                    await sharedprfs.clear();
                    // ignore: use_build_context_synchronously
                    Navigator.of(ctx).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (ctx1) => const LoginScreen()),
                        (route) => false);
                  },
                  child: const Text("Logout")),
            ],
          );
        });
  }
}
