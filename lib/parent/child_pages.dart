import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/db.dart';
import 'package:flutter_shop/page/page_screen.dart';
import 'package:provider/provider.dart';

import '../provider_data.dart';

class ChildPages extends StatefulWidget {
  final    ID;
  const ChildPages({Key key, this.ID}) : super(key: key);
  @override
  _ChildPagesState createState() => _ChildPagesState();
}

class _ChildPagesState extends State<ChildPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _draw(),
    );
  }

  Widget _draw(){
    final auth = Provider.of<ProviderData>(context);
    //Future<List<String>> result=getDocs(auth.userData.id);
    // print(result);
    return FutureBuilder(
      future: DB().getDocPages(widget.ID) ,
      builder: (context , snapshot){
        if(snapshot.connectionState ==ConnectionState.done){
          if(snapshot.hasData){
            List<String> name =[];
            List<String>photo=[];
            List<String>PagesIDs=[];

            var items = snapshot.data;
            print('items.length ${items.length}');
            for(var item in items){
              print('item.runtimeType ${item.runtimeType}');
              print("hhhhhhhhhhhhhhhhhhhdddddddddddddddd");
              print("item.documents.length${item.documents.length}");
              for(int i = 0 ;i < item.documents.length  ;i++){
                print('ddddddddddddddddddddddddddddddddddd');
             print("item.documents[i]['page_name']${item.documents[i]['pageName']}");
             print("item.documents[i]['pageID']${item.documents[i]['pageID']}");
             print("item.documents[i]['cover_Photo']${item.documents[i]['cover_Photo']}");
                name.add(item.documents[i]['pageName']);
                photo.add(item.documents[i]['cover_Photo']);
                PagesIDs.add(item.documents[i]['pageID']);
                //   switchindex.add(item.documents[i]['statues']);
              }
            }
            print('name.length ${name.length}');
           print('photo.length ${photo.length}');
            print('PagesIDs.length ${PagesIDs.length}');
            return ListView.builder(
                itemCount: name.length,
                itemBuilder:(context, index){
                  // return Center(child: Text(name[index]),);
                  return  BodyOfScreen(document:name[index],documment:photo[index],docummment:PagesIDs[index],ID:widget.ID);
                } );

          }
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
        return Center(child: CircularProgressIndicator(),);

      }
      ,
    );
    DB().getDocs('81nwUL3cKAeEd6JbJlzViFarXhr1');
    //getDocs('81nwUL3cKAeEd6JbJlzViFarXhr1');


    /*  Firestore.instance.collection('User')
        .document(auth.userData.id)
        .collection('groups').document().get().then(
            (DocumentSnapshot result) async {
          Firestore.instance
              .collection('Notification')
              .document()
              .collection('ActivtyLogitem')
              .add({
          }
          );
        });*/

/*
    return StreamBuilder<QuerySnapshot>(
      //snapshot.data
      //stream: Firestore.instance.collection('User').where('ParentID',isEqualTo: auth.userData.uid).snapshots(),
      stream: Firestore.instance.collectionGroup('members').snapshots(),
//var myReviews = firebase.firestore().collectionGroup('reviews')
//   .where('author', '==', myUserId);

      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
       // int  numm= snapshot.data.documents.length;


      //  print(auth.userData.ParentID);
        if (snapshot.hasError)
          return new Text('Error: ${snapshot.error}');
        if (!snapshot.hasData)
          return new Text('no data to returen');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting: return new Text('Loading...');
          default:
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
        print(document.data.length);
                return    Card(
                  color: Colors.pink,
                  child: InkWell(

                    splashColor: Colors.yellow,
                    highlightColor: Colors.blue.withOpacity(0.5),

                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                              children: <Widget>[
                                ( document['cover_photo']==null)?
                                Container(
                                    width: 60,
                                    height: 60,

                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        // borderRadius: BorderRadius.circular(100.0),
                                        image: DecorationImage(

                                          image: ExactAssetImage('images/imageprofile3.jpg'),
                                          fit: BoxFit.cover,
                                        ))): Container(
                                    width: 60,
                                    height: 60,

                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        // borderRadius: BorderRadius.circular(100.0),
                                        image: DecorationImage(

                                          image: NetworkImage(document['cover_photo']),
                                          fit: BoxFit.cover,

                                        ))),

                                Row(
                                  children: <Widget>[
                                    Text(
                                      document['groupName'],
                                      style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold,
                                        fontSize:15.0,
                                        fontFamily: 'DancingScript',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            IconButton(icon: Icon(Icons.delete_forever,),onPressed: (){
                              Firestore.instance.collection('User').document(document.documentID).delete();

                            },),
                          /*  Switch(value:switchval,onChanged:(bool val){
                              setState(() {
                                switchval=val;
                              });
                              Firestore.instance.collection('User').document(widget.document.documentID).updateData({'statues':switchval});

                            }, activeColor: switchval ? Colors.blue : Colors.grey  ,)*/
                          ],
                        )
                    ),
                  ),
                );




              }).toList(),
            );
        }
      },
    );*/

  }


}

class BodyOfScreen extends StatefulWidget {
  final document;
  final  documment;
  final  docummment;
  final ID;


  const BodyOfScreen({Key key, this.document,this.documment,this.docummment,this.ID}) : super(key: key);
  @override
  _BodyOfScreenState createState() => _BodyOfScreenState();
}

class _BodyOfScreenState extends State<BodyOfScreen> {

  bool switchval=false;



  @override
  Widget build(BuildContext context) {
    Firestore.instance.collection('User').document(widget.ID).collection('pages').document(widget.docummment).get().then((DocumentSnapshot result) async{

      setState(() {
        switchval = result['statues'];
      });
    });


    return    Card(
      child: InkWell(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageScreen(widget.docummment)),
          );
        },

        splashColor: Colors.yellow,
        highlightColor: Colors.blue.withOpacity(0.5),

        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween ,
              children: <Widget>[
                Column(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                  children: <Widget>[
                    ( widget.documment==null)?
                    Container(
                        width: 60,
                        height: 60,

                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // borderRadius: BorderRadius.circular(100.0),
                            image: DecorationImage(

                              image: ExactAssetImage('images/imageprofile3.jpg'),
                              fit: BoxFit.cover,
                            ))): Container(
                        width: 60,
                        height: 60,

                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // borderRadius: BorderRadius.circular(100.0),
                            image: DecorationImage(

                              image: NetworkImage(widget.documment),
                              fit: BoxFit.cover,

                            ))),

                    Row(
                      children: <Widget>[
                        Text(
                          widget.document,
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold,
                            fontSize:15.0,
                            fontFamily: 'DancingScript',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(icon: Icon(Icons.delete_forever,),onPressed: (){
                  Firestore.instance.collection('User').document(widget.ID).collection('pages').document(widget.docummment).delete();
                  Firestore.instance.collection('pages').document(widget.docummment).collection('follow').document(widget.ID).delete();

                },),


                Switch(value:switchval,onChanged:(bool val){
                  setState(() {
                    switchval=val;
                  });
                  Firestore.instance.collection('pages').document(widget.docummment).collection('follow').document(widget.ID).updateData({'statues':switchval});
                  Firestore.instance.collection('User').document(widget.ID).collection('pages').document(widget.docummment).updateData({'statues':switchval});

                }, activeColor: switchval ? Colors.blue : Colors.grey  ,)
              ],
            )
        ),
      ),
    );
  }
}
