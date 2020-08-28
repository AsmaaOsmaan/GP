import 'package:flutter/material.dart';
class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Container(


      child: ListView.builder(
        itemBuilder: (context, position) {
          return
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              color: Colors.grey,
              elevation: 10,

              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: <Widget>[
                  Text('Aya  and 11 others Has reacteded on  your Post ', style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,

                  ),)
                ],),
              ),
            );
        },
      ),
    );
  }
}