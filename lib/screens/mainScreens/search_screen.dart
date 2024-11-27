import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chip_tags/flutter_chip_tags.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:virtual_cook/Utils/utils.dart';
import 'package:virtual_cook/screens/mainScreens/details.dart';
import 'package:virtual_cook/services/database.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> _values = [];

  Stream? searchRecipeStream;

  // void _deleteChip(String id) {
  //   setState(() {
  //     _chiplist.removeWhere((element) => element.id == id);
  //   });
  // }

  // addchip() {
  //   setState(() {
  //     _chiplist.add(
  //       ChipModel(
  //           id: DateTime.now().toString(), name: _chipTextController.text),
  //     );
  //     _chipTextController.text = '';
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: GoogleFonts.roboto(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColor.kSecondaryColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: AppColor.KPinkColor,
          child: Icon(
            Iconsax.search_normal,
            color: AppColor.kPrimaryColor,
          ),
          onPressed: () {
            ontheload();
          }),
      body: Container(
        child: SingleChildScrollView(
            child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 20.0),
                child: Text(
                  'Search Recipes\nwith existing ingreadients',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChipTags(
                      list: _values,
                      createTagOnSubmit: true,
                      iconColor: Colors.white,
                      chipColor: Colors.black,
                      decoration: InputDecoration(
                          hintText: 'Enter Ingredients....',
                          border: OutlineInputBorder()),
                    )
                  ],
                ),
              ),
              Container(
                  child: showRecipes(searchRecipeStream: searchRecipeStream))
            ],
          ),
        )),
      ),
    );
  }

  ontheload() async {
    searchRecipeStream =
        await DatabaseMethods().searchRecipes(_values.join(","));
    setState(() {});
  }
}

class showRecipes extends StatelessWidget {
  const showRecipes({
    super.key,
    required this.searchRecipeStream,
  });

  final Stream? searchRecipeStream;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: searchRecipeStream,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => DetailsPage(
                              type: ds['type'],
                              name: ds['name'],
                              time: ds['time'],
                              ingredients: ds['allIngredient'],
                              procedure: ds['procedure'],
                              image: ds['Image'],
                              link: ds['YoutubeLink']));
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1,
                              height: 300,
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
                              child: Column(
                                // crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: MediaQuery.of(context).size.height *
                                        .23,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20)),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20),
                                      ),
                                      child: Image.network(
                                        ds['Image'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    ds['type'],
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    ds['name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Iconsax.clock,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 7,
                                      ),
                                      Text(ds['time'] + "min"),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            // Positioned(
                            //   right: 10,
                            //   top: 10,
                            //   child: Icon(
                            //     Iconsax.heart,
                            //     color: Colors.white,
                            //     size: 30,
                            //   ),
                            // )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else if (!snapshot.hasData) {
            return Center(
              child: Lottie.asset('assets/anim/empty.json'),
            );
          } else {
            return Center(
              child: Lottie.asset('assets/anim/empty.json'),
            );
          }
        });
  }
}
