import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:virtual_cook/Utils/utils.dart';

// ignore: must_be_immutable
class ListContainer extends StatelessWidget {
  ListContainer({
    required this.onTap,
    required this.title,
    required this.icon,
    super.key,
  });

  VoidCallback onTap;
  String title;
  Icon icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: MediaQuery.of(context).size.width / 1,
          height: 80,
          decoration: BoxDecoration(
              color: AppColor.kWhite,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5.0,
                  spreadRadius: 3.0,
                  color: Colors.black12,
                )
              ]),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        icon,
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          title,
                          style: GoogleFonts.lora(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Iconsax.arrow_right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
