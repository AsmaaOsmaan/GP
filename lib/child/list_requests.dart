import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListRequests extends StatefulWidget {
  @override
  _ListRequestsState createState() => _ListRequestsState();
}

class _ListRequestsState extends State<ListRequests> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: ListView.builder(
        itemBuilder: (context, position) {
          return
            Card(
              child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                   mainAxisAlignment:MainAxisAlignment.spaceBetween ,

                    children: <Widget>[
                     Column(
                       mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                       children: <Widget>[

                         Container(
                             width: 60,
                             height: 60,
                             decoration: BoxDecoration(
                                 shape: BoxShape.circle,
                                 // borderRadius: BorderRadius.circular(100.0),
                                 image: DecorationImage(
                                   image: ExactAssetImage('images/3.jpg'),
                                   fit: BoxFit.cover,
                                 ))),
                           Row(
                             children: <Widget>[
                               Text(
                               "Asmaa abdelrahman",
                               style: TextStyle(
                                 color: Colors.pink,
                                 fontWeight: FontWeight.bold,
                                 fontSize:15.0,
                                 fontFamily: 'DancingScript',
                               ),
                         ),
                             ],
                           ),
                       ],
                     ),
                    //  Icon(
                     //   Icons.add,
                     //   color: Colors.pink,
                     //   size: 30.0,
                    //  ),
                     Expanded(
                       child: Row(
                         mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                         children: <Widget>[
                           RaisedButton(
                             child: Text('Accept'),
                             onPressed: (){
                             },
                             color: Colors.grey,
                             hoverColor: Colors.purple,
                           ),


                           RaisedButton(
                             child: Text('Reject'),
                             onPressed: (){
                             },
                             color: Colors.pink,
                             hoverColor: Colors.purple,
                           )
                         ],
                       ),
                     )



                    ],
                  )
                  //Text(position.toString(), style: TextStyle(fontSize: 22.0),),
                  ),
          );

        },
      ),
    );
  }
}
