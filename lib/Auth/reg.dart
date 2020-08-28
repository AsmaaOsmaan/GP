import 'package:flutter_shop/splash/NewSplashScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/Auth/Animation/FadeAnimation.dart';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../parent/list_children.dart';

class Reg extends StatefulWidget {
  @override
  _RegState createState() => _RegState();
}

class _RegState extends State<Reg> {
  bool isloading = false;

//  File _image1, _image2, _image3, _image4;
//  String imageurl;
  // Uri
//  String downloadUrl;
  final userrefrence = Firestore.instance.collection('User');
  TextEditingController _UserNameController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _AgeController = TextEditingController();
  TextEditingController PassWordController = TextEditingController();
  TextEditingController PhoneNumberController = TextEditingController();
  TextEditingController confirmPwdInputController=TextEditingController();
  final _formkey = GlobalKey<FormState>();



  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _UserNameController.dispose();
    _EmailController.dispose();
    _AgeController.dispose();
    PassWordController.dispose();
    PhoneNumberController.dispose();
    confirmPwdInputController.dispose();
  }

  String dropval;
  void dropchange(String val) {
    setState(() {
      dropval = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 400,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: -40,
                    height: 400,
                    width: width,
                    child: FadeAnimation(
                        1,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('images/background.png'),
                                  fit: BoxFit.fill)),
                        )),
                  ),
                  Positioned(
                    height: 400,
                    width: width + 20,
                    child: FadeAnimation(
                        1.3,
                        Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('images/background-2.png'),
                                  fit: BoxFit.fill)),
                        )),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      1.5,
                      Text(
                        "Sign Up",
                        style: TextStyle(
                            color: Color.fromRGBO(49, 39, 79, 1),
                            fontWeight: FontWeight.bold,
                            fontSize: 30),
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  FadeAnimation(
                      1.7,
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color.fromRGBO(196, 135, 198, .3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              )
                            ]),
                        child: Form(
                          key: _formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              TextFormField(
                                controller: _UserNameController,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.person),
                                  hintText: 'User Name',
                                ),
                                validator: validateName,
                              ),
                              SizedBox(height: 10),
                           TextFormField(
                                controller: _EmailController,
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
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.visibility_off),
                                  hintText: 'Password',
                                ),
                                validator:pwdValidator,
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: confirmPwdInputController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.visibility_off),
                                  hintText: 'Confirm Password',
                                ),
                                validator:pwdValidator,
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _AgeController,
//                                keyboardType: TextInputType.number,
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.calendar_today),
                                  hintText: 'Date Of Birth',
                                ),
                                validator: (value) {
                                  var potentialNumber = int.tryParse(value);
                                  if (potentialNumber == null) {
                                    return 'Age is requierd';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: PhoneNumberController,
                                keyboardType: TextInputType.phone,
                                obscureText: true,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.phone),
                                  hintText: 'Phone Number',
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Phone Number is requeierd';
                                  }
                                  if (value.length != 11 ) {
                                    return 'Please Enter Valid Phone Number!';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              Container(
                                width: double.infinity, // specific value
                                child: DropdownButton<String>(
                                  icon: Icon(
                                    Icons.group,
                                  ),
                                  elevation: 1,
                                  onChanged: dropchange,
                                  value: dropval,
                                  hint: Text(
                                    'Gender',
                                    style: TextStyle(
                                      fontSize: 22,
                                    ),
                                  ),
                                  items: <String>['Male', 'Female']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      child: Text(value),
                                      value: value,
                                    );
                                  }).toList(),
                                ),
                              ),
                              SizedBox(
                                height: 50,
                              ),
                              FadeAnimation(
                                  1.9,
                                  Container(
                                    height: 50,
                                    margin: EdgeInsets.symmetric(horizontal: 60),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Color.fromRGBO(49, 39, 79, 1),
                                    ),
                                    child: Center(
                                      child: RaisedButton(
                                        child: Text(
                                          "Create Account",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: Color.fromRGBO(49, 39, 79, 1),
                                        onPressed: ()async {
                                          if (_formkey.currentState.validate()) {

                                            Firestore.instance.collection('User')
                                                .document()
                                                .setData({
                                              'UserName': _UserNameController.text,
                                              'Email': _EmailController.text,
                                              'Password': PassWordController.text,
                                              'age': _AgeController.text,
                                              'PhoneNumber':PhoneNumberController.text,
                                              'Gender': dropval,

                                            })
                                                .then((data) {
                                              setState(() {
                                                print('add');
                                                isloading=true;
                                              });
                                            });
                                            PassWordController.text='';
                                            _AgeController.text='';
                                            _EmailController.text='';
                                            _UserNameController.text='';
                                            PhoneNumberController.text='';
//                                            Navigator.push(
//                                              context,
//                                              MaterialPageRoute(
//                                                  builder: (context) => PageParent()),
//                                            );


                                            //   dropval='';
//                                imageurl=" ";
                                          }


                                        },
                                      ),
                                    ),
                                  )),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      )),
//
                  SizedBox(
                    height: 30,
                  ),
//
                  SizedBox(
                    height: 20,
                  ),
//                  FadeAnimation(1.7, Center(child: Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(196, 135, 198, 1)),))),

                  SizedBox(
                    height: 30,
                  ),
//                  FadeAnimation(2, Center(child: Text("Create Account", style: TextStyle(color: Color.fromRGBO(49, 39, 79, .6)),))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

//

///// validation form///////
  ///valid email//
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if(value.isEmpty)
      return 'Email is requierd';
    if (!regex.hasMatch(value))
      return 'Email format is invalid';

    ///not work///////////
    else{
      userrefrence.document( value ).get().then((DocumentSnapshot doc){
        print(doc.exists);
        if (doc.exists==true)
          return'email already exist';
        else{
          return null;
        }
      });
    }}
/////////////////////////////////////////


  //validate username//
  String validateName(String value) {
    if (value.isEmpty) return 'UserName is requierd';
    if (value.length < 3)
      return 'Please enter a valid name your Name must be more than 2 charater';
    else
      return null;
  }

  ///validate age///
  String validateAge(int value) {
    if (value.toString().isEmpty) return 'Age is requierd';


      return null;
  }

//
  String pwdValidator(String value) {
    if (value.isEmpty) return 'Password is requierd';
    if (value.length < 6) {
      return 'Password must be longer than 6 characters';
    } else {
      return null;
    }
  }
  ////////////////////////////

  Widget _loading() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
