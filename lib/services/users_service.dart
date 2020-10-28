import 'package:flutter_chat/global/environment.dart';
import 'package:flutter_chat/models/users.dart';
import 'auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chat/models/users_response.dart';

class UserService {
  Future<List<User>> getUsers() async {
    try {
      final res = await http.get('${Environment.apiUrl}/users', headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final userResponse = userResponseFromJson(res.body);
      return userResponse.users;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
