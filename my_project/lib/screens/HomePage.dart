// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_project/screens/AboutThisApp.dart';
import 'package:my_project/screens/LoginPage.dart';
import 'package:my_project/screens/ProfilePage.dart';
import 'package:my_project/screens/StatisticsPage.dart';
import 'package:my_project/screens/TipsPage.dart';
import 'package:intl/intl.dart';
import 'package:my_project/Database/Advice_Database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:animated_digit/animated_digit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:my_project/utils/constants.dart';
// ------------- Everything must be readed before creating the homepage

// Using DateTime to read the date and handling the daily advice
DateTime _now = DateTime.now();
String formattedDate = DateFormat.d().format(_now);
int today = int.parse(formattedDate);
int today_index = today % 17;
final Uri _url = Uri.parse(Advices[today_index]['url']);

// Computing of the level of susteinabilty
// My idea: probably the level could be computed by using a shered preferences dictionaty. Ence, everytime you upload a new activity (even if not automatically)
// an istance of the shared preferences "database" (because is not a real one) is updated. The function could read all the elements and use them to evaluate
// the value of LoS. Then the current value is udated and can be passed to the widget below

double _levelOfSusteinability() {
  return 324;
}

//-------------- UI of the page
class HomePageState extends StatefulWidget {
  const HomePageState({super.key});

  @override
  State<HomePageState> createState() => HomePage();
}

class HomePage extends State<HomePageState> {
  // Constants of building
  static const routename = 'Homepage';

  //-------------- Index used trought the code to build widgets
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Daily advice handler

    print('${HomePage.routename} built');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        title: Text(HomePage.routename),
      ),
      drawer: Drawer(
        backgroundColor: Constants.secondaryColor,
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Row(
              children: [
                TextButton(
                  style: Constants.TextButtonStyle_Drawer,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  child: const Text('Profile'),
                ),
                Icon(
                  IconData(0xe491, fontFamily: 'MaterialIcons'),
                  color: Constants.secondarylightColor,
                  size: 24.0,
                ),
              ],
            ),
            SizedBox(
              width: 300,
              height: 1,
            ),
            Row(
              children: [
                TextButton(
                  style: Constants.TextButtonStyle_Drawer,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AboutThisAppState()));
                  },
                  child: const Text('About this App'),
                ),
                Icon(
                  Icons.help_outline,
                  color: Constants.secondarylightColor,
                  size: 24.0,
                ),
              ],
            ),
            SizedBox(
              width: 300,
              height: 1,
            ),
            Row(
              children: [
                TextButton(
                  style: Constants.TextButtonStyle_Drawer,
                  onPressed: () {
                    _OnLogoutTapConfirm(context);
                  },
                  child: const Text('Logout'),
                ),
                Icon(
                  IconData(0xe3b3, fontFamily: 'MaterialIcons'),
                  color: Constants.secondarylightColor,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
              ],
            ),
            SizedBox(
              width: 300,
              height: 1,
            ),
          ],
        ),
      ),
      backgroundColor: Constants.primaryLightColor,

      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                height: 280,
                width: 330,
                color: Constants.thirdColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Curiosity of the day',
                      style: TextStyle(
                          color: Constants.secondaryColor,
                          fontSize: 20,
                          fontFamily: Constants.myfontFamily,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment(-0.9, 1),
                      child: Text(
                        'Do you know?',
                        style: TextStyle(
                            color: Constants.secondaryColor,
                            fontFamily: Constants.myfontFamily,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 125,
                        width: 270,
                        child: Text(
                          Advices[today_index]['adv_text'],
                          style: TextStyle(fontSize: 15),
                          textAlign: TextAlign.justify,
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment(-0.9, 5),
                      child: TextButton(
                        onPressed: () {
                          _launchUrl();
                        },
                        child: Text(
                          'Learn more',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 174, 255),
                              fontFamily: Constants.myfontFamily,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  height: 200,
                  width: 330,
                  color: Constants.thirdColor,
                  child: Column(

                      //alignment: Alignment.topCenter,
                      children: [
                        SizedBox(height: 10),
                        Text(
                          'Level of Sustainability',
                          style: Constants.TextButtonStyle_HomePage,
                        ),
                        SizedBox(
                          height: 160,
                          width: 180,
                          child: SfRadialGauge(
                              //enableLoadingAnimation = false,
                              //animationDuration: 2000,
                              //title: GaugeTitle(text: 'Level of Susteinability',textStyle: _TextButtonStyle_HomePage),
                              axes: <RadialAxis>[
                                RadialAxis(
                                    minimum: 0,
                                    maximum: 400,
                                    startAngle: 180,
                                    endAngle: 0,
                                    interval: 100,
                                    radiusFactor: 1.2,
                                    canScaleToFit: true,
                                    axisLineStyle: AxisLineStyle(thickness: 10),
                                    labelOffset: 12,
                                    showAxisLine: true,
                                    ranges: <GaugeRange>[
                                      GaugeRange(
                                          startValue: 0,
                                          endValue: 100,
                                          color: Colors.red),
                                      GaugeRange(
                                          startValue: 100,
                                          endValue: 200,
                                          color: Colors.orange),
                                      GaugeRange(
                                          startValue: 200,
                                          endValue: 300,
                                          color: Colors.yellow),
                                      GaugeRange(
                                          startValue: 300,
                                          endValue: 400,
                                          color: Colors.green)
                                    ],
                                    pointers: <GaugePointer>[
                                      MarkerPointer(
                                        value: _levelOfSusteinability(),
                                        markerType: MarkerType.diamond,
                                        markerHeight: 15,
                                        color: Colors.black,
                                        enableAnimation: true,
                                      )
                                    ],
                                    annotations: <GaugeAnnotation>[
                                      GaugeAnnotation(
                                          widget: Container(
                                              child: Text(
                                                  _levelOfSusteinability()
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          angle: 90,
                                          positionFactor: 0)
                                    ]),
                              ]),
                        )
                      ]

                      //AnimatedDigitWidget(value: 324,textStyle: _TextButtonStyle_HomePage,),
                      //Icon(
                      //IconData(0xe07e, fontFamily: 'MaterialIcons'),
                      //color: secondaryColor,
                      //size: 30.0,
                      //)
                      )),
            ),
            SizedBox(height: 30),
            Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                          height: 150,
                          width: 150,
                          color: Constants.thirdColor,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Trees',
                                  style: Constants.TextButtonStyle_HomePage,
                                ),
                                SizedBox(height: 20),
                                AnimatedDigitWidget(
                                  value: 1254,
                                  textStyle: Constants.TextButtonStyle_HomePage,
                                ),
                                Icon(
                                  IconData(0xf0603,
                                      fontFamily: 'MaterialIcons'),
                                  color: Constants.secondaryColor,
                                  size: 30.0,
                                )
                              ])),
                    ),
                    SizedBox(width: 30),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                          height: 150,
                          width: 150,
                          color: Constants.thirdColor,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Total steps',
                                  style: Constants.TextButtonStyle_HomePage,
                                ),
                                SizedBox(height: 20),
                                AnimatedDigitWidget(
                                  value: 125436,
                                  textStyle: Constants.TextButtonStyle_HomePage,
                                ),
                                Icon(
                                  IconData(0xf6bd, fontFamily: 'MaterialIcons'),
                                  color: Constants.secondaryColor,
                                  size: 30.0,
                                )
                              ])),
                    )
                  ],
                )),
          ],
        ),
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
              print(index);
              if (index != 0) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomePageState()));
              } else {
                print('still in the homepage ');
              }

            //break;
            case 1:
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const TipsPage()));

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

      //floatingActionButton: FloatingActionButton(
      //child: const Icon(Icons.add),
      //onPressed: () {},
      //backgroundColor: secondaryColor,
      //elevation: 0.0,
      //splashColor: primaryLightColor,
      //),
      //floatingActionButtonLocation:FloatingActionButtonLocation.endFloat,
    );
  } //build

//-------------- Functions used trought the code

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void _OnLogoutTapConfirm(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePageState()));
      },
      style: Constants.TextButtonStyle_Alert,
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        _Logout(context);
      },
      style: Constants.TextButtonStyle_Alert,
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to logout?"),
      actions: [
        cancelButton,
        continueButton,
      ],
      backgroundColor: Constants.primaryLightColor,
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _Logout(dynamic context) async {
    final user_preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    await user_preferences.remove('Rememeber_login');
    print('Into _Logout');
    print(await user_preferences.getBool('Rememeber_login'));
    Navigator.pop(context);

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }
} //HomePage
// test home page 