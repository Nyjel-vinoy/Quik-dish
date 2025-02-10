import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:quicke/widgets/app_support.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String email = "", password = "";
  TextEditingController userEmailcontroller = TextEditingController();
  TextEditingController userPasswordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  userlogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushReplacementNamed(context, '/bottomnav');
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "No user found for this email",
              style: TextStyle(fontSize: 18.0),
            ))));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Wrong password",
              style: TextStyle(fontSize: 18.0),
            ))));
      } else {
        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Oops! Please check your info",
              style: TextStyle(fontSize: 18.0),
            ))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2.5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0XFFff5c30),
                        Color(0XFFe74b1a),
                      ]),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 3),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 2,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    )),
              ),
              Container(
                margin: EdgeInsets.only(top: 60, left: 20, right: 20),
                child: Column(
                  children: [
                    Image.asset(
                      "images/logo.png",
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 30),
                    Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 1.8,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 40),
                              Text(
                                'Login',
                                style: appwidget.headLinefeild(),
                              ),
                              SizedBox(height: 40),
                              TextFormField(
                                controller: userEmailcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "please enter email";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  hintStyle: appwidget.semiBoldfeild(),
                                  prefixIcon: Icon(Icons.email_outlined),
                                ),
                              ),
                              SizedBox(height: 40),
                              TextFormField(
                                controller: userPasswordcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "please enter password";
                                  }
                                  return null;
                                },
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  hintStyle: appwidget.semiBoldfeild(),
                                  prefixIcon: Icon(Icons.lock_outline),
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/forgotpassword',
                                    );
                                  },
                                  child: Text(
                                    "Forgot Password?",
                                    style: appwidget.semiBoldfeild(),
                                  ),
                                ),
                              ),
                              SizedBox(height: 50),
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      email = userEmailcontroller.text;
                                      password = userPasswordcontroller.text;
                                    });
                                    userlogin();
                                  }
                                },
                                child: Material(
                                  elevation: 5.0,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Color(0XFFff5c30),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/admin_login');
                                },
                                child: Text(
                                  "Admin Login?",
                                  style: appwidget.semiBoldfeild(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: Text(
                        "Don't have account? signup",
                        style: appwidget.semiBoldfeild(),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
