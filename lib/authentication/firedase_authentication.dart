import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthImplementation {
  Future signOut();
  Future<String> getCurrentUser();
  Future<String> sigIn(String email, String password);

  Future<String> sigUp(String email, String password);
}

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class Auth with ChangeNotifier implements AuthImplementation {
  FirebaseUser _user;

  Status _status = Status.Uninitialized;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Status get status => _status;
  FirebaseUser get user => _user;

  Future signOut() async {
    _firebaseAuth.signOut();

    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    return user.uid;
  }

  Future<String> sigIn(String email, String password) async {
    AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return authResult.user.uid;
  }

  Future<String> sigUp(String email, String password) async {
    AuthResult authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return authResult.user.uid;
  }

//
}
