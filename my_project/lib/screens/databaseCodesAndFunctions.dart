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
final tomorrow='2023-05-18';


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

        // Here we write on the database: (2 days)
        // First: check if there are new data available (= the date is different)
        bool newDataReady=await _newDataReady(today);
        if(newDataReady==true){

      // to use this page, two consecutive dates are uploaded into the db
        await Provider.of<DatabaseRepository>(context, listen: false).insertData(StatisticsData(1, today, steps,distance,activity_time));
        await Provider.of<DatabaseRepository>(context, listen: false).insertAnswers(Questionnaire(1, today, question1, question2, question3, total));
        await Provider.of<DatabaseRepository>(context, listen: false).insertAchievements(Achievements(1, today,today_LoS, today_trees));

        await Provider.of<DatabaseRepository>(context, listen: false).insertData(StatisticsData(1, tomorrow, steps,distance,activity_time));
        await Provider.of<DatabaseRepository>(context, listen: false).insertAnswers(Questionnaire(1, tomorrow, question1, question2, question3, total));
        await Provider.of<DatabaseRepository>(context, listen: false).insertAchievements(Achievements(1, tomorrow,today_LoS, today_trees));
        print('stored new data');}

        else{
      // otherwise, the data are just update to the new vale (nb: can work with differences into the hours!)
        await Provider.of<DatabaseRepository>(context, listen: false).updateData(StatisticsData(1, today, steps,distance,activity_time));
        await Provider.of<DatabaseRepository>(context, listen: false).updateAnswers(Questionnaire(1, today, question1, question2, question3, total));
        await Provider.of<DatabaseRepository>(context, listen: false).updateAchievements(Achievements(1, today,today_LoS, today_trees));
        print('update the data');
        }
        

        // From now on the data are stored into the database. I hope that you'll find pretty clear how to pass properly the data!
      },),

      // Ok, i dati li scrive. Mi chiedo a questo punto se io non possa fare una cosa un attimo più furba:
      // selezionare l'intero record e mostrare solo l'attributo della classe che mi serve, come viene fatto nella classe todo: tu non vai
      // a selezionare un particolare attributo ma bensì tutti i dati! In questo modo ti eviti i problemi con gli int e liste...chissà!


    body: Consumer<DatabaseRepository>(
          builder: (context, dbr, child) {
          return FutureBuilder(
            future: dbr.dailyAchievement(1,today),
            builder: (context,snapshot){
              if(snapshot.hasData){
                final data = snapshot.data as List<Achievements>;
                final entity_row=data[0];
                return Container(
                  height: 50,
                  width: 200,
                  child: Text(
                    'today LoS: ${entity_row.levelOfSustainability}',
                    style: Constants.TextButtonStyle_HomePage,
                  ),
                  color: Constants.primaryLightColor,
                );
                
              }
              else{
                return CircularProgressIndicator();
              }
            }
          );}
    )
      )
    );
  }}

      //Here i build the page: has so many logical errors, be patient with me please

//       body: Consumer<DatabaseRepository>(
//             builder: (context, dbr, child) {
//           return FutureBuilder(
            
//             initialData: null,
//             future: 
//                    //dbr.dailyTotal(01,today), //1
//                    dbr.dailyAchievement(1, today), //2
//                   //dbr.dateRangeLoS(1, today, today, today), // 3 
//                   // this query doesn't work well. Why? BOOOO

//                   // Possibile strategia alternativa: usare solo query di selezione e usare delle funzioni con cicli per il conteggio/creazione delle liste...

//             builder: (context, snapshot) {
//               if (snapshot.hasData) {
// // Up to now, you can only change the instruction given to the builder... I don't know how to create, for example, a list of FutureBuilder...

// // DOMANDE DA FARE DOMANI: 
// // 1. Come inserire un future builder dentro un container? 
// // 2. Cosa vuol dire l'errore sul between? Forse non legge correttamente la stringa?


//                 //final data = snapshot.data as List<Questionnaire>;  //1
//                 // final data = snapshot.data as List<Achievements>;  //2 
//                 final data = snapshot.data as List<Achievements>; 
//                 //int intoRangeLos = _intoRangeLos(data);

//                 //int intoRangeLos = _intoRangeLos(data,today);
//                 return 
//                  ListView.builder(
//                     //shrinkWrap:true,
//                     itemCount: data.length,
//                     itemBuilder: (context, index) {

//                       final entity_row = data[index];
                      
//                       return Column(
//                         children: [
//                           SizedBox(height: 20),

                          
                                                    
//                           //Text('total level from answers: ${entity_row.total}'), //1

//                           // Text('total trees: ${entity_row.trees}'), //2
//                           // SizedBox(height: 20),
//                            Text('today LoS: ${entity_row.levelOfSustainability}'), //2
//                           //Text('comulative LoS: $intoRangeLos') // 3

//                         ],
//                       );
//                     });
//                     } 
//                 else {
//                 //CircularProgressIndicator is shown while the list of Todo is loading.
//                 return CircularProgressIndicator();
//               } //else
//             },//builder of FutureBuilder
//           );
//         }),


      //  ),
      // );
      
      // }
      
      // }


// Some functions ready made for you with much love 

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

  //This method allows to refresh the stored JWT in SharedPreferences
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

  // int _intoRangeLos( List<Achievements> data){
  //   int out=0;
  //   int stop = data.length;

  //   for(int i=0; i<=stop; i++  ){
  //     out+=data[i].levelOfSustainability;
  //   }
  //   return out;
  // }
  int _intoRangeLos( List<Achievements> data, String startDate){
    // ad esempio questa funzione ti potrebbe semplificare non poco la vita...
    int out=0;
    int stop = data.length;
    
    for (int j=0; j<=stop; j++){
      if(data[j].date==startDate){
        int startIndex=j;
        for(int i=startIndex; i<=stop; i++  ){
          out+=data[i].levelOfSustainability;
    }
      }
    }

    
    return out;
  }
  


  