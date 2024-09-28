// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    goToLogin();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
    children:[
   Positioned(
       top: 0,
       left: 0,
       right: 0,
       bottom: 0,
       child: Image.asset("assets/images/background.jpeg",fit: BoxFit.fill,)),
      Center(child: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Image.asset("assets/images/splash.png",width: 160,height: 160,),
          const SizedBox(height: 20,),
          const Text("Students Register",style: TextStyle(fontSize: 25),),
        ],
      )),

        ]
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> goToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => const LoginScreen()));
  }

  Future<void> checkUserLogedin() async {
    final sharedprfs = await SharedPreferences.getInstance();
    final userLoggedIn = sharedprfs.getBool(save_Key);
    if (userLoggedIn == null || userLoggedIn == false) {
      goToLogin();
    } else {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => const HomePage()));
    }
  }
}
