import 'package:flutter/material.dart';
class MessageBox extends StatefulWidget {
  final bool isMe;
  final String message;
  const MessageBox({Key? key,required this.isMe, required this.message}) : super(key: key);

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.isMe?MainAxisAlignment.end:MainAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            // width: MediaQuery.of(context).size.width *.5,
            constraints: BoxConstraints(maxWidth: 200),
            decoration: BoxDecoration(
                color: widget.isMe?Color(0xff3D4354):Color(0xff7A8194),
                borderRadius: BorderRadius.circular(15)
            ),
            child: Text(
              widget.message,
              style: TextStyle(
                  color: Colors.white
              ),
            )),
      ],
    );
  }
}
