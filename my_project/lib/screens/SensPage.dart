import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:my_project/Database/entities/questionnaire.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart'; // to view the map
import 'package:my_project/utils/constants.dart';
import '../Database/repositries/appDatabaseRepository.dart';
import 'AboutThisApp.dart';
import 'LoginPage.dart';
import 'ProfilePage.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

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
  late DateTime lastSubmissionDate; // Store the last submission date

  @override
  void initState() {
    super.initState();

    // Initialize the last submission date
    lastSubmissionDate = DateTime.now();
  }

  void _showQuestionnaire() {
    // Get the current date
    final currentDate = DateTime.now(); // once assigned can be changed
    final todayDate = DateFormat('yyyy-MM-dd').format(lastSubmissionDate);

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
                      value: 1,
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
                      value: 2,
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
                      value: 1,
                      groupValue: question2Value,
                      onChanged: (value) {
                        setState(() {
                          question2Value = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: const Text('More than 2L'),
                      value: 2,
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
                      value: 1,
                      groupValue: question3Value,
                      onChanged: (value) {
                        setState(() {
                          question3Value = value!;
                        });
                      },
                    ),
                    RadioListTile<int>(
                      title: const Text('No'),
                      value: 2,
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
                int total = question1Value! + question2Value! + question3Value!;
                //if it's a new day insert new data otherwise update the current value in the data base
                if (currentDate.day != lastSubmissionDate.day ||
                    currentDate.month != lastSubmissionDate.month ||
                    currentDate.year != lastSubmissionDate.year) {
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .insertAnswers(Questionnaire(
                          1,
                          todayDate,
                          question1Value!,
                          question2Value!,
                          question3Value!,
                          total));
                } else {
                  await Provider.of<DatabaseRepository>(context, listen: false)
                      .updateAnswers(Questionnaire(
                          1,
                          todayDate,
                          question1Value!,
                          question2Value!,
                          question3Value!,
                          total));
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

  // ignore: non_constant_identifier_names
  void _OnLogoutTapConfirm(BuildContext context) {
    // set up the buttons

    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfilePage()));
      },
      style: Constants.TextButtonStyle_Alert,
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () async {
        final user_preferences = await SharedPreferences.getInstance();
        await user_preferences.setBool('Rememeber_login', false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SensPage()));
        // Must be changed to point at the current page
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
              GestureDetector(
                onTap: () {
                  _showQuestionnaire();
                },
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 12.0,
                    animation: true,
                    percent: 0.7,
                    center: const Text(
                      "70.0%",
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
                ),
              ),
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
                        'help the world to improve air quality by planting more trees!',
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
                        child: const Center(
                          child: Text(
                            'Total Trees Planted: 10',
                            textAlign: TextAlign.center,
                            style: TextStyle(
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
