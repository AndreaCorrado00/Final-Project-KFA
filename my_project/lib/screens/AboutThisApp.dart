import 'package:flutter/material.dart';
import 'package:my_project/screens/HomePage.dart';
import 'package:my_project/utils/constants.dart';
import 'package:my_project/screens/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/screens/LoginPage.dart';

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
      //body: TO BE IMPLEMENTED
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
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
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

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }
} //About this app 