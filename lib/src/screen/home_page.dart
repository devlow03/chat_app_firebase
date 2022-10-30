import 'dart:convert';

import 'package:chat_app/model/user_model.dart';
import 'package:chat_app/src/screen/login_page.dart';
import 'package:chat_app/src/screen/message_screen.dart';
import 'package:chat_app/src/screen/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
   UserModel user;
   HomePage(this.user);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292F3F),
      appBar: AppBar(
        elevation: 0.0,
        title: const Text("Messages",
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600
        ),
        ),
        backgroundColor: Color(0xff292F3F),
        actions:  [

          IconButton(
              onPressed: ()async{
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width,

            child: Column(
              children: [
                const SizedBox(height: 10,),
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Gần đây",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.white38,
                        letterSpacing: 1.2
                      ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection("users").doc(widget.user.uid).collection("messages").snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data.docs.length < 1) {
                        return Center(

                        );
                      }
                      return SizedBox(
                        height: MediaQuery.of(context).size.height*0.12,

                        child: ListView.separated(
                          // physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context,index){
                            var friendId = snapshot.data.docs[index].id;
                            return FutureBuilder(
                              future: FirebaseFirestore.instance.collection("user").doc(friendId).get(),
                              builder: (context,AsyncSnapshot asyncSnapshot ){
                                if(asyncSnapshot.hasData){
                                  var friend = asyncSnapshot.data;
                                  return  InkWell(
                                    onTap: (){
                                      Get.to(MessageScreen(
                                        friendId: friendId,
                                        friendImage: friend["image"],
                                        friendName: friend["name"],
                                        currentUser: widget.user,
                                      ));
                                    },
                                    child: Column(
                                      children:  [
                                         CircleAvatar(
                                          backgroundImage: NetworkImage(friend['image']),
                                          radius: 25,
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(friend['name'],
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.white
                                          ),
                                        )

                                      ],
                                    ),
                                  );
                                }
                                return Center();

                              },


                            );
                          }, separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(width: 25,);
                        },
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),


                const SizedBox(height: 30,),
             

              ],
            ),
          ),
             Container(
               height: MediaQuery.of(context).size.height,
               constraints: BoxConstraints(
                 maxHeight: 500
               ),
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: const Color(0xff292F3F)
                  ),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance.collection("users").doc(widget.user.uid).collection("messages").snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if(snapshot.hasData){
                        if(snapshot.data.docs.length<1){
                          return Center(
                            child: Text('Không có đoạn hội thoại nào'),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context,index){
                            var friendId = snapshot.data.docs[index].id;
                            var lastMsg = snapshot.data.docs[index]['last_msg'];
                            // var date =  snapshot.data.docs[index]['date'];

                            return FutureBuilder(
                              future: FirebaseFirestore.instance.collection("user").doc(friendId).get(),
                              builder: (context,AsyncSnapshot asyncSnapshot){
                                if(asyncSnapshot.hasData){
                                  var friend = asyncSnapshot.data;
                                  // return TextButton(onPressed: (){
                                  //   print(jsonDecode(friend.toString()));
                                  // }, child: Text('a'));
                                  return InkWell(
                                    onTap: (){
                                      Get.to(MessageScreen(
                                        friendId: friendId,
                                        friendImage: friend["image"],
                                        friendName: friend["name"],
                                        currentUser: widget.user,
                                      ));
                                    },
                                    child:  ListTile(
                                      leading: CircleAvatar(
                                        radius: 25,
                                        backgroundImage: NetworkImage(friend['image']),
                                      ),
                                      title: Text(friend['name'],
                                        style: TextStyle(fontSize: 15,
                                            color: Colors.white
                                        ),
                                      ),
                                      subtitle: Text("$lastMsg",
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white54,

                                        ),
                                      ),
                                      // trailing: Text(date,
                                      //   style: TextStyle(
                                      //       fontSize: 14,
                                      //       color: Colors.white54
                                      //   ),
                                      // ),
                                    ),
                                  );

                                }
                                return Center();

                              },
                            );


                          },
                        );

                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  ),
                )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child:  Image.asset("resource/images/search.png"),
        onPressed: (){
          Get.to(SearchPage(widget.user));
        },
        backgroundColor: Color(0xff1B202D),
      ),
    );
  }
}