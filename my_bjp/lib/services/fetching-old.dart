import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:my_bjp/screens/about/about.dart';
import 'package:my_bjp/screens/scheme_pop.dart';
import 'package:my_bjp/screens/wr_prs.dart';
import 'package:my_bjp/services/eventsFetching.dart';
import 'package:my_bjp/templates/buttonList.dart';
import '../templates/card.dart';
import '../values/constants.dart' as Constants;
import 'package:my_bjp/screens/videos.dart';

class FetchData extends StatefulWidget {
  @override
  FetchDataState createState() => FetchDataState();
}







class FetchDataState extends State<FetchData> with AutomaticKeepAliveClientMixin<FetchData> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: 
      SenseFeed(
         child: ListView(children: [Text('Loading')]),
         opacity: 1,
      ),
    );
  }
  @override
  bool get wantKeepAlive => true;
}





class SenseFeed extends StatefulWidget {
  @override
  SenseFeedState createState() => SenseFeedState();

  final Widget child;
   final double opacity;
   SenseFeed({this.child, this.opacity});
}



class SenseFeedState extends State<SenseFeed> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  List data=[];
  int network = 1;
  int loading = 1;
  RefreshController _refreshController = RefreshController(initialRefresh: false);

Future retrieve() async {

  try{
  
    Response response = await post(Constants.NEWS_FEED_URL,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: json.encode({"start":0}),
      encoding: Encoding.getByName("utf-8"));
      setState(() {
        data = jsonDecode(response.body);
        loading = 0;
        network = 1;
     });
  } catch(e){
    setState(() {
      print('error');
      loading = 0;
      network = 0;
      _refreshController.refreshFailed();
    });
  }

  }

  void _onRefresh() async {
    try {
      await retrieve();
      _refreshController.refreshCompleted();
    } on SocketException catch (_) {
      setState(() {
        loading = 0;
        network = 0;
        _refreshController.refreshFailed();
      });
    }
  }

  void _onLoading() async {
    try {
      retrieve();
    } on SocketException catch (_) {
      setState(() {
        loading = 0;
        network = 0;
        _refreshController.loadFailed();
      });
    }
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    super.initState();
    _fcm.subscribeToTopic('HUNGERGAME');
    /*
    //does not works on latest version
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async{
        print("onMessage: $message");
      },
      onResume: (Map<String, dynamic> message) async{
        print("onResume: $message");
      },
      onLaunch: (Map<String,dynamic> message) async{
        print("onMessage: $message");
      }
    );
    */
    _onLoading();
  }
  @override
  Widget build(BuildContext context) {
      return Opacity(
          opacity: widget.opacity,
          child: SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
             child: ListView(
              children:[
                 SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(10.0, 10 , 10.0, 10.0),
                    scrollDirection: Axis.horizontal,
                    child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                        ActionChip(label: Text("Videos",style:GoogleFonts.farro(color: Colors.white,fontWeight: FontWeight.bold),),
                            avatar: Icon(Icons.play_circle_outline_rounded),
                            backgroundColor: Constants.BJP_GREEN,onPressed: (){
                            Navigator.push(context,MaterialPageRoute(builder: (context) => Videos()));
                        }),
                        SizedBox(width: 20),
                        ActionChip(label: Text("Write To State President",style:GoogleFonts.farro(color: Colors.white,fontWeight: FontWeight.bold),),backgroundColor: Constants.BJP_ORANGE,onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => WrPrs()));
                        }),
                        SizedBox(width: 20),
                        ActionChip(label: Text("Schemes",style:GoogleFonts.farro(color: Colors.white,fontWeight: FontWeight.bold),),backgroundColor: Constants.BJP_GREEN,onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => SchemePop()));
                        }),
                        SizedBox(width: 20),
                        ActionChip(label: Text("Know Your Booth",style:GoogleFonts.farro(color: Colors.white,fontWeight: FontWeight.bold),),backgroundColor: Constants.BJP_ORANGE,onPressed: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context) => ButtonList(title:"Booth",url:Constants.BOOTH_DISTRICT,data:[],start:"B")));
                        }),
                        SizedBox(width: 20),
                        ActionChip(label: Text("Events",style:GoogleFonts.farro(color: Colors.white,fontWeight: FontWeight.bold),),backgroundColor: Constants.BJP_GREEN,onPressed: (){
                          Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EventsList()));
                        }),
                        SizedBox(width: 20),
                        ActionChip(label: Text("About the Party",style:GoogleFonts.farro(color: Colors.white,fontWeight: FontWeight.bold),),backgroundColor: Constants.BJP_ORANGE,onPressed: (){
                            Navigator.push(context,
                        MaterialPageRoute(builder: (context) => About()));
                        }),
                    ])
                  ),
                 Column(

          children:
            loading!=0
              ? [
                  Image.asset(
                    'lib/images/20degree_256.gif',
                    height: 100,
                    width: 100,
                  )
                ]
              : (network!=0
                  ? (data.map((e) => DesignedCard(obj: e)).toList())
                  : [
                      Center(
                          child: Column(children: <Widget>[
                        Text('Check Your Network'),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: () {},
                        ),
                        Text('Pull to Refresh'),
                      ]))
                    ]),
              )]

                  )
            )
          );
  
  }
}
