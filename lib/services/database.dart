import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  Future<Stream<QuerySnapshot>> getFoodItem(String name) async {
    return await FirebaseFirestore.instance
        .collection('recipes')
        .limit(5)
        .where('type', isEqualTo: name)
        .snapshots();
  }

  Future addFoodToFav(Map<String, dynamic> userInfo, String id) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection('Fav')
        .add(userInfo);
  }

  Future<Stream<QuerySnapshot>> getAllRecipes() async {
    return await FirebaseFirestore.instance.collection('recipes').snapshots();
  }

  Future<Stream<QuerySnapshot>> getFavRecipes(String id) async {
    return await FirebaseFirestore.instance
        .collection('users-fav-recipes')
        .doc(id)
        .collection('items')
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> searchRecipes(String name) async {
    return await FirebaseFirestore.instance
        .collection('recipes')
        .where('primaryIngredient', isEqualTo: name)
        .snapshots();
  }

  Future addToFav(Map<String, dynamic> addInfo) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    var currentUser = _auth.currentUser;
    CollectionReference ref =
        FirebaseFirestore.instance.collection("users-fav-recipes");
    return ref.doc(currentUser!.email).collection("items").doc().set(addInfo);
  }
}
