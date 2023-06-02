// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_project/screens/Barplot/bar_graph.dart';
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
    ),

    );
  }
}

Future<bool> _pingImpact() async{
    final url=Impact.baseUrl + Impact.pingEndpoint;
    // finally the call
    final response =await http.get(Uri.parse(url)); // is an async function
    return response.statusCode==200;
  }



   Future<int> _getAndStoreTokens() async {
    //Create the request
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': Impact.username, 'password': Impact.password};
    //Get the response
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);
    //If response is OK, decode it and store the tokens. Otherwise do nothing.
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    } //if
    //Just return the status code
    return response.statusCode;
  } //_getAndStoreTokens

  //This method allows to refrsh the stored JWT in SharedPreferences
  Future<int> _refreshTokens() async {
    //Create the request 
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};
    //Get the response
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);
    //If the response is OK, set the tokens in SharedPreferences to the new values
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    } //if
    //Just return the status code
    return response.statusCode;
  }
  


  Future _getStep(today)async{
    // Returns the sum of the steps made into a certain day 

    // preliminary settings
    final sp=await SharedPreferences.getInstance();
    var access=sp.getString('access');
    if (access == null){
      return null;
    }
    else{
      if(JwtDecoder.isExpired(access)){
        await _refreshTokens();
        access = sp.getString('access');
      }
      //request
      final url=Impact.baseUrl+Impact.stepEndpoint + '/patients/Jpefaq6m58'+'/day/$today/';
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'}; //fixed costruction!
      final response = await http.get(Uri.parse(url), headers: headers);

    // Creatione of the response
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      //List result = [];
      List steps_data=[];
      final total_steps=0;
      for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
        //result.add(Steps.fromJson(decodedResponse['data']['date'], decodedResponse['data']['data'][i]));
        steps_data.add(Steps.fromJson(decodedResponse['data']['date'], decodedResponse['data']['data'][i]).getValue());
      }//for
      int out=steps_data.reduce((a, b) => a + b);
      return out;
    } //if
    else{
      void result = null;
    }//else
    
    }
    

  }//getStep

  Future _getDistance(today)async{
    final sp=await SharedPreferences.getInstance();
    var access=sp.getString('access');
    if (access == null){
      return null;
    }
    else{
      if(JwtDecoder.isExpired(access)){
        await _refreshTokens();
        access = sp.getString('access');
      }
      
      final url=Impact.baseUrl+Impact.distanceEndpoint + '/patients/Jpefaq6m58'+'/day/$today/';
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'}; //fixed costruction
      final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      List distance_data=[];
      for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
        distance_data.add(Distance.fromJson(decodedResponse['data']['date'], decodedResponse['data']['data'][i]).getValue());
      }//for
      int out=distance_data.reduce((a, b) => a + b);
      return out; // unit of measure???
    } //if
    else{
      void result = null;
    }//else
    } 
  }//getDistance

  Future _getActivity_time(today)async{
    final sp=await SharedPreferences.getInstance();
    var access=sp.getString('access');
    if (access == null){
      return null;
    }
    else{
      if(JwtDecoder.isExpired(access)){
        await _refreshTokens();
        access = sp.getString('access');
      }
      final url=Impact.baseUrl+Impact.activityEndpoint + '/patients/Jpefaq6m58'+'/day/$today/';
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'}; //fixed costruction!
      final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      List activity_time_data=[];
      for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
        activity_time_data.add(Activity.fromJson(decodedResponse['data']['date'], decodedResponse['data']['data'][i]).getValue());
      }//for
      double out=activity_time_data.reduce((a, b) => a + b);
      return out.toInt(); // unit of measure???
    } //if
    else{
      void result = null;
    }//else
    
    }
    

  }//getDistance





  Future _changePassword(String oldpsw, String newpsw )async{
    final sp=await SharedPreferences.getInstance();
    var access=sp.getString('access');
    if (access == null){
      return null;
    }
    else{
      if(JwtDecoder.isExpired(access)){
        await _refreshTokens();
        access = sp.getString('access');
      }
      final url=Impact.baseUrl+'/gate/v1/change_password/';
      final body ={"old_password": '$oldpsw' , "new_password": '$newpsw'};
      final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'}; //fixed costruction!
      final response = await http.put(Uri.parse(url),body:body);
      return response;
    // if (response.statusCode == 200) {
    //   final decodedResponse = jsonDecode(response.body);
    //   List activity_time_data=[];
    //   for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
    //     activity_time_data.add(Activity.fromJson(decodedResponse['data']['date'], decodedResponse['data']['data'][i]).getValue());
    //   }//for
    //   double out=activity_time_data.reduce((a, b) => a + b);
    //   return out.toInt(); // unit of measure???
    // } //if
    // else{
    //   void result = null;
    // }//else
    
    }
    

  }//getDistance