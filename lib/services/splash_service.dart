import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_cook/screens/bottom_navbar.dart';
import 'package:virtual_cook/screens/getstated.dart';

class SplashService {
  void splahService(BuildContext context) {
    final _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    if (user != null) {
      Timer(
          Duration(seconds: 5),
          () => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => BottomNavigation())));
    } else {
      Timer(
          Duration(seconds: 5),
          () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => GetStared())));
    }
  }
}
