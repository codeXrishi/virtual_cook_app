import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ignore: must_be_immutable
class VideoPlayerScreen extends StatefulWidget {
  String link;
  VideoPlayerScreen({super.key, required this.link});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    final videoID = YoutubePlayer.convertUrlToId(widget.link);
    _controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        showLiveFullscreenButton: true,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Watch Video'),
        backgroundColor: Colors.amberAccent,
      ),
      body: ListView(children: [
        YoutubePlayer(
          controller: _controller!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.red,
        ),
      ]),
    );
  }
}
