import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:virtual_cook/Utils/utils.dart';
import 'package:virtual_cook/services/splash_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashService service = SplashService();

  @override
  void initState() {
    super.initState();
    service.splahService(context);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor.kBlue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/anim/splash.json', height: height * 0.40),
            Text(
              'Virtual Cook',
              style: GoogleFonts.calistoga(
                fontSize: 35,
                color: AppColor.kPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
