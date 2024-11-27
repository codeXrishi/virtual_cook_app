import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtual_cook/Utils/listtiles.dart';
import 'package:virtual_cook/Utils/utils.dart';
import 'package:virtual_cook/screens/authScreens/loginscreen.dart';
import 'package:virtual_cook/screens/mainScreens/profile_screen.dart';
import 'package:virtual_cook/screens/mainScreens/webview.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({super.key});

  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
    });
  }

  //Firebase auth user
  final user = FirebaseAuth.instance.currentUser!;

  dynamic launchEmail() async {
    try {
      Uri email = Uri(
        scheme: 'mailto',
        path: "rushi.dolkar@gmail.com",
        queryParameters: {'subject': "Feedback"},
      );

      await launchUrl(email);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        backgroundColor: AppColor.KPinkColor,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            profile(),
            ListContainer(
              title: 'Edit Profile',
              icon: Icon(Iconsax.edit),
              onTap: () {
                Get.to(() => ProfileScreen());
              },
            ),
            ListContainer(
              title: 'Privacy Policy',
              icon: Icon(Iconsax.lock),
              onTap: () {
                Get.to(() => WebViewPage());
              },
            ),
            ListContainer(
              title: 'Send Feedback',
              icon: Icon(Iconsax.messages),
              onTap: () async {
                launchEmail();
              },
            ),
            ListContainer(
              title: 'Logout',
              icon: Icon(Iconsax.lock),
              onTap: () {
                signOut();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget profile() {
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
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: data['image'] != null
                          ? CircleAvatar(
                              radius: 70.0,
                              backgroundImage: NetworkImage(data['image']),
                            )
                          : CircleAvatar(
                              radius: 70.0,
                              backgroundImage:
                                  AssetImage('assets/images/user.png'),
                            ),
                    ),
                    Text(
                      "Hey! " + data['name'],
                      style: GoogleFonts.lora(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      data['userEmail'],
                      style: GoogleFonts.quicksand(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ));
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
