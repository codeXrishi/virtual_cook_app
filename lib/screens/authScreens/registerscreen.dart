import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'package:virtual_cook/Utils/loading.dart';
import 'package:virtual_cook/Utils/utils.dart';
import 'package:virtual_cook/screens/authScreens/loginscreen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController registerEmailController = TextEditingController();
  TextEditingController registerPasswordController = TextEditingController();
  TextEditingController registerUserController = TextEditingController();
  TextEditingController registerPhone = TextEditingController();
  TextEditingController registerDob = TextEditingController();

  bool obsecuredText = false;
  bool loading = false;

  //firebase auth
  FirebaseAuth _auth = FirebaseAuth.instance;

  User? userr = FirebaseAuth.instance.currentUser;

  //Email validation
  bool isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@[a-zA-Z]+\.[a-zA-Z]{2,}$').hasMatch(email);
  }

  //Sign up Method
  Future signUp() async {
    var name = registerUserController.text.toString().trim();
    var userEmail = registerEmailController.text.toString().trim();
    var phone = registerPhone.text.toString().trim();
    var dob = registerDob.text.toString();

    // final User? user = _auth.currentUser;
    // String uid = userr!.uid;
    try {
      if (_formKey.currentState!.validate()) {
        setState(() {
          loading = true;
        });
        await _auth
            .createUserWithEmailAndPassword(
                email: registerEmailController.text,
                password: registerPasswordController.text)
            .then((value) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({
            'name': name,
            'userEmail': userEmail,
            'createdAt': DateTime.now(),
            'uid': userr?.uid,
            'phone': phone,
            'dob': dob,
          });
          Utils().showBottomSnackbar(
              context, 'Oh Hey!', 'User Registration Successfully!');
          setState(() {
            loading = false;
            registerEmailController.clear();
            registerPasswordController.clear();
            registerUserController.clear();
            registerPhone.clear();
            registerDob.clear();
          });
          Get.off(() => LoginScreen());
        }).onError((error, stackTrace) {
          Utils().toastMessage(error.toString());
          setState(() {
            loading = false;
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Email Already in Used')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Some Error occured')));
      }
      ;
    }
    return null;
  }

  @override
  void dispose() {
    registerEmailController.dispose();
    registerPasswordController.dispose();
    registerUserController.dispose();
    registerPhone.dispose();
    registerDob.dispose();
    super.dispose();
  }

  @override
  void initState() {
    obsecuredText = true;
    super.initState();
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
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset('assets/images/register.png'),
                    height: height * .25,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            controller: registerUserController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                              ),
                              labelText: 'Name',
                              hintText: 'Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            controller: registerEmailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                              ),
                              labelText: 'Email',
                              hintText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
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
                            controller: registerPasswordController,
                            keyboardType: TextInputType.text,
                            obscureText: obsecuredText,
                            obscuringCharacter: "*",
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.password,
                              ),
                              suffixIcon: IconButton(
                                padding: EdgeInsetsDirectional.only(end: 12),
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
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Password';
                              } else if (value.length < 6) {
                                return 'Atleast 8 character is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: registerPhone,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Iconsax.call),
                                prefixText: '+91| ',
                                labelText: 'Phone No',
                                hintText: 'Phone No',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.none,
                            controller: registerDob,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Iconsax.calendar),
                                labelText: 'Date Of Birth',
                                hintText: 'Tap to select DOB',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12))),
                            onTap: () async {
                              DateTime? dataPicked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1970),
                                lastDate: DateTime(2025),
                              );
                              if (dataPicked != null) {
                                setState(() {
                                  registerDob.text =
                                      dataPicked.toString().split(" ")[0];
                                });
                              }
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      signUp();
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: AppColor.kPrimaryColor,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        backgroundColor:
                                            AppColor.kSecondaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 16)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColor.kPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.off(() => LoginScreen());
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
  }
}
