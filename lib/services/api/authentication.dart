import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reebapp/services/api/user.dart';

class Authentication{

  static final FirebaseAuth _auth = FirebaseAuth.instance;

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

  static Future<void> signOut(Function() callback) async {
    await _auth.signOut().then((value) => callback);
  }


}