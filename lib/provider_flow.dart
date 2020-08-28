//import 'package:first_run/register.dart';
//import 'package:first_run/splash/NewSplashScreen.dart';
//import 'package:flutter/material.dart';
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
//import 'package:first_run/Auth/login.dart';
//import 'package:first_run/authentication/provider.dart';
//import 'package:first_run/authentication/firedase_authentication.dart';
//
//class ProviderTest extends StatefulWidget {
//  @override
//  _ProviderTestState createState() => _ProviderTestState();
//}
//
//class _ProviderTestState extends State<ProviderTest> {
//  @override
//  Widget build(BuildContext context) {
//    return ChangeNotifierProvider(
//      builder: (_) => Auth.instance(),
//      child: Consumer(
//        builder: (context, Auth user, _) {
//          switch (user.status) {
//            case Status.Uninitialized:
//              return Splash();
//            case Status.Unauthenticated:
//              return Register();
//            case Status.Authenticating:
//              return Login();
//            case Status.Authenticated:
////              return SplashScreen();
//              return Login();
//          }
//        },
//      ),
//    );
//  }
//
//}
//
//
//class Splash extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Material(
//      child: Center(
//        child: Text("Splash Screen"),
//      ),
//    );
//  }
//}
//
