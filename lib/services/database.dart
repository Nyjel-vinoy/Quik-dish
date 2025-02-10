import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  // Add user details
  Future<void> addUserDetail(
      Map<String, dynamic> userInfoMap, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .set(userInfoMap);
    } catch (e) {
      print("Error adding user details: $e");
    }
  }

  // Update user wallet
  Future<void> updateUserWallet(String id, String amount) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(id)
          .update({"wallet": amount});
    } catch (e) {
      print("Error updating wallet: $e");
    }
  }

  Future<void> addFoodItem(
      Map<String, dynamic> userInfoMap, String name) async {
    try {
      await FirebaseFirestore.instance.collection(name).add(userInfoMap);
    } catch (e) {
      print("Error adding user details: $e");
    }
  }

  Future<Stream<QuerySnapshot>> getFoodItem(String name) async {
    return await FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future<void> addFoodtoCart(
      Map<String, dynamic> userInfoMap, String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(id)
          .collection("cart")
          .add(userInfoMap);
    } catch (e) {
      print("Error adding user details: $e");
    }
  }

  Future<Stream<QuerySnapshot>> getFoodCart(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .collection("cart")
        .snapshots();
  }
}
