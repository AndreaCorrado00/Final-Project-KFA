import 'package:flutter/material.dart';
import 'package:my_project/screens/HomePage.dart';
import 'package:my_project/utils/constants.dart';
import 'package:my_project/screens/ProfilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/screens/LoginPage.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
                height:  400,
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
                  child: Container(
                    color: Constants.secondarylightColor,
                          padding: EdgeInsets.only(left: 15),
                          width: 350,
                          height:  320,
                          child: const Text(
                            'this is a possibility, but i think that an image inside the text could be better',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.left,
                          ),
                        ),),]
                        ) )
          ),),

          ],),

// Row(
                  //   children: [
                  //       // ignore: prefer_const_literals_to_create_immutables
                  //       Container(
                  //         padding: EdgeInsets.only(left: 15),
                  //         width: 220,
                  //         height:  350,
                  //         child: Text(
                  //           'bla bla bla',
                  //           style: TextStyle(fontSize: 16),
                  //           textAlign: TextAlign.left,
                  //         ),
                  //       ),
                  //       SizedBox(width: 15),
                  //       Image(image: NetworkImage(
                  //             'https://img.freepik.com/premium-vector/marketing-research-illustration_335657-4800.jpg',
                  //             scale: 6)),
                        
                  //       ]),

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