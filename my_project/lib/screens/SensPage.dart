import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

// ignore: camel_case_types
class SensPage extends StatefulWidget {
  const SensPage({super.key});

  @override
  State<StatefulWidget> createState() => Sens_page();
}

// ignore: camel_case_types
class Sens_page extends State<SensPage> {
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
                const Text('Question 1'),
                RadioListTile<int>(
                  title: const Text('Option 1'),
                  value: 1,
                  groupValue: question1Value,
                  onChanged: (value) {
                    setState(() {
                      question1Value = value;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: const Text('Option 2'),
                  value: 2,
                  groupValue: question1Value,
                  onChanged: (value) {
                    setState(() {
                      question1Value = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Question 2'),
                RadioListTile<int>(
                  title: const Text('Option 1'),
                  value: 1,
                  groupValue: _question2Value,
                  onChanged: (value) {
                    setState(() {
                      _question2Value = value;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: const Text('Option 2'),
                  value: 2,
                  groupValue: _question2Value,
                  onChanged: (value) {
                    setState(() {
                      _question2Value = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Text('Question 3'),
                RadioListTile<int>(
                  title: const Text('Option 1'),
                  value: 1,
                  groupValue: _question3Value,
                  onChanged: (value) {
                    setState(() {
                      _question3Value = value;
                    });
                  },
                ),
                RadioListTile<int>(
                  title: const Text('Option 2'),
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
                      builder: (context) => const SensPage(
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
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      // decoration: const BoxDecoration(color: Color.fromRGBO(200, 230, 201, 1)),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _showQuestionnaire,
              child: CircularPercentIndicator(
                radius: 120.0,
                lineWidth: 13.0,
                animation: true,
                percent: 0.7,
                center: const Text(
                  "70.0%",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
                footer: const Text(
                  "Level Of Sustainability",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.0),
                ),
                circularStrokeCap: CircularStrokeCap.round,
                progressColor: const Color.fromARGB(255, 48, 108, 17),
              ),
            ),
          ]),
    );
  }
}
