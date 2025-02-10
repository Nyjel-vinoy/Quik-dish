import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quicke/services/database.dart';
import 'package:quicke/services/shared_pref.dart';

import 'package:quicke/widgets/app_support.dart';
import 'package:random_string/random_string.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String email = "", password = "", name = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  registration() async {
    if (password != null) {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              "registration succesfully",
              style: TextStyle(fontSize: 16.0),
            ))));
        String id = randomAlphaNumeric(10);
        Map<String, dynamic> addUserinfo = {
          "Name": nameController.text,
          "Email": emailcontroller.text,
          "wallet": '0',
          "Id": id
        };
        await DatabaseMethods().addUserDetail(addUserinfo, id);
        await SharedPreferenceHelper().saveUserName(nameController.text);
        await SharedPreferenceHelper().saveUserEmail(emailcontroller.text);
        await SharedPreferenceHelper().saveUserWallet('0');
        await SharedPreferenceHelper().saveUserId(id);

        Navigator.pushReplacementNamed(context, '/bottomnav');
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar((SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Weak password",
                style: TextStyle(fontSize: 16.0),
              ))));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar((SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Account already exist",
                style: TextStyle(fontSize: 16.0),
              ))));
        } else {
          ScaffoldMessenger.of(context).showSnackBar((SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Check again provide info",
                style: TextStyle(fontSize: 16.0),
              ))));
        }
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
                        height: MediaQuery.of(context).size.height / 1.6,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20)),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 40),
                              Text(
                                'Signup',
                                style: appwidget.headLinefeild(),
                              ),
                              SizedBox(height: 40),
                              TextFormField(
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "please Enter  Name";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: "Name",
                                  hintStyle: appwidget.semiBoldfeild(),
                                  prefixIcon: Icon(Icons.person_outlined),
                                ),
                              ),
                              SizedBox(height: 40),
                              TextFormField(
                                controller: emailcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "please Enter  Email";
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
                                controller: passwordcontroller,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "please Enter  password";
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
                              SizedBox(height: 70),
                              GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      email = emailcontroller.text;
                                      name = nameController.text;
                                      password = passwordcontroller.text;
                                    });
                                    registration();
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
                                        "Signup",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ),
                              )
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
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        "Already have account? Login",
                        style: appwidget.semiBoldfeild(),
                      ),
                    )
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
