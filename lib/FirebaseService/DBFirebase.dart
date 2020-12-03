
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

final String COLLECTION_USER = "esusers";
class DBFirebaseHelper{
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final FirebaseAuth auth = FirebaseAuth.instance;


  static Future<void> insertUser(ESUser user) async{
    DocumentReference doc = db.collection(COLLECTION_USER).doc(auth.currentUser.uid);
    user.id = auth.currentUser.uid;
    return doc.set(user.toMap());
  }
}