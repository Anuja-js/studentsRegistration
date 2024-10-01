
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:studentsregistration/screens/home_screen.dart';
import 'package:studentsregistration/screens/splash_screen.dart';
import 'firebase_options.dart';
const save_Key = "userLoggedIn";
void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context,snaphot){
        if(snaphot.hasData){
          return  const HomePage();
        }
        else{
          return const SplashScreen();
        }
      })
    );
  }
}
