
import 'package:flutter/material.dart';
import 'package:studentsregistration/screens/splash_screen.dart';
const save_Key = "userLoggedIn";
void main(){
  runApp( const MyApp()
  );
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Users",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.deepPurple
      ),
      home:  const SplashScreen(),
    );
  }
}
