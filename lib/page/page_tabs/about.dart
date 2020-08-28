import 'package:flutter/material.dart';
class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFcccccc),

      body: ListView(

        children: <Widget>[
          Card(
            child: Column(

            children: <Widget>[
              SizedBox(height: 50,width: MediaQuery.of(context).size.width*1/13,),
              Row(
                children: <Widget>[
                  FlatButton(onPressed: (){}, child:Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.call,
                            size: 25,
                          ),
                          color: Colors.grey.shade800,
                          onPressed: () {}),
                      Text('0123457890',
                          style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF9656A1)
                          )),
                    ],
                  ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  FlatButton(onPressed: (){}, child:Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.email,
                            size: 25,
                          ),
                          color: Colors.grey.shade800,
                          onPressed: () {}),
                      Text('mbc3.gmail.com',
                          style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF9656A1)
                          )),
                    ],
                  ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  FlatButton(onPressed: (){}, child:Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.language,
                            size: 20,
                          ),
                          color: Colors.grey.shade800,
                          onPressed: () {}),
                      Text('https://mbc3.com',
                          style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF9656A1)
                          )),
                    ],
                  ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  FlatButton(onPressed: (){}, child:Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.offline_bolt,
                            size: 25,
                          ),
                          color: Colors.grey.shade800,
                          onPressed: () {}),
                      Text('Send Message',
                          style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF9656A1)
                          )),
                    ],
                  ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  FlatButton(onPressed: (){}, child:Row(
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            Icons.subscriptions,
                            size: 25,
                          ),
                          color: Colors.grey.shade800,
                          onPressed: () {}),
                      Text('https://youtube.com/mbc3tv',
                          style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF9656A1)
                          )),
                    ],
                  ),
                  )
                ],
              ),
            ],
          ),
          ),
        ],
    ),



    );
  }
}
