
import 'package:chat_app/widgets/message_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/user_model.dart';
import '../../widgets/message_textfield.dart';

class MessageScreen extends StatefulWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;
  MessageScreen({Key? key,
    required this.currentUser,
    required this.friendId,
    required this.friendName,
    required this.friendImage
}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final ScrollController _controller = ScrollController();
   int onNull = 1;
  @override
  
  TextEditingController messControl = TextEditingController();
  void initState(){
    super.initState();
    setState((){
      WidgetsBinding.instance.addPostFrameCallback((_) {_scrollDown();});
    });

  }
  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1B202D),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff1B202D),
        // automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: Image.network(widget.friendImage,height: 35,),
            ),
            const SizedBox(
              width: 5,
            ),
            Column(
              children:  [
                Text(
                  widget.friendName,
                  style: TextStyle(fontSize: 16),
                ),
                // Text(
                //   "Online",
                //   style: TextStyle(fontSize: 12, color: Colors.white54),
                // )
              ],
            )
          ],
        ),
        // actions: const [
        //   Icon(Icons.local_phone),
        //   SizedBox(
        //     width: 10,
        //   ),
        //   Icon(Icons.videocam),
        //   SizedBox(
        //     width: 10,
        //   ),
        // ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("users").doc(widget.currentUser.uid).collection("messages").doc(widget.friendId).collection("chats").orderBy("date").snapshots(),
              builder: (context, AsyncSnapshot snapshot){
               if(snapshot.hasData){
                 if(snapshot.data.docs.length<1){
                   return Center();
                 }
                 return ListView.separated(
                   shrinkWrap: true,
                   controller: _controller,
                   itemCount: snapshot.data.docs.length,
                   itemBuilder: (context,index){
                    bool isMe = snapshot.data.docs[index]['senderId'] == widget.currentUser.uid;
                    return MessageBox(isMe: isMe, message: snapshot.data.docs[index]['message']);
                   }, separatorBuilder: (BuildContext context, int index) {
                     return SizedBox(height: 10,);
                 },
                 );
               }
               return Center(
                 child: CircularProgressIndicator(),
               );
              }

            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: SafeArea(
              child: Row(
                children: [
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  // const Icon(
                  //   Icons.mic,
                  //   color: Color(0xff9398A7),
                  // ),
                  // const SizedBox(
                  //   width: 5,
                  // ),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      height: 46,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xff3D4354)),
                      child: Row(
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          const SizedBox(
                            width: 5,
                          ),
                          // const Icon(Icons.sentiment_satisfied_alt_outlined),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (bool){
                                  if(messControl.text.length>=1){
                                    setState((){
                                      onNull = 0;
                                    });
                                  }
                                  else{
                                    setState((){
                                      onNull = 1;
                                    });
                                  }


                                },

                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                hintText: "Nhập tin nhắn",
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                              controller: messControl,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Visibility(
                            visible: onNull==0,
                            replacement: Center(),
                            child: InkWell(
                                onTap: () async{
                                  String message = messControl.text;
                                  messControl.clear();

                                  await FirebaseFirestore.instance.collection('users').doc(widget.currentUser.uid).collection('messages').doc(widget.friendId).collection('chats').add({
                                    "senderId":widget.currentUser.uid,
                                    "receiverId":widget.friendId,
                                    "message":message,
                                    "type":"text",
                                    "date":DateTime.now(),
                                  }).then((value){
                                    FirebaseFirestore.instance.collection('users').doc(widget.currentUser.uid).collection('messages').doc(widget.friendId).set({
                                      'last_msg':message
                                    });
                                    _scrollDown();
                                  });
                                  await FirebaseFirestore.instance.collection('users').doc(widget.friendId).collection('messages').doc(widget.currentUser.uid).collection('chats').add({
                                    "senderId":widget.currentUser.uid,
                                    "receiverId":widget.friendId,
                                    "message":message,
                                    "type":"text",
                                    "date":DateTime.now(),
                                  }).then((value){
                                    FirebaseFirestore.instance.collection('users').doc(widget.friendId).collection('messages').doc(widget.currentUser.uid).set({
                                      'last_msg':message
                                    });
                                    _scrollDown();
                                  });

                                },
                                child: const Icon(Icons.send)),
                          ),

                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )



        ],
      ),
    );
  }
}
