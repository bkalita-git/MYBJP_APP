import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:my_bjp/screens/about/Antyodaya.dart';
import 'package:my_bjp/screens/about/history_development.dart';
import 'package:my_bjp/screens/about/integral_humanism.dart';
import 'package:my_bjp/templates/bjpappbar.dart';
import 'package:my_bjp/templates/bjpbutton.dart';
import 'philosophy.dart';
import  '../../values/constants.dart' as Constants;

class About extends StatelessWidget{

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context)=>
          SafeArea(
              child: Scaffold(
              appBar: bjpAppBar("The Party",context),
              body:Column(children: [Expanded(child:
              ListView(
                
                children:[
        
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 50, 20.0, 0.0),
                    child: bjpButton(() {Navigator.push(context,MaterialPageRoute(builder: (context) => Philosophy()));},"Our Philosophy",Constants.BJP_ORANGE),
                  ),
                   Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                    child: bjpButton(() {Navigator.push(context,MaterialPageRoute(builder: (context) => IntegralHumanism()));},"Integral Humanism",Constants.BJP_ORANGE),
                  ),
                   Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                    child: bjpButton(() {_launchURL(Constants.HISTORY);},"History",Constants.BJP_ORANGE),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                    child: bjpButton(() {Navigator.push(context,MaterialPageRoute(builder: (context) => HistoryDevelopment()));},"History and Development",Constants.BJP_ORANGE),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                    child: bjpButton(() {Navigator.push(context,MaterialPageRoute(builder: (context) => Antyodaya()));},"Antyodaya",Constants.BJP_ORANGE),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0.0),
                    child: bjpButton(() { _launchURL(Constants.CONSTITUTION);},"Constitution",Constants.BJP_ORANGE),
                  ),

                ]
              ))]),
          
            )
        );
}