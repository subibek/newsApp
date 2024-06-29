import 'package:flutter/material.dart';

import '../components/bottom_nav_bar.dart';
import 'favorite_page.dart';
import 'home_page.dart';

//Toggle page implements the bottom navigation bar to switch between the pages

class TogglePage extends StatefulWidget {
  const TogglePage({super.key});

  @override
  State<TogglePage> createState() => _TogglePageState();
}

class _TogglePageState extends State<TogglePage> {

  int _selectedPage = 0;

  navigateBottomToolBar(index) {
    setState(() {
      _selectedPage = index;
    });
  }

//List of pages to switch between 

  final List<Widget> pages = [
    const HomePage(),
    const FavoritePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: MyBottomNavBar(
        onTabChange: (index) => navigateBottomToolBar(index)),
        body: pages[_selectedPage],
    );
  }
}