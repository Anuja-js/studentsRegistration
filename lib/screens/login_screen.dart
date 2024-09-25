// ignore_for_file: use_build_context_synchronously

import 'package:studentsregistration/screens/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  bool obscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor:Colors.black,
      //   title: const Text("Log In"),
      // ),
      body: SafeArea(
        child: Stack(
          children:[
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Image.asset("assets/images/background.jpeg",fit: BoxFit.fill,)),

            Positioned(
              top: 100,
              left: 10,
              right: 10,
              bottom: 10,

              child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset("assets/images/splash.png",width: 50,height: 50,),
                      const SizedBox(width: 10,),
                      const Text("Log In")
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Enter Your Name',
                      labelStyle: TextStyle(
                        color:Colors.black,
                      ),
                      fillColor: Colors.grey,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red, width: 2)),
                      focusedBorder: OutlineInputBorder(
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    style: const TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Courier',
                    ),
                    controller: _passwordController,
                    obscureText: obscure,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscure = !obscure;
                            });
                          },
                          icon: obscure
                              ?const Icon(Icons.visibility_outlined,
                                  color: Colors.black,)
                              :const Icon(
                                  Icons.visibility_off_outlined,
                                  color:Colors.black,
                                )),
                      labelText: "Enter Your Password",
                      labelStyle:const TextStyle(color: Colors.black,),
                      border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey, width: 2)),
                      errorBorder:const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2),
                      ),
                      focusedBorder:const OutlineInputBorder(
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
                  const Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          checkLogIn(context);
                        } else {
                           if (kDebugMode) {
                             print("Data Empty");
                           }
                        }
                        // checkLogIn(context);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.black),
                        foregroundColor:MaterialStateProperty.all(Colors.white),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                              vertical: 15,
                              horizontal: MediaQuery.of(context).size.width / 2.5),
                        ),
                      ),
                      child: const Text("LogIn",style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(height: 30,)
                ],
              ),
          ),
            ),
            ]
        ),

      ),
    );
  }

  void checkLogIn(BuildContext ctx) async {
    final username = _nameController.text;
    final password = _passwordController.text;
    if (username == "Anuja" && password == "anuja@gmail.com") {
//go to home
      if (kDebugMode) {
        print("User name and password correct");
      }
      final sharedprfs = await SharedPreferences.getInstance();
      await sharedprfs.setBool(save_Key, true);

      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx1) {
        return const HomePage();
      }));
    } else {
      if (kDebugMode) {
        print("User name and password doesn't match");
      }
      //snackBar
      const errorMessage = "User name or password is incorrect";

      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
          margin: EdgeInsets.all(15.0),
          content: Text(errorMessage)
      )
      );
    }
  }
}
