// import 'package:flutter/material.dart';
// import 'package:my_project/screens/LoginPage.dart';
// void main() {
//   runApp(
//     MyApp());}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home:  LoginPage(),
//     );
//   }
// }


import 'package:my_project/screens/LoginPage.dart';
import 'package:my_project/screens/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'KAD - prototype',
        theme: ThemeData(
            primarySwatch: Colors.green,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            scaffoldBackgroundColor: Colors.white),
        home: const Scaffold(
          body: login(),
        ));
  }
}

// ignore: camel_case_types
class login extends StatefulWidget {
  const login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _loginState createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {
  get child => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      TyperAnimatedText(
                        "Hello There!",
                        textStyle: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 40),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Welcome Back!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700], fontSize: 15),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 1.75,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              'https://img.freepik.com/free-vector/save-planet-concept-with-people-taking-care-earth_23-2148522570.jpg?w=740&t=st=1683661017~exp=1683661617~hmac=644c9c528c5a3fba74cea62bd1f4cf9dc8d5285466a89496f8942c8ece9a0ccc')),
                    ),
                  ),
                ],
              ),

              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                color: Color.fromARGB(255, 226, 203, 70),
                shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color.fromARGB(255, 255, 251, 251),
                    ),
                    borderRadius: BorderRadius.circular(40)),
                child: const Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      color: Colors.white70),
                ),
              ),
              MaterialButton(
                minWidth: double.infinity,
                height: 60,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignupPage()),
                  );
                },
                color: Color.fromARGB(255, 39, 97, 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white70),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
