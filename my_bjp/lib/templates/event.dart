import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';

import '../values/constants.dart' as Constants;


class DesignedEvent extends StatelessWidget{
  final obj;
  DesignedEvent({this.obj});
  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
       child: Card(
         color: Colors.white,
         margin: EdgeInsets.fromLTRB(5.0, 20.0, 5.0, 30.0),
         elevation: 3,
         shape: RoundedRectangleBorder(
           side: BorderSide(width: 0.2),
           borderRadius: BorderRadius.circular(15.0),
         ),
         clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Material(
            elevation: 5,
          child: ListTile(
            tileColor: Constants.BJP_ORANGE,
            leading: Image.asset(Constants.LEADING_BJP_LOGO),
            title:   Text(obj['title'], style: GoogleFonts.hindSiliguri(color:Colors.white, fontSize: 20, fontWeight: FontWeight.bold ),),
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 5),
            subtitle: Text(
              obj['dt']!=null?obj['dt']+'\nLocation- '+obj['location']+'':'',
              style: GoogleFonts.hindSiliguri(fontSize:17, fontWeight:FontWeight.bold ),
            ),
          ),
          ),


          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ReadMoreText(
              obj['text'],
              trimLines: 9,
              textAlign: TextAlign.justify,
              colorClickableText: Colors.pink,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
              moreStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    ),
    );
  }

}