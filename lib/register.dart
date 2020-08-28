
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_shop/Auth/Animation/FadeAnimation.dart';
import 'package:flutter_shop/Auth/login.dart';
import 'package:flutter_shop/parent/list_children.dart';
import 'package:flutter_shop/provider_data.dart';

import 'package:flutter_shop/user_data.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import 'authentication/dialogBox.dart';
import 'authentication/firedase_authentication.dart';

//import 'login.dart';
//import '../authentication/dialogBox.dart';
//import '../authentication/firedase_authentication.dart';

class Register extends StatefulWidget {
  Register({
    this.auth,
    this.onSignedIn,
    this.providerData,
  });

  final AuthImplementation auth;
  final ProviderData providerData ;
  final VoidCallback onSignedIn;
  @override
  _RegisterState createState() => _RegisterState();
}

enum FormType {
  login,
  register,
}

class _RegisterState extends State<Register> {
  File _image1,_image2,_image3,_image4;
  DialogBox dialogBox = new DialogBox();
  bool isloading = false;
  String imageurl;
  String downloadUrl;
  final userrefrence = Firestore.instance.collection('User');

  TextEditingController _ChildUserNameController = TextEditingController();
  TextEditingController _ChildAboutmeController = TextEditingController();
  TextEditingController _UserNameController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _AgeController = TextEditingController();
  TextEditingController PassWordController = TextEditingController();
  TextEditingController PhoneNumberController = TextEditingController();
  TextEditingController confirmPwdInputController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  Future getImage(File requierdImage) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      requierdImage = image;
    });
  }

  Future getImageFromCamera(File requierdImage) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      requierdImage = image;
    });
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _ChildUserNameController.dispose();
    _ChildAboutmeController.dispose();
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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PersistentBottomSheetController _sheetController;
  String _displayName;
  bool _loading2 = false;
  bool _autoValidate = false;
  String errorMsg = "";
  FormType _formType = FormType.register;
  String _email = "";
  String _password = "";

  void moveToLogin() {
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<ProviderData>(context);
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
                              validator: pwdValidator,
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: confirmPwdInputController,
                              obscureText: true,
                              decoration: InputDecoration(
                                icon: Icon(Icons.visibility_off),
                                hintText: 'Confirm Password',
                              ),
                              validator: pwdValidator,
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: _AgeController,
                              keyboardType: TextInputType.datetime,
//                                inputFormatters: Date,
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
                                if (value.length != 11) {
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

                                elevation: 10,
                                onChanged: dropchange,
                                iconSize: 36,
                                value: dropval,
                                style: TextStyle(color: Colors.purple,fontWeight: FontWeight.bold,),
                                hint: Text(
                                  'Gender',
                                  style: TextStyle(
                                    fontSize: 22,
                                  ),
                                ),


                                items: <String>[
                                  'Male' ,
                                  'Female'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    child: Text(value),
                                    value: value,
                                  );
                                }).toList(),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _ChildAboutmeController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.description),
                                hintText: 'About You',
                              ),
                              validator: validateAbout,
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            Container(
                              width: double.infinity, // specific value
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.add_a_photo,
                                  ),
                                  SizedBox(width:10,),
                                  Text(
                                    "choose your Profile pictures",
                                    style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 10),
                                  ),

//                                  SizedBox(width:1),
                                  _displayImagesGridsfile(),
                                  _displayImagesGridsCamera(),
                                ],
                              ),
                            ),

                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
//

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
//
                          onPressed: () async {
                            if (_formkey.currentState.validate()) {
                              if(_image1!=null){

                                imageurl= await UploadImage(_image1);

                              }

                              else if(_image4!=null)
                                imageurl=await UploadImage(_image4);

//
                              if (PassWordController.text ==
                                  confirmPwdInputController.text) {
//                                Toast.show("your account create Successfully", context);
                                final auth = Provider.of<ProviderData>(context);

                                FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                    email: _EmailController.text,
                                    password: PassWordController.text)
                                    .then((currentUser) => Firestore.instance
                                    .collection("User")
                                    .document(
                                  currentUser.user.uid,
                                )
                                    .setData({
                                  "uid": currentUser.user.uid,
                                 // "statues": "false",
                                  "statues": "false",
                                  "ParentID": "parent",
                                  'UserName': _UserNameController.text,
                                  'Email': _EmailController.text,
                                  'Password': PassWordController.text,
                                  'age': _AgeController.text,
                                  'PhoneNumber': PhoneNumberController.text,
                                  'Gender': dropval,
                                  'nickname': _UserNameController.text,
                                  'photoUrl':imageurl,
                                  'aboutMe':_ChildAboutmeController.text,
                                  "id": currentUser.user.uid,
                                }).then((result) async {
                                  setState(() {
                                    print('add');
                                    isloading = true;
                                    _UserNameController.text='';
                                    _EmailController.text='';
                                    PassWordController.text='';
                                    _AgeController.text='';
                                    PhoneNumberController.text='';
                                    confirmPwdInputController.text='';
                                    _ChildAboutmeController.text='';
                                    imageurl="";
                                  });
                                  DocumentSnapshot userDoc =
                                  await Firestore.instance
                                      .collection('User')
                                      .document(
                                      currentUser.user.uid)
                                      .get();
                                  Provider.of<ProviderData>(context)
                                      .userData =
                                      UserData.fromDoc(userDoc);
                                  // ignore: sdk_version_set_literal
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              PageParent(
//
                                              )),
                                          (_) => false);

                                }).catchError((err) {
                                  dialogBox.information(
                                      context, "Error", err.toString());
                                  print("Error =" + err.toString());
                                }))
                                    .catchError((err) {
                                  dialogBox.information(
                                      context, "Error", err.toString());
                                  print("Error =" + err.toString());
                                });
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text("Error"),
                                        content:
                                        Text("The passwords do not match"),
                                        actions: <Widget>[
                                          FlatButton(
                                            child: Text("Close"),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          )
                                        ],
                                      );
                                    });
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    child: Center(
                      child: Column(
                        children: <Widget>[
                          Text("Already have an account?"),
                          FlatButton(
                            child: Text("Login here!"),
//                            onPressed: moveToLogin,
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => Login()));
                            },
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
//                  FadeAnimation(2, Center(child: Text("Create Account", style: TextStyle(color: Color.fromRGBO(49, 39, 79, .6)),))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _displayImagesGridsCamera(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[


            Container(
              child: IconButton(icon:Icon(Icons.camera_alt)
                  , onPressed:()async{
                    var image = await ImagePicker.pickImage(source: ImageSource.camera);

                    setState(() {
                      _image4 = image;
                    });

                  }),
            )

          ],
        )
      ],
    );
  }
  //////////////////////////////

  Widget _displayImagesGridsfile(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[


            Container(
              child: IconButton(icon:Icon(Icons.photo_filter)
                  , onPressed:()async{
                    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

                    setState(() {
                      _image1 = image;
                    });

                  }),
            )

          ],
        )
      ],
    );
  }

  Future<String>UploadImage(File image)async{
    String name=Random().nextInt(1000).toString()+'_child';
    final StorageReference storageReference= FirebaseStorage().ref().child(name);
    final StorageUploadTask UploadTask=storageReference.putFile(image);
    StorageTaskSnapshot respons=    await  UploadTask.onComplete;
    String URL=await respons.ref.getDownloadURL();

    return URL;
  }

//

///// validation form///////
  ///valid email//
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

/////////////////////////////////////////
  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return '*Required';
    if (!regex.hasMatch(value))
      return '*Enter a valid email';
    else
      return null;
  }

  //validate username//
  String validateName(String value) {
    if (value.isEmpty) return 'UserName is requierd';
    if (value.length < 3)
      return 'Please enter a valid name .';
    else
      return null;
  }

  String validateAbout(String value) {
    if (value.isEmpty) return 'Please Write some information about you !';

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
}
