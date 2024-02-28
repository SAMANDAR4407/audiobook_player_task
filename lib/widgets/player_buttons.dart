
import 'package:audio_service/audio_service.dart';
import 'package:audiobook_player/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


class PlayerButtons extends StatelessWidget {
  const PlayerButtons({
    super.key,
    required this.audioPlayer, required this.onNext, required this.onPrev,
  });

  final Function() onNext;
  final Function() onPrev;
  final AudioPlayer audioPlayer;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatefulBuilder(
          builder: (context, setState) {
            return Material(
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                onTap: () {
                  setState(() {
                    if(audioPlayer.loopMode == LoopMode.all){
                      audioHandler.setRepeatMode(AudioServiceRepeatMode.none);
                    } else if(audioPlayer.loopMode == LoopMode.one){
                      audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
                    } else {
                      audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Icon(
                    audioPlayer.loopMode == LoopMode.one ? CupertinoIcons.repeat_1 : CupertinoIcons.repeat,
                    color: audioPlayer.loopMode == LoopMode.one || audioPlayer.loopMode == LoopMode.all ? Colors.red : Colors.white,
                    size: 30,
                  ),
                ),
              ),
            );
          }
        ),
        const SizedBox(width: 10),
        StreamBuilder<SequenceState?>(
          stream: audioPlayer.sequenceStateStream,
          builder: (context, snapshot) {
            return Material(
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                onTap: (){
                  if(audioPlayer.hasPrevious){
                    onPrev();
                    audioPlayer.seekToPrevious();
                  } else {
                    null;
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(3),
                  child: Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ),
            );
          },
        ),

        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playerState = snapshot.data;
              final processingState = playerState!.processingState;

              if (processingState == ProcessingState.loading ||
                  processingState == ProcessingState.buffering) {
                return Container(
                  width: 75,
                  height: 75,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(8),
                  child: const CircularProgressIndicator(color: Colors.white,strokeWidth: 5),
                );
              } else if (!audioPlayer.playing) {
                return IconButton(
                  onPressed: audioPlayer.play,
                  iconSize: 75,
                  icon: const Icon(
                    Icons.play_circle,
                    color: Colors.white,
                  ),
                );
              } else if(processingState != ProcessingState.completed){
                return IconButton(
                  onPressed: audioPlayer.pause,
                  iconSize: 75,
                  icon: const Icon(
                    Icons.pause_circle,
                    color: Colors.white,
                  ),
                );
              } else {
                return IconButton(
                  onPressed: ()=> audioPlayer.seek(
                    Duration.zero,
                    index: audioPlayer.effectiveIndices!.first,
                  ),
                  iconSize: 75,
                  icon: const Icon(
                    Icons.replay_circle_filled_outlined,
                    color: Colors.white,
                  ),
                );
              }
            }
            return const SizedBox();
          },
        ),
        
        StreamBuilder<SequenceState?>(
          stream: audioPlayer.sequenceStateStream,
          builder: (context, snapshot) {
            return Material(
              clipBehavior: Clip.antiAlias,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                onTap: (){
                  if(audioPlayer.hasNext){
                    onNext();
                    audioPlayer.seekToNext();
                  }
                  else {
                    null;
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(3),
                  child: Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 45,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(width: 10),
        StatefulBuilder(
          builder: (context, setState) {
            return Material(
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(50),
              child: InkWell(
                    onTap: () {
                      setState(() {
                        if(audioPlayer.shuffleModeEnabled){
                          audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
                        } else {
                          audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
                        }
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        CupertinoIcons.shuffle,
                        color: audioPlayer.shuffleModeEnabled ? Colors.red : Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
            );
          }
        ),
      ],
    );
  }
}
