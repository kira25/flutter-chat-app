import 'package:flutter/material.dart';
import 'package:flutter_chat/global/environment.dart';
import 'package:flutter_chat/models/messages_response.dart';
import 'package:flutter_chat/models/users.dart';
import 'package:flutter_chat/services/auth_service.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  User userTo;

  Future<List<Message>> getChat(String userId) async {
    final res = await http.get('${Environment.apiUrl}/messages/$userId',
        headers: {
          'Content-Type': 'application-json',
          'x-token': await AuthService.getToken()
        });

    final messageResponse = messageResponseFromJson(res.body);

    return messageResponse.messages;
  }
}
