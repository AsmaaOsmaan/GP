
import 'package:flutter_shop/page/page_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class About extends StatefulWidget {
  final String documentID;

  About(this.documentID, {Key key}) : super(key: key);
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firestore.instance
            .collection('groups')
            .document(widget.documentID)
            .get(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
                    return Scaffold(
            //backgroundColor: Color(0xFFcccccc),
                      appBar: AppBar(

                        backgroundColor: Colors.grey.shade300,
                        title: Text('About ',style: TextStyle(fontSize: 23,color: Colors.purple.shade800),),

                      ),
                      body: ListView(

                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: Column(

                              children: <Widget>[
                                SizedBox(height: 50,width: MediaQuery.of(context).size.width*1/3,),
                                Row(
                                  children: <Widget>[
                                    FlatButton(onPressed: (){}, child:Row(
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                              Icons.call,
                                              size: 25,
                                            ),
                                            color: Colors.grey.shade800,
                                            onPressed: () {}),
                                        Text('0123457890',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Color(0xFF9656A1)
                                            )),
                                      ],
                                    ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    FlatButton(onPressed: (){}, child:Row(
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                              Icons.email,
                                              size: 25,
                                            ),
                                            color: Colors.grey.shade800,
                                            onPressed: () {}),
                                        Row(
                                          children: <Widget>[
                                            Text(snapshot.data['groupName'],
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Color(0xFF9656A1)
                                                )),
                                          Text('.gmail.com',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Color(0xFF9656A1)
                                                )),
                                          ],

                                        ),
                                      ],
                                    ),
                                    )
                                  ],
                                ),

                                Row(
                                  children: <Widget>[
                                    FlatButton(onPressed: (){}, child:Row(
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                              Icons.offline_bolt,
                                              size: 25,
                                            ),
                                            color: Colors.grey.shade800,
                                            onPressed: () {}),
                                        Text('Send Message',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Color(0xFF9656A1)
                                            )),
                                      ],
                                    ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    FlatButton(onPressed: (){}, child:Row(
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                              Icons.subscriptions,
                                              size: 25,
                                            ),
                                            color: Colors.grey.shade800,
                                            onPressed: () {}),
                                        Text('https://youtube.com/',
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Color(0xFF9656A1)
                                            )),
                                        Text(snapshot.data['groupName'],
                                            style: TextStyle(
                                                fontSize: 17,
                                                color: Color(0xFF9656A1)
                                            )),
                                      ],
                                    ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  child: Container(color: Colors.grey.shade300,),
                                  height: 10,

                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Text(
                                      'Group By',
                                      style: TextStyle(fontSize: 18, color: Colors.grey.shade900),
                                    ),
                                   FlatButton(
                                      onPressed: () {},
                                      child: Text(snapshot.data['username'],
                                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                                      ),
                                    ),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                                  children: <Widget>[


                                    Text(
                                      'Members in group',
                                      style: TextStyle(
                                          fontSize: 17, color: Colors.grey.shade900),
                                    ),
                                    Text(snapshot.data['NumberOfMembers'].toString() ,
                                      style: TextStyle(fontSize: 16, color: Colors.grey.shade600),),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                                  children: <Widget>[
                                    Text(
                                      'Admins',
                                      style: TextStyle(fontSize: 18, color: Colors.grey.shade900),
                                    ),
                                    FlatButton(
                                      onPressed: () {},
                                      child: Text(
                                        snapshot.data['username'],
                                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  child: Container(color: Colors.grey.shade300,),
                                  height: 10,

                                ),
                               /* Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.public,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width*1/9,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Public',style: TextStyle(color: Colors.grey.shade900,fontSize: 18,),),
                                        Text(
                                          "Anyone can see who's in this group",style: TextStyle(color: Colors.grey.shade500,fontSize: 14,),),
                                      ],
                                    ),

                                  ],
                                ),
                                SizedBox(height: 15,),
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.grey,
                                      size: 25,
                                    ),
                                    SizedBox(width: MediaQuery.of(context).size.width*1/9,),


                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('visible',style: TextStyle(color: Colors.grey.shade900,fontSize: 18,),),
                                        Text(
                                          "Anyone can find  this group ",style: TextStyle(color: Colors.grey.shade500,fontSize: 14,),),
                                      ],
                                    ),

                                  ],
                                ),*/

                              ],
                            ),
                          ),
                        ],
                      ),



          );

          }
        });
  }
}
