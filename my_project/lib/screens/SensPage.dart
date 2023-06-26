import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:intl/intl.dart';
import 'package:my_project/Database/entities/achievements.dart';
import 'package:my_project/Database/entities/questionnaire.dart';
import 'package:my_project/Database/entities/statisticsData.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart'; // to view the map
import 'package:my_project/utils/constants.dart';
import '../Database/repositries/appDatabaseRepository.dart';
import 'AboutThisApp.dart';
import 'LoginPage.dart';
import 'package:provider/provider.dart';

int? question1Value;
int? question2Value;
int? question3Value;

class SensPage extends StatefulWidget {
  const SensPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => Sens_page();
}

// ignore: camel_case_types
class Sens_page extends State<SensPage> {
  // ignore: prefer_typing_uninitialized_variables
  double FLoS = 0.0;
  var Trees = 0;
  var LoS = 0;

  // ignore: non_constant_identifier_names

  Future<bool> _newDataReady(String today) async {
    final sp = await SharedPreferences.getInstance();
    print('into newDataReady');
    if (sp.getString('today') != today || sp.getString('today') == null) {
      print('the day is changed');
      sp.setString('today', today);
      return true;
    } else {
      print('date is not changed');
      return false;
    }
  }

  void _showQuestionnaire() async {
    // Get the current date
    final currentDate = DateTime.now()
        .subtract(Duration(days: 1)); // once assigned can be changed
    final today = DateFormat('yyyy-MM-dd').format(currentDate);
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Questionnaire'),
          // the Alert should Satateful
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    const Text('Did you use public transportation today?'),
                    RadioListTile<int>(
                      title: const Text('Yes'),
                      value: 20,
                      groupValue: question1Value,
                      onChanged: (value) {
                        setState(
                          () {
                            question1Value = value!;
                          },
                        );
                      },
                    ),
                    RadioListTile<int>(
                      title: const Text('No'),
                      value: 0,
                      groupValue: question1Value,
                      onChanged: (value) {
                        setState(() {
                          question1Value = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                        'Did you save water today?If yes how much(approximatly)'),
                    RadioListTile<int>(
                      title: const Text('Less than 2L'),
                      value: 20,
                      groupValue: question2Value,
                      onChanged: (value) {
                        setState(() {
                          question2Value = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: const Text('More than 2L'),
                      value: 0,
                      groupValue: question2Value,
                      onChanged: (value) {
                        setState(() {
                          question2Value = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text('Did you save a meal from being wasted today?'),
                    RadioListTile<int>(
                      title: const Text('Yes'),
                      value: 20,
                      groupValue: question3Value,
                      onChanged: (value) {
                        setState(() {
                          question3Value = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: const Text('No'),
                      value: 0,
                      groupValue: question3Value,
                      onChanged: (value) {
                        setState(() {
                          question3Value = value!;
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
// initialize the questionnaire
                setState(() {
                  question1Value = null;
                  question2Value = null;
                  question3Value = null;
                });

                Navigator.of(context).pop();
              },
              child: const Text('Cancel'), //close the Questionnaire
            ),

//add/updating the values of the questions to the database
            TextButton(
              onPressed: () async {
                final sp = await SharedPreferences.getInstance();
                
                int total = question1Value! + question2Value! + question3Value!;

                // ignore: non_constant_identifier_names
                bool newDataReady = await _newDataReady(today);
                if (newDataReady == true) {
                  await sp.setInt('Steps',0);
                  await sp.setInt('Distance',0);
                  await sp.setInt('Activity',0);
                  LoS = _computeLoS(0, 0, 0, total);

                } else {
                int? steps = sp.getInt('Steps');
                int? distance = sp.getInt('Distance');
                int? activityTime = sp.getInt('Activity');
                  LoS = _computeLoS(steps!, distance!, activityTime!, total);
                }

                //Shared pref for total questionnaire
                if (newDataReady ==  false) {
                  Future<void> totalquestion() async {
                    final sp = await SharedPreferences.getInstance();
                    sp.setInt('Total_Q', total);

                  }
                  totalquestion();
                } else {
                  Future<void> totalquestion() async {
                    final sp = await SharedPreferences.getInstance();
                    sp.setInt('Total_Q', 0);

                  }

                  totalquestion();
                }

                //if it's a new day insert new data otherwise update the current value in the database
                // ignore: unrelated_type_equality_checks
                if (newDataReady == true) {
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .insertAnswers(Questionnaire(1, today, question1Value!,
                          question2Value!, question3Value!, total));
                  //INSERT the New Value of LoS
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .insertAchievements(Achievements(1, today, LoS));
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .insertData(StatisticsData(1, today, 0, 0, 0));
                } else {
                      // int? steps = sp.getInt('Steps');
                      // int? distance = sp.getInt('Distance');
                      // int? activityTime = sp.getInt('Activity');
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .updateAnswers(Questionnaire(1, today, question1Value!,
                          question2Value!, question3Value!, total));
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .updateAchievements(Achievements(1, today, LoS));
                  // await Provider.of<DatabaseRepository>(context, listen: false)
                  //     .updateData(StatisticsData(
                  //         1, today, steps!, distance!, activityTime!));
                }

// initialize the questionnaire
                setState(() {
                  question1Value = null;
                  question2Value = null;
                  question3Value = null;
                });
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _OnLogoutTapConfirm(BuildContext context) {
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        final userPreferences = await SharedPreferences.getInstance();
        await userPreferences.setBool('Rememeber_login', false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
        // Must be changed to point at the current page
      },
      style: Constants.TextButtonStyle_Alert,
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        //cancelButton,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Hero!'),
        backgroundColor: Constants.primaryColor,
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

//end Drawer

      body: Column(
        children: [
          // viewing the air quality map by Airly
          const SizedBox(
            width: 1000,
            height: 264,
            child: WebView(
              initialUrl: 'https://airly.org/map/en/',
              javascriptMode: JavascriptMode.unrestricted,
            ),
          ),
          const SizedBox(height: 30),

          Row(
            children: [
              // showing the Questionnaire whenever the user tap on Los
              GestureDetector(onTap: () {
                _showQuestionnaire();
              }, child:
                  Consumer<DatabaseRepository>(builder: (context, dbr, child) {
                List<Achievements> initialData = [Achievements(0, '0000', 0)];

                return FutureBuilder(
                  future: dbr.userAllSingleAchievemnts(1),
                  initialData: initialData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data as List<Achievements>;
                      if (data.length == 0) {
                        FLoS = 0.0;
                      } else {
                        double FLoS = _reachedLoS(data) as double;

                        //a class to store the number of trees
                        Future<void> updateTrees() async {
                          Trees = FLoS ~/ 0.01;
                          final sp = await SharedPreferences.getInstance();
                          sp.setInt('trees', Trees);
                          sp.setDouble('FLoS', FLoS);
                        }

                        updateTrees();

                        // a class to and update the number of trees

                        Future<void> getTreesValue() async {
                          final sp = await SharedPreferences.getInstance();
                          final storedTrees = sp.getInt('trees');
                          if (storedTrees != null) {
                            setState(() {
                              Trees = storedTrees;
                            });
                          }
                        }

                        getTreesValue();

                        return SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularPercentIndicator(
                            radius: 80.0,
                            lineWidth: 12.0,
                            animation: true,
                            percent: FLoS,
                            center: Text(
                              '${(FLoS * 100).toStringAsFixed(2)}%',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20.0),
                            ),
                            footer: const Text(
                              "LoS",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17.0),
                            ),
                            circularStrokeCap: CircularStrokeCap.round,
                            progressColor: Color.fromARGB(255, 19, 184, 24),
                          ),
                        );
                      }
                    }

                    return CircularProgressIndicator();
                  },
                );
              })),

              const SizedBox(width: 10),
              SizedBox(
                width: 200,
                height: 200,
                child: Center(
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      color: Color.fromARGB(255, 82, 153, 1),
                      fontSize: 25,
                    ),
                    child: AnimatedTextKit(
                      repeatForever: true,
                      isRepeatingAnimation: true,
                      animatedTexts: [
                        TyperAnimatedText('Tap on LoS'),
                        TyperAnimatedText('To update'),
                        TyperAnimatedText('Your Sustainability Level.'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              SizedBox(
                width: 200,
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 190,
                      height: 50,
                      child: Text(
                        'help the world to improve by planting more trees!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15.0),
                      ),
                    ),

                    SizedBox(
                      width: 185,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 23, 178, 41),
                          borderRadius:
                              BorderRadius.circular(30), //border corner radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), //color of shadow
                              spreadRadius: 5, //spread radius
                              blurRadius: 7, // blur radius
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Total Trees Planted: $Trees',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                              color: Colors
                                  .white, // Optionally change the text color
                            ),
                          ),
                        ),
                      ),
                    ),

                    //
                  ],
                ),
              ),
              const SizedBox(
                  width: 10), // Add some spacing between the containers
              Container(
                height: 200,
                width: 200,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://us.123rf.com/450wm/3djuice/3djuice2109/3djuice210900073/173812664-reforestation-abstract-concept-vector-illustration.jpg?ver=6')),
                ),
              ),
            ],
          ),
        ],
      ),
      //),
    );
  }
}

int _computeLoS(
    int dailySteps, int dailyDistance, int dailyActivitytime, int total) {
  // Defining of weights
  double ansW = 1;
  double stepsW = 0.01;
  double distW = 0.005;
  double timeW = 0.02;

  // int malus = -50; //for example

  // as a sum of int, round is not necessary (for now BUT in the future...)
  num weightedSum = total * ansW +
      dailySteps * stepsW +
      dailyDistance * distW +
      dailyActivitytime * timeW;
  int result = weightedSum.toInt();

  // if you didn't recorded anything, you'll get a malus
  if (result == 0) {
    return result;
  }
  // Otherwise, good job!
  else {
    return result;
  }
}

double _reachedLoS(List<Achievements> data) {
  // basically the sum of allll the LoS recorded by the user
  double out = 0;
  for (int i = 0; i <= data.length - 1; i++) {
    out += data[i].levelOfSustainability;
    out = out / 10000.0;
  }
  return out;
}
