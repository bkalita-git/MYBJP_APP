import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:my_bjp/templates/bjpappbar.dart';
import 'package:my_bjp/templates/bjpbutton.dart';
import 'package:my_bjp/templates/threeArgList.dart';
import '../values/constants.dart' as Constants;

class ButtonList extends StatefulWidget {
  final title;
  final url;
  final data;
  final start;
  ButtonList({this.title,this.url,this.data,this.start});
  @override
  ButtonListState createState() => ButtonListState();
}

class ButtonListState extends State<ButtonList> with AutomaticKeepAliveClientMixin<ButtonList> {
  List data = [];
  int network = 1;
  int loading = 1;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  Future retrieve() async {
    if(widget.url=="empty"){
      setState(() {
          data=widget.data;
          loading = 0;
          network = 1;
          _refreshController.refreshCompleted();
        });
    }
      else{
        print(widget.url);
        try{
         Response response = await post(widget.url,
          headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: json.encode({"start":widget.start}),
          encoding: Encoding.getByName("utf-8"));
          setState(() {
            data = jsonDecode(response.body);
            loading = 0;
            network = 1;
            _refreshController.refreshCompleted();
         });
        } catch(e){
          print('error');
            loading = 0;
            network = 0;
            _refreshController.refreshFailed();
        }
        
      }
  }

  void _onRefresh() async {
    try {
       await retrieve();
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
    _onLoading();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(child:
    Scaffold(
      appBar: bjpAppBar(widget.title,context),
      body: SmartRefresher(
        enablePullDown: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
         child: Column(
        children: [
           Divider(),
          Divider(),
          Expanded(
          child: ListView(
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
                  ? (data.map((e) => 
                  

                  Container(
                  margin: EdgeInsets.fromLTRB(20.0, 50, 20.0, 0.0),
                  child: bjpButton((){
                          if(e['screen']=="NDP"){
                             Navigator.push(context,MaterialPageRoute(builder: (context) => ThreeArgList(title:e['title'],url:e['url'],data:[], start:e['start'])));
                           }
                          else if(e['screen']=="BL")
                            Navigator.push(context,MaterialPageRoute(builder: (context) => ButtonList(title:e['title'],url:e['url'],data:[],start:e['start'])));
                          else if(e['id']!=-1)
                            Navigator.push(context,MaterialPageRoute(builder: (context) => ButtonList(title:e['title'],url:"empty",data:e['id']!=-1?Constants.ORG_LIST[e['id']]:[],start:"")));


                        }, e['title'], Constants.BJP_ORANGE))
                    
                    
                    ).toList())
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

        ),
                      )
                      ]
         )
      ),
    ));
  }

  @override
  bool get wantKeepAlive => true;
}
