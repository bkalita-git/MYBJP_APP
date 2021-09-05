import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

Widget bjpButton(GestureTapCallback onPressed, String title, Color color ){
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: color,
        shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        )
      ),
      ),
      onPressed: onPressed,
    child:  Text(
      title,
      style: GoogleFonts.oswald(color: Colors.white, fontSize: 20),
      ));
}