import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:my_bjp/templates/bjpappbar.dart';
import '../values/constants.dart' as Constants;

class ThreeArgList extends StatefulWidget {
  final title;
  final url;
  final data;
  final start;
  ThreeArgList({this.title,this.url,this.data,this.start});
  @override
  ThreeArgListState createState() => ThreeArgListState();
}

class ThreeArgListState extends State<ThreeArgList> with AutomaticKeepAliveClientMixin<ThreeArgList> {
  int error = 0;
  List data = [];
  int network = 1;
  int loading = 1;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  Future retrieve() async {
    if(widget.url=="empty"){
      print(widget.url);
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
            print(data[0]['args_list'][0]);
            print(data[0]['args_list']);
            print(data[0]);


            loading = 0;
            network = 1;
            _refreshController.refreshCompleted();
            error=0;
         });
        } catch(e){
          print('error');
            setState(() {
              error=1;
            });
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
          (data.length!=0)?
          Padding( padding: const EdgeInsets.fromLTRB(8,8,8,0), child:
           Table(
            border:TableBorder.all(width: 2.0, color:Constants.BJP_ORANGE),
            children: [
              TableRow(children: [
                Container(color: Colors.black38, padding: EdgeInsets.all(10), child:Text(data[0]['args_list'][0], style: GoogleFonts.balooDa(fontWeight: FontWeight.bold))),
                Container(color:Colors.black26, padding: EdgeInsets.all(10), child:Text(data[0]['args_list'][1], style: GoogleFonts.balooDa(fontWeight: FontWeight.bold))),
                Container(color:Colors.black12, padding: EdgeInsets.all(10), child:Text(data[0]['args_list'][2], style: GoogleFonts.balooDa(fontWeight: FontWeight.bold))),
              ]

              )
            ],
          ),
          ):
          Divider()
          ,
          Expanded(
          child: 
          (error==0)?
          ListView(
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
                  ? [Padding( padding: const EdgeInsets.fromLTRB(8,0,8,8), child:
                  Table( 
                    border:TableBorder.all(width: 2.0,color: Constants.BJP_ORANGE), children:
                  (data.map((e) => 
                  
                  TableRow( 
                    children:[
                    Container(padding:EdgeInsets.all(10),child:Text(e[e['args_list'][0]],)),
                    Container(padding:EdgeInsets.all(10),child:Text(e[e['args_list'][1]])),
                    Container(padding:EdgeInsets.all(10),child:SelectableText(e[e['args_list'][2]],)),
                    
                  ])
                  
                  ).toList()) ))]
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

        ):
        Container(
          child:Text(
            "coming soon",
            style: GoogleFonts.balooDa(color:Colors.orange, fontSize: 50),
            )
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
