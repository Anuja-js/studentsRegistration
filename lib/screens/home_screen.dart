// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentsregistration/customs/custom_text.dart';
import 'package:studentsregistration/screens/edit_user_details.dart';
import 'package:studentsregistration/screens/user_detail.dart';
import '../customs/constants.dart';
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
    fetchStudents();
    super.initState();
  }

  void fetchStudents() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Students").get();
      userList = querySnapshot.docs;
      filteredList = userList;
     if(mounted){
       setState(() {

       });
     }
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
    } filteredList = searchList;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: TextCustom(text: "Students", color: white),
        backgroundColor: black,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isPress = !isPress;
                });
              },
              icon: isPress
                  ? Icon(
                      Icons.grid_4x4_outlined,
                      color: white,
                    )
                  : Icon(Icons.list_alt_outlined, color: white)),
          IconButton(
            onPressed: () async {
              logout(context);
            },
            icon: Icon(Icons.logout, color: white),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: TextField(
                      controller: textControl,
                      onChanged: (value) {
                        filterSearch(value);
                      },
                      style: TextStyle(color: white),
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: white,
                        ),
                      ),
                    ),
                  ),
                ],
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
          SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 3,
              )),
          isPress
              ? filteredList.isEmpty
                  ? Center(
                      child: TextCustom(
                      text: "Student Not found",
                      color: black,
                    ))
                  : Center(child: getUsersList())
              : filteredList.isEmpty
                  ? Center(
                      child:
                          TextCustom(text: "Student Not found", color: black))
                  : Center(child: getUserWrapView())
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: black,
        foregroundColor: white,
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
    return SizedBox(width: MediaQuery.of(context).size.width/2.1,
      child: ListView.builder(
        physics: const ScrollPhysics(),
        scrollDirection: Axis.vertical,
        itemCount: filteredList.length, // Use filteredList
        itemBuilder: (BuildContext context, int position) {
          DocumentSnapshot documentSnapshot = filteredList[position];
          return Card(
            margin:  const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
            color: Colors.transparent,
            elevation: 2.0,
            child: SizedBox(height: MediaQuery.of(context).size.height/7,
              child: InkWell(onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (ctx){
                  return UserDetails(documentSnapshot);
                }));
              },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),

                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                         documentSnapshot["image"] != ""
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              documentSnapshot["image"],
                              width: 50,
                              height: 50,
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
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.error, color: Colors.red, size: 20),
                                    sh10,
                                    TextCustom(text: 'Failed load', color: black),
                                  ],
                                );
                              },
                            ),
                          )
                        : const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.person), // Placeholder icon
                          ),sw10,
                  SizedBox(width: MediaQuery.of(context).size.width/12,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextCustom(
                            text: documentSnapshot["studentName"],
                            color: black
                        ),
                        TextCustom(text:documentSnapshot["studyProgram"],color: Colors.black87,),
                      ],
                    ),
                  ),
                        const Spacer(),
                   Column(mainAxisAlignment: MainAxisAlignment.center,crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       GestureDetector(
                           onTap: (){
                             navigateToDetail('Edit User',
                                 documentSnapshot: documentSnapshot);

                           },
                           child: const Icon(Icons.edit, color: Colors.black54)),

                        sh20,
                        GestureDetector(
                            onTap: (){
                              showDeleteDialog(context, documentSnapshot);
                            },
                            child: const Icon(Icons.delete, color: Colors.black54)),

                     ],
                   )
                    ]
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Show users as a grid view
  // Show users as a wrap layout
  Widget getUserWrapView() {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 10, // Horizontal spacing between items
        runSpacing: 10, // Vertical spacing between items
        children: List.generate(filteredList.length, (position) {
          DocumentSnapshot documentSnapshot = filteredList[position];
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UserDetails(documentSnapshot)));
            },
            child: ConstrainedBox(constraints:const BoxConstraints(maxWidth: 300,
            // minWidth: MediaQuery.of(context).size.width /7,
            ) ,
               // Dynamic width for each item
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
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
                      documentSnapshot["image"] != ""
                          ? CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey, // Fallback color
                        backgroundImage:
                        NetworkImage(documentSnapshot["image"]),
                      )
                          : const CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.person), // Placeholder icon
                      ),
                     sh10, // Spacing between avatar and name
                      Text(
                        documentSnapshot["studentName"],
                        style:  TextStyle(
                          color: black,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis, // Avoid overflow
                        maxLines: 1, // Limit to 1 line
                      ),
                     sh10, // Spacing between name and study program
                      Text(
                        documentSnapshot["studyProgram"],
                        style: TextStyle(
                          color: black,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      // const Spacer(),
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
            ),
          );
        }),
      ),
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
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
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

  void _delete(BuildContext context, {required String name}) async {
    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("Students").doc(name);

    try {
      await documentReference.delete();
      filteredList.removeWhere((element) => element.id == documentReference.id);
      showSnackbar(context, 'User Deleted Successfully');
      setState(() {});
    } catch (e) {
      showSnackbar(context, 'Error deleting user: $e');
    }

    Navigator.of(context).pop();
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
