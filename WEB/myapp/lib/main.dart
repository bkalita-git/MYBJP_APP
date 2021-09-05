import 'dart:convert';

import 'package:http/http.dart';

import 'package:flutter/material.dart';
import 'package:sdp_transform/sdp_transform.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';


void main() {
  runApp(MyApp());
  }

class MyApp extends StatefulWidget{
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _localRenderer  = new RTCVideoRenderer();
  final _remoteRenderer = new RTCVideoRenderer();
  RTCPeerConnection _peerConnection;

  bool _offer=false;

  final sdpController = TextEditingController();
  @override
  void initState(){
    _localRenderer.initialize();
    _remoteRenderer.initialize();
    _getRemoteAndLocalUserMedia().then((pc){
      _peerConnection = pc;
    }
    );
    super.initState();
  }
  _getLocalUserMedia ()async{
    return  await navigator.mediaDevices.getUserMedia({'audio':false,'video':true}); //returns <MediaStream>
  }

  _getRemoteAndLocalUserMedia()async{
    Map<String,dynamic> configuration = {
      "iceServers":[
        {
          "url":"stun:stun.l.google.com:19302"
        }
      ]
    };
    Map<String,dynamic> offerSdpConstraints = {
      "mandatory":{
        "OfferToReceiveAudio":true,
        "OfferToReceiveVideo":true
      },
      "optional":[]
    };
    _localRenderer.srcObject = await _getLocalUserMedia();
    RTCPeerConnection pc = await createPeerConnection(configuration,offerSdpConstraints);
    pc.addStream(_localRenderer.srcObject);
    pc.onIceCandidate=(e){
        if(e.candidate!=null){
          print(json.encode(
            {
              "candidate":e.candidate.toString(),
              "sdpMid":e.sdpMid.toString(),
              "sdpMlineIndex":e.sdpMlineIndex
            }
          ));
        }
    };
    pc.onIceConnectionState=(e){
      print(e);
    };
    pc.onAddStream=(stream){
      _remoteRenderer.srcObject=stream;
    };

    return pc;

  }

  void _createOffer()async{
    RTCSessionDescription description = await _peerConnection.createOffer(
      {
        "offerToReceiveVideo":1
      }
    );
    var session = parse(description.sdp);
    print(json.encode(session));
    _offer=true;
    _peerConnection.setLocalDescription(description);
  }

  void _createAnswer()async{
        RTCSessionDescription description = await _peerConnection.createAnswer(
      {
        "offerToReceiveVideo":1
      }
    );
    var session = parse(description.sdp);
     print(json.encode(session));
    _peerConnection.setLocalDescription(description);

  }

  void _setRemoteDescription()async{
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode('$jsonString');
    String sdp = write(session,null);
    RTCSessionDescription description = new RTCSessionDescription(sdp,_offer?'answer':'offer');
    print(description.toMap());
    await _peerConnection.setRemoteDescription(description);
  }
  void _setCandidate()async{
    String jsonString = sdpController.text;
    dynamic session = await jsonDecode('$jsonString');
    print(session['candidate']);
    dynamic candidate = new RTCIceCandidate(session['candidate'], session['sdpMid'], session['sdpMlineIndex']);
    await _peerConnection.addCandidate(candidate);
  }
  
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: Container(
          child:Column(children: [
              videoRenderers(),
              offerAndAnswerButton(),
              sdpCandidateTF(),
              sdpCandidateButtons(),
            ],)
        ),
      ),
    );
  }


  SizedBox videoRenderers()=>SizedBox(
    height: 210,
    child: Row(children: [
      Flexible(child: Container(
        key:Key('local'),
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        decoration: BoxDecoration(color: Colors.black),
        child: RTCVideoView(_localRenderer),
      )),
      Flexible(child: Container(
        key:Key('local'),
        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
        decoration: BoxDecoration(color: Colors.black),
        child: RTCVideoView(_remoteRenderer),
      )),

    ],),
  );
  Row offerAndAnswerButton()=>Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      ElevatedButton(onPressed: _createOffer, child: Text('offer'),style:ElevatedButton.styleFrom(primary:Colors.amber),),
      ElevatedButton(onPressed: _createAnswer, child: Text('answer'),style:ElevatedButton.styleFrom(primary:Colors.amber),),
  ],);

  Padding sdpCandidateTF()=>Padding(
    padding: const EdgeInsets.all(16),
    child: TextField(
      controller: sdpController,
      keyboardType: TextInputType.multiline,
      maxLines: 4,
      maxLength: TextField.noMaxLength,
    ),
  );

  Row sdpCandidateButtons()=>Row(
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
     ElevatedButton(onPressed: _setRemoteDescription, child: Text('set remote description'),style:ElevatedButton.styleFrom(primary:Colors.amber),),
     ElevatedButton(onPressed: _setCandidate, child: Text('set candidate'),style:ElevatedButton.styleFrom(primary:Colors.amber),),
  ],
  );
}