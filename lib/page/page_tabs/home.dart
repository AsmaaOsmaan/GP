import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_shop/Screenss/comment_screenPages.dart';
import 'package:flutter_shop/child/Screens/profile_screen.dart';
//import 'package:flutter_shop/page/comment_screenPages.dart';
import 'package:flutter_shop/page/edit_post.dart';
import 'package:flutter_shop/page/page_tabs/about.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

import '../../provider_data.dart';
import '../createpage_screen.dart';

class Home extends StatefulWidget {
  final String documentID;

  Home(this.documentID, {Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static final GlobalKey<FormFieldState<String>> _commentController =
      GlobalKey<FormFieldState<String>>();

  bool isLiked = false;
  int likecount = 0;
  int commentcount = 0;
  final _formKey = GlobalKey<FormState>();

  File _image1;
  String imageUrl1;
  TextEditingController _postContentController = TextEditingController();

  Future getImage(File requiredImage) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      requiredImage = image;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _postContentController.dispose();
  }

  void _EditPost(context, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return EditPost(widget.documentID, postId);
      },
      isScrollControlled: true,
    );
  }

  _commentButtonPressed(String postId) {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => pageComment(widget.documentID, postId)));
    });
  }

  _allAboutPressed() {
    setState(() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
    });
  }

  _createNewPage() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => CreatePage()));
    });
  }

  void _commentNew(context, String postId) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext builder) {
        return pageComment(widget.documentID, postId);
      },
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          _createPost(),
          _drawLine2(),

          _photoScroll(),
          _about(),
          _drawLine2(),
          _createPage(),
          _drawLine2(),
          _post(),

          // _cardHeader(),
          //_cardBody(),
          //_drawLine(),
          //_cardFooter(),
          //_drawLine2(),
          //_cardHeader(),
          //_cardBody(),
          //_drawLine(),
          //_cardFooter(),
        ],
      ),
    );
  }

  /* Widget _createPost() {
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width * 1 / 6,
                height: MediaQuery.of(context).size.width * 1 / 6,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: ExactAssetImage('images/profile_page.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () {
                final auth = Provider.of<ProviderData>(context, listen: false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(widget.documentID)),
                );
              }),
          SizedBox(width: MediaQuery.of(context).size.width * 2 / 60),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
            padding: EdgeInsets.only(
                right: (MediaQuery.of(context).size.width * 1 / 500),
                left: (MediaQuery.of(context).size.width * 1 / 500)),
            decoration: BoxDecoration(
                color: Color(0xFFcccccc),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 2 / 5,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _postContentController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write Post...",
                      hintStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic),
                    ),
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
                  onPressed: () async {
                    var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
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
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic),
            ),
            onPressed: () async {
              final auth = Provider.of<ProviderData>(context, listen: false);

              //String imageUrl1 = await uploadImage(_image1);
              Firestore.instance
                  .collection('pages')
                  .document(widget.documentID)
                  .collection('post')
                  .add({
                'postData': _postContentController.text,
                'pageid': widget.documentID,
                //'post_image': imageUrl1,
                'userid': auth.userData.id,
                'username': auth.userData.name,
                'postid': '',
                'timestamp': FieldValue.serverTimestamp(),
              }).then((data) {
                setState(() {
                  print('add');
                });
              });

              Firestore.instance
                  .collection('ActivtyLog')
                  .document(auth.userData.ParentID)
                  .collection('ActivtyLogitem')
                  .document()
                  .setData({
                'ParentID': auth.userData.ParentID,
                // 'comment_content': _commentController.currentState.value,
                'postData': _postContentController.text,
                //'post_image': imageUrl1,
                'userid': auth.userData.id,
                'postId': 'dfre',
                'username': auth.userData.name,
                'type': 'post',
                'timestamp': FieldValue.serverTimestamp(),
              });
              _postContentController.text = '';
            },
          ),
        ],
      ),
    );
  }*/
  Widget _createPost() {
    final auth = Provider.of<ProviderData>(context);
    if(auth.userData.ParentID=='parent'){
      return Container();
    }
    return Form(
      key: _formKey,
      child: Row(
        children: <Widget>[
          InkWell(
              child: Container(
                width: MediaQuery.of(context).size.width * 1 / 6,
                height: MediaQuery.of(context).size.width * 1 / 6,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: ExactAssetImage('images/profile_page.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () {
                final auth = Provider.of<ProviderData>(context, listen: false);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(widget.documentID)),
                );
              }),
          SizedBox(width: MediaQuery.of(context).size.width * 2 / 60),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0),
            padding: EdgeInsets.only(
                right: (MediaQuery.of(context).size.width * 1 / 500),
                left: (MediaQuery.of(context).size.width * 1 / 500)),
            decoration: BoxDecoration(
                color: Color(0xFFcccccc),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 2 / 5,
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _postContentController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Write Post...",
                      hintStyle: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          fontStyle: FontStyle.italic),
                    ),
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
                  onPressed: () async {
                    var image = await ImagePicker.pickImage(
                        source: ImageSource.gallery);
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
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.normal,
                  fontSize: 18.0,
                  fontStyle: FontStyle.italic),
            ),
            onPressed: ()
                // async
                async {
              if (_formKey.currentState.validate()) {
                if (_image1 != null) {
                  imageUrl1 = await uploadImage(_image1);
                }
                //String imageUrl1 = await uploadImage(_image1);
                final auth = Provider.of<ProviderData>(context);
                DocumentReference documentReference = Firestore.instance
                    .collection('pages')
                    .document(widget.documentID)
                    .collection('post')
                    .document();
                documentReference.setData({
                  'postData': _postContentController.text,
                  'post_image': imageUrl1,
                  'userid': auth.userData.id,
                  'username': auth.userData.name,
                  'timestamp': Timestamp.fromDate(DateTime.now()),
                  'post_id': documentReference.documentID,
                  'pageID': widget.documentID,
                  'NumberOfComments': 0,
                  'NumberOfLikes': 0,
                });


                /////////////////////




                Firestore.instance
                    .collection('user_home')
                    .document(auth.userData.id)
                    .collection('post')
                    .document()
                    .setData({
                  'postData': _postContentController.text,
                  'post_image': imageUrl1,
                  'userid': auth.userData.id,
                  'username':auth.userData.name,
                  'timestamp':  DateTime.now().toString(),
                  'post_id': documentReference.documentID,
                  'post_content': _postContentController.text,
                  'pageID': widget.documentID,
                  //'pageID':Null
                  //'groupID':Null
                  'groupID':'null'
                });







                /////////////////////
                Firestore.instance
                    .collection('ActivtyLog')
                    .document(auth.userData.ParentID)
                    .collection('ActivtyLogitem')
                    .document()
                    .setData({
                  'userProfileImg': auth.userData.profileImage,
                  'ParentID': auth.userData.ParentID,
                  'postData': _postContentController.text,
                  'imagePost': imageUrl1,
                  'userid': auth.userData.id,
                  'username': auth.userData.name,
                  'type': 'post',
                  'timestamp': Timestamp.fromDate(DateTime.now()),
                  'postID': documentReference.documentID,
                  'pageID': widget.documentID,
                });
                imageUrl1 = " ";
                _postContentController.text = "";
                Toast.show("your post shared Successfully", context);

              }
            },
          ),
        ],
      ),
    );
  }

  Widget _photoScroll() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      height: 150,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          Container(
            child: Image(
              image: AssetImage('images/0.jpg'),
              width: MediaQuery.of(context).size.width * 1 / 3,
              height: 120,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            child: Image(
              image: AssetImage('images/11.jpg'),
              width: MediaQuery.of(context).size.width * 1 / 3,
              height: 120,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            child: Image(
              image: AssetImage('images/22.jpg'),
              width: MediaQuery.of(context).size.width * 1 / 3,
              height: 120,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            child: Image(
              image: AssetImage('images/33.jpg'),
              width: MediaQuery.of(context).size.width * 1 / 3,
              height: 120,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            child: Card(
              child: Image(
                image: AssetImage('images/4.jpg'),
                width: MediaQuery.of(context).size.width * 1 / 3,
                height: 120,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            child: Image(
              image: AssetImage('images/5.jpg'),
              width: MediaQuery.of(context).size.width * 1 / 3,
              height: 120,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }

  Widget _about() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.call,
                          size: 25,
                        ),
                        color: Colors.grey.shade800,
                        onPressed: () {}),
                    Text('0123457890',
                        style:
                            TextStyle(fontSize: 17, color: Color(0xFF9656A1))),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.email,
                          size: 25,
                        ),
                        color: Colors.grey.shade800,
                        onPressed: () {}),
                    Text('mbc3.gmail.com',
                        style:
                            TextStyle(fontSize: 17, color: Color(0xFF9656A1))),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.language,
                          size: 20,
                        ),
                        color: Colors.grey.shade800,
                        onPressed: () {}),
                    Text('https://mbc3.com',
                        style:
                            TextStyle(fontSize: 17, color: Color(0xFF9656A1))),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.offline_bolt,
                          size: 25,
                        ),
                        color: Colors.grey.shade800,
                        onPressed: () {}),
                    Text('Send Message',
                        style:
                            TextStyle(fontSize: 17, color: Color(0xFF9656A1))),
                  ],
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: Icon(
                          Icons.subscriptions,
                          size: 25,
                        ),
                        color: Colors.grey.shade800,
                        onPressed: () {}),
                    Text('https://youtube.com/mbc3tv',
                        style:
                            TextStyle(fontSize: 17, color: Color(0xFF9656A1))),
                  ],
                ),
              )
            ],
          ),
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
          Container(
            color: Colors.white,
            child: FlatButton(
                onPressed: () => _allAboutPressed(),
                child: Row(
                  children: <Widget>[
                    Text(
                      'See ALL',
                      style: TextStyle(
                        color: Colors.grey.shade400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Icon(Icons.chevron_right)
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget _drawLine2() {
    return Container(
      height: 30,
    //  color: Colors.grey.shade400,
      decoration:BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/kidds6.jpg'),
            fit: BoxFit.cover,
          )) ,





    );
  }

  Widget _createPage() {
    return Container(
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Create your own Page ', style: TextStyle(fontSize: 18)),
          SizedBox(
            height: 2,
          ),
          RaisedButton(
            onPressed: () {
              final auth = Provider.of<ProviderData>(context);
              if(auth.userData.ParentID=='parent'){
                Container(child: Text("Sorry you can not creat page"),);
              }
              else{ _createNewPage();}

            } ,
            child: Text(
              'Create Page',
              style: TextStyle(color: Color(0xFF9656A1)),
            ),
          )
        ],
      ),
    );
  }

  Widget _post() {
    final auth = Provider.of<ProviderData>(context, listen: false);

    return StreamBuilder(
        stream: Firestore.instance
            .collection('pages')
            .document(widget.documentID)
            .collection('post')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Container(
                height: MediaQuery.of(context).size.height * 0.60,
                child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: <Widget>[
                          InkWell(
                              child: Container(
                                color: Colors.white,
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(
                                          MediaQuery.of(context).size.width *
                                              1 /
                                              26),
                                      child: CircleAvatar(
                                        backgroundImage: ExactAssetImage(
                                            'images/profile_page.jpg'),
                                        radius: 25,
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        /*Text(
                                        snapshot.data.documents[index]
                                            ['timestamp'],
                                        style: TextStyle(color: Colors.grey),
                                      ),*/
                                      ],
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
                                                      onPressed: () async {
                                                        await Firestore.instance
                                                            .collection('pages')
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
                                                            .collection('pages')
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
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        leading: Icon(
                                                          Icons.delete,
                                                          color:
                                                              Color(0xFF9656A1),
                                                        ),
                                                      ),
                                                    ),
                                                    FlatButton(
                                                      onPressed: () =>
                                                          _EditPost(
                                                              context,
                                                              snapshot
                                                                  .data
                                                                  .documents[
                                                                      index]
                                                                  .documentID),
                                                      child: ListTile(
                                                        title: Text(
                                                          'Edit Post',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        leading: Icon(
                                                          Icons.edit,
                                                          color:
                                                              Color(0xFF9656A1),
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
                                        left:
                                            (MediaQuery.of(context).size.width *
                                                1 /
                                                7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                final auth = Provider.of<ProviderData>(context,
                                    listen: false);

                                if (auth.userData.ParentID=='parent'){

                                }else
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ProfileScreen(auth.userData.id)),
                                  );
                              }),
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
                                    snapshot.data.documents[index]['postData'],
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        fontSize: 16,
                                        height: 1.2,
                                        color: Colors.grey.shade900),
                                  ),
                                  (snapshot.data.documents[index]
                                              ['post_image'] ==
                                          null)
                                      ? Container()
                                      : Image(
                                          image: NetworkImage(snapshot.data
                                              .documents[index]['post_image']),
                                          fit: BoxFit.cover,
                                        ),
                                  (auth.userData.ParentID=='parent')?
                                  Container():
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
                                            snapshot
                                                .data
                                                .documents[index]
                                                    ['NumberOfLikes']
                                                .toString(),
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
                                          child: Text(
                                            snapshot
                                                .data
                                                .documents[index]
                                                    ['NumberOfComments']
                                                .toString(),
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                fontSize: 13,
                                                height: 1.2,
                                                color: Colors.grey.shade800),
                                          ),
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
                                        (auth.userData.ParentID=='parent')?
                                        Container():
                                        FlatButton(
                                            child: Row(
                                              children: <Widget>[
                                                FutureBuilder(
                                                    future: Firestore.instance
                                                        .collection('pages')
                                                        .document(
                                                            widget.documentID)
                                                        .collection('post')
                                                        .document(snapshot
                                                            .data
                                                            .documents[index]
                                                            .documentID)
                                                        .collection('like')
                                                        .document(
                                                            auth.userData.id)
                                                        .get(),
                                                    builder: (context,
                                                        AsyncSnapshot<
                                                                DocumentSnapshot>
                                                            snapshot) {
                                                      if (!snapshot.hasData) {
                                                        return Icon(
                                                          Icons.thumb_up,
                                                          size: 18,
                                                          color: Colors
                                                              .grey.shade800,
                                                        );
                                                      }

                                                     isLiked = snapshot.data.exists;

                                                     return Icon(
                                                        Icons.thumb_up,
                                                        size: 18,
                                                        color: isLiked
                                                            ? Colors.blue
                                                            : Colors
                                                                .grey.shade800,
                                                      );
                                                    /*  (!snapshot.hasData)   ? Icon(
                                                        Icons.thumb_up,
                                                        size: 18,
                                                        color: Colors
                                                            .grey.shade800,
                                                      ):  Icon(
                                                        Icons.thumb_up,
                                                        size: 18,
                                                        color: isLiked
                                                            ? Colors.blue
                                                            : Colors
                                                            .grey.shade800,
                                                      );*/



                                                    }),
                                                Text('Like',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    )),
                                              ],
                                            ),
                                            onPressed: () {
                                              final auth =
                                                  Provider.of<ProviderData>(
                                                      context,
                                                      listen: false);

                                              setState(() {
                                                isLiked = !isLiked;
                                              });
                                              if (isLiked) {
                                                Firestore.instance
                                                    .collection('pages')
                                                    .document(widget.documentID)
                                                    .collection('post')
                                                    .document(snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID)
                                                    .collection('like')
                                                    .document(auth.userData.id)
                                                    .setData({
                                                  'username':
                                                      auth.userData.name,
                                                  'userid': auth.userData.id,
                                                  'postData':
                                                      _postContentController
                                                          .text,
                                                });
                                                Firestore.instance
                                                    .collection('pages')
                                                    .document(widget.documentID)
                                                    .collection('post')
                                                    .document(snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID)
                                                    .get()
                                                    .then((DocumentSnapshot
                                                        result) async {
                                                  Firestore.instance
                                                      .collection('ActivtyLog')
                                                      .document(auth
                                                          .userData.ParentID)
                                                      .collection(
                                                          'ActivtyLogitem')
                                                      .document()
                                                      .setData({
                                                    'postData':
                                                        result["postData"],
                                                    'imagePost':
                                                        result["post_image"],
                                                    'userid': auth.userData.id,
                                                    'username':
                                                        auth.userData.name,
                                                    'parentId':
                                                        auth.userData.ParentID,
                                                    'userProfileImg': auth
                                                        .userData.profileImage,
                                                    'type': 'like',
                                                    'timestamp':
                                                        Timestamp.fromDate(
                                                            DateTime.now()),
                                                  });
                                                });
                                                Firestore.instance
                                                    .collection('pages')
                                                    .document(widget.documentID)
                                                    .collection('post')
                                                    .document(snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID)
                                                    .updateData({
                                                  'NumberOfLikes':
                                                      FieldValue.increment(1),
                                                });
                                                Firestore.instance
                                                    .collection('pages')
                                                    .document(widget.documentID)
                                                    .collection('post')
                                                    .document(snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID)
                                                    .get()
                                                    .then((DocumentSnapshot
                                                        result) async {
                                                  Firestore.instance
                                                      .collection(
                                                          'Notification')
                                                      .document(
                                                          result["userid"])
                                                      .collection(
                                                          'Notificationitem')
                                                      .document()
                                                      .setData({
                                                    // 'postData':result["postData"],
                                                    //'imagePost':result["post_image"],
                                                    'postId': result["post_id"],
                                                    'OwnerId': result["userid"],
                                                    'ParentId':
                                                        auth.userData.ParentID,
                                                    'username':
                                                        auth.userData.name,
                                                    'userProfileImg': auth
                                                        .userData.profileImage,
                                                    'userid': auth.userData.id,
                                                    'timestamp':
                                                        Timestamp.fromDate(
                                                            DateTime.now()),
                                                    'type': 'like',
                                                  });
                                                });
                                              } else {
                                                final auth =
                                                    Provider.of<ProviderData>(
                                                        context);
                                                Firestore.instance
                                                    .collection('pages')
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
                                                    .collection('pages')
                                                    .document(widget.documentID)
                                                    .collection('post')
                                                    .document(snapshot
                                                        .data
                                                        .documents[index]
                                                        .documentID)
                                                    .updateData({
                                                  'NumberOfLikes':
                                                      FieldValue.increment(-1),
                                                });
                                              }
                                            }),

                                        (auth.userData.ParentID=='parent')?
                                        Container():
                                        FlatButton(
                                          child: Row(
                                            children: <Widget>[
                                              IconButton(
                                                  icon: Icon(
                                                    Icons.mode_comment,
                                                    size: 18,
                                                  ),
                                                  color: Colors.grey.shade800,
                                                  onPressed: () {}),
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
                                        /* FlatButton(
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
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 15,
                          //  color: Colors.grey.shade400,

                            decoration:BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('images/kidds6.jpg'),
                                  fit: BoxFit.cover,
                                )) ,


                          ),
                        ],
                      );
                    }),
              );
          }
        });
  }
/*
  Widget _cardHeader() {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 1 / 26),
          child: CircleAvatar(
            backgroundImage: ExactAssetImage('images/profile_page.jpg'),
            radius: 25,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'MBC3',
                  style: TextStyle(
                    color: Colors.grey.shade900,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1 / 7,
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '27 Nov 2019 at 14:30 PM . ',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.more_horiz),
          padding: EdgeInsets.only(
            left: (MediaQuery.of(context).size.width * 1 / 7),
          ),
        ),
      ],
    );
  }

  Widget _cardBody() {
    return Padding(
      padding: EdgeInsets.only(
        left: (MediaQuery.of(context).size.width * 1 / 40),
        right: (MediaQuery.of(context).size.width * 1 / 40),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Welcome to MBC3 page ',
            textAlign: TextAlign.start,
            style: TextStyle(
                fontSize: 16, height: 1.2, color: Colors.grey.shade900),
          ),
          Image(
            image: ExactAssetImage('images/post_page.PNG'),
            fit: BoxFit.cover,
          ),
          FlatButton(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      right: (MediaQuery.of(context).size.width * 1 / 7)),
                  child: Text(
                    '30K',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 13, height: 1.2, color: Colors.grey.shade800),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: (MediaQuery.of(context).size.width * 1 / 5)),
                  child: Text(
                    '3K Comments.400 Shares',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 13, height: 1.2, color: Colors.grey.shade800),
                  ),
                ),
              ],
            ),
            onPressed: () => _commentNew(context),
          )
        ],
      ),
    );
  }

  Widget _cardFooter() {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Row(
        /*   mainAxisAlignment: MainAxisAlignment.spaceBetween,*/
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.thumb_up,
                            size: 18,
                          ),
                          color: Colors.grey.shade800,
                          onPressed: () {}),
                      Text('Like',
                          style: TextStyle(
                            fontSize: 12,
                          )),
                    ],
                  ),
                  onPressed: () {},
                ),
                FlatButton(
                  child: Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.mode_comment,
                            size: 18,
                          ),
                          color: Colors.grey.shade800,
                          onPressed: () {}),
                      Text('Comment',
                          style: TextStyle(
                            fontSize: 12,
                          )),
                    ],
                  ),
                  onPressed: () => _commentNew(context),
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
    );
  }

  Widget _drawLine() {
    return Container(
      height: 1,
      color: Colors.grey.shade300,
    );
  }

 */
}

Future<String> uploadImage(File image) async {
  String name = Random().nextInt(1000).toString() + '_page';
  final StorageReference storageReference = FirebaseStorage().ref().child(name);
  final StorageUploadTask uploadTask = storageReference.putFile(image);
  StorageTaskSnapshot response = await uploadTask.onComplete;
  String url = await response.ref.getDownloadURL();
  return url;
}


