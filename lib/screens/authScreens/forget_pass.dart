import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_cook/Utils/utils.dart';
import 'package:virtual_cook/screens/authScreens/success.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final TextEditingController emailController = TextEditingController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future resetPassword() async {
    await _firebaseAuth
        .sendPasswordResetEmail(email: emailController.text.trim())
        .then((value) {
      Get.to(() => SuccessScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: FadeInLeft(
            animate: true,
            duration: Duration(milliseconds: 800),
            delay: Duration(milliseconds: 900),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //image
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  width: MediaQuery.of(context).size.width,
                  child: SvgPicture.asset(
                    'assets/images/forget_pass.svg',
                    height: height * .4,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  children: [
                    Text(
                      'Forget Password',
                      style: GoogleFonts.josefinSans(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Enter your email address associated\n with your account.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Form(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              border: OutlineInputBorder()),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  resetPassword();
                                },
                                child: Text(
                                  'Send Link',
                                  style: TextStyle(color: AppColor.kWhite),
                                ),
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    backgroundColor: AppColor.kPrimaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 16)),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
