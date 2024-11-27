import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_cook/Utils/utils.dart';
import 'package:virtual_cook/screens/authScreens/loginscreen.dart';
import 'package:virtual_cook/screens/mainScreens/details.dart';
import 'package:virtual_cook/screens/mainScreens/seeall.dart';
import 'package:virtual_cook/services/database.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Stream? footitemStream;

  ontheload() async {
    footitemStream = await DatabaseMethods().getFoodItem("Veg");
    setState(() {});
  }

  @override
  void initState() {
    ontheload();
    super.initState();
  }

  //carousal slider
  List imageList = [
    {"id": 1, "image_path": 'assets/slider/vegfood.jpg'},
    {"id": 2, "image_path": 'assets/slider/nonvegfood.jpg'},
    {"id": 3, "image_path": 'assets/slider/streetfood.jpg'},
    {"id": 4, "image_path": 'assets/slider/fast-food.jpg'},
  ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  //categories click
  bool veg = false, nonveg = false, street = false, fastfood = false;

  final user = FirebaseAuth.instance.currentUser!;

  // String? userEmail = FirebaseAuth.instance.currentUser?.email;

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            topRow(),
            SizedBox(
              height: 20,
            ),
            banner(),
            SizedBox(
              height: 20.0,
            ),
            homeView(),
          ],
        ),
      ),
    );
  }

  Widget allItems() {
    return StreamBuilder(
        stream: footitemStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return GestureDetector(
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
                      child: SizedBox(
                        height: 250,
                        child: Stack(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 30,
                              ),
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                height: 250,
                                width: 190,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        spreadRadius: 2,
                                        color: Colors.black12,
                                      ),
                                    ]),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        ds['type'],
                                        style: TextStyle(
                                          fontSize: 15,
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
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Iconsax.clock,
                                                    size: 20,
                                                  ),
                                                  SizedBox(
                                                    width: 7,
                                                  ),
                                                  Text(
                                                    ds['time'] + "min",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Icon(Iconsax.heart),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 35,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(80),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 4,
                                        spreadRadius: 2,
                                        color: Colors.black12,
                                      ),
                                    ]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(80),
                                  child: Image.network(
                                    ds['Image'],
                                    height: 140,
                                    width: 140,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  })
              : Center(child: CircularProgressIndicator());
        });
  }

  Widget topRow() {
    // final User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          return SafeArea(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: data['image'] != null
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(data['image']),
                            )
                          : CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/user.png'),
                            ),
                    ),
                    IconButton(
                        onPressed: () {
                          signOut();
                        },
                        icon: Icon(Iconsax.logout))
                  ],
                ),
                //user Name and text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Hello, ',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColor.kPrimaryColor,
                            ),
                          ),
                          Text(
                            data['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColor.kSecondaryColor,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Search Best Recipes',
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColor.kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget banner() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CarouselSlider(
                  items: imageList
                      .map(
                        (item) => Image.asset(
                          item['image_path'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                      .toList(),
                  carouselController: carouselController,
                  options: CarouselOptions(
                    scrollPhysics: BouncingScrollPhysics(),
                    autoPlay: true,
                    aspectRatio: 2,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: imageList.asMap().entries.map((entry) {
                    print(entry);
                    print(entry.key);
                    return GestureDetector(
                      onTap: () => carouselController.animateToPage(entry.key),
                      child: Container(
                        width: currentIndex == entry.key ? 17 : 7,
                        height: 7.0,
                        margin: EdgeInsets.symmetric(horizontal: 3.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: currentIndex == entry.key
                                ? Colors.white
                                : Colors.teal),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget homeView() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    veg = true;
                    nonveg = false;
                    street = false;
                    fastfood = false;
                    footitemStream = await DatabaseMethods().getFoodItem("Veg");
                  },
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: veg ? AppColor.kPrimaryColor : AppColor.kWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/veg.png',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            "Veg",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    veg = false;
                    nonveg = true;
                    street = false;
                    fastfood = false;
                    footitemStream =
                        await DatabaseMethods().getFoodItem("NonVeg");
                  },
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            nonveg ? AppColor.kPrimaryColor : AppColor.kWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/nonveg.png',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            "Non Veg",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    veg = false;
                    nonveg = false;
                    street = true;
                    fastfood = false;
                    footitemStream =
                        await DatabaseMethods().getFoodItem("FastFood");
                  },
                  child: Material(
                    elevation: 5.0,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            street ? AppColor.kPrimaryColor : AppColor.kWhite,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/fastfood.png',
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            "Fast Food",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // InkWell(
                //   onTap: () async {
                //     veg = false;
                //     nonveg = false;
                //     street = false;
                //     fastfood = true;
                //     footitemStream =
                //         await DatabaseMethods().getFoodItem("SeaFood");
                //   },
                //   child: Material(
                //     elevation: 5.0,
                //     borderRadius: BorderRadius.circular(12),
                //     child: Container(
                //       padding: EdgeInsets.all(8),
                //       decoration: BoxDecoration(
                //         color:
                //             fastfood ? AppColor.kPrimaryColor : AppColor.kWhite,
                //         borderRadius: BorderRadius.circular(12),
                //       ),
                //       child: Column(
                //         children: [
                //           Image.asset(
                //             'assets/images/seafood.png',
                //             height: 40,
                //             width: 40,
                //             fit: BoxFit.cover,
                //           ),
                //           Text(
                //             "SeaFood",
                //             style: TextStyle(
                //                 fontWeight: FontWeight.bold, fontSize: 11),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top 5 Recipes",
                  style: GoogleFonts.poppins(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => SeeAllRecipes());
                  },
                  child: Text(
                    "See all",
                    style: GoogleFonts.poppins(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: AppColor.kPrimaryColor),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(height: 250, child: allItems()),
        ],
      ),
    );
  }
}
