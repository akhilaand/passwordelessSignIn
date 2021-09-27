import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passwordles_sign_in/views/home_screen.dart';
import 'package:passwordles_sign_in/views/login_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passwordless Sign in',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream:FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context,snapshot)
        {
          if(snapshot.connectionState==ConnectionState.waiting){
            return const CircularProgressIndicator();
          }
          else if(snapshot.hasData){
            print("-------------------------------------------------------------");
            return const HomeScreen();
          }
          else{
            return LoginPage();
          }

        },

      ),
    );
  }
}


