import 'package:flutter/material.dart';
import 'package:flutter_chat/pages/users_page.dart';
import 'package:flutter_chat/services/auth_service.dart';
import 'package:flutter_chat/services/socket_service.dart';
import 'package:provider/provider.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: checkLoginState(context),
          builder: (context, snapshot) {
            return Center(
              child: Text('Espere'),
            );
          }),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final socketService = Provider.of<SocketService>(context, listen: false);

    final authService = Provider.of<AuthService>(context, listen: false);
    final authenticated = await authService.isLoggedin();
    if (authenticated) {
      socketService.connect();

      // Navigator.pushReplacement(
      //     context,
      //     PageRouteBuilder(
      //       pageBuilder: (_, __, ___) => UsersPage(),
      //       transitionDuration: Duration(milliseconds: 0),
      //     ));
      Navigator.pushReplacementNamed(context, 'users');
    } else {
      Navigator.pushReplacementNamed(context, 'login');
    }
  }
}
