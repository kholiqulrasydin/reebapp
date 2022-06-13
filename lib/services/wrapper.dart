import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:reebapp/consttants.dart';
import 'package:reebapp/main.dart';
import 'package:reebapp/screens/components/sizeconfig.dart';
import 'package:reebapp/screens/home_screen.dart';
import 'package:reebapp/services/api/authentication.dart';
import 'package:reebapp/services/api/user.dart';
import 'package:reebapp/services/update.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);
  static const routeName = "/";

  @override
  Widget build(BuildContext context) {
    return MainWrapper();
  }
}

class MainWrapper extends StatefulWidget {
  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {

  @override
  initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Splash();
        }

        if (snapshot.hasData) {
          Authentication.updateCheck().then((value) {
            if(value['version'] == 200){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (e) => false);
            }

            if(value['version'] == 401){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UpdateScreen(updateUrl: value['downloadLink'])), (e) => false);
            }
          });

          return Splash();
        }

        if (!snapshot.hasData) {

          Authentication.updateCheck().then((value) {
            if(value['version'] == 200){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WelcomeScreen()), (e) => false);
            }
            if(value['version'] == 401){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => UpdateScreen(updateUrl: value['downloadLink'])), (e) => false);
            }
          });

          return WelcomeScreen();
        }
        return Splash();
      },
    );
  }
}

class Splash extends StatelessWidget {
  final String ? text;
  const Splash({Key? key, this.text = "Menginisialisasi Pengguna"}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 4)),
      builder: (context, AsyncSnapshot snapshot) {
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: kBlackColor,
                  ),
                  SizedBox(height: SizeConfig.getSize(context, heightPercent: 2).height),
                  Text(
                    text!,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.normal),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}