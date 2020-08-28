import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  String name;
  String profileImage;
  String email;
  String gender;
  String age;
  String ParentID;
  String id;

  UserData({this.age, this.email, this.gender, this.name, this.profileImage,this.ParentID,this.id});

  factory UserData.fromDoc(DocumentSnapshot doc) {
    return UserData(
      name: doc['UserName'],
      profileImage: doc['images'],
      email: doc['Email'],
      gender: doc['Gender'],
      age: doc['age'],
        ParentID:doc['ParentID'],
      id:doc['id']
    );
  }

}

