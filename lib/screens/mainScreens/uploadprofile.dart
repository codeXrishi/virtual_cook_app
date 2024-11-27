import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:virtual_cook/Utils/utils.dart';

class UploadProfile extends StatefulWidget {
  const UploadProfile({super.key});

  @override
  State<UploadProfile> createState() => _UploadProfileState();
}

class _UploadProfileState extends State<UploadProfile> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  uploadProfile() async {
    String uid = randomAlphaNumeric(10);
    if (selectedImage != null) {
      Reference ref =
          FirebaseStorage.instance.ref().child("userImage/").child(uid);
      final UploadTask task = ref.putFile(selectedImage!);

      var downloadUrl = await (await task).ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'image': downloadUrl,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile Uploaded Successfully')));
      });
    }
    setState(() {
      selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Profile'),
        centerTitle: true,
        backgroundColor: AppColor.KPinkColor,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            selectedImage == null
                ? GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
            SizedBox(
              height: 50.0,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  uploadProfile();
                },
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "Add",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
