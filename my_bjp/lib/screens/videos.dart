import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

import 'package:video_player/video_player.dart';
//import 'package:auto_orientation/auto_orientation.dart';
import 'package:chewie/chewie.dart';
//import 'package:chewie/src/chewie_player.dart';


import 'package:my_bjp/templates/bjpappbar.dart';


class Videos extends StatefulWidget{
  @override
  _VideosState createState() => _VideosState();
}


class _VideosState extends State<Videos> {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network('https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        //aspectRatio: 3 / 2,
        autoPlay: false,
        looping: false,
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        appBar: bjpAppBar("Videos",context),
        body: Chewie(controller: chewieController)
        ),
    );
  }
}