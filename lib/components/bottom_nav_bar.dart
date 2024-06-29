import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

//implementation of the bottom navigation bar

class MyBottomNavBar extends StatelessWidget {
  void Function(int)? onTabChange;
  MyBottomNavBar({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      child: GNav(
  
        haptic: true,
        
         // haptic feedback
  tabBorderRadius: 30,
  tabBorder: Border.all(color: Colors.black, width: 1),
  curve: Curves.easeOutExpo, // tab animation curves // tab animation duration
  gap: 8, // the tab button gap between icon and text 
  color: Colors.black, // unselected icon color
  activeColor: Colors.black, // selected icon and text color
  iconSize: 33, 
  mainAxisAlignment: MainAxisAlignment.center,
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  onTabChange: (value) => onTabChange!(value),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: 'Home',
            ),
            GButton(
            icon: Icons.favorite,
            text: 'Favorite',
            ),
        ]
        ),
    );
  }
}