import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_shop/authentication/provider.dart';
import 'package:flutter_shop/parent/notification_detail.dart';
import 'package:flutter_shop/provider_data.dart';
import 'package:provider/provider.dart' ;
import 'package:timeago/timeago.dart' as timeago;

class ActivityFeed extends StatefulWidget {
  @override
  _ActivityFeedState createState() => _ActivityFeedState();
}

class _ActivityFeedState extends State<ActivityFeed> {

  // const  activityLogRef= Firestore.instance.collection('ActivtyLog');
  getActivityFeed(BuildContext context) async {
    final auth = Provider.of<ProviderData>(context);

    QuerySnapshot snapshot = await Firestore.instance.collection('ActivtyLog')
    //currentUser.id
    // .document('jeffd23')
        .document(auth.userData.id)
        .collection('ActivtyLogitem')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .getDocuments();
    List<ActivityFeedItem> ActivityLogitems = [];
    snapshot.documents.forEach((doc) {
      ActivityLogitems.add(ActivityFeedItem.fromDocument(doc));
      // print('Activity Feed Item: ${doc.data}');
    });
    return ActivityLogitems;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //  backgroundColor: Colors.orange,
      appBar: AppBar( title:Text("Activity Log") ),
      body: Container(

          child: FutureBuilder(
            future: getActivityFeed(context),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  child: Text("no data"),
                );
              }
              return ListView(
                children: snapshot.data,
              );
            },
          )),
    );
  }
}

Widget mediaPreview;
String activityItemText;

class ActivityFeedItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type;
  final String imagePost;
  // 'like', 'follow', 'comment'
  //final String mediaUrl;
  final String postId;
   final String userProfileImg;
  String commentData;
  String postData;
  final Timestamp timestamp;
  final String pageName;
  final String groupName;

  ActivityFeedItem({
    this.username,
    this.userId,
    this.type,
    // this.mediaUrl,
    this.postId,
    this.userProfileImg,
    this.commentData,
    this. postData,
    this.timestamp,
    this.pageName,
    this.groupName,
    this. imagePost
  });

  factory ActivityFeedItem.fromDocument(DocumentSnapshot doc) {
    return ActivityFeedItem(
      username: doc['username'],
      userId: doc['userId'],
      type: doc['type'],
      //  postId: doc['postId'],
      userProfileImg: doc['userProfileImg'],
      commentData: doc['commentData'],
      timestamp: doc['timestamp'],
      //  mediaUrl: doc['mediaUrl'],
      postData: doc['postData'],
      pageName:doc['pageName'],
      groupName:doc['groupName'],
        imagePost:doc['imagePost'],
    );
  }

  configureMediaPreview() {
    if (type == "like" || type == 'comment'|| type == 'post') {
      mediaPreview = GestureDetector(
        onTap: () => //Navigator.push(context, MaterialPageRoute(builder: (context) => details(postData,commentData))),
        print('shooooow'),

        child: Container(
          height: 50.0,
          width: 50.0,
          child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(

              )),
        ),
      );
    } else {
      mediaPreview = Text('');
    }

    if (type == 'like') {
      activityItemText = "liked in post";
    } else if (type == 'follow') {
      activityItemText = "is started follow for $pageName ";
    } else if (type == 'comment') {
      activityItemText = 'comment on post: $commentData';
    }
    else if (type == 'post') {
      activityItemText = 'shear new post';

    }
    else if (type == 'createGroup') {
      activityItemText = ' create group: $groupName';}
    else if (type == 'createPage') {
      activityItemText = ' create page: $pageName';}
    else if (type == 'joinGroup') {
      activityItemText = ' Join Group:$groupName';}
    else if (type == 'likePage') {
      activityItemText = ' Liked on Page:$pageName';}
    else {
      activityItemText = "Error: Unknown type '$type'";
    }
  }

  @override
  Widget build(BuildContext context) {
    configureMediaPreview();

    return Padding(
      padding: EdgeInsets.only(bottom: 2.0),
      child: Container(
        color: Colors.white54,
        child: ListTile(
          title: GestureDetector(

            onTap: () {
            //  (postData==null &&commentData==null)?():
            //  if (postData!=null &&commentData!=null){ Navigator.push(context, MaterialPageRoute(builder: (context) => details(postData,commentData)));}
             // else if(postData!=null &&commentData==null){
              //  Navigator.push(context, MaterialPageRoute(builder: (context) => details(postData,commentData,imagePost)));
            //  }

              // else if(postData==null &&commentData==null){
              //  Navigator.push(context, MaterialPageRoute(builder: (context) => details(postData='no comment',commentData='no comment')));
              // }
              //else if(postData==null &&commentData!=null){
              //  Navigator.push(context, MaterialPageRoute(builder: (context) => details(postData='no comment',commentData)));
              //}
              if(type=='like'||type=='comment'||type=='post'){
                Navigator.push(context, MaterialPageRoute(builder: (context) => details(postData,commentData,imagePost)));
              }
              else{

              }
            } ,

            child: RichText(
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' $activityItemText',
                    ),
                  ]),
            ),
          ),////////////need to test
          leading:(userProfileImg!=null)?CircleAvatar(
           //  backgroundImage: Image(image: NetworkImage(userProfileImg)),
            backgroundImage:NetworkImage(userProfileImg) ,

          ):

          CircleAvatar(
            // backgroundImage: CachedNetworkImageProvider(userProfileImg),
          ),
          subtitle: Text(
            timeago.format(timestamp.toDate()),
            overflow: TextOverflow.ellipsis,
          ),
          trailing: mediaPreview,
        ),
      ),
    );
  }
}
