import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat/global/environment.dart';
import 'package:flutter_chat/models/login_response.dart';
import 'package:flutter_chat/models/users.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService with ChangeNotifier {
  User user;
  bool _authenticatate = false;
  bool get authenticate => _authenticatate;
  final _storage = new FlutterSecureStorage();
  set authenticate(bool value) {
    _authenticatate = value;
    notifyListeners();
  }

  //Getters and setters del token
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

//LOGIN
  Future login(String email, String password) async {
    final data = {"email": email, "password": password};
    this.authenticate = true;

    final res = await http.post('${Environment.apiUrl}/login',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    print(res.body);
    this.authenticate = false;
    if (res.statusCode == 200) {
      final loginResponse = loginResponseFromJson(res.body);
      user = loginResponse.user;
      print('Logged');
      await this._saveToken(loginResponse.token);
      //Save token
      print('save token');
      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String email, String name, String password) async {
    final data = {"email": email, "name": name, "password": password};
    this.authenticate = true;
    final res = await http.post('${Environment.apiUrl}/login/new',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    print(res.body);
    this.authenticate = false;
    if (res.statusCode == 200) {
      final loginResponse = loginResponseFromJson(res.body);
      user = loginResponse.user;

      await this._saveToken(loginResponse.token);
      //Save token

      return true;
    } else {
      return false;
    }
  }

  Future<bool> isLoggedin() async {
    final token = await this._storage.read(key: 'token');

    final res = await http.get('${Environment.apiUrl}/login/renew',
        headers: {'Content-Type': 'application/json', 'x-token': token});
    print(res.body);

    if (res.statusCode == 200) {
      final loginResponse = loginResponseFromJson(res.body);
      user = loginResponse.user;

      await this._saveToken(loginResponse.token);
      //Save token

      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
