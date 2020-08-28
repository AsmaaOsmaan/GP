import 'dart:math';
import 'dart:io';
import 'package:flutter_shop/child/Screens/profile_add_friend_screen.dart';
import 'package:flutter_shop/child/Screens/profile_friends_screen.dart';
import 'package:flutter_shop/child/Screens/profile_screen.dart';
import 'package:flutter_shop/group/update_post.dart';
import 'package:flutter_shop/group/updategroup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/group/group_tabs/about.dart';
import 'package:flutter_shop/group/group_tabs/photo.dart';
import 'package:flutter_shop/page/page_screen.dart';
import 'package:flutter_shop/Screenss/group_comment_screen.dart';
import 'package:provider/provider.dart';
import '../provider_data.dart';
import 'creategroup_screen.dart';
//import '../group/group_tabs/files.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'invite_member.dart';
import 'list_members_group.dart';
import 'list_members_group_admin.dart';
import 'list_requests_group.dart';
class AdminGroupScreen extends StatefulWidget {
  final String documentID;

  AdminGroupScreen(this.documentID, {Key key}) : super(key: key);
  @override
  _AdminGroupScreenState createState() => _AdminGroupScreenState();
}

class _AdminGroupScreenState extends State<AdminGroupScreen> {
  bool isLiked = false;
  int likeCount = 0;


  final _formKey = GlobalKey<FormState>();
  File _image1;
  String imageurl;

  TextEditingController _postContentController = TextEditingController();
  String get documentID => null;
  Future getImage(File requiredImage) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      requiredImage = image;
    });
  }

  final _formKey2 = GlobalKey<FormState>();
  TextEditingController _commentContentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _commentContentController.dispose();
    _postContentController.dispose();
  }

  Future<String> countDocuments() async {
    QuerySnapshot _myDoc = await Firestore.instance.collection('members').getDocuments();
    List<DocumentSnapshot> _myDocCount = _myDoc.documents;
   return Future.value(_myDocCount.length .toString());  // Count of Documents in Collection
  }

  _photoPressed() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Photos(widget.documentID)));
    });
  }

  _aboutPressed() {
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => About(widget.documentID)));
    });
  }

  _createNewGroup() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreateGroup()));
    });
  }

  void _commentNew(context, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return GroupComment(widget.documentID, postId);
      },
      isScrollControlled: true,
    );
  }



  void _updatePost(context, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return UpdatePost(widget.documentID, postId);
      },
      isScrollControlled: true,
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.black,
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        title: Container(
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.black),
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
          padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 1 / 26,
              left: MediaQuery.of(context).size.width * 1 / 26),
          decoration: BoxDecoration(
              color: Color(0xFFcccccc),
              borderRadius: BorderRadius.all(Radius.circular(22.0))),
        ),
      ),
      body: ListView(
        children: <Widget>[
          _coverGroup(),
          _profileGroup(),
          _drawLine3(),
          _writePost(),
          _drawLine3(),
          _createPage(),
          _drawLine3(),
          _post(),
        ],
      ),
    );
  }

  Widget _coverGroup() {
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
              return Container(
                child:Column(
                  children: <Widget>[
                (snapshot.data['cover_photo']==null)
                    ? Container(
                    height: 200,
                    color: Colors.grey.shade200
                )
                    : Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(snapshot.data['cover_photo']),
                    ),
                  ),
                )
                  ],
                ),

              );

          }
        });
  }

  Widget _profileGroup() {
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
              return Container(
                decoration:BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('images/ty.jpg'),
                      fit: BoxFit.cover,
                    )) ,
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.purple.shade200,
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Group By',
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey.shade900),
                          ),
                          Text(
                              snapshot.data['username'],
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey.shade600),
                            ),

                        ],
                      ),
                    ),
                    Text(
                      snapshot.data['groupName'],
                      style:
                      TextStyle(fontSize: 25, color: Colors.grey.shade900),
                    ),

                    Column(
                      children: <Widget>[
                        InkWell(
                          onTap:  () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ListMembersGroupAdmin(widget.documentID),
                                // builder: (context) => GroupScreen( ),
                              ),
                            );
                          }, //list of members
                          child: Row(children: <Widget>[
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 1 / 13,
                            ),
                            Text( snapshot.data['NumberOfMembers'].toString() ,
                               style: TextStyle(
                               fontSize: 17, color: Colors.grey.shade900),),
                            Text(
                              '  Members',
                              style: TextStyle(
                                  fontSize: 17, color: Colors.grey.shade900),
                            ),
                          ],)

                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        InviteMember(widget.documentID),
                                    // builder: (context) => GroupScreen( ),
                                  ),
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.all(5),
                                color: Colors.grey.shade300,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.add,
                                      color: Colors.black,
                                      size: 25,
                                    ),
                                    Text(
                                      'invite',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.grey.shade900),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 200,
                                        child: Wrap(
                                          children: <Widget>[
                                            FlatButton(
                                              onPressed: ()
                                              async {
                                                await Firestore.instance
                                                    .collection('groups')
                                                    .document(widget
                                                    .documentID)
                                                    .delete();
                                              },
                                              child: ListTile(
                                                title: Text(
                                                  'Delete Group',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                leading: Icon(
                                                  Icons.delete,
                                                  color: Color(0xFF9656A1),
                                                ),
                                              ),
                                            ),
                                            FlatButton(
                                              onPressed: (){
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => UpdateGroup(widget.documentID)),
                                                );
                                              },
                                              child: ListTile(
                                                title: Text(
                                                  'Edit Group',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                leading: Icon(
                                                  Icons.edit,
                                                  color: Color(0xFF9656A1),
                                                ),
                                              ),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ListRequestsGroup(widget.documentID)),
                                                );
                                              },
                                              child: ListTile(
                                                title: Text(
                                                  'Request Group',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                                leading: Icon(
                                                  Icons.people,
                                                  color: Color(0xFF9656A1),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },

                              icon: Icon(Icons.more_horiz),
                              padding: EdgeInsets.only(
                                left: (MediaQuery.of(context).size.width *
                                    1 /
                                    2.5),
                              ),
                            ),


                          ],
                        ),
                      ],

                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () => _photoPressed(),
                          child: Text(
                            'Photo',
                            style: TextStyle(color: Color(0xFF9656A1)),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 1 / 13,
                        ),
                        RaisedButton(
                          onPressed: () => _aboutPressed(),
                          child: Text(
                            'About',
                            style: TextStyle(color: Color(0xFF9656A1)),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 1 / 13,
                        ),
                        RaisedButton(
                          onPressed: () {}, // => _filePressed(),
                          child: Text(
                            'Files',
                            style: TextStyle(color: Color(0xFF9656A1)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
          }
        });
  }
  Widget _writePost() {
    final auth = Provider.of<ProviderData>(context);
    if(auth.userData.ParentID=='parent'){
      return Container();
    }
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          (auth.userData.profileImage==null)?
          InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width * 1 / 6,
                height: MediaQuery.of(context).size.width * 1 / 6,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('images/user_placeholder.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen(auth.userData.id)),
                );
              })
              : InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width * 1 / 6,
                height: MediaQuery.of(context).size.width * 1 / 6,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image:    NetworkImage(auth.userData.profileImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen(auth.userData.id)),
                );
              }),
          SizedBox(width: MediaQuery.of(context).size.width * 2 / 60),
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(4),
            margin: EdgeInsets.only(
              top: 10,
              bottom: 10,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 2 / 5,
                  child: TextFormField(
                    controller: _postContentController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Write Post...",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                        )),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Post is required';
                      }
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    size: 28,
                  ),
                  color: Colors.grey.shade800,
                  onPressed: ()async{
                    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

                    setState(() {
                      _image1 = image;
                    });
                  },
                ),
              ],
            ),
          ),
          FlatButton(
            child: Text(
              'Post',
              style: TextStyle(color: Color(0xFF9656A1), fontSize: 18),
            ),
            onPressed: ()
            // async

            async {
              if (_formKey.currentState.validate()) {

                if(_image1!=null){

                  imageurl= await uploadImage(_image1);
                }

                final auth = Provider.of<ProviderData>(context);
                print('imageurl');
                print(imageurl);

                /* Firestore.instance.collection('groups')
                    .document(widget.documentID)
                    .get().then(
                        (DocumentSnapshot result) async {*/
                DocumentReference documentReference =
                Firestore.instance
                    .collection('groups')
                    .document(widget.documentID)
                    .collection('post')
                    .document();
                documentReference.setData({
                  'postData': _postContentController.text,
                  'post_image': imageurl,
                  'userid': auth.userData.id,
                  'username':auth.userData.name,
                  'timestamp': DateTime.now().toString(),
                  // 'timestamp': Timestamp.fromDate(DateTime.now()),
                  'post_id': documentReference.documentID,
                  'groupID': widget.documentID,
                  // 'groupName':result['groupName'],
                  'NumberOfComments':0,
                  'NumberOfLikes':0,

                });


                Firestore.instance
                    .collection('ActivtyLog')
                    .document(auth.userData.ParentID)
                    .collection('ActivtyLogitem')
                    .document()
                    .setData({
                  'postData': _postContentController.text,
                  'imagePost': imageurl,
                  'userid': auth.userData.id,
                  'username':auth.userData.name,
                  'ParentId':auth.userData.ParentID,
                  'userProfileImg':auth.userData.profileImage,
                  'type': 'post',
                  'timestamp': Timestamp.fromDate(DateTime.now()),
                  'groupID': widget.documentID,
                });
                Firestore.instance
                    .collection('user_home')
                    .document(auth.userData.id)
                    .collection('post')
                    .document()
                    .setData({
                  'postData': _postContentController.text,
                  'post_image': imageurl,
                  'userid': auth.userData.id,
                  'username':auth.userData.name,
                  'timestamp':  DateTime.now().toString(),
                  'post_id': documentReference.documentID,
                  'post_content': _postContentController.text,
                  'pageID': 'null',
                  //'pageID':Null
                  //'groupID':Null
                  'groupID': widget.documentID
                });
                imageurl=" ";
                print('add');
                print(imageurl);
                _postContentController.text="";



              }
            },
          ),
        ],
      ),
    );
  }
  Widget _drawLine3() {
    return Container(
        height: 30,
        //color: Colors.grey.shade300,
        decoration:BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/ty.jpg'),
              fit: BoxFit.cover,
            ))
    );
  }
  Widget _post() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection('groups')
            .document(widget.documentID)
            .collection('post')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Container(
                height: MediaQuery.of(context).size.height * 0.79,
                child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(
                                      MediaQuery.of(context).size.width *
                                          1 /
                                          26),
                                  child: InkWell(
                                    onTap: (){
                                      final auth = Provider.of<ProviderData>(context);

                                      Firestore.instance
                                          .collection('User')
                                          .document(auth.userData.id)
                                          .collection('Friends')
                                          .document(snapshot.data.documents[index]
                                      ['userid'])
                                          .get().then((DocumentSnapshot doc){
                                        if (doc.exists){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => FriendScreen(snapshot.data.documents[index]
                                              ['userid']),
                                            ),);

                                        }


                                        else if(auth.userData.id == snapshot.data.documents[index]
                                        ['userid']){
                                          Navigator.push(
                                            context,

                                            MaterialPageRoute(
                                              builder: (_) => ProfileScreen(snapshot.data.documents[index]
                                              ['userid']),
                                            ),
                                          );

                                        }
                                        else   {
                                          Navigator.push(
                                            context,

                                            MaterialPageRoute(
                                              builder: (_) => AddFriend(snapshot.data.documents[index]
                                              ['userid']),
                                            ),
                                          );
                                        }
                                      });
                                    },
                                    child: CircleAvatar(
                                      backgroundImage: ExactAssetImage(
                                          'images/profile_page.jpg'),
                                      radius: 25,
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          snapshot.data.documents[index]
                                          ['username'],
                                          style: TextStyle(
                                            color: Colors.grey.shade900,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              1 /
                                              7,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      snapshot.data.documents[index]['timestamp'],


                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),

                                IconButton(
                                  onPressed: () {
                                    final auth = Provider.of<ProviderData>(context);

                                    if( (snapshot.data.documents[index]['userid']) ==(auth.userData.id)) {
                                      showModalBottomSheet(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 200,
                                              child: Wrap(
                                                children: <Widget>[
                                                  FlatButton(
                                                    onPressed: () async {
                                                      await Firestore.instance
                                                          .collection('groups')
                                                          .document(widget
                                                          .documentID)
                                                          .collection('post')
                                                          .document(snapshot
                                                          .data
                                                          .documents[
                                                      index]
                                                          .documentID)
                                                          .collection(
                                                          'comment')
                                                          .document(snapshot
                                                          .data
                                                          .documents[
                                                      index]
                                                          .documentID)
                                                          .collection('like')
                                                          .getDocuments()
                                                          .then((snapshot) {
                                                        for (DocumentSnapshot ds
                                                        in snapshot
                                                            .documents) {
                                                          ds.reference
                                                              .delete();
                                                        }
                                                      });
                                                      await Firestore.instance
                                                          .collection('groups')
                                                          .document(widget
                                                          .documentID)
                                                          .collection('post')
                                                          .document(snapshot
                                                          .data
                                                          .documents[
                                                      index]
                                                          .documentID)
                                                          .delete();
                                                    },
                                                    child: ListTile(
                                                      title: Text(
                                                        'Delete Post',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                      leading: Icon(
                                                        Icons.delete,
                                                        color: Color(0xFF9656A1),
                                                      ),
                                                    ),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () => _updatePost(
                                                        context,
                                                        snapshot.data.documents[index]
                                                            .documentID),
                                                    child: ListTile(
                                                      title: Text(
                                                        'Edit Post',
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                      leading: Icon(
                                                        Icons.edit,
                                                        color: Color(0xFF9656A1),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });}
                                    else{
                                      Container();
                                    }


                                  },

                                  icon: Icon(Icons.more_horiz),
                                  padding: EdgeInsets.only(
                                    left: (MediaQuery.of(context).size.width *
                                        1 /
                                        5),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: (MediaQuery.of(context).size.width *
                                    1 /
                                    40),
                                right: (MediaQuery.of(context).size.width *
                                    1 /
                                    40),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    snapshot.data.documents[index]
                                    ['postData'],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1.2,
                                        color: Colors.grey.shade900),
                                  ),
                                  (snapshot
                                      .data.documents[index]['post_image']==null)
                                      ? Container()
                                      : Image(
                                    image: NetworkImage(snapshot
                                        .data.documents[index]['post_image']),
                                    fit: BoxFit.cover,
                                  ),



                                  FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(
                                              right: (MediaQuery.of(context)
                                                  .size
                                                  .width *
                                                  1 /
                                                  7)),
                                          child: Text(
                                            snapshot.data.documents[index]
                                            ['NumberOfLikes'].toString(),
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                                fontSize: 13,
                                                height: 1.2,
                                                color: Colors.grey.shade800),
                                          ),

                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              1 /
                                              7,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: (MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    1 /
                                                    5)),

                                            child: Row(children: <Widget>[
                                              Text(
                                                snapshot.data.documents[index]
                                                ['NumberOfComments'].toString(),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    height: 1.2,
                                                    color: Colors.grey.shade800),
                                              ),
                                              Text('  Comments',  textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    height: 1.2,
                                                    color: Colors.grey.shade800),),
                                            ],)


                                        ),
                                      ],
                                    ),
                                    onPressed: () => _commentNew(
                                        context,
                                        snapshot
                                            .data.documents[index].documentID),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            color: Colors.grey.shade300,
                          ),
                          Container(

                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        FlatButton(
                                            child: Row(
                                              children: <Widget>[


                                                FutureBuilder(

                                                    future: Firestore.instance
                                                        .collection('groups')
                                                        .document(
                                                        widget.documentID)
                                                        .collection('post')
                                                        .document(snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID)
                                                        .collection('like')
                                                        .document(snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID)
                                                        .get(),
                                                    builder: (context,
                                                        AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                      final auth = Provider.of<ProviderData>(context);
                                                      if (!snapshot
                                                          .hasData) {
                                                        return Icon(
                                                          Icons.thumb_up,
                                                          size: 18,
                                                          color: Colors
                                                              .grey.shade800,
                                                        );
                                                      }
                                                      isLiked =
                                                          snapshot.data.exists;
                                                      return Icon(
                                                        Icons.thumb_up,
                                                        size: 18,
                                                        color: isLiked
                                                            ? Colors.purple
                                                            : Colors
                                                            .grey.shade800,
                                                      );
                                                    }),

                                                Text('Like',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    )),
                                              ],
                                            ),
                                            onPressed: () {

                                              setState(() {
                                                isLiked = !isLiked;
                                              });
                                              if (isLiked) {

                                                final auth = Provider.of<ProviderData>(context);
                                                Firestore.instance
                                                    .collection('groups')
                                                    .document(widget.documentID)
                                                    .collection('post')
                                                    .document(snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID)
                                                    .collection('like')
                                                    .document(snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID)
                                                    .setData({
                                                  'userid': auth.userData.id,
                                                  'username':auth.userData.name,
                                                  'postData' : _postContentController.text,
                                                });
                                      Firestore.instance.collection('groups')
                                          .document(widget.documentID)
                                          .collection('post').document(snapshot
                                          .data
                                          .documents[index]
                                          .documentID).get().then(
                                      (DocumentSnapshot result) async {
                                                Firestore.instance
                                                    .collection('ActivtyLog')
                                                    .document(auth.userData.ParentID)
                                                    .collection(
                                                    'ActivtyLogitem')
                                                    .document()
                                                    .setData({
                                                  'postData':result["postData"],
                                                  'imagePost':result["post_image"],
                                                  'userid': auth.userData.id,
                                                  'username':auth.userData.name,
                                                  'parentId':auth.userData.ParentID,
                                                  'userProfileImg':auth.userData.profileImage,
                                                  'type': 'like',
                                                  'timestamp': Timestamp.fromDate(DateTime.now()),
                                                });});
                                                Firestore.instance
                                                    .collection('groups')
                                                    .document(widget.documentID)
                                                    .collection('post')
                                                    .document(snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID)
                                                    .updateData({
                                                  'NumberOfLikes': FieldValue.increment(1) ,
                                                });
                                                Firestore.instance.collection('groups')
                                                    .document(widget.documentID)
                                                    .collection('post').document(snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID).get().then(
                                                        (DocumentSnapshot result) async {
                                                      Firestore.instance
                                                          .collection('Notification')
                                                          .document(result["userid"])
                                                          .collection('Notificationitem')
                                                          .document()
                                                          .setData({
                                                       // 'postData':result["postData"],
                                                        //'imagePost':result["post_image"],
                                                        'postId':result["post_id"],
                                                        'OwnerId':result["userid"],
                                                        'ParentId':auth.userData.ParentID,
                                                        'username':auth.userData.name,
                                                        'userProfileImg':auth.userData.profileImage,
                                                        'userid':auth.userData.id,
                                                        'timestamp': Timestamp.fromDate(DateTime.now()),
                                                        'type':'like',
                                                      }
                                                      );
                                                    });
                                              } else {

                                                final auth = Provider.of<ProviderData>(context);
                                                Firestore.instance
                                                    .collection('groups')
                                                    .document(widget.documentID)
                                                    .collection('post')
                                                    .document(snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID)
                                                    .collection('like')
                                                    .document(snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID)
                                                    .delete();

                                                Firestore.instance
                                                    .collection('groups')
                                                    .document(widget.documentID)
                                                    .collection('post')
                                                    .document(snapshot
                                                    .data
                                                    .documents[index]
                                                    .documentID)
                                                    .updateData({
                                                  'NumberOfLikes': FieldValue.increment(-1) ,
                                                });
                                              }
                                            }),

                                        FlatButton(
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.mode_comment,
                                                size: 18,
                                                color: Colors.grey.shade800,

                                              ),
                                              Text('Comment',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                          onPressed: () => _commentNew(
                                              context,
                                              snapshot.data.documents[index]
                                                  .documentID),
                                        ),
                                        FlatButton(
                                          child: Row(
                                            children: <Widget>[
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.share,
                                                    size: 18,
                                                  ),
                                                  color: Colors.grey.shade800,
                                                  onPressed: () {}),
                                              Text('share',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  )),
                                            ],
                                          ),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(


                            decoration:BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/ty.jpg'),
                                  fit: BoxFit.cover,
                                )),


                            ///  **********
                            height: 15,
                            // color: Colors.grey.shade400,
                          ),
                        ],
                      );
                    }),
              );
          }
        });
  }
  Widget _createPage() {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Create your own Group ', style: TextStyle(fontSize: 18)),
          SizedBox(
            height: 2,
          ),
          RaisedButton(
            onPressed: () => _createNewGroup(),
            child: Text(
              'Create Group',
              style: TextStyle(color: Color(0xFF9656A1)),
            ),
          )
        ],
      ),
    );
  }
  Future<String>uploadImage(File image)async{
    String name=Random().nextInt(1000).toString()+'_group';
    final StorageReference storageReference= FirebaseStorage().ref().child(name);
    final StorageUploadTask UploadTask=storageReference.putFile(image);
    StorageTaskSnapshot respons=    await  UploadTask.onComplete;
    String URL=await respons.ref.getDownloadURL();

    return URL;
  }
}
