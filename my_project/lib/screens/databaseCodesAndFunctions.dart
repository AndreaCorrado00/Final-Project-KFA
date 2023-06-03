// A temp page into which you'll find all the functions and examples to use the database. 

import 'package:flutter/material.dart';
import 'package:my_project/Database/repositries/appDatabaseRepository.dart';
import 'package:my_project/screens/StatisticsPage.dart';
import 'package:my_project/utils/constants.dart';

import 'dart:convert';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_project/Models/Steps.dart';
import 'package:my_project/Models/Distance.dart';
import 'package:my_project/Models/Activity.dart';

import 'package:my_project/utils/impact.dart';

import 'package:my_project/Database/entities/achievements.dart';
import 'package:my_project/Database/entities/questionnaire.dart';
import 'package:my_project/Database/entities/statisticsData.dart';

import 'package:my_project/screens/Barplot/bar_graph.dart';

class databaseTestPage extends StatefulWidget {
 const databaseTestPage ({super.key});

  @override
  databaseTestPageState createState() => databaseTestPageState();
}

class databaseTestPageState extends State<databaseTestPage> {

static const routename = 'StatisticsPage';
//final today='2023-05-16';
final today='2023-05-17';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Database functions test page',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.primaryColor,

          title: Text('Database functions test page'),
          automaticallyImplyLeading: false,
        ),
       
      backgroundColor:Constants.primaryLightColor,
      //body: ListView(
      floatingActionButton: FloatingActionButton(
      child: Icon(Icons.punch_clock_sharp),
      onPressed: () async {
        await _pingImpact();        // connect to impact
        await  _getAndStoreTokens();// storing tokens. 
        // Now we are ready to read data from impact

        // Data for the statistics page
        int steps= await _getStep(today); 
        int distance= await _getDistance(today);
        int activity_time= await _getActivity_time(today);

        // data for the questionnaire
        int question1=1;
        int question2=2;
        int question3=3;
        int total = _computeTotalQuestionnaire([question1,question2,question3]); // total of the answers

        // data for the achievements
        int today_LoS=_computeLoS(total, steps, distance, activity_time);
        int today_trees=today_LoS ~/ 1000; // integer division: returns only the integer part of the resoult before the common 

        // Here we write on the database:
        await Provider.of<DatabaseRepository>(context, listen: false).insertData(StatisticsData(1, today, steps,distance,activity_time));
        await Provider.of<DatabaseRepository>(context, listen: false).insertAnswers(Questionnaire(1, today, question1, question2, question3, total));
        await Provider.of<DatabaseRepository>(context, listen: false).insertAchievements(Achievements(1, today,today_LoS, today_trees));

        // From now on the data are stored into the database. I hope that you'll find pretty clear how to pass properly the data!

      },),

      //Here i build the page
      // body: Consumer<DatabaseRepository>(
      //       builder: (context, dbr, child) {
      //     return FutureBuilder(
      //       initialData: null,
      //       future: dbr.totalLoS(01,today),
      //       builder: (context, snapshot) {
      //         if (snapshot.hasData) {
      //           List<int> data = snapshot.data as List<int>;  
      //           List<int> dailySteps=data;
      //           return 
      //            ListView.builder(
      //               itemCount: data.length,
      //               itemBuilder: (context, todoIndex) {
      //                 final todo = data[todoIndex];
      //                 return Column(
      //                   children: [
      //                     SizedBox(height: 20),

      //                     // Example of BarGraph
      //                     BarGraph(dailySteps: dailySteps),

      //                     SizedBox(height: 20),
      //                   ],
                          
                          
                          
                        
      //                 );
      //               });
      //               } 
      //           else {
      //           //CircularProgressIndicator is shown while the list of Todo is loading.
      //           return CircularProgressIndicator();
      //         } //else
      //       },//builder of FutureBuilder
      //     );
      //   }),
       ),
      );}}


// Some functions ready made for you with much love 
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
      double out=distance_data.reduce((a, b) => a + b)/100;//udm: [m]
      return out.toInt(); 
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
      double out=(activity_time_data.reduce((a, b) => a + b))/60000; //udm [min]
      return out.toInt();
    } //if
    else{
      void result = null;
    }//else
    
    }
  
  }//getActivity_time

 int _computeTotalQuestionnaire(List points)  {
    int out=points.reduce((a, b) => a + b);
    return out;
  }

  int _computeLoS(int point_answers , int daily_steps,int daily_distance,int daily_activityTime) {
    //For now, it's just a sum

    // Defining of weights
    int ans_w=1;
    int steps_w=1;
    int dist_w=1;
    int time_w=1;

    int malus=-50; //for example

    // as a sum of int, round is not necessary (for now)
    num weightedSum= point_answers*ans_w+daily_steps*steps_w+daily_distance*dist_w+daily_activityTime*time_w;
    int result=weightedSum.toInt();

    // if you didn't recorded anything, you'll get a malus
    if(result==0){return malus;} 
    // Otherwise, good job!
    else{return result;}
    
  }


  


  