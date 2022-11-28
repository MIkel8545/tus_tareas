import 'package:flutter/material.dart';

class AlertService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String message) {
    final snackBar = new SnackBar(
        backgroundColor: Colors.black,
        content: Text(
          message,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ));

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
