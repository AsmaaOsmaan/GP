import 'package:flutter/material.dart';

//import '../group_screen.dart';
class File extends StatefulWidget {
  @override
  _FileState createState() => _FileState();
}

class _FileState extends State<File> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.grey.shade300,
        title: Text('Files ',style: TextStyle(fontSize: 23,color: Colors.purple.shade800),),

      ),
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(height: 10,),

            FlatButton(
              padding: EdgeInsets.only(left:MediaQuery.of(context).size.width*1/13,),
              onPressed: (){},
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: ExactAssetImage('assets/images/profile_page.jpg'),
                    radius: 18,
                  ),
                  SizedBox(width: MediaQuery.of(context).size.width*1/13,),
                  Text('Add File',style: TextStyle(fontSize: 17,color: Colors.grey.shade800),),
                  SizedBox(width: MediaQuery.of(context).size.width*1/26,),

                  Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
