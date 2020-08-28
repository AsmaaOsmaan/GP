
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class ActivityFeedItemtwo{
  String username;
   String userId;
   String type; // 'like', 'follow', 'comment'
  //final String mediaUrl;
  String postId;
  // final String userProfileImg;
  String commentData;
  String postData;
   Timestamp timestamp;
  String pageName;
   String groupName;

  ActivityFeedItemtwo({
    this.username,
    this.userId,
    this.type,
    // this.mediaUrl,
    this.postId,
    //this.userProfileImg,
    this.commentData,
    this. postData,
    this.timestamp,
    this.pageName,
    this.groupName,
  });
   ActivityFeedItemtwo.fromDocument(DocumentSnapshot doc) {

     this.username=doc['username'];
     this.userId=doc['userId'];
     this.type=doc['type'];
     this.commentData=doc['commentData'];
     this.postData=doc['postData'];
     this.timestamp=doc['timestamp'];
     this.pageName=doc['pageName'];
     this.groupName=doc['groupName'];
//    return ActivityFeedItemtwo(
//      username: doc['username'],
//      userId: doc['userId'],
//      type: doc['type'],
//      //  postId: doc['postId'],
//      //userProfileImg: doc['userProfileImg'],
//      commentData: doc['commentData'],
//      timestamp: doc['timestamp'],
//      //  mediaUrl: doc['mediaUrl'],
//      postData: doc['postData'],
//      pageName:doc['pageName'],
//      groupName:doc['groupName'],
//    );
  }

}
