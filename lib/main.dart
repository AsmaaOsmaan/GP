//
//import 'package:flutter/material.dart';
////import 'authentication/auth_service.dart';
//import 'authentication/firedase_authentication.dart';
//import 'authentication/mapping.dart';
//import 'child/list_requests.dart';
////import 'splace_screen.dart';
//import 'splash/NewSplashScreen.dart';
//import 'package:flutter/cupertino.dart';
//
//import 'package:flutter_shop/parent/list_children.dart';
//
//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  // This widget is the root of your application.
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: 'Flutter Demo',
//      theme: ThemeData(
//
//        primarySwatch: Colors.blue,
//      ),
//      //home: SplashScreen(),
//      //   home: ListRequests (),
//      //  home:SplashScreen(),
//      //  home:Reg(),
//
//      home:Mapping(auth:Auth(),),
////    home: ProviderTest(),
//
//      //  home: SplashScreen(),
//    );
//  }
//}
//
//


//
////import 'package:flutter/material.dart';
////import 'home_widget.dart';
////import 'package:travel_budget/views/first_view.dart';
////import 'package:travel_budget/views/sign_up_view.dart';
////import 'package:travel_budget/widgets/provider_widget.dart';
////import 'package:travel_budget/services/auth_service.dart';
//
////void main() => runApp(MyApp());
////
////class MyApp extends StatelessWidget {
////  @override
////  Widget build(BuildContext context) {
////    return Provider(
////      auth: AuthService(),
////      child: MaterialApp(
////        title: "FacebOOk",
////        theme: ThemeData(
////          primarySwatch: Colors.green,
////        ),
////        home: HomeController(),
////        routes: <String, WidgetBuilder>{
////          '/signUp': (BuildContext context) =>Register(),
////          '/signIn': (BuildContext context) => Login(),
////          '/home': (BuildContext context) => HomeController(),
////        },
////      ),
////    );
////  }
////}
////
////class HomeController extends StatelessWidget {
////  @override
////  Widget build(BuildContext context) {
////    final AuthService auth = Provider.of(context).auth;
////    return StreamBuilder<String>(
////      stream: auth.onAuthStateChanged,
////      builder: (context, AsyncSnapshot<String> snapshot) {
////        if (snapshot.connectionState == ConnectionState.active) {
////          final bool signedIn = snapshot.hasData;
////          return signedIn ? SplashScreen() :Register();
////        }
////        return CircularProgressIndicator();
////      },
////    );
////  }
////}
////

import 'package:flutter_shop/provider_data.dart';
import 'package:flutter_shop/register.dart';
import 'package:flutter_shop/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication/firedase_authentication.dart';
import 'authentication/mapping.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
//    Provider.of<ProviderData>(context).userData= UserData();
    return MultiProvider(
        providers: [
    ChangeNotifierProvider<ProviderData>(
    create: (context) => ProviderData(),
    ),],
//      create: (context) => ProviderData(),
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
            primaryColor: Color(0xffd291bc),
            appBarTheme: AppBarTheme(
              color: Color(0xffd291bc),

              actionsIconTheme: IconThemeData(

              ),
              elevation: 0,
             // textTheme: TextTheme(title: TextStyle(color: ScreenUtitilities.textColor,fontFamily:"Quicksand", fontSize: 22)),

            ),



          primarySwatch: Colors.blue,
            tabBarTheme:TabBarTheme(
                labelColor: Color(0xff6a90f1),
                labelStyle: TextStyle(
                  fontSize: 22,
                  fontFamily: "Quicksand",

                ),
                labelPadding: EdgeInsets.only(right: 16,bottom: 12,left: 16,top: 16),
                indicatorSize: TabBarIndicatorSize.label,
               // unselectedLabelColor: ScreenUtitilities.unselectedColor,
                unselectedLabelStyle: TextStyle(
                  fontSize: 22,
                  fontFamily: "Quicksand",
                )
            )
        ),

//        home: Register(),
//        routes: {
//          'register': (BuildContext context) => Register(),
//        },
        home: Mapping(
          auth: Auth(),
        ),

//    home: ProviderTest(),

        //  home: SplashScreen(),
      ),
    );
  }
}

//import 'package:flutter/material.dart';
//import 'home_widget.dart';
//import 'package:travel_budget/views/first_view.dart';
//import 'package:travel_budget/views/sign_up_view.dart';
//import 'package:travel_budget/widgets/provider_widget.dart';
//import 'package:travel_budget/services/auth_service.dart';

//void main() => runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Provider(
//      auth: AuthService(),
//      child: MaterialApp(
//        title: "FacebOOk",
//        theme: ThemeData(
//          primarySwatch: Colors.green,
//        ),
//        home: HomeController(),
//        routes: <String, WidgetBuilder>{
//          '/signUp': (BuildContext context) =>Register(),
//          '/signIn': (BuildContext context) => Login(),
//          '/home': (BuildContext context) => HomeController(),
//        },
//      ),
//    );
//  }
//}
//
//class HomeController extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    final AuthService auth = Provider.of(context).auth;
//    return StreamBuilder<String>(
//      stream: auth.onAuthStateChanged,
//      builder: (context, AsyncSnapshot<String> snapshot) {
//        if (snapshot.connectionState == ConnectionState.active) {
//          final bool signedIn = snapshot.hasData;
//          return signedIn ? SplashScreen() :Register();
//        }
//        return CircularProgressIndicator();
//      },
//    );
//  }
//}
//
