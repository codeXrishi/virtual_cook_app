import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_cook/Utils/utils.dart';
import 'package:virtual_cook/screens/bottom_navbar.dart';
import 'package:virtual_cook/screens/mainScreens/details.dart';

import 'package:virtual_cook/services/database.dart';

class SeeAllRecipes extends StatefulWidget {
  const SeeAllRecipes({super.key});

  @override
  State<SeeAllRecipes> createState() => _SeeAllRecipesState();
}

class _SeeAllRecipesState extends State<SeeAllRecipes> {
  Stream? recipesItemStream;
  Stream? footitemStream;

  ontheload() async {
    recipesItemStream = await DatabaseMethods().getAllRecipes();
    setState(() {});
  }

  String type = '';

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.kWhite,
      appBar: AppBar(
        title: Text(
          "All Recipes",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColor.kBlue,
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => BottomNavigation());
          },
          icon: Icon(Iconsax.arrow_circle_left),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      type = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Filter By Category Type..',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Container(child: allrecipes()),
            ],
          ),
        ),
      ),
    );
  }

  Widget allrecipes() {
    return StreamBuilder(
        stream: recipesItemStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    if (type.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => DetailsPage(
                                      type: ds['type'],
                                      name: ds['name'],
                                      time: ds['time'],
                                      ingredients: ds['allIngredient'],
                                      procedure: ds['procedure'],
                                      image: ds['Image'],
                                      link: ds['YoutubeLink'],
                                    ));
                              },
                              child: Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      width:
                                          MediaQuery.of(context).size.width / 1,
                                      height: 150,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              spreadRadius: 2,
                                              color: Colors.black12,
                                            )
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(80),
                                              child: Image.network(
                                                ds['Image'],
                                                width: 130,
                                                height: 130,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow: TextOverflow
                                                          .ellipsis),
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
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                    // Positioned(
                                    //   right: 10,
                                    //   bottom: 10,
                                    //   child: (
                                    //     child: IconButton(
                                    //       onPressed: () {},
                                    //       icon: Icon(Iconsax.heart),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (ds['type']
                        .toString()
                        .toLowerCase()
                        .startsWith(type.toLowerCase())) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.to(() => DetailsPage(
                                      type: ds['type'],
                                      name: ds['name'],
                                      time: ds['time'],
                                      ingredients: ds['allIngredient'],
                                      procedure: ds['procedure'],
                                      image: ds['Image'],
                                      link: ds['YoutubeLink'],
                                    ));
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 1,
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(80),
                                            child: Image.network(
                                              ds['Image'],
                                              width: 140,
                                              height: 140,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                    right: 10,
                                    bottom: 10,
                                    child: Icon(Iconsax.heart),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  })
              : Center(
                  child: CircularProgressIndicator(),
                );
        });
  }
}
