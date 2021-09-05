import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:my_bjp/templates/bjpappbar.dart';
import '../../values/constants.dart' as Constants;

class Philosophy extends StatefulWidget{
  @override
  _PhilosophyState createState() => _PhilosophyState();
}

class _PhilosophyState extends State<Philosophy> {
  String contents="";

  void loadAsset() async {
    contents =  await rootBundle.loadString(Constants.ANTYODOYA);
    setState(() {
      contents =contents;
    });
  }
  @override
  void initState(){
    super.initState();
    loadAsset();

  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child:Scaffold(
        appBar: bjpAppBar("Philosophy",context),
        body: Column(children: [
                    Expanded(child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.all(20),
                      child: Text(
                        contents,
                        style: TextStyle(fontSize: 20),  textAlign: TextAlign.justify),

                    ),
            )
            
          ],
        ),
      )
    );
  }
}