import 'package:cloud_firestore/cloud_firestore.dart';

class UserGroupsDB{
  Future getDocs(String ID) async {
    List<QuerySnapshot> queries =[];


    QuerySnapshot querySnapshot = await Firestore.instance.collection("User")
        .document(ID)
        .collection('groups')
        .getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];




      print('eslm');
      //QuerySnapshot querySnapsho =  await Firestore.instance.collection("groups").where('groupID', isEqualTo: a.documentID).getDocuments();


      await Firestore.instance.collection("groups").document(a.documentID).collection('post').getDocuments().then((snap){
        print('snap.runtimeType ${snap.runtimeType}');

        queries.add(snap);



      });


    }

    return queries;





  }
}