import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quicke/admin/home_admin.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNamecontroller = TextEditingController();
  TextEditingController userPasswordcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFededeb),
      resizeToAvoidBottomInset: true, // Prevents keyboard overflow issues
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Heading
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  "Let's start with \n Admin!",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Login Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Material(
                  elevation: 3.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // Adapts to keyboard
                        children: [
                          const SizedBox(height: 20),

                          // Username Field
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter username';
                              }
                              return null;
                            },
                            controller: userNamecontroller,
                            decoration: InputDecoration(
                              hintText: 'Username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Password Field
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter password';
                              }
                              return null;
                            },
                            obscureText: true,
                            controller: userPasswordcontroller,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Login Button
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                LoginAdmin();
                              }
                            },
                            child: Material(
                              elevation: 5.0,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void LoginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot) {
      for (var result in snapshot.docs) {
        if (result.data()['id'] != userNamecontroller.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Your ID is not correct",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        } else if (result.data()['password'] !=
            userPasswordcontroller.text.trim()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Your password is not correct",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeAdmin()),
          );
        }
      }
    });
  }
}
