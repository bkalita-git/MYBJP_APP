import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'package:my_bjp/templates/bjpappbar.dart';
import '../values/constants.dart' as Constants;

class WrPrs extends StatefulWidget {
  @override
  WrPrsState createState() => WrPrsState();
}

class WrPrsState extends State<WrPrs> {

  Widget build(BuildContext context) {
    return SafeArea(
      child: 
      WebviewScaffold(
      url: Constants.URL_WRP_FORM,
      initialChild: Container(
        color: Colors.red,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      appBar: bjpAppBar("Write to State President",context),
    ));
    //return Text('test');

  }

}
