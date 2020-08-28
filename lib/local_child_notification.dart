import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/parent/local_child_notification_details.dart';
import 'package:flutter_shop/parent/notification_detail.dart';
import 'package:flutter_shop/provider_data.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_shop/pages/home.dart';
//import 'package:fluttershare/widgets/header.dart';
//import 'package:fluttershare/widgets/progress.dart';
import 'package:timeago/timeago.dart' as timeago;

class LocalChildNotification extends StatefulWidget {
  @override
  _LocalChildNotificationState createState() => _LocalChildNotificationState();
}

class _LocalChildNotificationState extends State<LocalChildNotification> {
  // const  activityLogRef= Fir4estore.instance.collection('ActivtyLog');
  getNotificationItem() async {
    final auth = Provider.of<ProviderData>(context);
    QuerySnapshot snapshot = await Firestore.instance.collection('Notification')
    //currentUser.id

    // .document('jeffd23')
        .document(auth.userData.id)
        .collection('Notificationitem')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .getDocuments();
    List<NotificationItem> ActivityLogitems = [];
    snapshot.documents.forEach((doc) {
      ActivityLogitems.add(NotificationItem.fromDocument(doc));
      // print('Activity Feed Item: ${doc.data}');
    });
    return ActivityLogitems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: Colors.orange,
     // appBar: AppBar( title:Text("Notification") ),
      body: Container(
          child: FutureBuilder(
            future: getNotificationItem(),
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

class NotificationItem extends StatelessWidget {
  final String username;
  final String userId;
  final String type; // 'like', 'follow', 'comment'
  //final String mediaUrl;
 // final String postId;
   final String userProfileImg;
  String commentData;
  String postData;
  final Timestamp timestamp;
  final String pageName;
  final String groupName;
  final String imagePost;
  final String postId;

  NotificationItem({
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
    this. imagePost,
   // this.postId,
  });

  factory NotificationItem.fromDocument(DocumentSnapshot doc) {
    return NotificationItem(
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
        postId:doc['postId']
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
      activityItemText = "liked in  your post";
    } else if (type == 'follow') {
      activityItemText = "is following  page or group";
    } else if (type == 'comment') {
      activityItemText = 'comment on  your post: $commentData';
    }
    else if (type == 'post') {
      activityItemText = 'shear new post';

    }
    else if (type == 'creat group') {
      activityItemText = 'your child create group: $groupName';}
    else if (type == 'creat group') {
      activityItemText = 'your child create page: $pageName';}
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => LocalChildNotificationDetails(postId)));
             // else if(postData!=null &&commentData==null){
              //  Navigator.push(context, MaterialPageRoute(builder: (context) => details(postData,commentData='no comment')));
             // }
              // else if(postData==null &&commentData==null){
              //  Navigator.push(context, MaterialPageRoute(builder: (context) => details(postData='no comment',commentData='no comment')));
              // }
              //else if(postData==null &&commentData!=null){
              //  Navigator.push(context, MaterialPageRoute(builder: (context) => details(postData='no comment',commentData)));
              //}
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
          ),
          leading:
          (userProfileImg!=null)?CircleAvatar(
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
