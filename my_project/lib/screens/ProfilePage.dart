import 'package:flutter/material.dart';
import 'package:my_project/screens/AboutThisApp.dart';
import 'package:my_project/screens/LoginPage.dart';
import 'package:my_project/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  var Trees;
  double LoS = 0.0;

  @override
  void initState() {
    super.initState();
    getTreesLoSValue(); // Call the function to retrieve Trees and LoS values
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.primaryColor,
          title: const Text('Profile'),
        ),
        drawer: Drawer(
          backgroundColor: Constants.secondaryColor,
          child: Column(
            children: [
              const SizedBox(
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
                              builder: (context) => AboutThisAppState()));
                    },
                    child: const Text('About this App'),
                  ),
                  const Icon(
                    Icons.help_outline,
                    color: Constants.secondarylightColor,
                    size: 24.0,
                  ),
                ],
              ),
              const SizedBox(
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
                  const Icon(
                    IconData(0xe3b3, fontFamily: 'MaterialIcons'),
                    color: Constants.secondarylightColor,
                    size: 24.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  ),
                ],
              ),
              const SizedBox(
                width: 200,
                height: 10,
              ),
            ],
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://img.freepik.com/free-vector/green-trees-leaves-flat-icons-set-oak-aspen-linden-maple-chestnut-clover-plants-isolated-vector-illustration_1284-3022.jpg?w=740&t=st=1684410201~exp=1684410801~hmac=f2643f557b94232a485bd203a769a09ad29aab8c4cb127f98c4fd6bb9fc54341'),
                  fit: BoxFit.cover,
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 60.0,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                              'https://www.pngall.com/wp-content/uploads/12/Avatar-Profile-Vector-PNG-Pic.png'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Andrea Corrado',
                    style: const TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 33, 92, 33),
                      shadows: [
                        Shadow(
                          color: Color.fromARGB(255, 30, 5, 5),
                          blurRadius: 3,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 220, 211, 51),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$Trees',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
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
                const SizedBox(
                    width: 20), // Add spacing between the circular boxes
                const SizedBox(
                    width: 16), // Add spacing between the circular boxes
                Expanded(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 176, 167, 37),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${LoS.toStringAsFixed(2)}%',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
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
              ],
            ),
            Container(
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: const Text(
                      'Email',
                      style: TextStyle(
                        color: Constants.secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'andrea.corrado00@gmail.com',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Your device',
                      style: TextStyle(
                        color: Constants.secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Amazfit GTS (2020)',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Password',
                      style: TextStyle(
                        color: Constants.secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      '******',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text(
                      'Connected services',
                      style: TextStyle(
                        color: Constants.secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Strava,Komoot, ...',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void _OnLogoutTapConfirm(BuildContext context) {
    Widget continueButton = TextButton(
      child: const Text("Continue"),
      onPressed: () async {
        final userPreferences = await SharedPreferences.getInstance();
        await userPreferences.setBool('Remember_login', false);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      style: Constants.TextButtonStyle_Alert,
    );
    AlertDialog alert = AlertDialog(
      title: const Text("Logout"),
      content: const Text("Are you sure you want to logout?"),
      actions: [
        continueButton,
      ],
      backgroundColor: Constants.primaryLightColor,
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> getTreesLoSValue() async {
    final sp = await SharedPreferences.getInstance();
    final storedTrees = sp.getInt('trees');
    final storedLoS = sp.getDouble('FLoS');
    if (storedTrees != null && storedLoS != null) {
      setState(() {
        Trees = storedTrees;
        LoS = storedLoS * 100;
      });
    }
  }
}
