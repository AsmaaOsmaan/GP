import 'package:flutter/material.dart';
class details extends StatefulWidget {
  final String post;
  final String comment;
  final String imagePost;
  //if you have multiple values add here
  details(this.post,this.comment, this.imagePost,{Key key}): super(key: key);//add also..example this.abc,this...

  @override
  State<StatefulWidget> createState() => _detailsState();
}

class _detailsState extends State<details> with SingleTickerProviderStateMixin{

  TabController _tabController;
  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: Text('Activity Details'),),
      body: Column(

        children: <Widget>[
        drawImage(context),

                TabBar(
                 // indicatorPadding: EdgeInsets.only(bottom: 700),
                      controller: _tabController,
                      //unselectedLabelColor: Colors.white,
                      labelColor: Colors.black,



                      tabs: [
                        Tab(child: new Text('Post',style: TextStyle(
                            inherit: true,
                            fontSize: 20.0,
                         //   color: Colors.black,

                        )) ,),
                        Tab(child: new Text('Comment',style: TextStyle(
                            inherit: true,
                            fontSize: 20.0,
                            //color: Colors.black,

                        )) ,),
                      ]),

                   drawTapView(context),

        ],
      ),
    );

  }

     Widget drawImage(BuildContext context) {
    if(widget.imagePost!=null)
    return Container(
      height: MediaQuery.of(context).size.height*0.35,
      // width: 1500  ,
      width: MediaQuery.of(context).size.width,
      child: Image(image: NetworkImage(widget.imagePost),
        fit: BoxFit.cover,) ,
    );
    else
      return Container(
         height: MediaQuery.of(context).size.height*0.35,
        // width: 1500  ,
        width: MediaQuery.of(context).size.width,
      //  child:  Image.asset('images/noImage.png'),
        child:  Image(image: ExactAssetImage('images/noImage.png'),fit: BoxFit.cover,
          height: 300,
        )
      );
     }
  Widget drawTapView(BuildContext context){
    if (widget.comment!=null){
      return Flexible(child: Container(

        child: TabBarView(
          controller: _tabController,
          children: [
            Container(
                padding: EdgeInsets.only(left: 50,top: 25),
                child: new Text(widget.post,style: TextStyle(
                  inherit: true,
                  fontSize: 20.0,
                  color: Colors.black,

                ),)
            ),
            Container(
                padding: EdgeInsets.only(left: 50,top: 25),
                child: new Text(widget.comment,style: TextStyle(fontSize: 20),)),

          ],
        ),
      ),) ;
    }
    else{
      return Flexible(
        child: Container(

          child: TabBarView(
            controller: _tabController,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 50,top: 25),
                  child: new Text(widget.post,style: TextStyle(
                    inherit: true,
                    fontSize: 20.0,
                    color: Colors.black,

                  ),)
              ),
              Container(
                  padding: EdgeInsets.only(left: 50,top: 25),
                  child: new Text("NO COMMENT",style: TextStyle(fontSize: 20),)),

            ],
          ),
        ),
      );
    }

  }
}