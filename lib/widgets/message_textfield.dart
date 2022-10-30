// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// class MessageTextField extends StatefulWidget {
//   final String currentId;
//   final String friendId;
//   const MessageTextField({Key? key,required this.currentId, required this.friendId}) : super(key: key);
//
//   @override
//   State<MessageTextField> createState() => _MessageTextFieldState();
// }
//
// class _MessageTextFieldState extends State<MessageTextField> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: SafeArea(
//         child: Row(
//           children: [
//             // const SizedBox(
//             //   width: 10,
//             // ),
//             // const Icon(
//             //   Icons.mic,
//             //   color: Color(0xff9398A7),
//             // ),
//             // const SizedBox(
//             //   width: 5,
//             // ),
//             Expanded(
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 20),
//                 height: 46,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(25),
//                     color: const Color(0xff3D4354)),
//                 child: Row(
//                   // ignore: prefer_const_literals_to_create_immutables
//                   children: [
//                     const SizedBox(
//                       width: 5,
//                     ),
//                     // const Icon(Icons.sentiment_satisfied_alt_outlined),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     Expanded(
//                       child: TextField(
//                         keyboardType: TextInputType.multiline,
//                         decoration: InputDecoration(
//                           hintText: "Nhắn tin",
//                           border: InputBorder.none,
//                         ),
//                         maxLines: null,
//                         controller: messControl,
//                       ),
//                     ),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                     InkWell(
//                         onTap: () async{
//                           String message = messControl.text;
//                           messControl.clear();
//                           await FirebaseFirestore.instance.collection('users').doc(widget.currentId).collection('messages').doc(widget.friendId).collection('chats').add({
//                             "senderId":widget.currentId,
//                             "receiverId":widget.friendId,
//                             "message":message,
//                             "type":"text",
//                             "date":DateTime.now(),
//                           }).then((value){
//                             FirebaseFirestore.instance.collection('users').doc(widget.currentId).collection('messages').doc(widget.friendId).set({
//                               'last_msg':message
//                             });
//                           });
//                           await FirebaseFirestore.instance.collection('users').doc(widget.friendId).collection('messages').doc(widget.currentId).collection('chats').add({
//                             "senderId":widget.currentId,
//                             "receiverId":widget.friendId,
//                             "message":message,
//                             "type":"text",
//                             "date":DateTime.now(),
//                           }).then((value){
//                             FirebaseFirestore.instance.collection('users').doc(widget.friendId).collection('messages').doc(widget.currentId).set({
//                               'last_msg':message
//                             });
//                           });
//
//                         },
//                         child: const Icon(Icons.send)),
//                     const SizedBox(
//                       width: 10,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
