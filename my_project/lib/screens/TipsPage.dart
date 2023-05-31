// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_project/screens/HomePage.dart';
import 'package:my_project/screens/StatisticsPage.dart';


//import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_project/utils/constants.dart';
import 'package:my_project/Database/Advice_Database.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

// Using DateTime to read the date
DateTime _today = DateTime.now();
//DateTime _yesterday=DateTime.now().subtract(Duration(days:1));
String _today_str = DateFormat.d().format(_today);
int today = int.parse(_today_str);
int cur_id = today % Cur_ln;
int rep_id = today % Rep_ln;
int adv_id = today % Adv_ln;
int sta_id = today % Sta_ln;




class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  TipsPageState createState() => TipsPageState();
}

class TipsPageState extends State<TipsPage> {
  //-------------- Index for the state
  int _selectedIndex = 1;
  


  // void _changeOpacity() {
  //   setState(() => _opacityLevel = _opacityLevel == 0 ? 0.0 : 1.0);
  // }
  

  static const routename = 'TipsPage';
  @override
  Widget build(BuildContext context) {
    
    // Future<List<int>> today_id=_todayIndex(today);
    // Future<int> cur_id = today_id[];

    print('${TipsPageState.routename} built');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        title: Text('Advice and Tips'),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Constants.primaryLightColor,
      body:  ListView(
        padding: EdgeInsets.all(30),
        children: [
          Animate(
            effects: Constants.Fade_effect_options,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                height:  double.parse(Curiosities[cur_id]['big_cont_h']),
                color: Constants.containerColor,
                child: Column(children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'New daily curiosity',
                      style: Constants.Tips_Title_style,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                        // ignore: prefer_const_literals_to_create_immutables
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          width: 220,
                          height:  double.parse(Curiosities[cur_id]['child_cont_h']),
                          child: Text(
                            Curiosities[cur_id]['text'],
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(width: 15),
                        Image(image: NetworkImage(
                              'https://img.freepik.com/premium-vector/marketing-research-illustration_335657-4800.jpg',
                              scale: 6)),
                        
                        ]),
                    Align(alignment: Alignment(-0.95,1),
                        child:TextButton(
                            onPressed: () async {
                              //final daily_constants = await SharedPreferences.getInstance();
                              //int? id=daily_constants.getInt('today_index') !% 17;
                              final Uri cur_url =
                                  Uri.parse(Curiosities[cur_id]['url']);
                              launchUrl(cur_url);},
                            child: Text('Learn more',
                              style: Constants.Url_Button_style,))),]))
          ),),
          SizedBox(height: 25),
          Animate(
            effects: Constants.Fade_effect_options,
            child:ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                height: 200,
                color: Constants.containerColor,
                child: Column(children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'New daily recipe for you',
                      style: Constants.Tips_Title_style,
                    ),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                        // ignore: prefer_const_literals_to_create_immutables
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          width: 215,
                          height: 105,
                          child: Text(
                           'We have selected this recipe for you: ' + Recipes[rep_id]['text'] + '. Will you try it?',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(width: 15),
                        Image(image: NetworkImage(Recipes[rep_id]['image'],
                              scale: 7)),
                        
                        ]),
                    Align(alignment: Alignment(-0.95,1),
                        child:TextButton(
                            onPressed: () async {
                              //final daily_constants = await SharedPreferences.getInstance();
                              //int? id=daily_constants.getInt('today_index') !% 17;
                              final Uri rep_url =
                                  Uri.parse(Recipes[rep_id]['url']);
                              launchUrl(rep_url);},
                            child: Text('Let\'s cook',
                              style: Constants.Url_Button_style,))),]))
          ),),
          SizedBox(height: 25),
          Animate(
            effects: Constants.Fade_effect_options,
            child:ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                height: 200,
                color: Constants.containerColor,
                child: Column(children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Every day a small step forward',
                      style: Constants.Tips_Title_style,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                        // ignore: prefer_const_literals_to_create_immutables
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          width: 220,
                          height: 105,
                          child: Text(
                            'What can you concretely do? Today we leave you this advice: ' + Adivices[adv_id]['text']+ '. Try to do it!',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(width: 15),
                        Image(image: NetworkImage(
                              'https://img.freepik.com/premium-vector/social-network-monitoring-illustration_335657-4667.jpg',
                              scale: 6)),
                        
                        ]),
                    Align(alignment: Alignment(-0.95,1),
                        child:TextButton(
                            onPressed: () async {
                              //final daily_constants = await SharedPreferences.getInstance();
                              //int? id=daily_constants.getInt('today_index') !% 17;
                              final Uri adv_url =
                                  Uri.parse(Adivices[adv_id]['url']);
                              launchUrl(adv_url);},
                            child: Text('Tell me more',
                              style: Constants.Url_Button_style,))),]))
          ),),
          SizedBox(height: 25),
          Animate(
            effects: Constants.Fade_effect_options,
            child:ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                height: 200,
                color: Constants.containerColor,
                child: Column(children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Stay informed, stay sustainable',
                      style: Constants.Tips_Title_style,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                        // ignore: prefer_const_literals_to_create_immutables
                        Container(
                          padding: EdgeInsets.only(left: 15),
                          width: 220,
                          height: 105,
                          child: Text(
                            'Do you know? ' + Statistics[sta_id]['text']+ '.',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(width: 15),
                        Image(image: NetworkImage(
                              'https://img.freepik.com/premium-vector/social-media-dashboard-abstract-concept-illustration_335657-4875.jpg?w=740',
                              scale: 7)),
                        
                        ]),
                    Align(alignment: Alignment(-0.95,1),
                        child:TextButton(
                            onPressed: () async {
                              //final daily_constants = await SharedPreferences.getInstance();
                              //int? id=daily_constants.getInt('today_index') !% 17;
                              final Uri sta_url =
                                  Uri.parse(Statistics[sta_id]['url']);
                              launchUrl(sta_url);},
                            child: Text('More about',
                              style: Constants.Url_Button_style,))),]))
          ),),
        ],
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.tips_and_updates),
      //       label: 'Advice and Tips',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.insights),
      //       label: 'Statistics',
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   backgroundColor: Constants.primaryColor,
      //   selectedItemColor: Constants.secondarylightColor,
      //   selectedFontSize: 14.0,
      //   type: BottomNavigationBarType.fixed,
      //   onTap: (int index) {
      //     switch (index) {
      //       case 0:
      //         Navigator.of(context).pushReplacement(MaterialPageRoute(
      //             builder: (context) => const HomeScreen()));
      //       break;
      //       case 1:
      //         if (index != 1) {
      //           Navigator.of(context).pushReplacement(
      //               MaterialPageRoute(builder: (context) => const TipsPage()));
      //         } else {
      //           print('still in the Statistics page ');
      //         }


      //       break;
      //       case 2:
      //         Navigator.of(context).pushReplacement(MaterialPageRoute(
      //             builder: (context) => const StatisticsPage()));

      //         // Probably in this case you have to put an if: if the index is not pointing the home and you are in the case of the home, return to home
      //         break;
      //     }

      //     //_changeOpacity();

      //     setState(
      //       () {
      //         _selectedIndex = index;
             
      //       },
      //     );
      //   },
      // ),
    );
  }

// Future<List<int>> _todayIndex(int today)async{

// final daily_constants = await SharedPreferences.getInstance();
// final int? current_day=daily_constants.getInt('today');

// if(today != current_day ){
//   await daily_constants.setInt('today',today);
//   int ran_daily_index=Random().nextInt(100)+1;
//   //await daily_constants.setInt('today_index', ran_daily_index );
//   List<int> out=[ran_daily_index%Cur_ln, ran_daily_index%Rep_ln,ran_daily_index%Adv_ln,ran_daily_index%Sta_ln];
//   return out;}
//   else{return [1,1,1,1];}
// }
}
