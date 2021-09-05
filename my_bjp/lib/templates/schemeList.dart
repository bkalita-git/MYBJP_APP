import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../screens/scheme.dart';

class SchemeListCard extends StatelessWidget {
  final obj;
  final index;

  SchemeListCard({this.obj,this.index});

  @override
  Widget build(BuildContext context) {
    return 
         ActionChip(
          backgroundColor: Colors.orange,
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Scheme(title:obj['title'], id:obj['id'])));
          },
          avatar: CircleAvatar(
            backgroundColor: Colors.grey.shade800,
            child: Text(this.index.toString()),
          ),
          label: Container(
            width: MediaQuery.of(context).size.width,
           child: Text(
                obj['title'],
              style: GoogleFonts.farro(
                color: Colors.white,
                fontSize: 19
              ),
            ),
          )
        //)
        );
  }
}
