// ignore_for_file: use_build_context_synchronously
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:studentsregistration/customs/constants.dart';
import 'package:studentsregistration/customs/custom_text.dart';
import 'package:studentsregistration/customs/logo_image.dart';
import 'package:studentsregistration/screens/login_screen.dart';
import 'package:studentsregistration/services/auth_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  bool obscurepass = true;
  String email = "";
  String password = "";
  String fullname = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
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
                  LogoImage(text: "SignUp"),
                  const SizedBox(
                    height: 20,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextFormField(
                      key: const ValueKey("fullname"),
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: "Enter Your Name",
                        labelStyle: TextStyle(
                          color: black,
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
                          return "Please Enter Your Name";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        setState(() {
                          fullname = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextFormField(
                      key: const ValueKey("email"),
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Enter Your Email",
                        labelStyle: TextStyle(
                          color: black,
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
                      onSaved: (value) {
                        setState(() {
                          email = value!;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
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
                                ? Icon(
                                    Icons.visibility_outlined,
                                    color: black,
                                  )
                                : Icon(
                                    Icons.visibility_off_outlined,
                                    color: black,
                                  )),
                        labelText: "Enter Your Password",
                        labelStyle: TextStyle(
                          color: black,
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
                      onSaved: (value) {
                        setState(() {
                          password = value!;
                        });
                      },
                    ),
                  ),
                  const Spacer(),
                  ConstrainedBox(
                    constraints:
                        const BoxConstraints(maxWidth: 400, minWidth: 120),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formkey.currentState!.validate()) {
                          // checkLogIn(context);
                          formkey.currentState!.save();
                          AuthServices.signupUser(
                              email, password, fullname, context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (ctx) {
                            return const LoginScreen();
                          }));
                        } else {
                          if (kDebugMode) {
                            print("Data Empty");
                          }
                        }
                        // checkLogIn(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(black),
                        foregroundColor: MaterialStateProperty.all(white),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 5,
                          ),
                        ),
                      ),
                      child: TextCustom(
                        text: "SignUp",
                        color: white,
                      ),
                    ),
                  ),
                  sh10,
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextCustom(
                          text: "Do you have an account?",
                          color: black,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (ctx) {
                                return const LoginScreen();
                              }));
                            },
                            child: TextCustom(
                              text: "LogIn",
                              color: Colors.indigoAccent,
                            ))
                      ],
                    ),
                  ),
                  sh10,
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
