import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/models/messages_response.dart';
import 'package:flutter_chat/services/auth_service.dart';
import 'package:flutter_chat/services/chat_service.dart';
import 'package:flutter_chat/services/socket_service.dart';
import 'package:flutter_chat/widgets/chat_message.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final textCtrl = new TextEditingController();
  final _focusNode = FocusNode();
  bool _sendingMessage = false;
  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  List<ChatMessage> _messages = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _listenMessage);

    _loadHistory(chatService.userTo.uid);
  }

  void _loadHistory(String userId) async {
    List<Message> chat = await chatService.getChat(userId);
    final history = chat.map((e) => new ChatMessage(
          text: e.mensaje,
          uid: e.de,
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 0))
            ..forward(),
        ));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic data) {
    print('Data recieved : ${data['payload']}');
    ChatMessage message = new ChatMessage(
        text: data['mensaje'],
        uid: data['de'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

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
                chatService.userTo.name.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(chatService.userTo.name,
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

    final newMessage = ChatMessage(
      uid: authService.user.uid,
      text: text,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();
    setState(() {
      _sendingMessage = false;
    });
    socketService.socket.emit('mensaje-personal', {
      'de': authService.user.uid,
      'para': chatService.userTo.uid,
      'mensaje': text
    });
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
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
