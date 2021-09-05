import 'package:flutter/material.dart';

import 'package:my_bjp/services/schemeListFetching.dart';
import 'package:my_bjp/templates/bjpappbar.dart';

class SchemePop extends StatefulWidget {
  @override
  SchemePopState createState() => SchemePopState();
}

class SchemePopState extends State<SchemePop> {
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: bjpAppBar("SCHEMES",context),
        body: FetchSchemeList(),
      ),
    );
  }

}
