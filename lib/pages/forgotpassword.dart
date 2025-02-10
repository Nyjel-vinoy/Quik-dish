import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  TextEditingController Emailcontroller = TextEditingController();
  String email = "";
  final _formKey = GlobalKey<FormState>();
  reset() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar((SnackBar(
          backgroundColor: Colors.black,
          content: Text(
            "Password link has been sent to your email !",
            style: TextStyle(fontSize: 16.0),
          ))));
      Future.delayed(Duration(seconds: 5));
      Navigator.pushReplacementNamed(context, '/login');
    } on FirebaseException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "No user found for that email",
              style: TextStyle(fontSize: 18.0),
            ))));
      } else {
        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              "Check again the Email",
              style: TextStyle(fontSize: 18.0),
            ))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 60.0),
            Container(
              alignment: Alignment.topCenter,
              child: Text(
                "Password Recovery",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 40.0),
            Text(
              "Enter your Email",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
                child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(width: 2.0, color: Colors.white),
                        color: Colors.black,
                      ),
                      child: TextFormField(
                        controller: Emailcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please enter email";
                          }
                          return null;
                        },
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle:
                              TextStyle(fontSize: 18.0, color: Colors.white),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 30,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = Emailcontroller.text;
                          });
                          reset();
                        }
                      },
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              "Send Email",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have account?",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/signup');
                          },
                          child: Text(
                            " create",
                            style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
