import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../group_screen.dart';

/*class Photos extends StatelessWidget {
  _backPressed() {
    setState(() {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => GroupScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Colors.grey,
          iconSize: 28,
          onPressed: () => _backPressed(),
        ),
        backgroundColor: Colors.white,
        title: Text('Photos ',style: TextStyle(fontSize: 23,color: Colors.purple.shade800),),

      ),

      body: StaggeredGridView.count(
        crossAxisCount: 4,
        children: List.generate(5, (int i) {
          return _Tile(i);
        }),
        staggeredTiles: List.generate(5, (int index) {
          return StaggeredTile.fit(2);
        }),
      ),
    );
  }
}*/
class Photos extends StatefulWidget {
  final String documentID;
  Photos(this.documentID, {Key key}) : super(key: key);
  @override
  _PhotosState createState() => _PhotosState();
}

class _PhotosState extends State<Photos> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.grey.shade300,
        title: Text('Photos ',style: TextStyle(fontSize: 23,color: Colors.purple.shade800),),

      ),

      body: StaggeredGridView.count(
        crossAxisCount: 4,
        children: List.generate(5, (int i) {
          return _Tile(i);
        }),
        staggeredTiles: List.generate(5, (int index) {
          return StaggeredTile.fit(2);
        }),
      ),
    );
  }

}


class _Tile extends StatelessWidget {
  _Tile(this.i);
  final int i;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(3)),
        child: Image.asset("images/$i.jpg"),
      ),
    );
  }
}