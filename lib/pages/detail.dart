import 'package:flutter/material.dart';
import 'package:quicke/services/database.dart';
import 'package:quicke/services/shared_pref.dart';
import 'package:quicke/widgets/app_support.dart';

class Detail extends StatefulWidget {
  String name, price, detail, image;
  Detail({
    required this.image,
    required this.detail,
    required this.name,
    required this.price,
  });

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int a = 1, total = 0;
  String? id;
  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    total = int.parse(widget.price);

    ontheload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(
          left: 20.0,
          right: 20,
          top: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.black,
              ),
            ),
            Image.network(
              widget.image,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      widget.name,
                    )
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (a > 1) {
                      --a;
                      total = total - int.parse(widget.price);
                    }

                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                Text(
                  a.toString(),
                  style: appwidget.semiBoldfeild(),
                ),
                SizedBox(width: 20.0),
                GestureDetector(
                  onTap: () {
                    ++a;
                    total = total + int.parse(widget.price);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Text(
              widget.detail,
              maxLines: 3,
              style: appwidget.lighttTextfeild(),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                Text("Delivery Time", style: appwidget.lighttTextfeild()),
                SizedBox(width: 5.0),
                Icon(Icons.alarm, color: Colors.black),
                SizedBox(width: 5.0),
                Text("30 min", style: appwidget.semiBoldfeild())
              ],
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total price", style: appwidget.semiBoldfeild()),
                      Text(
                        "\$" + total.toString(),
                        style: appwidget.headLinefeild(),
                      )
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> addFoodtoCart = {
                        "Name": widget.name,
                        "Quantity": a.toString(),
                        "Total": total.toString(),
                        "Image": widget.image,
                      };
                      await DatabaseMethods().addFoodtoCart(addFoodtoCart, id!);
                      ScaffoldMessenger.of(context).showSnackBar((SnackBar(
                          backgroundColor: Colors.orange,
                          content: Text(
                            "Food Added To Cart",
                            style: TextStyle(fontSize: 16.0),
                          ))));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Add to cart",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              )),
                          SizedBox(width: 30),
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(8)),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
