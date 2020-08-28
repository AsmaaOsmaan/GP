
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';


class AddProudct extends StatefulWidget {
  @override
  _AddProudctState createState() => _AddProudctState();
}

class _AddProudctState extends State<AddProudct> {
  bool isAdd=false;
  final _formkey=GlobalKey<FormState>();
  File _image1,_image2,_image3,_image4;
  String imageurl;
  Uri downloadUrl;
/////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////
  TextEditingController _proudctTitleController=TextEditingController();
  TextEditingController _proudctDescriptionController=TextEditingController();
  TextEditingController _proudctPriceController=TextEditingController();
  String SelectValue='select category';
  bool isError=false;
  bool isloading=false;

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
    _proudctDescriptionController.dispose();
    _proudctPriceController.dispose();
    _proudctTitleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Proudct'),
      ),
      body:(isloading) ? _loading() :ListView(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(16),
            child:Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _proudctTitleController ,
                    decoration: InputDecoration(
                      hintText: 'proudct Title',
                    ),

                    validator: (value) {
                      if (value.isEmpty) {
                        return 'title is requerd';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height:16 ,),
                  TextFormField(
                    controller: _proudctDescriptionController,
                    decoration: InputDecoration(
                      hintText: 'proudct Discreption',

                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Description is requeierd';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height:16 ,),
                  TextFormField(
                    controller:   _proudctPriceController,
                    keyboardType: TextInputType.numberWithOptions(
                        decimal: true
                    ),

                    decoration: InputDecoration(
                      hintText: ' proudct price',

                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'price is requierd';
                      }
                      return null;

                    },

                  ),
                  SizedBox(height: 16,),
                  SizedBox(width: double.infinity,
                    child:_SlectCategory() ,
                  ),
                  SizedBox(
                    height: 16,
                  ),


                  _displayImagesGrids(),
                  _displayImagesGridsCamera(),


                  SizedBox(height: 32,),
                  RaisedButton(
                    color: Colors.teal,
                    child: Text('Save Proudct',style: TextStyle(color: Colors.white),),
                    onPressed: ()async{
                      if (_formkey.currentState.validate()){
                        setState(() {
                          isloading=true;
                        });
                  if(_image1!=null){

                       //imageurl= await UploadImage(_image1);
                        String name=Random().nextInt(1000).toString()+'_proudct';
                        final StorageReference storageReference= FirebaseStorage().ref().child(name);
                        final StorageUploadTask UploadTask=storageReference.putFile(_image1);
                        StorageTaskSnapshot respons=    await  UploadTask.onComplete;
                      downloadUrl =await respons.ref.getDownloadURL();}


                      //  String imageurl2= await UploadImage(_image2);
                       // String imageurl3= await UploadImage(_image3);
                        else if(_image4!=null)

                        imageurl=await UploadImage(_image4);

                     //   String imageurl=await UploadImage(_image4);
                     //   List<String> images=[imageurl1,imageurl2, imageurl3,imageurl4];

                        Firestore.instance.collection('proudcts').document().setData({
                          'title' :  _proudctTitleController.text,
                          'description': _proudctDescriptionController.text  ,
                          'price':  _proudctPriceController.text,
                          'category_title':SelectValue,
                        //  'images':images,
                          'images':downloadUrl,

                          // 'image_camera':imageurl4,



                        }).then((data) {  setState(() {

                          isAdd=true;
                          isloading=false;
                        });
                        _proudctTitleController.text='';
                        _proudctDescriptionController.text='';
                        _proudctPriceController.text='';
                        SelectValue='select category';
                       // imageurl=" ";





                        });

                      }
                    }
                    ,
                  ),
                  // (isAdd)? Add():Container(),
                  SizedBox(width: 32,),
                  SizedBox(width: double.infinity,
                    //child: (isError)? Text('Error in Selecting',style: TextStyle(color: Colors.red),):Container(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<String>UploadImage(File image)async{
    String name=Random().nextInt(1000).toString()+'_proudct';
    final StorageReference storageReference= FirebaseStorage().ref().child(name);
    final StorageUploadTask UploadTask=storageReference.putFile(image);
    StorageTaskSnapshot respons=    await  UploadTask.onComplete;
    String URL=await respons.ref.getDownloadURL();

    return URL;
  }




  Widget _SlectCategory(){
    return StreamBuilder(
      stream: Firestore.instance.collection('categories').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');

        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return   DropdownButton<String>(
                value:  SelectValue,
                onChanged: (String newValue) {
                  if (newValue=='cat6'){
                    setState(() {
                      isError=true;
                    });
                  }
                  else{
                    setState(() {
                      SelectValue=newValue;
                      isError=false;
                    });}

                },
                items: snapshot.data.documents.map((DocumentSnapshot document){
                  return DropdownMenuItem<String>(
                    value: document['title'],
                    child:Text(document['title']),
                  );
                }).toList());
        }
      },
    );
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
























  Widget Add(){
    return Container(
      child: Center(
        child: Text('Add Successfuly',style: TextStyle(color: Colors.pink),),
      ),
    );

  }
  Widget _loading(){

    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

}
