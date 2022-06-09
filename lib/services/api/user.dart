import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserApi{

  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> addInitialData() async {
    DocumentSnapshot snap = await _firestore.collection('user').doc(_auth.currentUser!.uid).get();

    if(!snap.exists){
      await _firestore.collection('user').doc(_auth.currentUser!.uid).set({
        'createdAt': Timestamp.now(),
        'role': 'reader'
      });
    }

  }

  static Future<void> addToFavorites() async {

  }

  static Future<void> addToReadHistory() async {

  }
}