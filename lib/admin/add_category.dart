
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  bool isloading=false;
  bool isError=false;
  final _formkey=GlobalKey<FormState>();
  TextEditingController _categoryTitleController=TextEditingController();
  @override
  void dispose() {
    super.dispose();
    _categoryTitleController.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Category'),
      ),
      body: (isloading) ? _loading() : _drawForm(),
    );
  }
  Widget _loading(){

    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  Widget _drawForm(){
    return  Form(
      key: _formkey,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: TextFormField(
                controller:  _categoryTitleController,
                decoration: InputDecoration(
                    hintText: 'Category Title'

                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'categoryTitle is requerd';
                  }
                  return null;
                },

              ),


            ),
            SizedBox(height: 16,),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: RaisedButton(
                child: Text('Save Category'),
                onPressed: ()async{
                  if (_formkey.currentState.validate()){
                    setState(() {
                      isloading=true;
                    });

           var response=await Firestore.instance.collection('categories').where ('title',isEqualTo: _categoryTitleController.text).snapshots().first;

             if(response.documents.length>=1){
               setState(() {
                 isloading=false;
                 isError=true;
               });
             }
             else{
                    Firestore.instance.collection('categories').document().setData({
                      'title' :  _categoryTitleController.text,

                    }).then((onValue){
                      setState(() {
                        isloading=false;
                        isError=false;
                      });
                      _categoryTitleController.text='';

                    });

                  }
                }}
                ,
              ),
            ),
            (isError)? _Error():Container(),

          ],
        ),
      ),
    );

  }
  Widget _Error(){
    return Container(
      child: Center(
        child: Text('Erorr, Doplucet Error Entry',style: TextStyle(color: Colors.red),),
      ),
    );
  }



}
