
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService{
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static User getCurrentUser()  =>  auth.currentUser;

  static Future<User>register(String email, String password) async{
      final credintial = await  auth.createUserWithEmailAndPassword(email: email, password: password);
      return credintial.user;
  }

  static Future<User>login(String email, String password) async{
    final credintial = await  auth.signInWithEmailAndPassword(email: email, password: password);
    return credintial.user;

  }

  static Future<void>logOut() async{
    await auth.signOut();
  }
}