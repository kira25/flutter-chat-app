import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final textCtrl = new TextEditingController();
  final _focusNode = FocusNode();
  bool _sendingMessage = false;

  List<ChatMessage> _messages = [
    // ChatMessage(
    //   uid: '123',
    //   text: 'Hola mundo sdfsfsfsddasdasdasdasds',
    // ),
    // ChatMessage(
    //   uid: '454643',
    //   text: 'Hola mundo',
    // ),
    // ChatMessage(
    //   uid: '123',
    //   text: 'Hola mundo',
    // ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 13,
              backgroundColor: Colors.blue[400],
              child: Text(
                'Te',
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text('Test 1',
                style: TextStyle(color: Colors.black87, fontSize: 12))
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) => _messages[index])),
            Divider(
              height: 1,
            ),
            Container(
              color: Colors.white,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      child: Row(
        children: [
          Flexible(
              child: TextField(
            focusNode: _focusNode,
            controller: textCtrl,
            decoration: InputDecoration.collapsed(hintText: 'Enviar mensaje'),
            onSubmitted: _handleSubmit,
            onChanged: (value) {
              setState(() {
                if (value.trim().length > 0) {
                  _sendingMessage = true;
                } else {
                  _sendingMessage = false;
                }
              });
              //TODO: Value ready to post
            },
          )),
          //Button to send
          Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(child: Text('Send'), onPressed: () {})
                  : Container(
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(
                            Icons.send,
                          ),
                          onPressed: _sendingMessage
                              ? () => _handleSubmit(textCtrl.text.trim())
                              : null,
                        ),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                    ))
        ],
      ),
      margin: EdgeInsets.symmetric(
        horizontal: 8,
      ),
    ));
  }

  _handleSubmit(String text) {
    if (text.length == 0) return;
    print(text);
    setState(() {
      _sendingMessage = false;
    });

    final newMessage = ChatMessage(
      uid: '123',
      text: text,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    textCtrl.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    // TODO: Off del Socket
    //Clean animation controller of Chat
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
