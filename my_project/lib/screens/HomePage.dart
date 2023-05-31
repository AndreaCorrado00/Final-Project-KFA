import 'ProfilePage.dart';
import 'TipsPage.dart';
import 'SensPage.dart';
import 'StatisticsPage.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  //const HomeScreen({super.key});
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenstate createState() => HomeScreenstate();
}

class HomeScreenstate extends State<HomeScreen> {
  int page = 0;

  final page1 = SensPage();
  get page2 => StatisticsPage();
  get page3 => TipsPage();
  get page4 => ProfilePage();

  @override
  void initState() {
    super.initState();
  }

  Widget pageChooser(int page) {
    switch (page) {
      case 0:
        return page1;
      case 1:
        return page2;
      case 2:
        return page3;
      case 3:
        return page4;
      default:
        return const Text("Invalid page");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.white,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.green.shade100,
        height: 60.0,
        items: const <Widget>[
          Icon(
            Icons.home,
            size: 30.0,
            color: Colors.green,
          ),
          Icon(
            Icons.bar_chart_outlined,
            size: 30.0,
            color: Colors.green,
          ),
          Icon(
            Icons.tips_and_updates_outlined,
            size: 30.0,
            color: Colors.green,
          ),
          Icon(
            Icons.person,
            size: 30.0,
            color: Colors.green,
          ),
        ],
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            page = index;
          });
        },
      ),
      body: pageChooser(page),
    );
  }
}

class Page1 extends StatelessWidget {
  const Page1({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text("Page1");
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text("Page2");
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});
  @override
  Widget build(BuildContext context) {
    return const Text("Page3");
  }
}
