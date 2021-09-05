import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../templates/schemeList.dart';
import '../values/constants.dart' as Constants;

class FetchSchemeList extends StatefulWidget {
  @override
  FetchSchemeListState createState() => FetchSchemeListState();
}

class FetchSchemeListState extends State<FetchSchemeList> with AutomaticKeepAliveClientMixin<FetchSchemeList> {
   List data = [
    {"title": "Loading"}
  ];
  int network = 1;
  int loading = 1;
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  Future retrieve() async {
   try{
    Response response = await post(Constants.SCHEME_FEED_URL,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: json.encode({"start":0}),
      encoding: Encoding.getByName("utf-8"));
      if(mounted)
        setState(() {
          data = jsonDecode(response.body);
          loading = 0;
          network = 1;
      });
   } catch(e){
     print("error");
     setState(() {
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
    _onLoading();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white60,
      body: SafeArea( child: SmartRefresher(
        enablePullDown: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Column(
        children: [
          Divider(),
          Container(
              color: Colors.orange,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
          child: AutoSizeText(
                Constants.SCHEME_HEADER,
                style: TextStyle(fontSize: 25, color:Colors.white),
                maxLines: 1,
          )
          ),
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
                  ? (data.map((e) => SchemeListCard(obj: e, index: data.indexOf(e)+1)).toList())
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
      )),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
