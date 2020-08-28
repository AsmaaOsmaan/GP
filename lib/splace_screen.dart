import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/authentication/firedase_authentication.dart';
//import 'looooogin.dart';


class SplashScreen extends StatefulWidget {
  SplashScreen(Object documentID, {AuthImplementation auth, onSignedOut});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Timer(Duration(seconds: 5), () =>login.goToIntro(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.purple),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 40.0),
                      ),
                     /////////////////////////////////////////////////////////////////

    ////////////////////////////////////////////////////

////////////////////try////////////////////

   // CircleAvatar(
  // child: Center(
  //  child:Image.asset(
       // 'images/spon.PNG',
  //  width: 120,
  //  height: 120,
  //  fit: BoxFit.fill
  //  ),
  //  ),
    //radius: 50,
  //  ),

///////////////////////////////////////////

    Center(
      child: Container(
      width:100,
   height: 100,
   decoration: BoxDecoration(
      shape: BoxShape.circle,
   // borderRadius: BorderRadius.circular(100.0),
      image: DecorationImage(
   image: ExactAssetImage('images/spon.PNG'),
   fit: BoxFit.cover,



   // child: CircleAvatar(
   // backgroundImage: AssetImage('images/spon.jpg'),
 //   radius: 70,


   // )

   ),
  ),),
    ),

/////////////////////////////////////try3/////////////
                    //  ClipOval(
                      //    child: Image.asset('images/spon.PNG',fit: BoxFit.cover,height: 100,width: 100,)
                     // ),







                     // CircleAvatar(
                       // backgroundColor: Colors.white,
                        ///  backgroundImage:AssetImage("images/spon.jpg",fit: BoxFit.cover),
                      //  backgroundImage:    image: ExactAssetImage('assets/images/aa.jpg'),
                      // fit: BoxFit.cover,

                      //  radius: 70.0,
                        // child: Icon(
                        // Icons.shopping_cart,
                        //  color: Colors.greenAccent,
                        //  size: 50.0,
                        // ),

                        // child: Image.asset('images/spon.jpg',fit: BoxFit.cover,)
///////////////////////////////////////////////////////


                  //  ),

                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Text(
                        "kids safty",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                          fontFamily: 'DancingScript', ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "waiting",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                        color: Colors.white,fontFamily: 'DancingScript',),

                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}