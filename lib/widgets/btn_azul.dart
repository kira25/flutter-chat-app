import 'package:flutter/material.dart';

class BlueButton extends StatelessWidget {
  final Function onPress;
  final String text;

  const BlueButton({Key key, this.onPress, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
        elevation: 2,
        highlightElevation: 5,
        color: Colors.blue,
        shape: StadiumBorder(),
        child: Container(
          height: 55,
          width: double.infinity,
          child: Center(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 17),
            ),
          ),
        ),
        onPressed: onPress);
  }
}
