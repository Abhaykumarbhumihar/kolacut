import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled/screen/circular_slider.dart';
import 'package:untitled/screen/coin.dart';
import 'package:untitled/screen/homepage.dart';
import 'package:untitled/screen/orderdetail.dart';
import 'package:untitled/screen/register.dart';
import 'package:untitled/screen/saloondetail.dart';
import 'package:untitled/screen/userprofile.dart';
import 'package:untitled/screen/wishlish.dart';
import 'package:untitled/screen/yourbooking.dart';
import 'package:untitled/utils/Utils.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'profile.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var index = 0;
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

   List<Widget> _buildScreens() {
    return [
     const HomePage(),
     const TableBasicsExample(),
    const  CoinPage(),
     const Wishlist(),
    const  ProfilePage()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          index == 0 ? Icons.home : Icons.home_outlined,
          size: 30,
        ),
        activeColorPrimary: Color(Utils.hexStringToHexInt('77ACA2')),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(
          AssetImage(index == 1
              ? "images/svgicons/fillcal.png"
              : "images/svgicons/emptycal.png"),
          size: 30,
        ),
        activeColorPrimary: Color(Utils.hexStringToHexInt('77ACA2')),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        iconSize: 30,
        icon: const Icon(
          CupertinoIcons.creditcard_fill,
          color: Colors.white,
        ),
        activeColorPrimary: Color(Utils.hexStringToHexInt('77ACA2')),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const ImageIcon(
          AssetImage("images/svgicons/emptyheart.png"),
          size: 30,
        ),
        activeColorPrimary: Color(Utils.hexStringToHexInt('77ACA2')),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(
          CupertinoIcons.profile_circled,
          size: 30,
        ),
        activeColorPrimary: Color(Utils.hexStringToHexInt('77ACA2')),
        inactiveColorPrimary: CupertinoColors.systemGrey,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    //box.write('session', "TXKe48DXicKoAjkyEOgXWqU3VuVZqdHm");
    return PersistentTabView(
      context,
      controller: _controller,

      screens: _buildScreens(),
      items: _navBarsItems(),
      confineInSafeArea: true,
      backgroundColor: Colors.white,
      // Default is Colors.white.
      handleAndroidBackButtonPress: true,
      // Default is true.
      resizeToAvoidBottomInset: true,
      // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
      stateManagement: true,
      // Default is true.
      hideNavigationBarWhenKeyboardShows: true,
      // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popAllScreensOnTapOfSelectedTab: true,
      popActionScreens: PopActionScreensType.all,
      itemAnimationProperties: ItemAnimationProperties(
        // Navigation Bar's items animation properties.
        duration: Duration(milliseconds: 200),
        curve: Curves.ease,
      ),
      screenTransitionAnimation: ScreenTransitionAnimation(
        // Screen transition animation on change of selected tab.
        animateTabTransition: true,
        curve: Curves.ease,
        duration: Duration(milliseconds: 200),
      ),
      navBarStyle: NavBarStyle.style15,

      // Choose the nav bar style with this property.
      onItemSelected: (value) {
        setState(() {
          index = value;
        });

        debugPrint(value.toString() + "SDF SDF SDF SDF SDF $value");
      },
    );
  }
}
