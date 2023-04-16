import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerPage extends StatefulWidget {
  final String id;
  const PlayerPage({super.key, required this.id});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.id,
      flags: const YoutubePlayerFlags(
        showLiveFullscreenButton: true,
        mute: true,
      ),
    );
  }

  @override
  void dispose() {
   _controller.dispose();
    super.dispose();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _controller,
          bottomActions: [
            CurrentPosition(),
            ProgressBar(isExpanded: true),
          ],
        ),
        builder: (context, player) {
          return Column(
            children: [
              // some widgets

              player,
              FullScreenButton(
                controller: _controller,
                color: Colors.red,
              )
              //some other widgets
            ],
          );
        },
      ),
    );
  }
}
