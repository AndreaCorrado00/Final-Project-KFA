// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_project/screens/HomePage.dart';
import 'package:my_project/screens/TipsPage.dart';
import 'package:my_project/utils/constants.dart';

class StatisticsPage extends StatefulWidget {
 const StatisticsPage ({super.key});

  @override
  StatisticsPageState createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
 //-------------- Index used trought the code to build widgets
  int _selectedIndex = 2;


static const routename = 'StatisticsPage';
  @override
  Widget build(BuildContext context) {
    print('${StatisticsPageState.routename} built');
    return MaterialApp(
      title: 'Statistics ',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.primaryColor,
          title: Text('Statistics'),),
          //automaticallyImplyLeading: true,
          
        bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tips_and_updates),
            label: 'Advice and Tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Statistics',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Constants.primaryColor,
        selectedItemColor: Constants.secondarylightColor,
        selectedFontSize: 14.0,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomeScreen()));
            break;
            case 1:
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const TipsPage()));

    

              break;
            case 2:
                if (index != 2) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const StatisticsPage()));
              } else {
                print('still in the Statistics page ');
              }
              
              // Probably in this case you have to put an if: if the index is not pointing the home and you are in the case of the home, return to home
              break;
          }

          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
      ),


        ),
    );
  }
}
