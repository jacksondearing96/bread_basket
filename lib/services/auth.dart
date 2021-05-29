import 'package:bread_basket/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as Firebase;

class AuthService {
  final Firebase.FirebaseAuth _auth = Firebase.FirebaseAuth.instance;

  // Create custom user from Firebase User.
  User? _userFromFirebaseUser(Firebase.User? user) {
    return user != null ? User(userId: user.uid) : null;
  }

  // Auth changed user stream.
  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Sign in (anon).
  Future signInAnon() async {
    try {
      Firebase.UserCredential userCredential = await _auth.signInAnonymously();
      return _userFromFirebaseUser(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in (email and password).
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      Firebase.UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Register (email and password).
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      Firebase.UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      return _userFromFirebaseUser(userCredential.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out.
  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
