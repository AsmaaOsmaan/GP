import 'package:cloud_firestore/cloud_firestore.dart';

class DBB{
  Future getDocs(String ID) async {
    List<QuerySnapshot> queries =[];


//    List<String>IDs = [];
//    List<String>Posts_IDs = [];

    QuerySnapshot querySnapshot = await Firestore.instance.collection("User")
        .document(ID)
        .collection('groups')
        .getDocuments();
    for (int i = 0; i < querySnapshot.documents.length; i++) {
      var a = querySnapshot.documents[i];



      // print(a.documentID);
      print('eslm');
      //QuerySnapshot querySnapsho =  await Firestore.instance.collection("groups").where('groupID', isEqualTo: a.documentID).getDocuments();


      await Firestore.instance.collection("groups").document(a.documentID).collection('post').getDocuments().then((snap){
        print('snap.runtimeType ${snap.runtimeType}');

        queries.add(snap);


      });
    }
    return queries;

//      for(int i = 0 ;i < querySnapsho.documents.length ;i++){
//        print('ddddddddddddddddddddddddddddddddddd');
//        print(querySnapsho.documents.length);
//        print('i $i');
//        print(querySnapsho.documents[i]['groupName']);
//      }
    /* StreamBuilder<QuerySnapshot>(


          stream: Firestore.instance.collection('groups').where(
              'groupID', isEqualTo: a.documentID).snapshots(),

          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            // int  numm= snapshot.data.documents.length;
         print('asmmaa');
         print(snapshot.data.documents);
            //  print(auth.userData.ParentID);
            if (snapshot.hasError)
              return new Text('Error: ${snapshot.error}');
            if (!snapshot.hasData)
              return new Text('no data to returen');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Text('Loading...');
              default:
                return new ListView(
                  children: snapshot.data.documents.map((
                      DocumentSnapshot document) {
                    print(document.data.length);
                    return Card(
                      color: Colors.pink,
                      child: InkWell(

                        splashColor: Colors.yellow,
                        highlightColor: Colors.blue.withOpacity(0.5),

                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    (document['cover_photo'] == null) ?
                                    Container(
                                        width: 60,
                                        height: 60,

                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            // borderRadius: BorderRadius.circular(100.0),
                                            image: DecorationImage(

                                              image: ExactAssetImage(
                                                  'images/imageprofile3.jpg'),
                                              fit: BoxFit.cover,
                                            ))) : Container(
                                        width: 60,
                                        height: 60,

                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            // borderRadius: BorderRadius.circular(100.0),
                                            image: DecorationImage(

                                              image: NetworkImage(
                                                  document['cover_photo']),
                                              fit: BoxFit.cover,

                                            ))),

                                    Row(
                                      children: <Widget>[
                                        Text(
                                          document['groupName'],
                                          style: TextStyle(
                                            color: Colors.deepPurple,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                            fontFamily: 'DancingScript',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                IconButton(icon: Icon(Icons.delete_forever,),
                                  onPressed: () {
                                    Firestore.instance.collection('User')
                                        .document(document.documentID)
                                        .delete();
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

            //  print(a.documentID);
            //   IDs.add(a.documentID);
          }


      );*/
    /* getGroups(List<String> IDDs)async{
    for(String id in IDDs ){
      return StreamBuilder<QuerySnapshot>(
 stream: Firestore.instance.collectionGroup('groups').where('DocumentID',isEqualTo: id).snapshots(),
     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {});
    }

      }
*/

  }
}