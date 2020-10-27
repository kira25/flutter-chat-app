import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final String uid;
  final AnimationController animationController;

  const ChatMessage({Key key, this.text, this.uid, this.animationController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animationController,
          child: SizeTransition(
            sizeFactor: CurvedAnimation(parent: animationController,curve: Curves.easeOut),
                      child: Container(
        child: uid == '123' ? myMessage() : notMyMessage(),
      ),
          ),
    );
  }

  Widget myMessage() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 5, left: 50, right: 5),
        decoration: BoxDecoration(
            color: Color(0xFF4D9EF6), borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(8),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget notMyMessage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 5, left: 50, right: 5),
        decoration: BoxDecoration(
            color: Color(0xFFE4E5E8), borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.all(8),
        child: Text(
          text,
          style: TextStyle(color: Colors.black87),
        ),
      ),
    );
    ;
  }
}
