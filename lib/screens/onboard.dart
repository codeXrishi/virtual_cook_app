import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:virtual_cook/Utils/utils.dart';
import 'package:virtual_cook/models/onboarding_item.dart';
import 'package:virtual_cook/screens/getstated.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final controller = OnboardingItems();
  final pageController = PageController();

  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    Widget getStartButton() {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: AppColor.kPrimaryColor,
        ),
        width: MediaQuery.of(context).size.width * .9,
        height: 55,
        child: TextButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('onBoarding', true);

            if (!mounted) return;
            Navigator.push(context,
                (MaterialPageRoute(builder: (context) => GetStared())));
          },
          child: Text(
            'Get Started',
            style: TextStyle(color: AppColor.kWhite),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColor.kWhite,
      bottomSheet: Container(
        color: AppColor.kWhite,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: isLastPage
            ? getStartButton()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      pageController.jumpToPage(controller.items.length - 1);
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(color: AppColor.kPrimaryColor),
                    ),
                  ),

                  //Smooth Page Indicator
                  SmoothPageIndicator(
                    controller: pageController,
                    count: controller.items.length,
                    effect: ExpandingDotsEffect(
                      activeDotColor: AppColor.kPrimaryColor,
                      dotHeight: 5.0,
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      pageController.nextPage(
                          duration: Duration(milliseconds: 600),
                          curve: Curves.easeIn);
                    },
                    child: Text(
                      'Next',
                      style: TextStyle(color: AppColor.kPrimaryColor),
                    ),
                  ),
                ],
              ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 25),
        child: Expanded(
          child: PageView.builder(
            onPageChanged: (value) => setState(
                () => isLastPage = controller.items.length - 1 == value),
            itemCount: controller.items.length,
            controller: pageController,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Image.asset(
                    controller.items[index].image,
                    height: height * 0.50,
                  ),
                  Text(
                    controller.items[index].title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    controller.items[index].description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
