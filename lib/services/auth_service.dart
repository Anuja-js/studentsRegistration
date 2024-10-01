import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:studentsregistration/services/firebase_service.dart';
class AuthServices {
  // Static method to sign up a user
  static Future<void> signupUser(
      String email, String password, String name, BuildContext context) async {
    try {
      // Create a user with email and password using Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Update the user's display name
      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);

      // Optionally update the user's email (if needed)
      await FirebaseAuth.instance.currentUser?.updateEmail(email);

      // Save user data to Firestore or any database service
      await FirestoreServices.saveUser(
          name, email, userCredential.user?.uid ?? '');

      // Show success message after successful registration
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration Successful!'),
      ));
    } on FirebaseAuthException catch (e) {
      // Handle different error cases for Firebase Auth exceptions
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password provided is too weak!'),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Email provided is already in use!'),
        ));
      }
    } catch (e) {
      // Handle any other errors
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.toString()}'),
      ));
    }
  }
 static   signinUser(
      String email, String password, BuildContext context) async {
    try {
      // Sign in the user using Firebase Authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Show a success message when the user logs in
    await  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You are Logged-in!'),

      ));
      return true;
    } on FirebaseAuthException catch (e) {
      // Handle different error cases for Firebase Auth exceptions
      if (e.code == 'user-not-found') {
      await  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No user found with this email!'),
        ));
        return false;
      } else if (e.code == 'wrong-password') {
      await  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Password did not match!'),
        ));
        return false;
      }
    }
  }
}
