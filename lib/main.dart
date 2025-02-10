import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:quicke/admin/add_food.dart';
import 'package:quicke/admin/admin_login.dart';

import 'package:quicke/pages/bottomnav.dart';
import 'package:quicke/pages/forgotpassword.dart';
import 'package:quicke/pages/home.dart';
import 'package:quicke/pages/login.dart';
import 'package:quicke/pages/order.dart';

import 'package:quicke/pages/signup.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:quicke/widgets/app_contant.dart';

void main() async {
  WidgetsFlutterBinding();
  Stripe.publishableKey = Publishablekey;
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quicke',
      home: Signup(),
      routes: {
        '/home': (context) => Home(),
        '/login': (context) => Login(),
        '/signup': (context) => Signup(),
        '/forgotpassword': (context) => Forgotpassword(),
        '/bottomnav': (context) => Bottomnav(),
        '/addfood': (context) => AddFood(),
        '/order': (context) => Order(),
        '/admin_login': (context) => AdminLogin(),
      },
    );
  }
}
