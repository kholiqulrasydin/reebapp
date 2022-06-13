import 'package:firebase_core/firebase_core.dart';
import 'package:reebapp/consttants.dart';
import 'package:reebapp/services/api/authentication.dart';
import 'package:reebapp/services/wrapper.dart';
import 'package:reebapp/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: Theme.of(context).textTheme.apply(
              displayColor: kBlackColor,
            ),
      ),
      home: Wrapper(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/Bitmap.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.displayMedium,
                children: [
                  TextSpan(
                    text: "Reeb",
                  ),
                  TextSpan(
                    text: "App",
                    style: TextStyle(fontWeight: FontWeight.bold, color: kTextBoldColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * .6,
              child: RoundedButton(
                text: "start reading",
                fontSize: 20,
                press: () async {
                  await Authentication.signInUsingGoogle().then((value) =>
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Wrapper();
                            },
                          ),
                        )
                  // value == 200 ? Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return HomeScreen();
                  //     },
                  //   ),
                  // ) : Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) {
                  //       return WelcomeScreen();
                  //     },
                  //   ),
                  // )
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
