import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'screens/home.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/home',
      routes: {
        '/home': (context) => Home(),
      }
  ));
}
