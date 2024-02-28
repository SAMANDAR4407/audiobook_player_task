
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../core/model/audiofile.dart';
import '../main.dart';
import '../pages/player_page.dart';
import '../util.dart';

class PlaylistItem extends StatefulWidget {
  const PlaylistItem({
    super.key,
    required this.positionData,
    required this.audio,
    required this.audioPlayer,
    required this.scrollController,
    required this.index,
  });

  final int index;
  final MediaState? positionData;
  final AudioFile audio;
  final AudioPlayer audioPlayer;
  final ScrollController scrollController;

  @override
  State<PlaylistItem> createState() => _PlaylistItemState();
}

class _PlaylistItemState extends State<PlaylistItem> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListTile(
        leading: Icon(
          widget.positionData?.mediaItem?.title == widget.audio.title && widget.audioPlayer.playing
              ? Icons.pause_circle_outline_rounded
              : Icons.play_circle_outline_rounded,
          size: 40,
          color: widget.positionData?.mediaItem?.title == widget.audio.title ? Colors.red : Colors.black,
        ),
        title: Text(
          widget.audio.title!,
          maxLines: 2,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: widget.positionData?.mediaItem?.title == widget.audio.title ? Colors.red : Colors.black,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(formatDuration(Duration(seconds: widget.audio.length!.toInt())),
                style: const TextStyle(fontSize: 12, color: Colors.blueGrey)),
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.file_download_outlined),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        onTap: () {
          if(widget.positionData?.mediaItem?.title == widget.audio.title){
            if(widget.audioPlayer.playing) {
              audioHandler.pause();
            } else {
              audioHandler.play();
            }
          } else {
            playAudio(widget.index);
          }
          scrollPlaylist(widget.index, widget.scrollController);
        },
      ),
    );
  }
}