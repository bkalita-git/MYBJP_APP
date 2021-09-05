import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:http/http.dart';

import 'package:my_bjp/templates/bjpappbar.dart';
import '../values/constants.dart' as Constants;

class Scheme extends StatefulWidget {
  final id;
  final title;
  Scheme({this.title,this.id});

  @override
  _SchemeState createState() => _SchemeState();
}

class _SchemeState extends State<Scheme> {

    List data=[];
    Future retrieve() async {
    Response response = await post(Constants.SCHEME_DETAILS_URL,
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/x-www-form-urlencoded"
      },
      body: json.encode({"start":widget.id}),
      encoding: Encoding.getByName("utf-8"));
      if(mounted)
        setState(() {
          data = jsonDecode(response.body);
      });

  }

  @override
  void initState(){
    super.initState();
    retrieve();
  }
  @override
  Widget build(BuildContext context) => 
          SafeArea(child:Scaffold(
            body: data.length!=0?(ListView(
            children: [ClipRRect(
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
            tileColor: Colors.orangeAccent[100],
            leading: Image.asset(Constants.LEADING_BJP_LOGO),
            title:   Text(
              data[0]['title'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 5),
          ),
          ),

          ClipRRect(
        borderRadius: BorderRadius.circular(0),
        //child: url != null ? Image.network(url) : Container(),
        child: data[0]["url"]!=null?
                  FadeInImage.assetNetwork(
                    placeholder: 'lib/images/20degree_256.gif',
                    placeholderScale: 3,
                    image:data[0]["url"]
                  )
                  : (Image.asset(Constants.LINE))

      ),


           Divider(thickness: 5,), 
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              data[0]['text'],
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.justify,
            )
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: Icon(Icons.share),
                  color:Colors.blue,
                  onPressed: (){
                    shareButton(data[0]['text'],data[0]['url'],context);
                  },
              ),
            ],
          ),

        ],
      ),
    ),
    ),
            ])
            )
            :Center(
              child: Image.asset(
              "lib/images/20degree_256.gif",
              width: 100,
              
            )),
        appBar: bjpAppBar("SCHEME",context),
      )
      //)
  );
}

Future<void> shareButton(name,url,context) async{

  BuildContext dialogContext; 
  showDialog(
    context: context, 
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