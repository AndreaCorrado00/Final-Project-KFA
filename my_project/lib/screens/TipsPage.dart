// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_project/screens/HomePage.dart';
import 'package:my_project/screens/StatisticsPage.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/utils/impact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/utils/constants.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  TipsPageState createState() => TipsPageState();
}

class TipsPageState extends State<TipsPage> {
  //-------------- Index used trought the code to build widgets
  int _selectedIndex = 1;
  static const routename = 'TipsPage';
  @override
  Widget build(BuildContext context) {
    print('${TipsPageState.routename} built');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        title: Text('Advice and Tips'),
        //automaticallyImplyLeading: true,
      ),
      backgroundColor: Constants.primaryLightColor,
      body: ListView(
        padding: EdgeInsets.all(30),
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 200,
                color: Constants.thirdColor,
                child:Row(children:const [
                  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Advice of the day',
                      style: TextStyle(
                          color: Constants.secondaryColor,
                          fontSize: 20,
                          fontFamily: Constants.myfontFamily,
                          fontWeight: FontWeight.bold),)],)],
                      
                )
                ),),
                
          SizedBox(height: 25),
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 200,
                color: Constants.thirdColor,
                child:Row(children:const [
                  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Recipe of the day',
                      style: TextStyle(
                          color: Constants.secondaryColor,
                          fontSize: 20,
                          fontFamily: Constants.myfontFamily,
                          fontWeight: FontWeight.bold),)],)],
                      
                )
                ),),

          SizedBox(height: 25),
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 200,
                color: Constants.thirdColor,
                child:Row(children:const [
                  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Curiosity of the day',
                      style: TextStyle(
                          color: Constants.secondaryColor,
                          fontSize: 20,
                          fontFamily: Constants.myfontFamily,
                          fontWeight: FontWeight.bold),)],)],
                      
                )
                ),),

          SizedBox(height: 25),
          ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 200,
                color: Constants.thirdColor,
                child:Row(children:const [
                  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Statistic of the day',
                      style: TextStyle(
                          color: Constants.secondaryColor,
                          fontSize: 20,
                          fontFamily: Constants.myfontFamily,
                          fontWeight: FontWeight.bold),)],)],
                      
                )
                ),)
        ],
      ),

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
                  builder: (context) => const HomePageState()));
            //break;
            case 1:
              if (index != 1) {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const TipsPage()));
              } else {
                print('still in the Statistics page ');
              }

            //break;
            case 2:
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const StatisticsPage()));

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
    );
  }
}
