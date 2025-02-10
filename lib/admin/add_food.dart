import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quicke/services/database.dart';
import 'package:quicke/widgets/app_support.dart';
import 'package:random_string/random_string.dart';

class AddFood extends StatefulWidget {
  const AddFood({super.key});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final List<String> items = ['Icecream', 'Burger', 'Salad', 'Pizza'];
  String? value;
  TextEditingController namecontroller = TextEditingController();
  TextEditingController pricecontroller = TextEditingController();
  TextEditingController detailcontroller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  uploadItem() async {
    if (selectedImage != null &&
        namecontroller.text != "" &&
        pricecontroller.text != "" &&
        detailcontroller != "") {
      String addId = randomAlphaNumeric(10);

      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImage").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      var downloadUrl = await (await task).ref.getDownloadURL();
      Map<String, dynamic> addItem = {
        "Image": downloadUrl,
        "Name": namecontroller.text,
        "price": pricecontroller.text,
        "Detail": detailcontroller.text
      };
      await DatabaseMethods().addFoodItem(addItem, value!).then((value) {
        ScaffoldMessenger.of(context).showSnackBar((SnackBar(
            backgroundColor: Colors.orange,
            content: Text(
              "Food Item has been added  succesfully",
              style: TextStyle(fontSize: 16.0),
            ))));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0XFF373866),
          ),
        ),
        centerTitle: true,
        title: Text(
          "Add Item",
          style: appwidget.headLinefeild(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20, left: 20, right: 20.0, bottom: 30),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              "Upload the item picture",
              style: appwidget.semiBoldfeild(),
            ),
            SizedBox(height: 20),
            selectedImage == null
                ? GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(Icons.camera_alt_outlined,
                              color: Colors.black),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                  ),
            SizedBox(height: 20),
            Text("Item Name", style: appwidget.semiBoldfeild()),
            SizedBox(height: 30.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0XFFececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: namecontroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: " Enter Item name",
                  hintStyle: appwidget.lighttTextfeild(),
                ),
              ),
            ),
            //2

            SizedBox(height: 30),
            Text("Item Price", style: appwidget.semiBoldfeild()),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0XFFececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: pricecontroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: " Enter Item Price",
                  hintStyle: appwidget.lighttTextfeild(),
                ),
              ),
            ),

            //3
            SizedBox(height: 30),

            Text("Item Detail", style: appwidget.semiBoldfeild()),
            SizedBox(height: 10.0),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0XFFececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                maxLines: 6,
                controller: detailcontroller,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: " Enter Item detail",
                  hintStyle: appwidget.lighttTextfeild(),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Select Category", style: appwidget.semiBoldfeild()),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0XFFececf8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                items: items
                    .map((item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(fontSize: 18.0, color: Colors.black),
                        )))
                    .toList(),
                onChanged: ((value) => setState(() {
                      this.value = value;
                    })),
                dropdownColor: Colors.white,
                hint: Text("Select category"),
                iconSize: 36,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                value: value,
              )),
            ),
            SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                uploadItem();
              },
              child: Center(
                child: Material(
                  elevation: 5.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    width: 200,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Add",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
