import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:my_project/utils/impact.dart';
import 'package:my_project/models/steps.dart';

Future<int?> _authorize() async {
  //Create the request
  final url = Impact.baseUrl + Impact.tokenEndpoint;
  final body = {'username': Impact.username, 'password': Impact.password};

  //Get the response
  print('Calling: $url');
  final response = await http.post(Uri.parse(url), body: body);

  //If 200, set the token
  if (response.statusCode == 200) {
    final decodedResponse = jsonDecode(response.body);
    final sp = await SharedPreferences.getInstance();
    sp.setString('access', decodedResponse['access']);
    sp.setString('refresh', decodedResponse['refresh']);
  } //if

  //Just return the status code
  return response.statusCode;
} //_authorize

//This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
Future<List<Steps>?> _requestData() async {
  //Initialize the result
  List<Steps>? result;

  //Get the stored access token (Note that this code does not work if the tokens are null)
  final sp = await SharedPreferences.getInstance();
  var access = sp.getString('access');

  //If access token is expired, refresh it
  if (JwtDecoder.isExpired(access!)) {
    await _refreshTokens();
    access = sp.getString('access');
  } //if

  //Create the (representative) request
  final day = '2023-04-04';
  final url = Impact.baseUrl +
      Impact.stepsEndpoint +
      Impact.patientUsername +
      '/day/$day/';
  final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

  //Get the response
  print('Calling: $url');
  final response = await http.get(Uri.parse(url), headers: headers);

  //if OK parse the response, otherwise return null
  if (response.statusCode == 200) {
    final decodedResponse = jsonDecode(response.body);
    result = [];
    for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
      result.add(Steps.fromJson(
          decodedResponse['data']['date'], decodedResponse['data']['data'][i]));
    } //for
  } //if
  else {
    result = null;
  } //else

  //Return the result
  return result;
} //_requestData

//This method allows to obtain the JWT token pair from IMPACT and store it in SharedPreferences
Future<int> _refreshTokens() async {
  //Create the request
  final url = Impact.baseUrl + Impact.refreshEndpoint;
  final sp = await SharedPreferences.getInstance();
  final refresh = sp.getString('refresh');
  final body = {'refresh': refresh};

  //Get the respone
  print('Calling: $url');
  final response = await http.post(Uri.parse(url), body: body);

  //If 200 set the tokens
  if (response.statusCode == 200) {
    final decodedResponse = jsonDecode(response.body);
    final sp = await SharedPreferences.getInstance();
    sp.setString('access', decodedResponse['access']);
    sp.setString('refresh', decodedResponse['refresh']);
  } //if

  //Return just the status code
  return response.statusCode;
}

class SensPage extends StatefulWidget {
  SensPage({super.key});

  @override
  State<StatefulWidget> createState() => Sens_page();
}

class Sens_page extends State<SensPage> {
//verification de l'authenticitè
  bool _isAuthorized = false;
  String steps = '';
  // attention! need to refresh the token

  @override
  void initState() {
    super.initState();
    _authorize().then((result) async {
      if (result == 200) {
        setState(() {
          _isAuthorized = true;
        });

        final stepsdata = await _requestData();
        setState(() {
          steps = stepsdata.toString();
        });
      }
    });
  }

  void _showQuestionnaire() {
    int? question1Value = 3;
    int? _question2Value = 3;
    int? _question3Value = 3;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Questionnaire'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const Text('Did you use public transportation today?'),
                RadioListTile<int>(
                  title: const Text('Yes'),
                  value: 1,
                  groupValue: question1Value,
                  onChanged: (value) {
                    setState(() {
                      question1Value = value;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: const Text('No'),
                  value: 2,
                  groupValue: question1Value,
                  onChanged: (value) {
                    setState(() {
                      question1Value = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                    'Did you save water today?If yes how much(approximatly)'),
                RadioListTile<int>(
                  title: const Text('Less than 2L'),
                  value: 1,
                  groupValue: _question2Value,
                  onChanged: (value) {
                    setState(() {
                      _question2Value = value;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: const Text('More than 2L'),
                  value: 2,
                  groupValue: _question2Value,
                  onChanged: (value) {
                    setState(() {
                      _question2Value = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Did you save a meal from being wasted today?'),
                RadioListTile<int>(
                  title: const Text('Yes'),
                  value: 1,
                  groupValue: _question3Value,
                  onChanged: (value) {
                    setState(() {
                      _question3Value = value;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: const Text('No'),
                  value: 2,
                  groupValue: _question3Value,
                  onChanged: (value) {
                    setState(() {
                      _question3Value = value;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SensPage(
                          // question1: question1Value,
                          //question2: _question2Value,
                          //question3: _question3Value,
                          )),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          _showQuestionnaire();
        },
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  SizedBox(height: 50),
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(20.0),
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(40.0),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(
                        maxWidth: 380,
                        maxHeight: 100,
                      ),
                      color: Color.fromARGB(255, 206, 191, 54),
                      child: const DefaultTextStyle(
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontStyle: FontStyle.italic,
                        ),
                        child: Text(''),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  GestureDetector(
                    onTap: () {
                      // Handle tap event for the first ClipRRect
                      print('First ClipRRect tapped');
                    },
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(20.0),
                        bottomRight: Radius.circular(30.0),
                        bottomLeft: Radius.circular(40.0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        constraints: const BoxConstraints(
                          maxWidth: 380,
                          maxHeight: 100,
                        ),
                        color: const Color.fromARGB(255, 206, 191, 54),
                        child: DefaultTextStyle(
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 17.0,
                            fontStyle: FontStyle.italic,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              RotateAnimatedText('What is Sustainability?',
                                  duration: const Duration(seconds: 2)),
                              RotateAnimatedText('why is it so important?',
                                  duration: const Duration(seconds: 2)),
                              RotateAnimatedText(
                                  '   Sustainability is our society\'s ability to exist and develop without',
                                  duration: const Duration(seconds: 5)),
                              RotateAnimatedText(
                                  '   depleting all of the natural resources needed to live in the future.',
                                  duration: const Duration(seconds: 5)),
                            ],
                            onTap: () {
                              print("Tap Event");
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child:
                  //[
                  SizedBox(
                width: 200,
                height: 180,
                //color: Colors.blue,
                // child: Text('Additional Widget'),
                child: CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 12.0,
                  animation: true,
                  percent: 0.7,
                  center: Text(
                    '$steps',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                  footer: new Text(
                    '',
                    style: new TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 17.0),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                  progressColor: Color.fromARGB(255, 29, 131, 56),
                ),
              ),
              // ],
            ),
            SizedBox(
              height: 200,
              child: LinearPercentIndicator(
                width: 300.0,
                alignment: MainAxisAlignment.center,
                lineHeight: 20.0,
                percent: 0.5,
                center: const Text(
                  "50",
                  style: TextStyle(fontSize: 12.0),
                ),
                trailing: Icon(Icons.nature),
                linearStrokeCap: LinearStrokeCap.roundAll,
                backgroundColor: Color.fromARGB(255, 251, 237, 92),
                progressColor: Color.fromARGB(255, 183, 175, 23),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
