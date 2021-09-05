import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';


import 'package:http/http.dart';
import 'package:my_bjp/templates/card.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../values/constants.dart' as Constants;


class FetchData extends StatefulWidget {
  @override
  FetchDataState createState() => FetchDataState();
}




class FetchDataState extends State<FetchData> with AutomaticKeepAliveClientMixin<FetchData>{
  ScrollController _controller;
  NewsFeedStreamer _streamer;
  RefreshController _refreshController = RefreshController(initialRefresh: false);
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("bottom");
      _streamer.update();
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      print("Refresh");
      _streamer.init();
      //_refreshController.loadComplete();
      _refreshController.refreshCompleted();
    }
  }

  @override
  void initState(){
    super.initState();
    _controller = ScrollController();
    //_streamer = NumberListCreator();
    _streamer = NewsFeedStreamer();
    _streamer.update();
    _controller.addListener(_scrollListener);
  }


  @override 
  Widget build(BuildContext context){
    super.build(context);
    print("called");
    return StreamBuilder(
    stream: _streamer.stream,
    builder: (context, snapshot){
      
      // if(snapshot.connectionState == ConnectionState.waiting){
        
      // }else if(snapshot.connectionState == ConnectionState.done){
       
      // }else 
      
      if(snapshot.hasError){
      return Center(
                  child: Column(children: <Widget>[
                  Text('Check Your Network'),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {_streamer.reset();},
                  ),
                  Text('Pull to Refresh'),
                ]));
      }else if(snapshot.hasData){
        return SmartRefresher(
        enablePullDown: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        //onRefresh: _onRefresh,
        //onLoading: _onLoading,
        child: ListView(controller:_controller, children: snapshot.data.map<Widget>((e)=>DesignedCard(obj:e)).toList())
        );
      }else return  Container(child:Image.asset(
                    'lib/images/20degree_256.gif',
                    //height: 100,
                    width:100,
                  ));
    }
  );
  }

  @override
  bool get wantKeepAlive => true;

}


class NewsFeedStreamer{
  bool busy=false;
  List data=[];
  //List new_data=[];
  final controller = StreamController();
  int end = 0;
	Stream get stream=> controller.stream; //stream end where data arrives

  void init(){
        if(!busy){
          busy=true;




          // get(Constants.NEWS_FEED_TEST_URL,headers: {
          //   "Accept": "application/json",
          //   "Content-Type": "application/x-www-form-urlencoded"
          // },)
          post(Constants.NEWS_FEED_URL,headers: {
            "Accept": "application/json",
            "Content-Type": "application/x-www-form-urlencoded"
          },
          body: json.encode({"start":0}),
          encoding: Encoding.getByName("utf-8"))
            .then((value) {
              data=jsonDecode(value.body); 
              // if(data.length!=new_data.length){
              //   data=new_data;
              // } 
              print("Got Data Silently");
              busy=false;
              update();
            })
            .onError((error, stackTrace) {
              print(error);
              controller.sink.addError(error);
              busy=false;
            });
        }
  }
  NewsFeedStreamer(){
    init();
  }

  void update(){
      if(data.length>0 && !controller.isClosed){
        end +=5;
        controller.sink.add(data.getRange(0, min(end,data.length)));
        if(end>data.length){
          controller.close();
        }
      }
      
  }

  void reset(){
    busy=false;
    controller.sink.add(null);
    end = 0;
    data = [];
    init();
  }



}