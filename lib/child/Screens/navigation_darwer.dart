import 'package:flutter_shop/Auth/login.dart';
import 'package:flutter/material.dart';

import 'package:flutter_shop/child/Screens/models/nav_menue.dart';
import 'package:flutter_shop/child/Screens/naivigation_screens/friends.dart';
import 'package:flutter_shop/child/Screens/naivigation_screens/pages.dart';
import 'package:flutter_shop/child/Screens/naivigation_screens/groups.dart';
import 'package:flutter_shop/child/Screens/naivigation_screens/logout.dart';
import 'package:flutter_shop/provider_data.dart';
import 'package:provider/provider.dart';
class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer>  {

  String currentProfilePic = "images/1.jpg";
  String otherProfilePic = "https://yt3.ggpht.com/-2_2skU9e2Cw/AAAAAAAAAAI/AAAAAAAAAAA/6NpH9G8NWf4/s900-c-k-no-mo-rj-c0xffffff/photo.jpg";

  void switchAccounts() {
    String picBackup = currentProfilePic;
    this.setState(() {
      currentProfilePic = otherProfilePic;
      otherProfilePic = picBackup;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<ProviderData>(context);
    return Drawer(


          child: new ListView(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                //accountEmail: new Text("bramvbilsen@gmail.com"),
            //    accountName: new Text(auth.userData.name),
                accountName: new Text('amal'),
                currentAccountPicture: new GestureDetector(
                  child: new CircleAvatar(
                   // backgroundImage: new NetworkImage(currentProfilePic),
                    backgroundImage: new ExactAssetImage('images/1.jpg'),
                  ),
                  onTap: () => print("This is your current account."),
                ),
                otherAccountsPictures: <Widget>[
                  new GestureDetector(
                    child: new CircleAvatar(
                     // backgroundImage: new NetworkImage(otherProfilePic),
                      backgroundImage: new ExactAssetImage('images/4.jpg'),
                    ),
                   onTap: () => switchAccounts(),
                  ),
                ],
                decoration: new BoxDecoration(
                    image: new DecorationImage(

                        image:  ExactAssetImage('images/3.jpg'),
                    fit: BoxFit.cover,
                      //  fit: BoxFit.fill
                    )
                ),
              ),
              new ListTile(
                  title: new Text("Groups"),
                  trailing: new Icon(Icons.group_add),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Groups()),
                    );
                  }
              ),
              new ListTile(
                  title: new Text("Pages"),
                  trailing: new Icon(Icons.pages),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Pages()),
                    );
                  }
              ),
              new ListTile(
                  title: new Text("Friends"),
                  trailing: new Icon(Icons.people),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Friends()),
                    );
                  }
              ),
              new ListTile(
                  title: new Text("Logout"),
                  trailing: new Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                     // onTap: () => Navigator.pop(context),
                    );
                  }
              ),
              new Divider(),
              new ListTile(
                title: new Text("Cancel"),
                trailing: new Icon(Icons.cancel),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),


    );
  }
}
