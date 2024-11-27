import 'package:get/get.dart';
import 'package:virtual_cook/screens/mainScreens/fav_screen.dart';
import 'package:virtual_cook/screens/mainScreens/home_screen.dart';
import 'package:virtual_cook/screens/mainScreens/profile_setting.dart';
import 'package:virtual_cook/screens/mainScreens/search_screen.dart';

class BottomNavigationBarController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  RxInt index = 0.obs;

  final screens = [
    DashboardScreen(),
    FavScreen(),
    SearchScreen(),
    ProfileSetting(),
  ];
}
