import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_cook/Utils/utils.dart';
import 'package:virtual_cook/screens/mainScreens/videoplayer.dart';
import 'package:virtual_cook/services/database.dart';

class DetailsPage extends StatefulWidget {
  final String type, name, time, ingredients, procedure, image, link;

  DetailsPage(
      {super.key,
      required this.type,
      required this.name,
      required this.time,
      required this.ingredients,
      required this.procedure,
      required this.image,
      required this.link});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  // Future addToFav() async {
  //   final FirebaseAuth _auth = FirebaseAuth.instance;
  //   var currentUser = _auth.currentUser;
  //   CollectionReference ref =
  //       FirebaseFirestore.instance.collection("users-fav-recipes");
  //   return ref.doc(currentUser!.email).collection("items").doc().set({
  //     "name": widget.name,
  //     "type": widget.type,
  //     "time": widget.time,
  //     "Image": widget.image,
  //     "allIngredient": widget.ingredients,
  //     "procedure": widget.procedure,
  //     "YouTubeLink": widget.link,
  //   }).then((value) => Utils().toastMessage("Added to Fav"));
  // }

  ontheload() async {
    await DatabaseMethods().addToFav({
      "name": widget.name,
      "type": widget.type,
      "time": widget.time,
      "Image": widget.image,
      "allIngredient": widget.ingredients,
      "procedure": widget.procedure,
      "YouTubeLink": widget.link,
    }).then((value) => Utils().toastMessage("Added to Fav"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users-fav-recipes")
                  .doc(FirebaseAuth.instance.currentUser!.email)
                  .collection("items")
                  .where("name", isEqualTo: widget.name)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final doc = snapshot.data.docs;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: IconButton(
                    onPressed: () =>
                        doc.length == 0 ? ontheload() : print("Already added"),
                    icon: doc.length == 0
                        ? Icon(
                            Iconsax.heart,
                            size: 30,
                          )
                        : Icon(
                            Iconsax.heart5,
                            color: Colors.red,
                            size: 30,
                          ),
                  ),
                );
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.network(
                        widget.image,
                        width: 350,
                        height: 350,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Divider(),
                  Text(
                    widget.type,
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    widget.name,
                    style: GoogleFonts.poppins(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'Cooking Time',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Icon(Iconsax.clock),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        widget.time + ' min',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                    color: AppColor.kPrimaryColor,
                  ),
                  Text(
                    "Ingredient",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.ingredients),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 2,
                    color: AppColor.kPrimaryColor,
                  ),
                  Text(
                    "Procedure",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(widget.procedure),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          width: MediaQuery.of(context).size.width / 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to(() => VideoPlayerScreen(
                                      link: widget.link,
                                    ));
                              },
                              child: Text(
                                "View Tutorial",
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 3.0,
                                backgroundColor: AppColor.kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
