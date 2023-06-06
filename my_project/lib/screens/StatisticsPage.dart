// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_project/screens/AboutThisApp.dart';

import 'package:my_project/screens/Barplot/bar_graph.dart';
import 'package:my_project/screens/LoginPage.dart';
import 'package:my_project/screens/databaseCodesAndFunctions.dart';
import 'package:my_project/utils/constants.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';


class StatisticsPage extends StatefulWidget {
 const StatisticsPage ({super.key});

  @override
  StatisticsPageState createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {
 //-------------- Index used trought the code to build widgets
  int _selectedIndex = 2;

  List<double> dailySteps = [5600, 4000, 10000, 7000, 3000, 1000, 12000];


static const routename = 'StatisticsPage';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Statistics',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.primaryColor,

          title: Text('Statistics'),
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
                  const Icon(
                    IconData(0xe3b3, fontFamily: 'MaterialIcons'),
                    color: Constants.secondarylightColor,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ],
              ),
              const SizedBox(
                width: 200,
                height: 10,
              ),
            ],
          ),
        ),

       
      backgroundColor: Color.fromARGB(189, 212, 214, 211),
      body: ListView(
          children: [
            Padding(padding: const EdgeInsets.all(20),
            child: Animate(
              effects: Constants.Fade_effect_options,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 280,
                color: Constants.containerColor,
                child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                const Text('Steps', style: TextStyle(
                  color: Color.fromARGB(255, 1, 76, 4), fontSize: 24, fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 15),
                SizedBox(
                  height: 200,
                  //child: Animate(
                    //effects:
                   // [FadeEffect(duration: 2000.ms), SlideEffect()],
                    child: BarGraph(
                    dailySteps: dailySteps,
                    ),
                  ),
                 ],
                ),
              ),
            ),)),
            Padding(padding: const EdgeInsets.all(20),
            child: Animate(
              effects: Constants.Fade_effect_options,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 280,
                color: Constants.containerColor,
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                const Text('Distance', style: TextStyle(
                  color: Color.fromARGB(255, 1, 76, 4), fontSize: 24, fontWeight: FontWeight.bold,
                  ),
                  ),
                SizedBox(height: 15),
                SizedBox(
                  height: 200,
                  //child: Animate(
                    //effects:
                   // [FadeEffect(duration: 2000.ms), SlideEffect()],
                    child: BarGraph(
                    dailySteps: dailySteps,
                    ),
                  ),
                 ],
                ),
              ),
            ),)),
            Padding(padding: const EdgeInsets.all(20),
            child: Animate(
              effects: Constants.Fade_effect_options,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 280,
                color: Constants.containerColor,
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                const Text('Activity time', style: TextStyle(
                  color: Color.fromARGB(255, 1, 76, 4), fontSize: 24, fontWeight: FontWeight.bold,
                  ),
                  ),
                SizedBox(height: 15),
                SizedBox(
                  height: 200,
                  //child: Animate(
                    //effects:
                   // [FadeEffect(duration: 2000.ms), SlideEffect()],
                    child: BarGraph(
                    dailySteps: dailySteps,
                    ),
                  ),
                 ],
                ),
              ),
            ),)),
            Padding(padding: const EdgeInsets.all(20),
            child: Animate(
              effects: Constants.Fade_effect_options,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 280,
                color: Constants.containerColor,
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                const Text('Level of Sustainability', style: TextStyle(
                  color: Color.fromARGB(255, 1, 76, 4), fontSize: 24, fontWeight: FontWeight.bold,
                  ),
                  ),
                SizedBox(height: 15),
                SizedBox(
                  height: 200,
                  //child: Animate(
                    //effects:
                   // [FadeEffect(duration: 2000.ms), SlideEffect()],
                    child: BarGraph(
                    dailySteps: dailySteps,
                    ),
                  ),
                 ],
                ),
              ),
            ),)),
          ],

        ),

    floatingActionButton:
     FloatingActionButton(
      onPressed: (){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const databaseTestPage()));},
      child: Icon(Icons.data_array)
      
      ),
     ),

    );
  }

}


void _OnLogoutTapConfirm(BuildContext context)  {
    // set up the buttons

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: ()  {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const StatisticsPage()));},// Must be changed to point at the current page 
      style: Constants.TextButtonStyle_Alert,
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        final user_preferences = await SharedPreferences.getInstance();
         await user_preferences.setBool('Rememeber_login', false);
        Navigator.push(context, MaterialPageRoute(builder: (context) =>  LoginPage()));
         
      },
      style: Constants.TextButtonStyle_Alert,
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to logout?"),
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

