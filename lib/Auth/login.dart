import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_shop/Auth/Animation/FadeAnimation.dart';
import 'package:flutter_shop/authentication/dialogBox.dart';
import 'package:flutter_shop/authentication/firedase_authentication.dart';
import 'package:flutter_shop/parent/list_children.dart';
import 'package:flutter_shop/provider_data.dart';
import 'package:flutter_shop/register.dart';
import 'package:flutter_shop/splash/NewSplashScreen.dart';
import 'package:flutter_shop/user_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  Login({
    this.auth,
    this.onSignedIn,
    this.providerData,
  });
  final AuthImplementation auth;
  final VoidCallback onSignedIn;
  final ProviderData providerData ;
  String get documentID => null;
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  DialogBox dialogBox = new DialogBox();
  bool isloading = false;

  final userrefrence = Firestore.instance.collection('User');

  TextEditingController _EmailController;

  TextEditingController PassWordController;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _EmailController = new TextEditingController();
    PassWordController = new TextEditingController();
    super.initState();
  }

  FormType _formType = FormType.login;
  String _email = "";
  String _password = "";

  void moveToRegister() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Register()));
    });
  }

  @override
  void dispose() {
    super.dispose();

    _EmailController.dispose();

    PassWordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    final user = Provider.of<Auth>(context);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                height: 400,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/backgroundlogin.png'),
                        fit: BoxFit.fill)),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeAnimation(
                          1,
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/light-1.png'))),
                          )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(
                          1.3,
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/light-2.png'))),
                          )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeAnimation(
                          1.5,
                          Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('images/clock.png'))),
                          )),
                    ),
//
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(30.0),
                child: Column(
                  children: <Widget>[
                    FadeAnimation(
                        1.8,
                        Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10))
                              ]),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  controller: _EmailController,
                                  onSaved: (input) => _email = input,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    icon: Icon(Icons.email),
                                    hintText: 'Email or phone number',
                                  ),
                                  validator: validateEmail,
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                    controller: PassWordController,
                                    onSaved: (input) => _password = input,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      icon: Icon(Icons.visibility_off),
                                      hintText: 'Password',
                                    ),
                                    validator: pwdValidator),
                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                        )),
//
                    SizedBox(
                      height: 30,
                    ),

                    FadeAnimation(
                        2,
//                     user.status == Status.Authenticating
//                       ? Center(child: CircularProgressIndicator())
//                       :
                        Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ])),
                          child: Center(
                            child: RaisedButton(
                              color: Color.fromRGBO(143, 148, 251, 6),
                              child: Text("Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                try {
                                  if (_formKey.currentState.validate()) {
                                    Toast.show("User login Successfully", context);
                                    final auth =
                                    Provider.of<ProviderData>(context, listen: false);
                                    FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                        email: _EmailController.text,
                                        password: PassWordController.text)
                                        .then((currentUser) => Firestore
                                        .instance
                                        .collection("User")
                                        .document(currentUser.user.uid)
                                        .get()
                                        .then((DocumentSnapshot
                                    result) async {
                                      if (result["statues"]
                                          .toString() !=
                                          "true") {
                                        if (result["ParentID"] ==
                                            "parent") {
                                          DocumentSnapshot userDoc =
                                          await Firestore.instance
                                              .collection('User')
                                              .document(currentUser
                                              .user.uid)
                                              .get();
                                          Provider.of<ProviderData>(
                                              context)
                                              .userData =
                                              UserData.fromDoc(userDoc);
//                                            _formType = FormType.login;
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PageParent()));
                                          dialogBox.information(
                                              context,
                                              "Parent page",
                                              "you are logged in successfully.");
                                        } else if (result["ParentID"]
                                            .toString() !=
                                            "parent") {
                                          Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SplashScreen()));
                                          dialogBox.information(
                                              context,
                                              "child page",
                                              "you are logged in successfully.");
                                          DocumentSnapshot userDoc =
                                          await Firestore.instance
                                              .collection('User')
                                              .document(currentUser
                                              .user.uid)
                                              .get();
                                          Provider.of<ProviderData>(
                                              context)
                                              .userData =
                                              UserData.fromDoc(userDoc);
                                        }
                                      } else {
                                        dialogBox.information(
                                            context,
                                            "sorry",
                                            "you are blocked from your parent.");
                                      }
                                    }).catchError((err) {
                                      dialogBox.information(
                                        context, "Error User NOT FOUND please tray again!", err.toString());
                                    print("Error =" + err.toString());}))
                                        .catchError((err) {
                                      dialogBox.information(
                                          context, "Invalid Email or Password", err.toString());
                                      print("Error =" + err.toString());

                                    });
                                  }
                                } catch (e) {
                                  dialogBox.information(
                                      context, "Error", e.toString());
                                  print("Error =" + e.toString());
                                }
                              },

//
                            ),
                          ),
                        )),

//
                    SizedBox(
                      height: 20,
                    ),
                    Text("Don't have an account yet?"),
                    RaisedButton(
                      color: Color.fromRGBO(143, 148, 251, 6),
                      child: Text("Sign Up",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      onPressed: moveToRegister,
//
                    ),
//                    FadeAnimation(1.5, Text("Sign Up", style: TextStyle(color: Color.fromRGBO(143, 148, 251, 1)),),),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return 'Email is requierd';
    if (!regex.hasMatch(value))
      return 'Email format is invalid';

    ///not work///////////
    else {
      userrefrence.document(value).get().then((DocumentSnapshot doc) {
        print(doc.exists);
        if (doc.exists == true)
          return 'email already exist';
        else {
          return null;
        }
      });
    }
  }

  String pwdValidator(String value) {
    if (value.isEmpty) return 'Password is requierd';
    if (value.length < 6) {
      return 'Password must be longer than 6 characters';
    } else {
      return null;
    }
  }
}
