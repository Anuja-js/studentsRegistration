import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  // Static method to save user data to Firestore
  static Future<void> saveUser(String name, String email, String uid) async {
    // Reference to the Firestore instance, accessing the 'users' collection
    await FirebaseFirestore.instance
        .collection('users')   // Collection name is 'users'
        .doc(uid)              // Document is identified by the user ID (uid)
        .set({                 // Save the user data (email and name)
      'email': email,
      'name': name,
    });
  }
}
