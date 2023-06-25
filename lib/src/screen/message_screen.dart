import 'dart:io';

import 'package:chat_app/widgets/message_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/user_model.dart';

class MessageScreen extends StatefulWidget {
  final UserModel currentUser;
  final String friendId;
  final String friendName;
  final String friendImage;
  MessageScreen(
      {Key? key,
      required this.currentUser,
      required this.friendId,
      required this.friendName,
      required this.friendImage})
      : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final ScrollController scrollController = ScrollController();
  int onNull = 1;
  TextEditingController messControl = TextEditingController();
  int showEmoji = 0;
  @override
  void initState() {
    super.initState();
   
    // setState((){
    //   WidgetsBinding.instance.addPostFrameCallback((_) {_scrollDown();});
    // });
  }
  // void _scrollDown() {
  //   _controller.jumpTo(_controller.position.maxScrollExtent);
  // }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // backgroundColor: const Color(0xff1B202D),
      appBar: AppBar(
        elevation: 0.0,
        // backgroundColor: const Color(0xff1B202D),
        backgroundColor: Colors.white,
        // automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        title: Center(
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: Image.network(
                  widget.friendImage,
                  height: 35,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.friendName,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      const Text(
                        'Online',
                        style: TextStyle(color: Colors.blue, fontSize: 11),
                      )
                    ],
                  ),
                  // Text(
                  //   "Online",
                  //   style: TextStyle(fontSize: 12, color: Colors.white54),
                  // )
                ],
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.currentUser.uid)
                    .collection("messages")
                    .doc(widget.friendId)
                    .collection("chats")
                    .orderBy("date")
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (scrollController.hasClients) {
                        final position =
                            scrollController.position.maxScrollExtent;
                        scrollController.jumpTo(position);
                      }
                    });
                    return ListView.separated(
                      // reverse: true,
                      shrinkWrap: true,
                      controller: scrollController,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        bool isMe = snapshot.data.docs[index]['senderId'] ==
                            widget.currentUser.uid;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            children: [
                              MessageBox(
                                  isMe: isMe,
                                  message: snapshot.data.docs[index]['message']),
                                  const SizedBox(height: 20,),
                            ],
                            
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 30,
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
          ),
          
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 46,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        // color: const Color(0xff3D4354)
                        color: Colors.grey.shade100),
                    child: Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                            onTap: () {
                              setState(() {
                                showEmoji =1;
                                FocusScope.of(context).unfocus();
                                
                              });
                            
                            },
                            child: const Icon(
                              Icons.sentiment_satisfied_alt_outlined,
                              size: 30,
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            onTap: (){
                              setState(() {
                                showEmoji=0;
                              });
                            },
                            // ignore: avoid_types_as_parameter_names
                            onChanged: (bool) {
                              if (messControl.text.isNotEmpty) {
                                setState(() {
                                  onNull = 0;
                                  
                                });
                              } else {
                                setState(() {
                                  onNull = 1;
                                });
                              }
                            },
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              hintText: "Nhập tin nhắn",
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                            controller: messControl,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Icon(Icons.photo_album),
                        const SizedBox(
                          width: 20,
                        ),
                        
                        
                      
                      ],
                    ),
                  ),
                ),
                Visibility(
                          visible: onNull == 0,
                          replacement: Padding(
                            padding: const EdgeInsets.only(right:8.0),
                            child: InkWell(
                                onTap: () async {
                                  
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue
                                  ),
                                  child: const Icon(Icons.mic,color: Colors.white,size: 20,))),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right:8.0),
                            child: InkWell(
                                onTap: () async {
                                  String message = messControl.text;
                                  messControl.clear();
                                    
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.currentUser.uid)
                                      .collection('messages')
                                      .doc(widget.friendId)
                                      .collection('chats')
                                      .add({
                                    "senderId": widget.currentUser.uid,
                                    "receiverId": widget.friendId,
                                    "message": message,
                                    "type": "text",
                                    "date": DateTime.now(),
                                  }).then((value) {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.currentUser.uid)
                                        .collection('messages')
                                        .doc(widget.friendId)
                                        .set({'last_msg': message});
                                    
                                    // _scrollDown();
                                  }).then((value) {
                                   
                                  });
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.friendId)
                                      .collection('messages')
                                      .doc(widget.currentUser.uid)
                                      .collection('chats')
                                      .add({
                                    "senderId": widget.currentUser.uid,
                                    "receiverId": widget.friendId,
                                    "message": message,
                                    "type": "text",
                                    "date": DateTime.now(),
                                  }).then((value) {
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.friendId)
                                        .collection('messages')
                                        .doc(widget.currentUser.uid)
                                        .set({'last_msg': message}).then((value) {
                                    
                                    });
                                    // _scrollDown();
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.blue
                                  ),
                                  child: const Icon(Icons.arrow_upward,color: Colors.white,size: 20,))),
                          ),
                        ),
              ],
            ),
          ),
          Visibility(
            visible: showEmoji==1,
            replacement: const Center(),
            child: SizedBox(
            height: 325,
            child: EmojiPicker(
              textEditingController: messControl,
              onEmojiSelected: (category, emoji) {
                setState(() {
                  onNull=0;
                });
              },
              onBackspacePressed: () {},
              config: const Config(
                backspaceColor: Color(0xFFB71C1C),
                columns: 7,
                emojiSizeMax: 32.0,
                verticalSpacing: 0,
                horizontalSpacing: 0,
                initCategory: Category.RECENT,
                bgColor: Color(0xFFF2F2F2),
                indicatorColor: Color(0xFFB71C1C),
                iconColor: Colors.grey,
                iconColorSelected: Color(0xFFB71C1C),
                showRecentsTab: true,
                recentsLimit: 28,
                categoryIcons: CategoryIcons(),
                buttonMode: ButtonMode.MATERIAL,
              ),
            ),
          ),
          )
        ],
      ),
    );
  }
}
