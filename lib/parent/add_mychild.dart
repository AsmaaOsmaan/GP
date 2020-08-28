import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/provider_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
class AddChild extends StatefulWidget {
  @override
  _AddChildState createState() => _AddChildState();
}

class _AddChildState extends State<AddChild> {
  bool isloading=false;

  File _image1,_image2,_image3,_image4;
  String imageurl;
 // Uri
 String downloadUrl;
  final userrefrence=Firestore.instance.collection('User');
  TextEditingController _ChildUserNameController=TextEditingController();
  TextEditingController _ChildEmailController=TextEditingController();
  TextEditingController _ChildAgeController=TextEditingController();
  TextEditingController _ChildPassWordController=TextEditingController();
  TextEditingController _ChildAboutmeController=TextEditingController();
  final _formkey=GlobalKey<FormState>();




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
    _ChildEmailController.dispose();
    _ChildAgeController.dispose();
    _ChildPassWordController.dispose();
    _ChildAboutmeController.dispose();

  }
  String dropval;
  void dropchange(String val){
    setState(() {
      dropval=val;
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(icon: Icon(Icons.person_outline))
        ],
        backgroundColor: Colors.deepOrangeAccent,
        title: Text('New Child',style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize:20.0,
            fontStyle:FontStyle.italic
        ),),
        centerTitle: true,
      ),
      body:
       Form(
        key: _formkey,
        child: ListView(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 24,right: 24,top: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _ChildUserNameController,
                      decoration:InputDecoration(
                        icon: Icon(Icons.person),
                        hintText: 'User Name',
                      ),
                      validator: validateName,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _ChildEmailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration:InputDecoration(
                        icon: Icon(Icons.email),
                        hintText: 'Email',

                      ),

                      validator: validateEmail,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _ChildPassWordController,
                      obscureText: true,
                      decoration:InputDecoration(
                        icon: Icon(Icons.visibility_off),
                        hintText: 'Password',
                      ),

                      validator: (value) {
                        if (value.isEmpty) {
                          return 'PassWord is requeierd';
                        }
                        if(value.length<6){
                          return 'PassWord should be at least 6 charater';
                        }
                        return null;
                      },


                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _ChildAboutmeController,
                      decoration:InputDecoration(
                        icon: Icon(Icons.description),
                        hintText: 'About',
                      ),
                      validator: validateName,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _ChildAgeController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration:InputDecoration(
                        icon: Icon(Icons.calendar_today),
                        hintText: 'Age',
                      ),
                      validator: (value)  {
               var potentialNumber = int.tryParse(value);
               if (potentialNumber == null) {
              return 'Age is requierd';
                 }
               else if(potentialNumber>18){
                 return 'Sorry your child should be less than 18 year';
               }
               return null;
       },

                    ),
                    SizedBox(height: 10),

                    Container(
                      width: double.infinity, // specific value
                      child: DropdownButton<String>(
                        icon: Icon(Icons.group,),
                        elevation: 1,
                        onChanged: dropchange,
                        value: dropval,
                        hint: Text('Gender',style: TextStyle(fontSize: 22,),),
                        items: <String>['Male','Female']
                            .map<DropdownMenuItem<String>>((String value){
                          return DropdownMenuItem<String>(
                            child:Text(value),
                            value:value,
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 10),

                    Container(
                      width: double.infinity, // specific value
                      child: Row(
                        children: <Widget>[
                          _displayImagesGridsfile(),
                          _displayImagesGridsCamera(),
                        ],
                      ),
                    ),

                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 50,
                          width: double.infinity, // specific value
                          child: RaisedButton(
                              color:Colors.deepOrangeAccent,
                              child: Text('Sign in',style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,),),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0)),
                              onPressed: () async {
                                if (_formkey.currentState.validate()) {

                                  if(_image1!=null){

                                    imageurl= await UploadImage(_image1);
                                   // String name=Random().nextInt(1000).toString()+'_proudct';
                                   // final StorageReference storageReference= FirebaseStorage().ref().child(name);
                                  //  final StorageUploadTask UploadTask=storageReference.putFile(_image1);
                                   // StorageTaskSnapshot respons=    await  UploadTask.onComplete;
                                    //downloadUrl =await respons.ref.getDownloadURL();
                                  }
                                  //  String imageurl2= await UploadImage(_image2);
                                  // String imageurl3= await UploadImage(_image3);
                                  else if(_image4!=null)
                                    imageurl=await UploadImage(_image4);
/////////////

                               final auth = Provider.of<ProviderData>(context);
                                    FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                        email: _ChildEmailController.text,
                                        password: _ChildPassWordController.text)
                                        .then((currentUser) => Firestore.instance
                                        .collection("User")
                                        .document(
                                      currentUser.user.uid,
                                    ).setData({
                                    'UserName': _ChildUserNameController.text,
                                    'Email': _ChildEmailController.text,
                                    'Password': _ChildPassWordController.text,
                                    'age': _ChildAgeController.text,
                                    'Gender': dropval,
                                    //'ParentID':currentUser.user.uid,
                                      'ParentID':auth.userData.id,
                                    'images':imageurl,
                                    'statues':false,
                                      'nickname': _ChildUserNameController.text,
                                      'photoUrl':imageurl,
                                      'aboutMe':_ChildAboutmeController.text

                                  })
                                      .then((data) {
                                    setState(() {
                                      print('add');
                                      isloading=true;
                                      _ChildPassWordController.text='';
                                      _ChildAgeController.text='';
                                      _ChildEmailController.text='';
                                      _ChildUserNameController.text='';
                                      _ChildAboutmeController.text='';
                                      //   dropval='';
                                      imageurl=" ";
                                    });
                                  }));
                                //  _ChildPassWordController.text='';
                                 // _ChildAgeController.text='';
                                // _ChildEmailController.text='';
                             //     _ChildUserNameController.text='';
                               //   dropval='';
                                 //  imageurl=" ";
                                };

                              }  )),

                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
  Widget _displayImagesGrids(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[

            InkWell(
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.teal,
              ),
              onTap: ()async{
                var image = await ImagePicker.pickImage(source: ImageSource.gallery);

                setState(() {
                  _image1 = image;
                });
              },
            ),

          ],
        )
      ],
    );
  }
///// validation form///////
      ///valid email//
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if(value.isEmpty)
      return 'Email is requierd';
    if (!regex.hasMatch(value))
      return 'Enter Valid Email';

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
    }
/////////////////////////////////////////




  }
     //validate username//
  String validateName(String value) {
    if(value.isEmpty)
      return 'UserName is requierd';
    if (value.length < 3)
      return 'Name must be more than 2 charater';
    else
      return null;
  }
    ///validate age///
  String validateAge(int value) {
    if(value.toString().isEmpty)
      return 'Age is requierd';
    if (value < 18)
      return 'sorry your child should be at least 18 year';
    else
      return null;
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
  ////////////////////////////


  Widget _loading(){

    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

