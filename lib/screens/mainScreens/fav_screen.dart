import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_cook/Utils/utils.dart';
import 'package:virtual_cook/screens/mainScreens/details.dart';
import 'package:virtual_cook/services/database.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  Stream? FavRecipeStream;

  String? id = FirebaseAuth.instance.currentUser!.email;

  ontheload() async {
    FavRecipeStream = await DatabaseMethods().getFavRecipes(id!);
    setState(() {});
  }

  Future deleteFav(String id) async {
    await FirebaseFirestore.instance
        .collection('users-fav-recipes')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .collection('items')
        .doc(id)
        .delete()
        .then((value) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Successfully Remove!")));
    });
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColor.kSecondaryColor,
        centerTitle: true,
        title: Text(
          'Favourites Recipes',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.kWhite,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(child: favscreen()),
          ],
        ),
      ),
    );
  }

  Widget favscreen() {
    return StreamBuilder(
        stream: FavRecipeStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  var docId = snapshot.data.docs[index].id;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => DetailsPage(
                              type: ds['type'],
                              name: ds['name'],
                              time: ds['time'],
                              ingredients: ds['allIngredient'],
                              procedure: ds['procedure'],
                              image: ds['Image'],
                              link: ds['YouTubeLink'],
                            ));
                      },
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1,
                            height: 150,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    spreadRadius: 2,
                                    color: Colors.black12,
                                  )
                                ]),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(80),
                                    child: Image.network(
                                      ds['Image'],
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ds['type'],
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        ds['name'],
                                        style: TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Iconsax.clock,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 7,
                                          ),
                                          Text(
                                            ds['time'] + " min",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            right: 5,
                            bottom: 5,
                            child: IconButton(
                              icon: Icon(
                                Iconsax.close_circle,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                deleteFav(docId);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
