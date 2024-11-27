import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:virtual_cook/Utils/loading.dart';
import 'package:virtual_cook/screens/authScreens/forget_pass.dart';
import 'package:virtual_cook/screens/authScreens/registerscreen.dart';
import 'package:virtual_cook/screens/bottom_navbar.dart';

import '../../Utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPassworController = TextEditingController();
  bool obsecuredText = false;

  //firebase init
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading = false;

  bool isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  Future signIn() async {
    var loginEmail = loginEmailController.text.trim();
    var loginPassword = loginPassworController.text.trim();

    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      try {
        User? firebaseUser = (await _auth.signInWithEmailAndPassword(
                email: loginEmail, password: loginPassword))
            .user;
        if (firebaseUser != null) {
          Get.off(() => BottomNavigation());
          Utils().showBottomSnackbar(context, 'Oh Hey!', 'Login Successfull!');
          setState(() {
            loading = false;
          });
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          errorToast('User not found');
        } else {
          errorToast("Some Error Occured");
        }
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    loginEmailController.dispose();
    loginPassworController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    obsecuredText = true;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
            ),
            backgroundColor: AppColor.kWhite,
            body: SingleChildScrollView(
              child: FadeInLeft(
                animate: true,
                duration: Duration(milliseconds: 800),
                delay: Duration(milliseconds: 1000),
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/loginImg.svg',
                          height: height * .2,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Welcome Back,',
                          style: GoogleFonts.poppins(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Ingredient-Based Recipe Search',
                          style: GoogleFonts.poly(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),

                        //section 2 login form
                        Form(
                          key: _formKey,
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: loginEmailController,
                                  decoration: InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.person_outline_outlined),
                                      labelText: 'Email',
                                      hintText: 'E-mail',
                                      border: OutlineInputBorder()),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter email address';
                                    } else if (!isEmailValid(value)) {
                                      return 'Enter valid email!';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  controller: loginPassworController,
                                  keyboardType: TextInputType.text,
                                  obscureText: obsecuredText,
                                  obscuringCharacter: "*",
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.password),
                                      suffixIcon: IconButton(
                                        padding:
                                            EdgeInsetsDirectional.only(end: 12),
                                        onPressed: () {
                                          setState(() {
                                            obsecuredText = !obsecuredText;
                                          });
                                        },
                                        icon: Icon(obsecuredText
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      ),
                                      labelText: 'Password',
                                      hintText: 'Password',
                                      border: OutlineInputBorder()),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter Password';
                                    } else if (value.length < 6) {
                                      return 'Please enter 8 character password';
                                    }
                                    return null;
                                  },
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgetScreen()));
                                    },
                                    child: Text('Forget Password?')),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(
                                        'assets/icons/google.png',
                                        height: 50,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: Image.asset(
                                        'assets/icons/facebook.png',
                                        height: 50,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    signIn();
                                  },
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                        color: AppColor.kPrimaryColor),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    backgroundColor: AppColor.kSecondaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColor.kPrimaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegisterScreen()));
                              },
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
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
