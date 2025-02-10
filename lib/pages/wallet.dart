import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:quicke/services/database.dart';
import 'package:quicke/services/shared_pref.dart';
import 'package:quicke/widgets/app_contant.dart';
import 'package:quicke/widgets/app_support.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  String wallet = "0"; // Default to "0" to avoid null issues
  String? id;
  int? add;
  TextEditingController amountcontroller = TextEditingController();

  Map<String, dynamic>? paymentIntent;

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  /// Fetch user wallet and ID from shared preferences
  Future<void> getSharedPreferences() async {
    try {
      wallet = await SharedPreferenceHelper().getUserWallet() ?? "0";
      id = await SharedPreferenceHelper().getUserId();
      setState(() {});
    } catch (e) {
      print("Error fetching shared preferences: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: wallet.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : buildWalletUI(),
    );
  }

  Widget buildWalletUI() {
    return Container(
      margin: const EdgeInsets.only(top: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 2.0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Center(
                child: Text(
                  "Wallet",
                  style: appwidget.headLinefeild(),
                ),
              ),
            ),
          ),
          const SizedBox(height: 30.0),
          buildWalletInfo(),
          const SizedBox(height: 20.0),
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              "Add money",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 10.0),
          buildAddMoneyOptions(),
          const SizedBox(height: 50.0),
          GestureDetector(
            onTap: () => openEdit(),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: const Color(0xFF008080),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "Add Money",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildWalletInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(color: Color(0xFFF2F2F2)),
      child: Row(
        children: [
          Image.asset(
            "images/wallet.png",
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 40.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Wallet",
                style: appwidget.headLinefeild(),
              ),
              const SizedBox(height: 5.0),
              Text(
                "\$$wallet",
                style: appwidget.headLinefeild(),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildAddMoneyOptions() {
    final amounts = ["100", "500", "1000", "2000"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: amounts.map((amount) {
        return GestureDetector(
          onTap: () => makePayment(amount),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE9E2E2)),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              "\$$amount",
              style: appwidget.semiBoldfeild(),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> makePayment(String amount) async {
    print('called');
    try {
      paymentIntent = await createPaymentIntent(amount, 'INR');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            style: ThemeMode.dark,
            merchantDisplayName: 'Your App',
          ))
          .then((value) {});
      await displayPaymentSheet(amount);
    } catch (e) {
      print("Payment Error: $e");
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          content: Text("Payment failed. Please try again."),
        ),
      );
    }
  }

  Future<void> displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      add = int.parse(wallet) + int.parse(amount);
      await SharedPreferenceHelper().saveUserWallet(add.toString());
      await DatabaseMethods().updateUserWallet(id!, add.toString());
      await getSharedPreferences();
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text("Payment Successful"),
            ],
          ),
        ),
      );
      paymentIntent = null;
    } catch (e) {
      print("Display Payment Sheet Error: $e");
    }
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card'
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      print("Create Payment Intent Error: $err");
      rethrow;
    }
  }

  String calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

  Future openEdit() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.cancel)),
                        SizedBox(
                          width: 60.0,
                        ),
                        Center(
                          child: Text(
                            "Add Money",
                            style: TextStyle(
                              color: Color(0xFF008080),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text("Amount"),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black38, width: 2.0),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextField(
                        controller: amountcontroller,
                        decoration: InputDecoration(
                            border: InputBorder.none, hintText: 'Enter Amount'),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);

                          makePayment(amountcontroller.text);
                          print(amountcontroller.text);
                        },
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Color(0xFF008080),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                            "Pay",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ));
}
