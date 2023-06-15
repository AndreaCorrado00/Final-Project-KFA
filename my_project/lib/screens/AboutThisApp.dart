import 'package:flutter/material.dart';
import 'package:my_project/screens/HomePage.dart';
import 'package:my_project/utils/constants.dart';
import 'package:my_project/screens/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/screens/LoginPage.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:my_project/utils/aboutTexts.dart';

class AboutThisAppState extends StatefulWidget {
  const AboutThisAppState({super.key});

  @override
  State<AboutThisAppState> createState() => AboutThisApp();
}

class AboutThisApp extends State<AboutThisAppState> {
  static const routename = 'AboutThisApp';



  @override
  Widget build(BuildContext context) {
    print('${AboutThisApp.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: const Text('About this App'),
        backgroundColor: Constants.primaryColor,
        automaticallyImplyLeading: false,
      ),

      // drawer: Drawer(
      //   backgroundColor: Constants.secondaryColor,
      //   child: Column(
      //     children: [
      //       SizedBox(
      //         height: 100,
      //       ),
      //       Row(
      //         children: [
      //           TextButton(
      //             style: Constants.TextButtonStyle_Drawer,
      //             onPressed: () {
      //               Navigator.push(context,
      //                   MaterialPageRoute(builder: (context) => ProfilePage()));
      //             },
      //             child: const Text('Profile'),
      //           ),
      //           Icon(
      //             IconData(0xe491, fontFamily: 'MaterialIcons'),
      //             color: Constants.secondarylightColor,
      //             size: 24.0,
      //           ),
      //         ],
      //       ),
      //       SizedBox(
      //         width: 300,
      //         height: 1,
      //       ),
      //       Row(
      //         children: [
      //           TextButton(
      //             style: Constants.TextButtonStyle_Drawer,
      //             onPressed: () {
      //               Navigator.push(
      //                   context,
      //                   MaterialPageRoute(
      //                       builder: (context) => AboutThisAppState()));
      //             },
      //             child: const Text('About this App'),
      //           ),
      //           Icon(
      //             Icons.help_outline,
      //             color: Constants.secondarylightColor,
      //             size: 24.0,
      //           ),
      //         ],
      //       ),
      //       SizedBox(
      //         width: 300,
      //         height: 1,
      //       ),
      //       Row(
      //         children: [
      //           TextButton(
      //             style: Constants.TextButtonStyle_Drawer,
      //             onPressed: () {
      //               _OnLogoutTapConfirm(context);
      //             },
      //             child: const Text('Logout'),
      //           ),
      //           Icon(
      //             IconData(0xe3b3, fontFamily: 'MaterialIcons'),
      //             color: Constants.secondarylightColor,
      //             size: 24.0,
      //             semanticLabel: 'Text to announce in accessibility modes',
      //           ),
      //         ],
      //       ),
      //       SizedBox(
      //         width: 300,
      //         height: 1,
      //       ),
      //     ],
      //   ),
      // ),


      backgroundColor: Constants.primaryLightColor,
      body: ListView(
        padding: EdgeInsets.all(30),
        children: [

          Animate(
            effects: Constants.Fade_effect_options,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                height:  350,
                color: Constants.containerColor,
                child: Column(children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Nice to meet you!',
                      style: Constants.Tips_Title_style,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                  alignment: Alignment.center,
                  child: 
                  Row(
                    children: [
                        // ignore: prefer_const_literals_to_create_immutables
                        Container(
                          //color: Color.fromARGB(255, 240, 241, 233),
                          padding: EdgeInsets.only(left: 15),
                          width: 180,
                          height:  150,
                          child: Text(
                            niceToMeetYou['little'],
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(width: 15),
                        Image(image: NetworkImage(
                              'https://img.freepik.com/free-vector/foreign-language-workshop-illustration_335657-4784.jpg?w=740&t=st=1686848716~exp=1686849316~hmac=67674298e19d6fdbebd3686a4aa60c9e186bd5fcd8193b296e6c78b3bba30726',
                              scale: 5)),
                    ]
                  ),
                  ),
                  Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    //color: Color.fromARGB(255, 240, 241, 233),
                          padding: EdgeInsets.only(left: 15),
                          width: 340,
                          height:  140,
                          child: Text(
                            niceToMeetYou['bigger'],
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),),
                ]
                )
            )
            ) 
          ),
          SizedBox(height: 20,),
          Animate(
            effects: Constants.Fade_effect_options,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                height:  370,
                color: Constants.containerColor,
                child: Column(children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Why this app?',
                      style: Constants.Tips_Title_style,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                  alignment: Alignment.center,
                  child: 
                  Row(
                    children: [
                        // ignore: prefer_const_literals_to_create_immutables
                        Container(
                          //color: Color.fromARGB(255, 240, 241, 233),
                          padding: EdgeInsets.only(left: 15),
                          width: 180,
                          height:  150,
                          child: Text(
                            whyThisApp['little'],
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(width: 15),
                        Image(image: NetworkImage(
                              'https://img.freepik.com/premium-vector/job-seekers-illustration_335657-4659.jpg?w=740',
                              scale: 5)),
                    ]
                  ),
                  ),
                  Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    //color: Color.fromARGB(255, 240, 241, 233),
                          padding: EdgeInsets.only(left: 15),
                          width: 340,
                          height:  170,
                          child: Text(
                            whyThisApp['bigger'],
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),),
                ]
                )
            )
            ) 
          ),
          SizedBox(height: 20,),
          Animate(
            effects: Constants.Fade_effect_options,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                height:  450,
                color: Constants.containerColor,
                child: Column(children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'What will you find here?',
                      style: Constants.Tips_Title_style,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                  alignment: Alignment.center,
                  child: 
                  Row(
                    children: [
                        // ignore: prefer_const_literals_to_create_immutables
                        Container(
                          //color: Color.fromARGB(255, 240, 241, 233),
                          padding: EdgeInsets.only(left: 15),
                          width: 180,
                          height:  152,
                          child: Text(
                            whatInside['little'],
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(width: 15),
                        Image(image: NetworkImage(
                              'https://img.freepik.com/free-vector/big-data-analytics-abstract-concept-illustration_335657-4860.jpg?w=740&t=st=1686848874~exp=1686849474~hmac=85713165195f76925a9fa57d6f74709ec7058b9ed2ebe6a70d86cd2befa848b1',
                              scale: 5)),
                    ]
                  ),
                  ),
                  Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    //color: Color.fromARGB(255, 240, 241, 233),
                          padding: EdgeInsets.only(left: 15),
                          width: 340,
                          height:  230,
                          child: Text(
                            whatInside['bigger'],
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),),
                ]
                )
            )
            ) 
          ),
          SizedBox(height: 20,),
          Animate(
            effects: Constants.Fade_effect_options,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                height:  390,
                color: Constants.containerColor,
                child: Column(children: [
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Measure your improvements!',
                      style: Constants.Tips_Title_style,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                  alignment: Alignment.center,
                  child: 
                  Row(
                    children: [
                        // ignore: prefer_const_literals_to_create_immutables
                        Container(
                          //color: Color.fromARGB(255, 240, 241, 233),
                          padding: EdgeInsets.only(left: 15),
                          width: 180,
                          height:  150,
                          child: Text(
                            levelOfSustainability['little'],
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(width: 15),
                        Image(image: NetworkImage(
                              'https://img.freepik.com/premium-vector/teamwork-power-illustration_335657-4717.jpg?w=740',
                              scale: 5)),
                    ]
                  ),
                  ),
                  Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    //color: Color.fromARGB(255, 240, 241, 233),
                          padding: EdgeInsets.only(left: 15),
                          width: 340,
                          height:  170,
                          child: Text(
                            levelOfSustainability['bigger'],
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),),
                ]
                )
            )
            ) 
          ),
      
        ]
      ),


      floatingActionButton: FloatingActionButton(

        child: const Icon(Icons.home),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        },
        backgroundColor: Constants.secondaryColor,
        elevation: 0.0,
        splashColor: Constants.primaryLightColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  } //build

  void _OnLogoutTapConfirm(BuildContext context) {
    // set up the buttons
   
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        _Logout(context);
      },
      style: Constants.TextButtonStyle_Alert,
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Are you sure you want to logout?"),
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

  void _Logout(dynamic context) async {
    final user_preferences = await SharedPreferences.getInstance();
    // ignore: await_only_futures
    await user_preferences.remove('Rememeber_login');
    print('Into _Logout');
    print(await user_preferences.getBool('Rememeber_login'));
    Navigator.pop(context);

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
  }
} //About this app 

