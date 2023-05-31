import 'package:flutter/material.dart';
import 'package:my_project/screens/HomePage.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_project/utils/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  static const routename = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}



class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    //Check if the user is already logged in before rendering the login page
    _checkLogin();
  }//initState

   void _checkLogin() async {
    final user_preferences=await SharedPreferences.getInstance();
    if(await user_preferences.getBool('Rememeber_login')==true){
      print('Into_checkLogin');
      print(await user_preferences.getBool('Rememeber_login'));
      _toHomePage(context);
    }//if
  }//_checkLogin

  static const routename = '_LoginPageState';

  Future<String> _loginUser(LoginData data) async {
    
    if(data.name  == 'andrea@gmail.com' && data.password == '0000'){
      final user_preferences=await SharedPreferences.getInstance();
      await user_preferences.setBool('Rememeber_login', true);
      print('Into _loginUser');
      print(await user_preferences.getBool('Rememeber_login'));
      return '';
    } else {
      return 'Wrong credentials';
    }
  } // _loginUser

  Future<String> _signUpUser(SignupData data) async {
    // Problems: i have to control the flow of the database. At the moment, the login doesn't uses the saved name, moreover, an other used different from andre@gmai.com will provide a logic erro
     //final dataDB=await SharedPreferences.getInstance();
     //await dataDB.setString('name', data.name!);
     //await dataDB.setString('password', data.password!);
     //SignupData.fromSignupForm(name: dataDB.getString('name'), password: dataDB.getString('password'));
     return 'To be implemented';
  } // _signUpUser

  Future<String> _recoverPassword(String email) async {
    return 'Recover password functionality needs to be implemented';
  } // _recoverPassword

  @override
  Widget build(BuildContext context) {
  
    
    return FlutterLogin(
      title: 'Project',
      onLogin: _loginUser,
      onSignup: _signUpUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () async{_toHomePage(context);},
      theme: LoginTheme(
        pageColorLight: Constants.primaryColor,
        primaryColor: Constants.secondaryColor,
        accentColor: Constants.secondarylightColor,
        errorColor: Colors.deepOrange,
        
        // ignore: prefer_const_constructors
        titleStyle: TextStyle(
          color: Constants.primaryLightColor,
          fontFamily: Constants.myfontFamily,
          letterSpacing: 4,),
        ),
        
        
    );
  } // build
  void _toHomePage(BuildContext context){

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen ()));

  }//_toHomePage
} // LoginScreen