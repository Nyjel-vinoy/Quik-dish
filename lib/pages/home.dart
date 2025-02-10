import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:quicke/pages/detail.dart';
import 'package:quicke/services/database.dart';
import 'package:quicke/services/shared_pref.dart';

import 'package:quicke/widgets/app_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool icecream = false, pizza = false, salad = false, burger = false;
  Stream? fooditemVerticallyStream;
  Stream? fooditemStream;
  String? username;

  Future<void> loadUserName() async {
    SharedPreferenceHelper sharedPref = SharedPreferenceHelper();
    String? savedUsername = await sharedPref.getUserName();
    if (savedUsername != null && savedUsername.isNotEmpty) {
      setState(() {
        username = savedUsername;
      });
    }
  }

  ontheload() async {
    fooditemStream = await DatabaseMethods().getFoodItem("Icecream");
    fooditemVerticallyStream = await DatabaseMethods().getFoodItem("Salad");
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    loadUserName();

    super.initState();
  }

  Widget allItemVertically() {
    return Expanded(
      child: StreamBuilder(
        stream: fooditemVerticallyStream,
        builder: (context, AsyncSnapshot Snapshot) {
          return Snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: Snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = Snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Detail(
                                    image: ds["Image"],
                                    name: ds["Name"],
                                    price: ds["price"],
                                    detail: ds["Detail"],
                                  )),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(4),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    ds["Image"],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ds["Name"],
                                        style: appwidget.semiBoldfeild(),
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        "Honey Got Cheese",
                                        style: appwidget.lighttTextfeild(),
                                      ),
                                      Text(
                                        "\$${ds["price"]}",
                                        style: appwidget.semiBoldfeild(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget allItems() {
    return StreamBuilder(
        stream: fooditemStream,
        builder: (context, AsyncSnapshot Snapshot) {
          return Snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: Snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = Snapshot.data.docs[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Detail(
                                    image: ds["Image"],
                                    name: ds["Name"],
                                    price: ds["price"],
                                    detail: ds["Detail"],
                                  )),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.all(4),
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    ds["Image"],
                                    height: 150.0,
                                    width: 150.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  ds["Name"],
                                  style: appwidget.semiBoldfeild(),
                                ),
                                Text(
                                  "Fresh and Healthly",
                                  style: appwidget.lighttTextfeild(),
                                ),
                                Text(
                                  "\$" + ds["price"],
                                  style: appwidget.semiBoldfeild(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  })
              : CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.only(right: 20, left: 20, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Hello, $username",
                    style: appwidget.boldTextfeild(),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/order');
                    },
                    child: Container(
                      child: Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(color: Colors.black),
                      padding: EdgeInsets.all(3),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Delecious Food",
                style: appwidget.headLinefeild(),
              ),
              Text(
                "Discover & get great food",
                style: appwidget.lighttTextfeild(),
              ),
              SizedBox(height: 20.0),
              showItem(),
              SizedBox(
                height: 20.0,
              ),
              Container(height: 270, child: allItems()),
              SizedBox(
                height: 20.0,
              ),
              allItemVertically(),
            ],
          ),
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            icecream = true;
            pizza = false;
            salad = false;
            burger = false;
            fooditemStream = await DatabaseMethods().getFoodItem("Icecream");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            child: Container(
              decoration: BoxDecoration(
                color: icecream ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/ice-cream.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: icecream ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            icecream = false;
            pizza = true;
            salad = false;
            burger = false;
            fooditemStream = await DatabaseMethods().getFoodItem("Pizza");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: pizza ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/pizza.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: pizza ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            icecream = false;
            pizza = false;
            salad = false;
            burger = true;
            fooditemStream = await DatabaseMethods().getFoodItem("Burger");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: burger ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/burger.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: burger ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            icecream = false;
            pizza = false;
            salad = true;
            burger = false;
            fooditemStream = await DatabaseMethods().getFoodItem("Salad");
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: salad ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "images/salad.png",
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                color: salad ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
