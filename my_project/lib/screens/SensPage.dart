import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:intl/intl.dart';
import 'package:my_project/Database/entities/achievements.dart';
import 'package:my_project/Database/entities/questionnaire.dart';
import 'package:my_project/Database/entities/statisticsData.dart';
import 'package:my_project/main.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart'; // to view the map
import 'package:my_project/utils/constants.dart';
import '../Database/repositries/appDatabaseRepository.dart';
import 'AboutThisApp.dart';
import 'package:provider/provider.dart';

//initialize the question value (to be assigned later)
int? question1Value;
int? question2Value;
int? question3Value;

class SensPage extends StatefulWidget {
  const SensPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => Sens_page();
}

class Sens_page extends State<SensPage> {
  //initialize FLoS/Trees/LoS
  double FLoS = 0.0;
  var Trees = 0;
  var LoS = 0;

//check if the date is changed or not
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

//create a async function to show the questionnaire alert
  void _showQuestionnaire() async {
    // Get the current date
    final currentDate = DateTime.now()
        .subtract(Duration(days: 1)); // once assigned can be changed
    final today = DateFormat('yyyy-MM-dd').format(currentDate);

    //define the questions and the responses values
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Questionnaire'),
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
// initialize the question values after clicking on cancel
                setState(() {
                  question1Value = null;
                  question2Value = null;
                  question3Value = null;
                });

                Navigator.of(context).pop();
              },
              child: const Text('Cancel'), //close the Questionnaire
            ),
            TextButton(
              onPressed: () async {
                // call the sp : Shared Preferences
                final sp = await SharedPreferences.getInstance();
                //calculate the total value obtained by the questionnaire
                int total = question1Value! + question2Value! + question3Value!;

                bool newDataReady = await _newDataReady(today);
                if (newDataReady == true) {
                  //if the date is changed initialize all the activities values and calculate the new LoS
                  await sp.setInt('Steps', 0);
                  await sp.setInt('Distance', 0);
                  await sp.setInt('Activity', 0);
                  LoS = _computeLoS(0, 0, 0, total);
                } else {
                  //if the date is not changed get all activities values from the shared preferenes and calculate the finale LoS
                  int? steps = sp.getInt('Steps');
                  int? distance = sp.getInt('Distance');
                  int? activityTime = sp.getInt('Activity');
                  LoS = _computeLoS(steps!, distance!, activityTime!, total);
                }

                //Shared pref for the total of questionnaire to be used in the statistics page also here if we have a new day the value stored have
                //to be initialized to 0.if the date sill the same set the value into the DB
                if (newDataReady == false) {
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
                if (newDataReady == true) {
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .insertAnswers(Questionnaire(1, today, question1Value!,
                          question2Value!, question3Value!, total));
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .insertAchievements(Achievements(1, today, LoS));
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .insertData(StatisticsData(1, today, 0, 0, 0));
                } else {
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .updateAnswers(Questionnaire(1, today, question1Value!,
                          question2Value!, question3Value!, total));
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .updateAchievements(Achievements(1, today, LoS));
                }

                // initialize the questionnaire
                setState(() {
                  question1Value = null;
                  question2Value = null;
                  question3Value = null;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

// the Logout function
  void _OnLogoutTapConfirm(BuildContext context) {
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        final sp = await SharedPreferences.getInstance();
        sp.setBool('isLoggedIn', false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp()));
        // Must be changed to point at the current page
      },
      style: Constants.TextButtonStyle_Alert,
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
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
  // build the Sens page UI
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Hero!'),
        backgroundColor: Constants.primaryColor,
      ),

      //drawer for : logout and about this app
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
              // showing the Questionnaire whenever the user tap on Los %
              GestureDetector(onTap: () {
                _showQuestionnaire();
              }, child:
                  //updating the LoS by obtaining the Achivements data stored in the DB
                  Consumer<DatabaseRepository>(builder: (context, dbr, child) {
                List<Achievements> initialData = [Achievements(0, '0000', 0)];

                return FutureBuilder(
                  future: dbr.userAllSingleAchievemnts(1),
                  initialData: initialData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data as List<Achievements>;
                      if (data.length == 0) {
                        FLoS = 0.0; // if we don't have data return FLoS = 0
                      } else {
                        double FLoS = _reachedLoS(data)
                            as double; // otherwise calculate the FinaL LoS after obtaining all the data

                        //store and update the number of trees, PS : to be used later
                        Future<void> updateTrees() async {
                          Trees = FLoS ~/
                              0.01; //every 1% we have a new planted tree
                          final sp = await SharedPreferences.getInstance();
                          sp.setInt('trees', Trees);
                          sp.setDouble('FLoS', FLoS);
                        }

                        updateTrees();

                        //update the number of trees

                        //get the number of trees

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
                        //showing the cicular percent indicator with the LoS value
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

                    return SizedBox(
                      width: 200,
                      height: 200,
                      child: Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(), //loading
                        ),
                      ),
                    );
                  },
                );
              })),
              // animated text
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
          const SizedBox(height: 8), // Add some spacing between the containers
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
                    //viewing the reached total numbers of trees
                    SizedBox(
                      width: 185,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 23, 178, 41),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
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
                              color: Colors.white,
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

//function to compute the total LoS

int _computeLoS(
    int dailySteps, int dailyDistance, int dailyActivitytime, int total) {
  // Defining of weights
  double ansW = 1;
  double stepsW = 0.01;
  double distW = 0.005;
  double timeW = 0.02;

  // as a sum of int, round is not necessary (for now BUT in the future...)
  num weightedSum = total * ansW +
      dailySteps * stepsW +
      dailyDistance * distW +
      dailyActivitytime * timeW;
  int result = weightedSum.toInt();

  // if you didn't recorded anything, you'll get a 0
  if (result == 0) {
    return result;
  }
  // Otherwise, good job!
  else {
    return result;
  }
}

//function to calculate the sum of the reached Level Of Suistainbiltity that were stored in DB
double _reachedLoS(List<Achievements> data) {
  double out = 0;
  for (int i = 0; i <= data.length - 1; i++) {
    out += data[i].levelOfSustainability;
  }
  out = out / 25000.0;
  return out;
}
