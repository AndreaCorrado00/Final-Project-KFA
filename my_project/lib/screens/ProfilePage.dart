// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:my_project/screens/AboutThisApp.dart';
import 'package:my_project/screens/HomePage.dart';
import 'package:my_project/screens/LoginPage.dart';
import 'package:my_project/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  static const routename = 'ProfileScreen';
  @override
  Widget build(BuildContext context) {
    print('${ProfilePageState.routename} built');
    return MaterialApp(
      title: 'Profile ',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 153, 216, 152),
          title: Text('Profile'),
          //actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
          //automaticallyImplyLeading: true,
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
                              builder: (context) => ProfilePage()));
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
        backgroundColor: Colors.green.shade100,
        body: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [
                //     Color.fromARGB(255, 137, 214, 164),
                //     Color.fromARGB(255, 82, 133, 81)
                //   ],
                //   begin: Alignment.bottomCenter,
                //   end: Alignment.topCenter,
                //   stops: [0.2, 0.9],
                image: DecorationImage(
                  image: NetworkImage(
                      'https://img.freepik.com/free-vector/different-colorful-leaves-collection-flat-design_23-2149112268.jpg?w=740&t=st=1684360667~exp=1684361267~hmac=6fa0275bc5b93080c06a7ee690dfcf36d09c2d960fd430c01fa78dec27b26396'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      //const CircleAvatar(
                      //backgroundColor: secondarylightColor,
                      //minRadius: 35.0,
                      //child: Icon(
                      //Icons.call,
                      //size: 30.0
                      //),
                      //),
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 60.0,
                        child: CircleAvatar(
                          radius: 50.0,
                          //backgroundImage: TO BE IMPLEMENTED
                        ),
                      ),
                      //CircleAvatar(
                      //backgroundColor: Colors.red.shade300,
                      //minRadius: 35.0,
                      //child: Icon(
                      //Icons.message,
                      //size: 30.0
                      //),
                      //),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Andrea Corrado',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 39, 98, 39),
                    ),
                  ),
                ],
              ),
            ),
            // Row(
            // children: <Widget>[
            // Expanded(
            //   child: Container(
            //     width: 100,
            //     height: 100,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: Color.fromARGB(255, 220, 211, 51),
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: const [
            //         Text(
            //           '100',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontWeight: FontWeight.bold,
            //             fontSize: 35,
            //             color: Colors.white,
            //           ),
            //         ),
            //         Text(
            //           'Trees',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             fontSize: 15,
            //             color: Colors.white70,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // Expanded(
            //   child: Container(
            //     color: Constants.secondaryColor,
            //     child: const ListTile(
            //       title: Text(
            //         '500',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           fontSize: 30,
            //           color: Colors.white,
            //         ),
            //       ),
            //       subtitle: Text(
            //         'LoS',
            //         textAlign: TextAlign.center,
            //         style: TextStyle(
            //           fontSize: 20,
            //           color: Colors.white70,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),

            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 220, 211, 51),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '100',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Trees',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 16), // Add spacing between the circular boxes
                Expanded(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 196, 186, 58),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '500',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'LoS',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 16), // Add spacing between the circular boxes
                Expanded(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 176, 167, 37),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          '1',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Level',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Container(
              child: const Column(
                children: <Widget>[
                  ListTile(
                    title: Text(
                      'Email',
                      style: TextStyle(
                        color: Constants.secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'andrea.corrado00@gmail.com',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Your device',
                      style: TextStyle(
                        color: Constants.secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Amazfit GTS (2020)',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Password',
                      style: TextStyle(
                        color: Constants.secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '******',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'Connected services',
                      style: TextStyle(
                        color: Constants.secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Strava,Komoot, ...',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

// ignore: non_constant_identifier_names
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
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginPage()));
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
}
