import 'package:flutter/material.dart';

import 'child_groups.dart';
import 'child_pages.dart';

class ChildPage extends StatefulWidget {
   final    ID;
  const ChildPage({Key key, this.ID}) : super(key: key);
  @override
  _ChildPageState createState() => _ChildPageState();
}

class _ChildPageState extends State<ChildPage> with SingleTickerProviderStateMixin{
  TabController tabController;
  @override
  void initState() {
    tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('ChildPage'),
        bottom: TabBar(
            controller: tabController,
            //indicatorColor: Color(0xff6a90f1),
            //indicatorWeight: 3,

            isScrollable: true,
            tabs:[
             Tab(child: Text('Child Pages',style: TextStyle(color: Colors.black),),),
              Tab(child: Text('Child Groups',style: TextStyle(color: Colors.black),),)
            ],

           /* onTap: (int index){
            }*/

        ),


      ),
      body: TabBarView(
        controller: tabController,
        children: [
          ChildPages(ID:widget.ID),
          ChildGroups(ID:widget.ID),
        ],
      ),
    );
  }
}
