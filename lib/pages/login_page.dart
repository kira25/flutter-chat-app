import 'package:flutter/material.dart';
import 'package:flutter_chat/helpers/show_alert.dart';
import 'package:flutter_chat/services/auth_service.dart';
import 'package:flutter_chat/services/socket_service.dart';
import 'package:flutter_chat/widgets/btn_azul.dart';
import 'package:flutter_chat/widgets/custom_input.dart';
import 'package:flutter_chat/widgets/labels.dart';
import 'package:flutter_chat/widgets/logo.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Logo(
                    title: 'Messenger',
                  ),
                  _Form(),
                  Labels(
                    route: 'register',
                    title: 'No tienes cuenta?',
                    subtitle: 'Crear una ahora!',
                  ),
                  Text('Terminos y condiciones de uso')
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    Function onPress = () async {
      print('email controllerr :${emailCtrl.text}');
      print('pass controllerr :${passCtrl.text}');

      FocusScope.of(context).unfocus();
      final loginOk =
          await authService.login(emailCtrl.text.trim(), passCtrl.text.trim());
      if (loginOk) {
        //TODO: Connect to socket server
        socketService.connect();
        Navigator.pushReplacementNamed(context, 'users');
        //Navigate to other page
      } else {
        showAlert(context, 'Login incorrect', 'Check your credentials');
        //Show Alert
      }
    };
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Email',
            textEditingController: emailCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            isPassword: true,
            icon: Icons.lock,
            placeholder: 'Password',
            textEditingController: passCtrl,
            keyboardType: TextInputType.text,
          ),
          BlueButton(
            onPress: authService.authenticate ? null : onPress,
            text: 'Enter',
          )
        ],
      ),
    );
  }
}
