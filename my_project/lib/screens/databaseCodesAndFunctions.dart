// A temp page into which you'll find all the functions and examples to use the database.

import 'package:flutter/material.dart';
import 'package:my_project/utils/constants.dart';

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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/Database/repositries/appDatabaseRepository.dart';
// entities into write the data
import 'package:my_project/Database/entities/achievements.dart';
import 'package:my_project/Database/entities/questionnaire.dart';
import 'package:my_project/Database/entities/statisticsData.dart';

class databaseTestPage extends StatefulWidget {
  const databaseTestPage({super.key});

  @override
  databaseTestPageState createState() => databaseTestPageState();
}

// What will you find here:
// this code hase inside same examples of what can we do with out database. First, decide if you want to simulate
// an entire week or a real-life situation where you use the database to retrive only the daily data.

// then some function are used to compute the values that must be inserted into the database and other to load data in the correct way

// finally, into the body, you'll find same other function which create the correct visualization of the resource inside the database.

// Note that i've made same important assumpionts that i hope simplyfies a lot the workload and the code For example, all values are int.

class databaseTestPageState extends State<databaseTestPage> {
  static const routename = 'StatisticsPage';
  final today = '2023-05-16';
  final tomorrow = '2023-05-17';
  final oneWeekLater = '2023-05-22';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Database functions test page',
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Constants.primaryColor,
              title: const Text('Database functions test page'),
              automaticallyImplyLeading: true,
            ),
            backgroundColor: Constants.primaryLightColor,
            floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.punch_clock_sharp),
                onPressed: () async {
                  // First: check if there are new data available (= the date is different)
                  bool newDataReady = await _newDataReady(today);
                  bool weekData =
                      true; // if we want to simulate an entire week of loadings.
                  await _pingImpact(); // connect to impact
                  await _getAndStoreTokens(); // storing tokens.
                  // Now we are ready to read data from impact

                  // Data for the statistics page
                  // NB: here the data are collected just for one day.
                  int steps = await _getStep(today);
                  int distance = await _getDistance(today);
                  int activity_time = await _getActivity_time(today);

                  // data for the questionnaire
                  int question1 = 1;
                  int question2 = 2;
                  int question3 = 3;
                  int total = _computeTotalQuestionnaire([
                    question1,
                    question2,
                    question3
                  ]); // total of the answers

                  // data for the achievements
                  int today_LoS =
                      _computeLoS(total, steps, distance, activity_time);

                  // up to now the code works like a real-situation application. I think that we need to load one week of data for our demo.

                  if (newDataReady == true && weekData == false) {
                    // to use this page, two consecutive dates are uploaded into the db
                    await Provider.of<DatabaseRepository>(context,
                            listen: false)
                        .insertData(StatisticsData(
                            1, today, steps, distance, activity_time));
                    await Provider.of<DatabaseRepository>(context,
                            listen: false)
                        .insertAnswers(Questionnaire(
                            1, today, question1, question2, question3, total));
                    await Provider.of<DatabaseRepository>(context,
                            listen: false)
                        .insertAchievements(Achievements(1, today, today_LoS));

                    await Provider.of<DatabaseRepository>(context,
                            listen: false)
                        .insertData(StatisticsData(
                            1, tomorrow, steps, distance, activity_time));
                    await Provider.of<DatabaseRepository>(context,
                            listen: false)
                        .insertAnswers(Questionnaire(1, tomorrow, question1,
                            question2, question3, total));
                    await Provider.of<DatabaseRepository>(context,
                            listen: false)
                        .insertAchievements(
                            Achievements(1, tomorrow, today_LoS));
                    print('stored new data');
                  } else if (weekData == true) {
                    Map weekSteps = await _getWeekSteps(today, oneWeekLater);
                    List days = await weekSteps.keys.toList();
                    List steps = await weekSteps.values.toList();

                    Map weekDist = await _getWeekDistance(today, oneWeekLater);
                    List distance = await weekDist.values.toList();

                    Map weekTime =
                        await _getWeekActivityTime(today, oneWeekLater);
                    List activity_time = await weekTime.values.toList();

                    for (int i = 0; i < 7; i++) {
                      // per quanto riguarda il questionario, dovremmo simulare 7 risposte diverse date al singolo questionario, oppure semplicamente quel
                      // giorno si mostra che, aggiungendo dati al questionario, le cose migliorano.

                      await Provider.of<DatabaseRepository>(context,
                              listen: false)
                          .insertData(StatisticsData(1, days[i], steps[i],
                              distance[i], activity_time[i]));
                      await Provider.of<DatabaseRepository>(context,
                              listen: false)
                          .insertAnswers(Questionnaire(1, days[i], question1,
                              question2, question3, total));
                      await Provider.of<DatabaseRepository>(context,
                              listen: false)
                          .insertAchievements(
                              Achievements(1, days[i], today_LoS));
                    }
                  } else {
                    // otherwise, the data are just update to the new vale (nb: can work with differences into the hours!)
                    await Provider.of<DatabaseRepository>(context,
                            listen: false)
                        .updateData(StatisticsData(
                            1, today, steps, distance, activity_time));
                    await Provider.of<DatabaseRepository>(context,
                            listen: false)
                        .updateAnswers(Questionnaire(
                            1, today, question1, question2, question3, total));
                    await Provider.of<DatabaseRepository>(context,
                            listen: false)
                        .updateAchievements(Achievements(1, today, today_LoS));
                    print('update the data');
                  }
                }),

// Her you'll find a simple body with elementary operations on the db.
            body: Column(
              children: [
// -----------------------------------------------------------------------------------
                Text('achievements entity queries'),
                SizedBox(
                  height: 10,
                ),

                Consumer<DatabaseRepository>(// calling the consumer
                    builder: (context, dbr, child) {
                  // building
                  List<Achievements> initialData = [
                    Achievements(0, '0000', 0)
                  ]; // data used to start (but can be null too, this is just an example)
                  return FutureBuilder(
                      // let's build a future (sounds pretty good, but it's a nightmare!)
                      initialData: initialData,
                      future: dbr.dailyAchievement(1, today), //the query used
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data as List<Achievements>;
                          if (data.length == 0) {
                            // a simple way to manage the possbility of an empty db
                            return const Text(
                                'there are not data available yet',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 0, 0)));
                          } else {
                            final entity_row = data[0]; // here we work
                            return Container(
                              height: 20,
                              width: 500,
                              child: Text(
                                'today LoS: ${entity_row.levelOfSustainability}', // showing the results
                              ),
                              color: Constants.containerColor,
                            );
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      });
                }),
                SizedBox(
                  height: 10,
                ),

                Consumer<DatabaseRepository>(builder: (context, dbr, child) {
                  List<Achievements> initialData = [Achievements(0, '0000', 0)];
                  return FutureBuilder(
                      initialData: initialData,
                      future: dbr.userAllSingleAchievemnts(1),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data as List<Achievements>;
                          if (data.length == 0) {
                            return const Text(
                                'there are not data available yet',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 0, 0)));
                          } else {
                            int LoS = _reachedLoS(
                                data); //it's the sum of ALLLL level of sustainability recorded up to now
                            int trees = LoS ~/ 1000; // stupid but effective way
                            return Container(
                              height: 20,
                              width: 500,
                              child: Text(
                                'Comulative LoS: ${LoS} and total trees: ${trees}',
                              ),
                              color: Constants.containerColor,
                            );
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      });
                }),
                SizedBox(
                  height: 10,
                ),

                // -----------------------------------------------------------------------------------
                Text('statistics data entity queries'),
                SizedBox(
                  height: 10,
                ),

                Consumer<DatabaseRepository>(builder: (context, dbr, child) {
                  List<StatisticsData> initialData = [
                    StatisticsData(0, '0000', 0, 0, 0)
                  ];
                  return FutureBuilder(
                      initialData: initialData,
                      future: dbr.userAllSingleStatisticsData(1),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data as List<StatisticsData>;
                          if (data.length == 0) {
                            return const Text(
                                'there are not data available yet',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 0, 0)));
                          } else {
                            List<int> week_steps = _createStepsDataForGraph(
                                data); // so just a list created with a function

                            return Container(
                              height: 20,
                              width: 500,
                              child: Text('Data for graph: ${week_steps}'),
                              color: Constants.containerColor,
                            );
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      });
                }),
                SizedBox(
                  height: 10,
                ),
// -----------------------------------------------------------------------------------
                Text('questionnaire entity queries'),
                SizedBox(
                  height: 10,
                ),

                Consumer<DatabaseRepository>(builder: (context, dbr, child) {
                  List<Questionnaire> initialData = [
                    Questionnaire(0, '0000', 0, 0, 0, 0)
                  ];
                  return FutureBuilder(
                      initialData: initialData,
                      future: dbr.dailyQuestionaire(1, today),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data as List<Questionnaire>;
                          if (data.length == 0) {
                            return const Text(
                                'there are not data available yet',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 255, 0, 0)));
                          } else {
                            final entity_row = data[0];
                            return Container(
                              height: 20,
                              width: 500,
                              child: Text(
                                'today from questionnaire: ${entity_row.total}',
                              ),
                              color: Constants.containerColor,
                            );
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      });
                }),
              ],
            )));
  }
}

// Some functions ready made for you with much love
// --------------------------------- IMPACT --------------------------------------------------
Future<bool> _pingImpact() async {
  final url = Impact.baseUrl + Impact.pingEndpoint;
  // call
  final response = await http.get(Uri.parse(url)); // is an async function
  return response.statusCode == 200;
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

Future<bool> _newDataReady(String day) async {
  final sp = await SharedPreferences.getInstance();
  print('into newDataReady');
  if (sp.getString('today') != day || sp.getString('today') == null) {
    print('the day is changed');
    sp.setString('today', day);
    return true;
  } else {
    print('date is not changed');
    return false;
  }
}

// --------------------------------- IMPACT AND MODELS --------------------------------------------------
Future _getStep(today) async {
  // Returns the sum of the steps made into a certain day
  // preliminary settings
  final sp = await SharedPreferences.getInstance();
  var access = sp.getString('access');
  if (access == null) {
    return null;
  } else {
    if (JwtDecoder.isExpired(access)) {
      await _refreshTokens();
      access = sp.getString('access');
    }
    //request
    final url = Impact.baseUrl +
        Impact.stepEndpoint +
        '/patients/Jpefaq6m58' +
        '/day/$today/';
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $access'
    }; //fixed costruction!
    final response = await http.get(Uri.parse(url), headers: headers);

    // Creatione of the response
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      //List result = [];
      List steps_data = [];
      final total_steps = 0;
      for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
        //result.add(Steps.fromJson(decodedResponse['data']['date'], decodedResponse['data']['data'][i]));
        steps_data.add(Steps.fromJson(decodedResponse['data']['date'],
                decodedResponse['data']['data'][i])
            .getValue());
      } //for
      int out = steps_data.reduce((a, b) => a + b); // here we compute the sum
      return out;
    } //if
    else {
      void result = null;
    } //else
  }
} //getStep

Future _getDistance(today) async {
  final sp = await SharedPreferences.getInstance();
  var access = sp.getString('access');
  if (access == null) {
    return null;
  } else {
    if (JwtDecoder.isExpired(access)) {
      await _refreshTokens();
      access = sp.getString('access');
    }

    final url = Impact.baseUrl +
        Impact.distanceEndpoint +
        '/patients/Jpefaq6m58' +
        '/day/$today/';
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $access'
    }; //fixed costruction
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      List distance_data = [];
      for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
        distance_data.add(Distance.fromJson(decodedResponse['data']['date'],
                decodedResponse['data']['data'][i])
            .getValue());
      } //for
      double out = distance_data.reduce((a, b) => a + b) / 100; //udm: [m]
      return out.toInt();
    } //if
    else {
      void result = null;
    } //else
  }
} //getDistance

Future _getActivity_time(today) async {
  final sp = await SharedPreferences.getInstance();
  var access = sp.getString('access');
  if (access == null) {
    return null;
  } else {
    if (JwtDecoder.isExpired(access)) {
      await _refreshTokens();
      access = sp.getString('access');
    }
    final url = Impact.baseUrl +
        Impact.activityEndpoint +
        '/patients/Jpefaq6m58' +
        '/day/$today/';
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $access'
    }; //fixed costruction!
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      List activity_time_data = [];
      for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
        activity_time_data.add(Activity.fromJson(
                decodedResponse['data']['date'],
                decodedResponse['data']['data'][i])
            .getValue());
      } //for
      double out =
          (activity_time_data.reduce((a, b) => a + b)) / 60000; //udm [min]
      return out.toInt();
    } //if
    else {
      void result = null;
    } //else
  }
} //getActivity_time

//--------------------------------- WEEK DATA FOR THE DEMO -------------------------

// getWeekSteps
Future _getWeekSteps(String startDate, String endDate) async {
  // Returns the sum of the steps made into a certain day

  // preliminary settings
  final sp = await SharedPreferences.getInstance();
  var access = sp.getString('access');
  if (access == null) {
    return null;
  } else {
    if (JwtDecoder.isExpired(access)) {
      await _refreshTokens();
      access = sp.getString('access');
    }
    //request
    final url = Impact.baseUrl +
        Impact.stepEndpoint +
        '/patients/Jpefaq6m58' +
        '/daterange/start_date/$startDate/end_date/$endDate/';
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $access'
    }; //fixed costruction!
    final response = await http.get(Uri.parse(url), headers: headers);

    // Creatione of the response
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      Map stepsWeekdata = {};
      //List stepsWeekdata=[];
      for (var i = 0; i < decodedResponse['data'].length; i++) {
        List dailySteps = [];
        for (var j = 0; j < decodedResponse['data'][i]['data'].length; j++) {
          dailySteps.add(Steps.fromJson(decodedResponse['data'][i]['date'],
                  decodedResponse['data'][i]['data'][j])
              .getValue());
        }
        int daySteps = dailySteps.reduce((a, b) => a + b);
        stepsWeekdata[decodedResponse['data'][i]['date']] = daySteps;
        //stepsWeekdata.add(daySteps);
      }
      return stepsWeekdata;
    } //if

    else {
      void result = null;
      return result;
    } //else
  }
}

// getWeekDistance
Future _getWeekDistance(String startDate, String endDate) async {
  // Returns the sum of the steps made into a certain day

  // preliminary settings
  final sp = await SharedPreferences.getInstance();
  var access = sp.getString('access');
  if (access == null) {
    return null;
  } else {
    if (JwtDecoder.isExpired(access)) {
      await _refreshTokens();
      access = sp.getString('access');
    }
    //request
    final url = Impact.baseUrl +
        Impact.distanceEndpoint +
        '/patients/Jpefaq6m58' +
        '/daterange/start_date/$startDate/end_date/$endDate/';
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $access'
    }; //fixed costruction!
    final response = await http.get(Uri.parse(url), headers: headers);

    // Creatione of the response
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      Map stepsDistancedata = {};
      //List stepsDistancedata=[];
      for (var i = 0; i < decodedResponse['data'].length; i++) {
        List dailyDistance = [];
        for (var j = 0; j < decodedResponse['data'][i]['data'].length; j++) {
          dailyDistance.add(Distance.fromJson(
                  decodedResponse['data'][i]['date'],
                  decodedResponse['data'][i]['data'][j])
              .getValue());
        }
        double dayDist =
            dailyDistance.reduce((a, b) => a + b) / 100.toInt(); //udm: [m]
        stepsDistancedata[decodedResponse['data'][i]['date']] = dayDist.toInt();
        //stepsDistancedata.add(dayDist);
      }
      return stepsDistancedata;
    } //if

    else {
      void result = null;
      return result;
    } //else
  }
}

// getWeekActivitytime
Future _getWeekActivityTime(String startDate, String endDate) async {
  // Returns the sum of the steps made into a certain day

  // preliminary settings
  final sp = await SharedPreferences.getInstance();
  var access = sp.getString('access');
  if (access == null) {
    return null;
  } else {
    if (JwtDecoder.isExpired(access)) {
      await _refreshTokens();
      access = sp.getString('access');
    }
    //request
    final url = Impact.baseUrl +
        Impact.activityEndpoint +
        '/patients/Jpefaq6m58' +
        '/daterange/start_date/$startDate/end_date/$endDate/';
    final headers = {
      HttpHeaders.authorizationHeader: 'Bearer $access'
    }; //fixed costruction!
    final response = await http.get(Uri.parse(url), headers: headers);

    // Creatione of the response
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);

      Map ActivityTimeWeekdata = {};
      //List ActivityTimeWeekdata=[];
      for (var i = 0; i < decodedResponse['data'].length; i++) {
        List dailySteps = [];
        for (var j = 0; j < decodedResponse['data'][i]['data'].length; j++) {
          dailySteps.add(Activity.fromJson(decodedResponse['data'][i]['date'],
                  decodedResponse['data'][i]['data'][j])
              .getValue());
        }
        if (dailySteps.length == 0) {
          ActivityTimeWeekdata[decodedResponse['data'][i]['date']] = 0;
        } else {
          double dayTime =
              dailySteps.reduce((a, b) => a + b) / 60000; //udm [min]
          ActivityTimeWeekdata[decodedResponse['data'][i]['date']] =
              dayTime.toInt();
        }
        //ActivityTimeWeekdata.add(dayTime);
      }
      return ActivityTimeWeekdata;
    } //if

    else {
      void result = null;
      return result;
    } //else
  }
}

// --------------------------------- DATABASE ATTRIBUTES COMPUTATION --------------------------------------------------
int _computeTotalQuestionnaire(List points) {
  int out = points.reduce((a, b) => a + b);
  return out;
}

int _computeLoS(int point_answers, int daily_steps, int daily_distance,
    int daily_activityTime) {
  //For now, it's just a sum. In the future will be a weighted sum

  // Defining of weights
  int ans_w = 1;
  int steps_w = 1;
  int dist_w = 1;
  int time_w = 1;

  int malus = -50; //for example

  // as a sum of int, round is not necessary (for now BUT in the future...)
  num weightedSum = point_answers * ans_w +
      daily_steps * steps_w +
      daily_distance * dist_w +
      daily_activityTime * time_w;
  int result = weightedSum.toInt();

  // if you didn't recorded anything, you'll get a malus
  if (result == 0) {
    return malus;
  }
  // Otherwise, good job!
  else {
    return result;
  }
}

List<int> _createStepsDataForGraph(List<StatisticsData> data) {
  // require to pass to the function an item of userAllSingleStatisticsData query

  List<int> out = [
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; //initially, the data are all zeros. [Mon,Tue,...,Sun]
  int lnList = data.length; // the length of the list of items
  // if data are collected for less than one week, the elements are associated one-to-one with the days
  if (lnList < out.length) {
    for (int i = 0; i <= lnList - 1; i++) {
      out[i] = data[i].dailySteps;
    }
  }
  // else, we need to translate the origin of days. But in this manner we aren't precise with the days...the last data will be alwais connected to sunday...
  else {
    for (int i = 0; i <= out.length - 1; i++) {
      out[i] = data[lnList - 7 + i].dailySteps;
    }
  }
  // else, we need to translate the origin of days. But in this manner we aren't precise with the days...the last data will be alwais connected to sunday...

  return out;
}

List<int> _createSDistanceDataForGraph(List<StatisticsData> data) {
  // require to pass to the function an item of userAllSingleStatisticsData query

  List<int> out = [
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; //initially, the data are all zeros. [Mon,Tue,...,Sun]
  int lnList = data.length; // the length of the list of items
  // if data are collected for less than one week, the elements are associated one-to-one with the days
  if (lnList < out.length) {
    for (int i = 0; i <= lnList - 1; i++) {
      out[i] = data[i].dailyDistance;
    }
  }
  // else, we need to translate the origin of days. But in this manner we aren't precise with the days...the last data will be alwais connected to sunday...
  else {
    for (int i = 0; i <= out.length - 1; i++) {
      out[i] = data[lnList - 7 + i].dailyDistance;
    }
  }

  return out;
}

List<int> _createActivityTimeDataForGraph(List<StatisticsData> data) {
  // require to pass to the function an item of userAllSingleStatisticsData query

  List<int> out = [
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; //initially, the data are all zeros. [Mon,Tue,...,Sun]
  int lnList = data.length; // the length of the list of items
  // if data are collected for less than one week, the elements are associated one-to-one with the days
  if (lnList < out.length) {
    for (int i = 0; i <= lnList - 1; i++) {
      out[i] = data[i].dailyActivityTime;
    }
  }
  // else, we need to translate the origin of days. But in this manner we aren't precise with the days...the last data will be alwais connected to sunday...
  else {
    for (int i = 0; i <= out.length - 1; i++) {
      out[i] = data[lnList - 7 + i].dailyActivityTime;
    }
  }
  // else, we need to translate the origin of days. But in this manner we aren't precise with the days...the last data will be alwais connected to sunday...

  return out;
}

List<int> _createLoSDataForGraph(List<Achievements> data) {
  // require to pass to the function an item of userAllSingleAchievemnts query

  List<int> out = [
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ]; //initially, the data are all zeros. [Mon,Tue,...,Sun]
  int lnList = data.length; // the length of the list of items
  // if data are collected for less than one week, the elements are associated one-to-one with the days
  if (lnList < out.length) {
    for (int i = 0; i <= out.length - 1; i++) {
      out[i] = data[i].levelOfSustainability;
    }
  }
  // else, we need to translate the origin of days. But in this manner we aren't precise with the days...the last data will be alwais connected to sunday...
  else {
    for (int i = 0; i <= out.length - 1; i++) {
      out[i] = data[lnList - 7 + i].levelOfSustainability;
    }
  }
  return out;
}

int _reachedLoS(List<Achievements> data) {
  // basically the sum of allll the LoS recorded by the user
  int out = 0;
  for (int i = 0; i <= data.length - 1; i++) {
    out = out + data[i].levelOfSustainability;
  }
  return out;
}
