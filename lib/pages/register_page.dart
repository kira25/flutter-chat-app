import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/btn_azul.dart';
import 'package:flutter_chat/widgets/custom_input.dart';
import 'package:flutter_chat/widgets/labels.dart';
import 'package:flutter_chat/widgets/logo.dart';

class RegisterPage extends StatelessWidget {
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
                    title: 'Register',
                  ),
                  _Form(),
                  Labels(
                    route: 'login',title: 'Ya tienes una cuenta?',subtitle: 'Ingresa ahora',
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
  final usernameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Function onPress = () {
      print('email controllerr :${emailCtrl.text}');
      print('pass controllerr :${passCtrl.text}');
    };
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeholder: 'Nombre',
            textEditingController: usernameCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          CustomInput(
            isPassword: true,
            icon: Icons.lock,
            placeholder: 'Email',
            textEditingController: emailCtrl,
            keyboardType: TextInputType.text,
          ),
          CustomInput(
            icon: Icons.perm_identity,
            placeholder: 'Password',
            textEditingController: passCtrl,
            keyboardType: TextInputType.emailAddress,
          ),
          BlueButton(
            onPress: onPress,
            text: 'Enter',
          )
        ],
      ),
    );
  }
}
