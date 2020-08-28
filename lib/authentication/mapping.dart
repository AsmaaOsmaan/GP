import 'package:flutter_shop/Auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/splash/NewSplashScreen.dart';
import 'firedase_authentication.dart';

class Mapping extends StatefulWidget {
  final AuthImplementation auth;

  Mapping({this.auth});

  @override
  _MappingState createState() => _MappingState();
}

enum AuthState{
  notSignedIn,
  signedIn,
}

class _MappingState extends State<Mapping> {
  AuthState authState=AuthState.notSignedIn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.getCurrentUser().then((firebaseUserId){
      setState(() {
        authState=firebaseUserId ==null ? AuthState.notSignedIn : AuthState.signedIn;
      });

    });
  }

  void _signedIn(){
    setState(() {
      authState=AuthState.signedIn;
    });
  }

  void _signedOut(){
    setState(() {
      authState=AuthState.notSignedIn;
    });
  }


  @override
  Widget build(BuildContext context) {
    switch(authState){
      case AuthState.notSignedIn:
        return new Login(
          auth:widget.auth,
          onSignedIn : _signedIn,

        );

      case AuthState.signedIn:
        return new SplashScreen(
          auth:widget.auth,
          onSignedOut : _signedOut,

        );
    }
    return null;
  }
}
