import 'package:flutter/material.dart';
import 'package:my_project/screens/HomePage.dart';
import 'package:my_project/utils/constants.dart';
import 'package:my_project/screens/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/screens/LoginPage.dart';

class AboutThisAppState extends StatefulWidget {
  const AboutThisAppState ({super.key});

  @override
  State<AboutThisAppState > createState() => AboutThisApp();
}

class AboutThisApp extends State<AboutThisAppState>{
  bool _visible=false;

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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  },
                  child: const Text('Profile'),
                ),
                Icon(
                  IconData(0xe491, fontFamily: 'MaterialIcons'),
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
                Icon(
                  IconData(0xe3b3, fontFamily: 'MaterialIcons'),
                  color: Constants.secondarylightColor,
                  size: 24.0,
                  semanticLabel: 'Text to announce in accessibility modes',
                ),
              ],
            ),
            SizedBox(
              width: 300,
              height: 1,
            ),
          ],
        ),
      ),





      backgroundColor: Constants.primaryLightColor,
      body:AnimatedOpacity(
        opacity: 1.0,
          duration: const Duration(seconds: 1),
          child: ListView(
          padding: EdgeInsets.all(30),
      
          children: [ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                height:  300,
                color: Constants.containerColor,
                child: Column(children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment(-0.9,0),
                    child: Text(
                      'Nice to meet you!',
                      style: Constants.Tips_Title_style,
                    ),
                  ),
                  SizedBox(height: 10,),
                  const Align(
                    alignment: Alignment(-0.85,0),
                    child:Text(
                      'We are ...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),]))),
                  SizedBox(height: 15,),
                ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                height:  300,
                color: Constants.containerColor,
                child: Column(children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment(-0.9,0),
                    child: Text(
                      'Why this app?',
                      style: Constants.Tips_Title_style,
                    ),
                  ),
                  SizedBox(height: 10,),
                  const Align(
                    alignment: Alignment(-0.85,0),
                    child:Text(
                      'The purpose of this app is ...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),]))),
                   SizedBox(height: 15,),
                ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
                height:  300,
                color: Constants.containerColor,
                child: Column(children: [
                  SizedBox(height: 10),
                  Align(
                    alignment: Alignment(-0.9,0),
                    child: Text(
                      'How to use this app?',
                      style: Constants.Tips_Title_style,
                    ),
                  ),
                  SizedBox(height: 10,),
                  const Align(
                    alignment: Alignment(-0.85,0),
                    child:Text(
                      'The app has ...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),])))
                  
                  ])),





      
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.home),
          onPressed: () {Navigator.push(context,MaterialPageRoute(builder: (context) => HomePageState()));},
          backgroundColor: Constants.secondaryColor,
          elevation: 0.0,
          splashColor: Constants.primaryLightColor,
          ),
    floatingActionButtonLocation:FloatingActionButtonLocation.endFloat,

    
      );
  
  } 
  
  
  void _OnLogoutTapConfirm(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePageState()));
      },
      style: Constants.TextButtonStyle_Alert,
    );
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