import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/signup_screen.dart';

class LoginHelper {
  Widget loginLog() {
    return Image.asset(
      "assets/authenticaiton/logo.png",
      width: 150,
    );
  }

  Widget welcomeText() {
    return const Text(
      "Bienvenido Administrador!",
      style:  TextStyle(
        fontSize: 30,
        fontFamily: 'Brand-Bold',
        letterSpacing: 1,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget subtitleText() {
    return const Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16.0),
      child:  Text(
        "Inicie sesión en su cuenta existente de Global Oil",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontFamily: 'Brand-Regular',
          letterSpacing: 1,
          color: Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget orText() {
    return const Text(
      'OR',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget divider(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: 2.0,
        width: size.width / 2 - 30,
        color: Colors.black45,
      ),
    );
  }
  Widget donthaveaccount(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          '¿No tienes una cuenta?',
          style: TextStyle(
            fontSize: 18.0,
            color: Colors.blueGrey,
            fontWeight: FontWeight.w800,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (c) => SignUpScreen(),
              ),
            );
          },
          child: Text(
            ' Registrarse',
            style: TextStyle(
              color: Colors.red[300],
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
