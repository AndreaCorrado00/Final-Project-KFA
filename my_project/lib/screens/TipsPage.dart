// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_project/screens/HomePage.dart';
import 'package:my_project/screens/StatisticsPage.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/utils/impact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/utils/constants.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({super.key});

  @override
  TipsPageState createState() => TipsPageState();
}

class TipsPageState extends State<TipsPage> {
 //-------------- Index used trought the code to build widgets
  int _selectedIndex = 1;
  static const routename = 'TipsPage';
  @override
  Widget build(BuildContext context) {
    print('${TipsPageState.routename} built');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        title: Text('Advice and Tips'),
        //automaticallyImplyLeading: true,
      ),

      backgroundColor: Constants.primaryLightColor,
      body:
      Center(
        
        child: Column(
        children:[ TextButton (
          
          onPressed: () async{
            final resoult = await _pingImpact();
            if (resoult == true){print('Request Succesfull'); }
            
          },
          child: Text('ping Impact'), style: Constants.TextButtonStyle_Alert),
          TextButton (
          
          onPressed: () async{
            final resoult = await _getAndStoreTokens();
            if (resoult == 200){print('Stored');}
            else {print('No way ');} 
          },
          child: Text('get and store tokens'), style: Constants.TextButtonStyle_Alert),

          TextButton (
          
          onPressed: () async{
            final resoult = await _getAndStoreTokens();
            if (resoult == 200){print('refreshed');}
            else {print('No way ');} 
          },
          child: Text('refresh tokens'), style: Constants.TextButtonStyle_Alert),],),),



          bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tips_and_updates),
            label: 'Advice and Tips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Statistics',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Constants.primaryColor,
        selectedItemColor: Constants.secondarylightColor,
        selectedFontSize: 14.0,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const HomePageState()));
            //break;
            case 1:
            if (index != 1) {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const TipsPage()));
              } else {
                print('still in the Statistics page ');
              }
            

    

            //break;
            case 2:
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const StatisticsPage()));
              
              // Probably in this case you have to put an if: if the index is not pointing the home and you are in the case of the home, return to home
              break;
          }

          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
      ),

    );
  }



  //Handling http request
  Future<bool> _pingImpact() async{
    
    final url=Impact.baseUrl + Impact.pingEndpoint;

    // finally the call
    final response =await http.get(Uri.parse(url)); // is an async function
    
    return response.statusCode==200;


  }

  Future<int> _getAndStoreTokens() async {

    //Create the request
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': Impact.username, 'password': Impact.password};

    //Get the response
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If response is OK, decode it and store the tokens. Otherwise do nothing.
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Just return the status code
    return response.statusCode;
  } //_getAndStoreTokens

  //This method allows to refrsh the stored JWT in SharedPreferences
  Future<int> _refreshTokens() async {

    //Create the request 
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');
    final body = {'refresh': refresh};

    //Get the response
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //If the response is OK, set the tokens in SharedPreferences to the new values
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final sp = await SharedPreferences.getInstance();
      await sp.setString('access', decodedResponse['access']);
      await sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Just return the status code
    return response.statusCode;
    
  } //_refreshTokens
}
