import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:reebapp/services/api/user.dart';

class Authentication{

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<int> signInUsingGoogle() async {
    try{
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _auth.signInWithCredential(credential);
      await UserApi.addInitialData();
      print('signIn passed');
      return 200;
    }catch(e){
      print(e.toString());
      return 500;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<Map> updateCheck() async {
    int turn = 500;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print(packageInfo.version.toString());
    String downloadLink = await _firestore.collection('settings').doc('app').get().then((value) => value.get('downloadLink'));
    try{
      String appVersion = await _firestore.collection('settings').doc('app').get().then((value) => value.get('version'));
      if(appVersion != packageInfo.version.toString()){
        turn = 401;
      }
      if(appVersion == packageInfo.version.toString()){
        turn = 200;
      }
    }catch(e){
      turn = 500;
    }
    
    return {'version': turn, 'downloadLink': downloadLink};
  }


}