// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studentsregistration/customs/constants.dart';
import 'package:studentsregistration/customs/custom_text.dart';
import 'package:studentsregistration/screens/home_screen.dart';
import 'package:studentsregistration/screens/sign_up.dart';

import '../customs/logo_image.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  bool obscure = true;
  bool obscurepass = true;
  String email = "";
  String password = "";
  String fullname = "";
  bool login = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                "assets/images/background.jpeg",
                fit: BoxFit.fill,
              )),
          Positioned(
            top: 100,
            left: 10,
            right: 10,
            bottom: 10,
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  login
                      ? sh10
                      :  LogoImage(text: 'Login',),
                  sh20,
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextFormField(
                      key: const ValueKey("email"),
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: emailController,
                      obscureText: obscure,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscure = !obscure;
                              });
                            },
                            icon: obscure
                                ? const Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.black,
                                  )),
                        labelText: "Enter Your Email",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2)),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your Email";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  sh20,
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: TextFormField(
                      key: const ValueKey("password"),
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: passwordController,
                      obscureText: obscurepass,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscurepass = !obscurepass;
                              });
                            },
                            icon: obscurepass
                                ? const Icon(
                                    Icons.visibility_outlined,
                                    color: Colors.black,
                                  )
                                : const Icon(
                                    Icons.visibility_off_outlined,
                                    color: Colors.black,
                                  )),
                        labelText: "Enter Your Password",
                        labelStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2)),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Your Password";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          formkey.currentState!.save();
                            await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);

                           try{
                              await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                             login = true;
                             saveSharedPreference(context, login);
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(duration: Duration(seconds: 1),
                               content: Text('User login Succesfully'),
                             ));
                             Navigator.push(context,
                                 MaterialPageRoute(builder: (ctx) {
                                   return const HomePage();
                                 }));
                           }catch (e){
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(duration: Duration(seconds: 1),
                               content: Text('User not found!'),
                             ));
                           }

                        } else {
                          login = false;
                          if (kDebugMode) {
                            print("Data Empty");
                          }
                        }
                        // checkLogIn(context);
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 5,
                        )),
                      ),
                      child: TextCustom(text: "LogIn", color: Colors.white),
                    ),
                  ),
                  sh10,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextCustom(
                          text: "Don't have an account?", color: Colors.black),
                      TextButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (ctx) {
                              return const SignUp();
                            }));
                          },
                          child: TextCustom(
                            text: "SignUp",
                            color: Colors.indigoAccent,
                          ))
                    ],
                  ),sh10,
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
  void saveSharedPreference(context, bool login) async {
    final shared = await SharedPreferences.getInstance();
    await shared.setBool('isLoggedIn', login);
  }
}

