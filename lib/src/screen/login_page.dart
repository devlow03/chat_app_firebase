import 'package:chat_app/main.dart';
import 'package:chat_app/src/screen/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';

import '../../model/user_model.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future signInFunction()async{
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if(googleUser==null){
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );
    UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    DocumentSnapshot user = await firestore.collection('user').doc(userCredential.user!.uid).get();
    if(user.exists){
      print("Tài khoản đã tổn tại");
    }
    else {
      await firestore.collection('user').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'name': userCredential.user!.displayName,
        'image': userCredential.user!.photoURL,
        'uid': userCredential.user!.uid,
        'date': DateTime.now()
      });
    }

    DocumentSnapshot userData = await FirebaseFirestore.instance.collection('user').doc(user.id).get();
    UserModel userModel = UserModel.fromJson(userData);
    Get.offAll(HomePage(userModel));

  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.grey.shade200,
        // backgroundColor: Color(0xff1B202D),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Lottie.asset("resource/images/chat_splash.json")),
            SizedBox(
              width: MediaQuery.of(context).size.width * .85,
              child: ElevatedButton(
                onPressed: () async {
                  await signInFunction();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      Image.asset("resource/images/google_ico.png",
                      height: 30,
                        width: 30,
                      ),
                      SizedBox(width: 50,),
                      Center(
                        child: Text(
                          'Sign in with Google',
                          style: TextStyle(
                              fontSize: 17,
                              // fontWeight: FontWeight.w700,
                              color: Colors.black,
                              letterSpacing: 1),
                        ),
                      ),
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  // shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(30),
                  //     side: BorderSide(color: Colors.grey.shade100)
                  // ),
                  primary: Colors.white,
                ),
              ),
            ),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ));
  }
}