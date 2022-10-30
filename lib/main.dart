import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/src/screen/home_page.dart';
import 'package:chat_app/src/screen/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  //     options: FirebaseOptions(
  //   apiKey: "AIzaSyDjGS89UUfOAHT2AU-Be1g7A5FvX7AoqqM",
  //   appId: "1:532957255733:web:3e224abf927424a961397c",
  //   messagingSenderId: "532957255733",
  //   projectId: "chatapp-50d3e",
  // )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  Future checkSignin() async{
    User? user = FirebaseAuth.instance.currentUser;
    if(user!=null){
      DocumentSnapshot userData = await FirebaseFirestore.instance.collection('user').doc(user.uid).get();
      UserModel userModel = UserModel.fromJson(userData);
      return HomePage(userModel);
    }
    else{
      return LoginScreen();
    }
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Message App',
      debugShowCheckedModeBanner: false,
      home:
      // LoginScreen()
      FutureBuilder(
        future: checkSignin(),
        builder: (context,AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return snapshot.data;
          }
          return Center();
        },
      ),
    );
  }
}


