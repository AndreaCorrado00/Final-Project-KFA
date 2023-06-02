// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_project/screens/Barplot/bar_graph.dart';
import 'package:my_project/screens/HomePage.dart';
import 'package:my_project/utils/constants.dart';
import 'package:percent_indicator/percent_indicator.dart';


import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_project/Models/Steps.dart';
import 'package:my_project/Models/Distance.dart';
import 'package:my_project/Models/Activity.dart';

import 'package:my_project/utils/impact.dart';


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
       
      backgroundColor: Color.fromARGB(189, 212, 214, 211),
      body: ListView(
          children: [
            Padding(padding: const EdgeInsets.all(8.0),
            child: Animate(
              effects: [FadeEffect(duration:2000.ms),SlideEffect()],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Steps', style: TextStyle(
                  color: Color.fromARGB(255, 1, 76, 4), fontSize: 24, fontWeight: FontWeight.bold,
                  ),
                  ),
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
            ),
            Padding(padding: const EdgeInsets.all(8.0),
            child: Animate(
              effects: [FadeEffect(duration:2000.ms),SlideEffect()],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Distance', style: TextStyle(
                  color: Color.fromARGB(255, 1, 76, 4), fontSize: 24, fontWeight: FontWeight.bold,
                  ),
                  ),
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
            ),
            Padding(padding: const EdgeInsets.all(8.0),
            child: Animate(
              effects: [FadeEffect(duration:2000.ms),SlideEffect()],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Activity time', style: TextStyle(
                  color: Color.fromARGB(255, 1, 76, 4), fontSize: 24, fontWeight: FontWeight.bold,
                  ),
                  ),
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
            ),
            Padding(padding: const EdgeInsets.all(8.0),
            child: Animate(
              effects: [FadeEffect(duration:2000.ms),SlideEffect()],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('LoS', style: TextStyle(
                  color: Color.fromARGB(255, 1, 76, 4), fontSize: 24, fontWeight: FontWeight.bold,
                  ),
                  ),
                SizedBox(
                  height: 200,
                  //child: Animate(
                    //effects:
                   // [FadeEffect(duration: 2000.ms), SlideEffect()],
                    child: CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 12.0,
                  animation: true,
                  percent: 0.7,
                  center: new Text(
                    "6000",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                  footer: new Text(
                    "Steps",
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Color.fromARGB(255, 29, 131, 56),
                ),
                  ),
                 ],
                ),
              ),
            ),
          ],

        ),

    floatingActionButton:
     FloatingActionButton(
      onPressed: _toTestDB(context),
      
      ),
     ),

    );
  }
}

void Function()?  _toTestDB(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
  } //_toTestDB
