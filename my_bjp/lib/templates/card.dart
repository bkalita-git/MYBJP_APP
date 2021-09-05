import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';

import '../values/constants.dart' as Constants;

class DesignedCard extends StatelessWidget{
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final obj;
  DesignedCard({this.obj});
  
  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
      key: _scaffoldKey,
       //key: UniqueKey(),
       child: Card(
         color: Colors.white,
         margin: EdgeInsets.fromLTRB(5.0, 0, 5.0, 20.0),
         shape: RoundedRectangleBorder(
           side: BorderSide(width: 0.2),
           
           borderRadius: BorderRadius.circular(15.0),
         ),
         clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Material(
          child:  GestureDetector(
                onLongPress: (){
                  HapticFeedback.vibrate();
                  Clipboard.setData(ClipboardData(text: obj['title']+'\n\n\n'+obj['text']));
                  Fluttertoast.showToast(
                    msg: "Copied!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Constants.BJP_ORANGE,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                },
                child: ListTile(
                  title: Text(
                    obj['title'],
                    style: GoogleFonts.hindSiliguri(fontSize: 18, fontWeight: FontWeight.bold),
                  
                    ),
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                  subtitle: Text(
                    obj['dt']!=null?obj['dt']+'\nPosted by- '+obj['by']+'':'Secondary Text',
                    style: TextStyle(fontSize: 10,color: Colors.black.withOpacity(0.6)),
                  ),
                ),
            )
          ),

          IconButton(
                  icon: Icon(Icons.download_rounded),
                  color:Colors.blue,
                  onPressed: (){
                    //shareButton(obj['text'],obj['url'],context);
                  },
          ),
          
          ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: 
        // FadeInImage.assetNetwork(
        //     imageErrorBuilder:  (BuildContext context, Object exception, StackTrace stackTrace) {
        //                           print("LOADING ERROR");
        //                           return Image.asset('lib/images/20degree_256.gif');
        //                         },
        //     placeholder: 'lib/images/20degree_256.gif',
        //     placeholderScale: 3,
        //     image:  obj['url']!=null?obj['url']:Constants.LINE,
        //   ),

      
          CachedNetworkImage(
              //width: MediaQuery.of(context).size.width,
              imageUrl: obj['url'],
              placeholder: (context, url) => Image.asset('lib/images/20degree_256.gif', width: 100,),
              errorWidget: (context, url, error) => Icon(Icons.error),
              
          ),
        ),      


          Padding(
            padding: const EdgeInsets.fromLTRB(10,10,10,5),
            child: GestureDetector(
                onLongPress: (){
                  HapticFeedback.vibrate();
                  Clipboard.setData(ClipboardData(text: obj['title']+'\n\n\n'+obj['text']));
                  Fluttertoast.showToast(
                    msg: "Copied!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Constants.BJP_ORANGE,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
                },
                child: ReadMoreText(
                  obj['text'],
                  trimLines: 4,
                  textAlign: TextAlign.justify,
                  colorClickableText: Colors.pink,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  moreStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  style: GoogleFonts.hindSiliguri(fontSize: 15),
            ),
            )
          ),


          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(Icons.share),
                  color:Colors.blue,
                  onPressed: (){
                    shareButton(obj['text'],obj['url'],context);
                  },
              )
            ],
          ),

        ],
      ),
    ),
    );
  }

}

Future<void> shareButton(name,url,context) async{

  BuildContext dialogContext; // <<----
  showDialog(
    context: context, // <<----
    barrierDismissible: false,
    builder: (BuildContext context) {
      dialogContext = context;
      return Center(
              child: Image.asset(
                Constants.LOADING_BJP_GIF,
                height:100,
                width:100,
          ),
        );
    },
  );

  var request = await HttpClient().getUrl(Uri.parse(url));
  var response = await request.close();
  
  Uint8List bytes = await consolidateHttpClientResponseBytes(response);
  // Uint8List bytes;
  // CachedNetworkImageProvider(url).load(key, (bytes, {allowUpscaling, cacheHeight, cacheWidth}){
  //   bytes = bytes.buffer.asUint8List();
  //   return instantiateImageCodec(bytes, targetWidth: cacheWidth, targetHeight: cacheHeight);
  // });

  Navigator.pop(dialogContext);

  await Share.files(
    'esys images',
      {
        'esys.png': bytes,
      },
    '*/*',
    text:name
  );
}
