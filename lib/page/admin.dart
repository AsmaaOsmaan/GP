import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_shop/page/edit_page.dart';
import 'package:flutter_shop/page/page_tabs/about.dart';
import 'package:flutter_shop/page/page_tabs/home.dart';
import 'package:flutter_shop/page/page_tabs/photo.dart';
import 'package:flutter_shop/page/page_tabs/posts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider_data.dart';

class Admin extends StatefulWidget {
  final String documentID;

  Admin(this.documentID, {Key key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> with TickerProviderStateMixin {
  bool isLiked = false;
  int likecount = 0;
  bool isFollowing = false;
  int followcount = 0;

  void _more(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: 200,
            child: Wrap(
              children: <Widget>[
                FlatButton(
                  onPressed: () {},
                  child: ListTile(
                    title: Text('Send Message'),
                    leading: Icon(Icons.message),
                  ),
                ),
                FlatButton(
                  onPressed: () {},
                  child: ListTile(
                    title: Text('Report'),
                    leading: Icon(Icons.block),
                  ),
                ),
                FlatButton(
                  onPressed: () {},
                  child: ListTile(
                    title: Text('Copy Link'),
                    leading: Icon(Icons.link),
                  ),
                ),
              ],
            ),
          );
        });
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _coverPage(),
            _profilePage(),
            DefaultTabController(
              length: 4,
              child: Column(
                children: <Widget>[
                  SafeArea(
                    child: Column(
                      children: <Widget>[
                        _tabBar(),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: _tabView(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coverPage() {
    return FutureBuilder(
        future: Firestore.instance
            .collection('pages')
            .document(widget.documentID)
            .get(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(snapshot.data['cover_Photo']),
                  ),
                ),
              );
          }
        });
  }

  Widget _profilePage() {
    final auth = Provider.of<ProviderData>(context, listen: false);
    /*final current_user = Firestore.instance
        .collection('page')
        .where('admin', isEqualTo: auth.userData.id)
        .snapshots();*/
    return FutureBuilder(
        future: Firestore.instance
            .collection('pages')
            .document(widget.documentID)
            .get(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width * 1 / 26),
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(snapshot.data['profile_Picture']),
                            radius: 30,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 1 / 9,
                        ),
                        Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  (snapshot.data['pageName']),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w400,
                                    height: 1.2,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      1 /
                                      30,
                                ),
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.blue,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              (snapshot.data['page_catogory']),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
//                            Text(
//                              '8.5M followers',
//                              style: TextStyle(
//                                color: Colors.grey.shade600,
//                                fontSize: 13,
//                              ),
//                            ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 1 / 9,
                        ),
                        Expanded(
                          child: IconButton(
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
                                                  .document(widget.documentID)
                                                  .collection('post')
                                                  .document(widget.documentID)
                                                  .collection('comment')
                                                  .document(widget.documentID)
                                                  .collection('like')
                                                  .getDocuments()
                                                  .then((snapshot) {
                                                for (DocumentSnapshot ds
                                                    in snapshot.documents) {
                                                  ds.reference.delete();
                                                }
                                              });

                                              await Firestore.instance
                                                  .collection('pages')
                                                  .document(widget.documentID)
                                                  .delete();
                                            },
                                            child: ListTile(
                                              title: Text(
                                                'Delete Page',
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                              leading: Icon(
                                                Icons.delete,
                                                color: Colors.blueAccent,
                                              ),
                                            ),
                                          ),
                                          FlatButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Edit(widget.documentID)));
                                            },
                                            child: ListTile(
                                              title: Text(
                                                'Edit Page',
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
                                              ),
                                              leading: Icon(
                                                Icons.edit,
                                                color: Colors.blueAccent,
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
                              left: (MediaQuery.of(context).size.width * 1 / 7),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 2 / 4,
                          padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 1 / 26,
                          ),
//                          child: FlatButton(
//                            shape: RoundedRectangleBorder(
//                                borderRadius: BorderRadius.circular(7.0)),
//                            onPressed: () {},
//                            color: Color(0xFF9656A1),
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.center,
//                              children: <Widget>[
//                                Icon(
//                                  Icons.library_add,
//                                  color: Colors.white,
//                                ),
//                                Text(
//                                  'Follow',
//                                  textAlign: TextAlign.right,
//                                  style: TextStyle(
//                                    color: Colors.white,
//                                    fontSize: 15,
//                                  ),
//                              ),
//                              ],
//                            ),
//                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .25 / 9,
                        ),
                        Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 1 / 4,
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0)),
                            onPressed: () {},
                            color: Color(0xFFcccccc),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    Icons.more_horiz,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    _more(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('8,600,198 people like this'),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              );
          }
        });
  }

  Widget _tabBar() {
    return TabBar(
      indicatorColor: Colors.purple,
      tabs: [
        Tab(
          icon: Icon(
            Icons.home,
            color: Colors.purple,
          ),
          child: Text(
            'Home',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.chrome_reader_mode,
            color: Colors.purple,
          ),
          child: Text(
            'Posts',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.language,
            color: Colors.purple,
          ),
          child: Text(
            'About',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Tab(
          icon: Icon(
            Icons.photo_library,
            color: Colors.purple,
          ),
          child: Text(
            'Photos',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _tabView() {
    return TabBarView(
      children: <Widget>[
        Home(widget.documentID),
        Posts(widget.documentID),
        About(),
        Photos(),
      ],
    );
  }
}
