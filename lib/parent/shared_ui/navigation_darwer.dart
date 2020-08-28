import 'package:flutter_shop/Auth/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shop/models/nav_menue.dart';
import 'package:flutter_shop/parent/add_mychild.dart';
import 'package:flutter_shop/parent/list_children.dart';
import 'package:flutter_shop/Auth/logout.dart';
class NavigationDrawer extends StatefulWidget {
  @override
  _NavigationDrawerState createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  List<NavMenuItem>navigationMenu=[
    NavMenuItem("List MyChildren", () => PageParent ()),
    NavMenuItem("Add Child",() => AddChild()),
    NavMenuItem("Logout",() => Login()),

  ];
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:Padding(
        padding: const EdgeInsets.only(top: 250,left: 22),
        child: ListView.builder(itemBuilder: (context , position) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(
                navigationMenu[position].title,style: TextStyle(color: Colors.grey.shade700,fontSize: 22),),
              trailing: Icon(Icons.chevron_right,color:Colors.grey.shade400,) ,
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context){
                  return navigationMenu[position].destination();
                }));
              },
            ),
          );
        },itemCount: navigationMenu.length,),
      )

    );
  }
}
