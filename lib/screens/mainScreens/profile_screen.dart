import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_cook/Utils/utils.dart';
import 'package:virtual_cook/screens/mainScreens/uploadprofile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  //Firebase auth user
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: AppColor.KPinkColor,
      ),
      body: SingleChildScrollView(
        child: profileScreen(),
      ),
    );
  }

  Future updateProfile() async {
    var name = nameController.text.toString().trim();
    var email = emailController.text.toString().trim();
    var phone = phoneController.text.toString().trim();
    var dob = dobController.text.toString().trim();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid)
        .update({
      'name': name,
      'userEmail': email,
      'dob': dob,
      'phone': phone,
    }).then((value) {
      Utils().showBottomSnackbar(context, 'Oh Hey', 'Profile Update');
    });
  }

  Future selectImage() async {}

  // Future uploadImage(image) async {
  //   try {
  //     Reference src = FirebaseStorage.instance
  //         .ref()
  //         .child('userImages/')
  //         .child(nameController.text + '.png');
  //     src.putFile(image).whenComplete(() {
  //       Fluttertoast.showToast(msg: 'Image uploaded to Firebase');
  //     });
  //     imageUrl = await src.getDownloadURL();
  //     setState(() {});
  //   } catch (e) {
  //     Utils().toastMessage(e.toString());
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  Widget profileScreen() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          return SafeArea(
            child: Container(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: Stack(
                        children: [
                          data['image'] != null
                              ? CircleAvatar(
                                  radius: 70.0,
                                  backgroundImage: NetworkImage(data['image']),
                                )
                              : CircleAvatar(
                                  backgroundImage:
                                      AssetImage('assets/images/user.png'),
                                  radius: 70.0,
                                ),
                          Positioned(
                            child: CircleAvatar(
                              child: IconButton(
                                onPressed: () {
                                  Get.to(() => UploadProfile());
                                },
                                icon: Icon(
                                  Iconsax.edit,
                                  size: 20,
                                  color: AppColor.kPrimaryColor,
                                ),
                              ),
                            ),
                            bottom: -8,
                            left: 85,
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hey!',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          data['name'],
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColor.kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Divider(
                      thickness: 2,
                      color: AppColor.KPinkColor,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Form(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController
                                ..text = "${data['name'].toString()}",
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Iconsax.user),
                                  labelText: 'Name',
                                  hintText: 'Name',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50))),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              enabled: false,
                              controller: emailController
                                ..text = "${data['userEmail'].toString()}",
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  labelText: 'Email',
                                  hintText: 'Email',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50))),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              controller: phoneController
                                ..text = "${data['phone'].toString()}",
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Iconsax.call),
                                  prefixText: '+91| ',
                                  labelText: 'Phone No',
                                  hintText: 'Phone No',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50))),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              enabled: false,
                              keyboardType: TextInputType.none,
                              controller: dobController
                                ..text = "${data['dob']}",
                              decoration: InputDecoration(
                                  prefixIcon: Icon(Iconsax.calendar),
                                  labelText: 'Date Of Birth',
                                  hintText: 'Tap to select DOB',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50))),
                              onTap: () async {
                                DateTime? dataPicked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1970),
                                  lastDate: DateTime(2025),
                                );
                                if (dataPicked != null) {
                                  setState(() {
                                    dobController.text =
                                        dataPicked.toString().split(" ")[0];
                                  });
                                }
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        updateProfile();
                                      },
                                      child: Text(
                                        'Edit Profile',
                                        style: TextStyle(
                                            color: AppColor.kPrimaryColor),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          textStyle: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          backgroundColor:
                                              AppColor.kSecondaryColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
