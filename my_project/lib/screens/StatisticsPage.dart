// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:my_project/screens/AboutThisApp.dart';

import 'package:my_project/screens/Barplot/bar_graph.dart';
import 'package:my_project/screens/LoginPage.dart';
import 'package:my_project/screens/databaseCodesAndFunctions.dart';
import 'package:my_project/utils/constants.dart';
//import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

// to receive datacfrom impact
import 'dart:convert';
import 'dart:io';
import 'package:my_project/utils/impact.dart';
// to save data from impact into a proper way
import 'package:my_project/Models/Steps.dart';
import 'package:my_project/Models/Distance.dart';
import 'package:my_project/Models/Activity.dart';

// to use the db
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/Database/repositries/appDatabaseRepository.dart';
// entities into write the data
import 'package:my_project/Database/entities/achievements.dart';
import 'package:my_project/Database/entities/questionnaire.dart';
import 'package:my_project/Database/entities/statisticsData.dart';

final currentDate = DateTime.now().subtract(Duration(days: 1)); // once assigned can be changed
final today = DateFormat('yyyy-MM-dd').format(currentDate);


class StatisticsPage extends StatefulWidget {
 const StatisticsPage ({super.key});

  @override
  StatisticsPageState createState() => StatisticsPageState();
}

class StatisticsPageState extends State<StatisticsPage> {

 //-------------- Index used trought the code to build widgets

static const routename = 'StatisticsPage';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Statistics',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.primaryColor,

          title: Text('Statistics'),
          actions: [IconButton(
            icon: Icon(Icons.data_array),
            onPressed: (){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const databaseTestPage()));},
          )]
          ,
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
          
          // ----------------------------Steps graph OK 
          Consumer<DatabaseRepository>(
          builder: (context, dbr, child) {
            List<StatisticsData> initialData=[StatisticsData(0, '0000', 0, 0, 0)];
          return FutureBuilder(
            initialData: initialData,
            future: dbr.userAllSingleStatisticsData(1),
            builder: (context,snapshot){
              if(snapshot.hasData){
                final data = snapshot.data as List<StatisticsData>;
                if(data.length==0){
                  return _noDataGraph('Steps');
                }
                else{
                List<double> week_steps= _createStepsDataForGraph(data); // so just a list created with a function
               return _dataGraph(week_steps, 'Steps');
              }}
              else{
                return CircularProgressIndicator();
              }
            }
          );}
    ),
    // ------------------------------------------ distance graph UPDATE
          Consumer<DatabaseRepository>(
          builder: (context, dbr, child) {
            List<StatisticsData> initialData=[StatisticsData(0, '0000', 0, 0, 0)];
          return FutureBuilder(
            initialData: initialData,
            future: dbr.userAllSingleStatisticsData(1),
            builder: (context,snapshot){
              if(snapshot.hasData){
                final data = snapshot.data as List<StatisticsData>;
                if(data.length==0){
                  return _noDataGraph('Distance');
                }
                else{
                List<double> weekDist= _createSDistanceDataForGraph(data); // so just a list created with a function
               return _dataGraph(weekDist, 'Distance');
              }}
              else{
                return CircularProgressIndicator();
              }
            }
          );}
    ),
    // ----------------------------------------------- activity time graph UPDATE
          Consumer<DatabaseRepository>(
          builder: (context, dbr, child) {
            List<StatisticsData> initialData=[StatisticsData(0, '0000', 0, 0, 0)];
          return FutureBuilder(
            initialData: initialData,
            future: dbr.userAllSingleStatisticsData(1),
            builder: (context,snapshot){
              if(snapshot.hasData){
                final data = snapshot.data as List<StatisticsData>;
                if(data.length==0){
                  return _noDataGraph('Activity Time');
                }
                else{
                List<double> weekActivity= _createActivityTimeDataForGraph(data); // so just a list created with a function
               return _dataGraph(weekActivity, 'Activity Time');
              }}
              else{
                return CircularProgressIndicator();
              }
            }
          );}
    ),
    // ---------------------------------------------------LoS graph UPDATE
          Consumer<DatabaseRepository>(
          builder: (context, dbr, child) {
            List<Achievements> initialData=[Achievements(0, '0000',  0)];
          return FutureBuilder(
            initialData: initialData,
            future: dbr.userAllSingleAchievemnts(1),
            builder: (context,snapshot){
              if(snapshot.hasData){
                final data = snapshot.data as List<Achievements>;
                if(data.length==0){
                  return _noDataGraph('Level of Sustainability');
                }
                else{
                List<double> weekLoS= _createLoSDataForGraph(data); // so just a list created with a function
               return _dataGraph(weekLoS, 'Level of Sustainability');
              }}
              else{
                return CircularProgressIndicator();
              }
            }
          );}
    ),
            
          ],

        ),

    floatingActionButton:
     FloatingActionButton(
      onPressed: () async {

        // First: check if there are new data available (= the date is different)
        bool newDataReady=await _newDataReady(today);
        bool weekData=true; // if we want to simulate an entire week of loadings.

        await _pingImpact();        // connect to impact
        await  _getAndStoreTokens();// storing tokens. 
        // Now we are ready to read data from impact

        // Data for the statistics page
        // NB: here the data are collected just for one day. 
        int steps= await _getStep(today); 
        int distance= await _getDistance(today);
        int activity_time= await _getActivity_time(today); 

        // data for the achievements
        // In this page, since the user could not even complete the homepage questionnaire, the LoS is computed by setting to zero the points of the questionnaire.
        // This is not a problem becouse the function which creates the list of LoS receive data from the db and not frum this function!
        int today_LoS=_computeLoS(steps, distance, activity_time);
        
        // Writing data:
        if(newDataReady==true) { // writing new data becouse the day has changed
        await Provider.of<DatabaseRepository>(context, listen: false).insertData(StatisticsData(1, today, steps,distance,activity_time));
        // the date is changed, ones upon a day the questionnaire in inserted
        await Provider.of<DatabaseRepository>(context, listen: false).insertAnswers(Questionnaire(1, today, 0,0,0,0));
        await Provider.of<DatabaseRepository>(context, listen: false).insertAchievements(Achievements(1, today,today_LoS));

        print('stored new data');

        // a simple snackBar to return the state of the data
        final snackBar=SnackBar(content: Text('New data stored!',
        style: TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.bold,fontSize: 15),),
        backgroundColor: Color.fromARGB(255, 206, 211, 206),
        
        action: SnackBarAction(
              label: 'Got it!',
              textColor: Color.fromARGB(255, 15, 89, 158) ,
              disabledTextColor:Color.fromARGB(255, 15, 89, 158) ,
              onPressed: () {},)
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);}

        else{ // update new data
        await Provider.of<DatabaseRepository>(context, listen: false).updateData(StatisticsData(1, today, steps,distance,activity_time));
        await Provider.of<DatabaseRepository>(context, listen: false).updateAchievements(Achievements(1, today,today_LoS));
        print('update the data');

        final snackBar=SnackBar(content: Text('Data updated!',
        style: TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.bold,fontSize: 15),),
        backgroundColor: Color.fromARGB(255, 206, 211, 206),
        
        action: SnackBarAction(
              label: 'Got it!',
              textColor: Color.fromARGB(255, 15, 89, 158) ,
              disabledTextColor:Color.fromARGB(255, 15, 89, 158) ,
              onPressed: () {},)
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);}
        
        },
      child: Icon(Icons.add),
      backgroundColor: Constants.primaryColor,
      
      ),
     ),

    );
  }

}

//--------------------------------------------------- PAGE FUNCTIONS
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

  Future<bool> _newDataReady(String today) async{
    final sp=await SharedPreferences.getInstance();
    print('into newDataReady');
    if(sp.getString('today')!=today || sp.getString('today')==null ){
      print('the day is changed');
      sp.setString('today', today);
      return true;
    }
    else {
      print('date is not changed');
      return false;}
  }



// ------------------------------------------- IMPACT FUNCTIONS ----------------------------------
  Future<bool> _pingImpact() async{
    final url=Impact.baseUrl + Impact.pingEndpoint;
    // call
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
    // return the status code
    return response.statusCode;
  } //_getAndStoreTokens

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
      int out=steps_data.reduce((a, b) => a + b); // here we compute the sum
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
      if (decodedResponse['data'].length==0){
        return 0; 
      }
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


// --------------------------------------- DB FUNCTIONS TO PREPARE DATA

int _computeLoS(int daily_steps,int daily_distance,int daily_activityTime, {int point_answers =0}) {
    //For now, it's just a sum. In the future will be a weighted sum

    // Defining of weights
    double ans_w=1;
    double steps_w=0.1;
    double dist_w=0.1;
    double time_w=0.1;

    int malus=-50; //for example

    // as a sum of int, round is not necessary (for now BUT in the future...)
    num weightedSum= point_answers*ans_w+daily_steps*steps_w+daily_distance*dist_w+daily_activityTime*time_w;
    int result=weightedSum.toInt();

    // if you didn't recorded anything, you'll get a malus
    if(result==0){return malus;} 
    // Otherwise, good job!
    else{return result;}
    
  }

 List<double> _createStepsDataForGraph( List<StatisticsData> data) {
    // require to pass to the function an item of userAllSingleStatisticsData query

    List<double> out=[0,0,0,0,0,0,0]; //initially, the data are all zeros. [Mon,Tue,...,Sun]
    int lnList=data.length; // the length of the list of items
    // if data are collected for less than one week, the elements are associated one-to-one with the days
    if(lnList<out.length){
    for(int i=0; i<=lnList-1; i++){
      out[i]=data[i].dailySteps+0.0;

    }}
    // else, we need to translate the origin of days. But in this manner we aren't precise with the days...the last data will be alwais connected to sunday...
    else {
      for(int i=0; i<=out.length-1; i++){
      out[i]=data[lnList-7+i].dailySteps+0.0;
    }
    }
    return out;
  }

  List<double> _createSDistanceDataForGraph( List<StatisticsData> data) {
    // require to pass to the function an item of userAllSingleStatisticsData query

    List<double> out=[0,0,0,0,0,0,0]; //initially, the data are all zeros. [Mon,Tue,...,Sun]
    int lnList=data.length; // the length of the list of items
    // if data are collected for less than one week, the elements are associated one-to-one with the days
    if(lnList<out.length){
    for(int i=0; i<=lnList-1; i++){
      out[i]=data[i].dailyDistance+0.0;

    }}
    // else, we need to translate the origin of days. But in this manner we aren't precise with the days...the last data will be alwais connected to sunday...
    else {
      for(int i=0; i<=out.length-1; i++){
      out[i]=data[lnList-7+i].dailyDistance+0.0;
    }
    }
    return out;
  }

  List<double> _createActivityTimeDataForGraph( List<StatisticsData> data) {
    // require to pass to the function an item of userAllSingleStatisticsData query

    List<double> out=[0,0,0,0,0,0,0]; //initially, the data are all zeros. [Mon,Tue,...,Sun]
    int lnList=data.length; // the length of the list of items
    // if data are collected for less than one week, the elements are associated one-to-one with the days
    if(lnList<out.length){
    for(int i=0; i<=lnList-1; i++){
      out[i]=data[i].dailyActivityTime+0.0;

    }}
    // else, we need to translate the origin of days. But in this manner we aren't precise with the days...the last data will be alwais connected to sunday...
    else {
      for(int i=0; i<=out.length-1; i++){
      out[i]=data[lnList-7+i].dailyActivityTime+0.0;
    }
    }
    return out;
  }

  List<double> _createLoSDataForGraph( List<Achievements> data) {
    // require to pass to the function an item of userAllSingleAchievemnts query 

    List<double> out=[0,0,0,0,0,0,0]; //initially, the data are all zeros. [Mon,Tue,...,Sun]
    int lnList=data.length; // the length of the list of items
    // if data are collected for less than one week, the elements are associated one-to-one with the days
    if(lnList<out.length){
    for(int i=0; i<=lnList-1; i++){
      out[i]=data[i].levelOfSustainability+0.0;

    }}
    // else, we need to translate the origin of days. But in this manner we aren't precise with the days...the last data will be alwais connected to sunday...
    else {
      for(int i=0; i<=out.length-1; i++){
      out[i]=data[lnList-7+i].levelOfSustainability+0.0;
    }
    }
    return out;
  }

Widget _noDataGraph(String title){

 return  Padding(padding: const EdgeInsets.all(20),
            child: Animate(
              effects: Constants.Fade_effect_options,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              height: 280,
                color: Constants.containerColor,
                child:Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children:  [
                SizedBox(height: 10),
                 Text('$title', style: TextStyle(
                  color: Color.fromARGB(255, 1, 76, 4), fontSize: 24, fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 15),
                SizedBox(
                  height: 200,
                    child: BarGraph(
                    dailySteps: [0.0,0.0,0.0,0.0,0.0,0.0,0.0],
                    ),
                  ),
                 ],
                ),
              ),
            ),));
}

Widget _dataGraph(List<double> data, String title){
  return Padding(padding: const EdgeInsets.all(20),
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
                 Text('$title', style: TextStyle(
                  color: Constants.secondaryColor, fontSize: 24, fontWeight: FontWeight.bold,
                  ),
                  ),
                  SizedBox(height: 15),
                SizedBox(
                  height: 200,
                    child: BarGraph(
                    dailySteps: data,
                    ),
                  ),
                 ],
                ),
              ),
            ),));
}