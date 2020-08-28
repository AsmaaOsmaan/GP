import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Photos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
