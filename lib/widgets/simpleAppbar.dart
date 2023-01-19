import 'package:flutter/material.dart';

AppBar simpleAppBar(bool isMainTitle, String title) {
  return AppBar(

    title: Text(
      isMainTitle ? "AutoParts" : title,
      style: TextStyle(
        fontSize: 20,
        letterSpacing: 1.5,
        fontWeight: FontWeight.bold,
        fontFamily: "Brand-Regular",
      ),
    ),
    centerTitle: true,
  );
}
