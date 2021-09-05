import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../values/constants.dart' as Constants;

Widget bjpAppBar(String title, BuildContext context){
  return AppBar(
          toolbarHeight: MediaQuery.of(context).size.width*0.25,
          backgroundColor: Colors.white,
          flexibleSpace: Image(
            image: AssetImage(Constants.APP_BAR_BANNER),
            fit: BoxFit.cover,
          ),
           bottom: PreferredSize( preferredSize: Size.fromHeight(30),child: Text(title, style:GoogleFonts.oswald(fontSize: 25,color: Colors.white)
        )));
}