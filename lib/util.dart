import 'package:audio_service/audio_service.dart';
import 'package:audiobook_player/pages/player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

import 'core/model/audiofile.dart';
import 'core/model/book.dart';
import 'main.dart';

enum EnumStatus{
  initial, loading, success, fail
}

void loadPlaylist(Book book,List<AudioFile> list) async {
  final mediaItems = list
      .map((chapter) => MediaItem(
    id: chapter.url ?? '',
    album: book.title,
    title: chapter.title ?? '',
    extras: {
      'url': chapter.url,
      'bookId': chapter.bookId
    },
  )).toList();

  await audioHandler.updateQueue(mediaItems);
}

void playAudio(int index) async {
  await audioHandler.skipToQueueItem(index);
  await audioHandler.play();
}

String formatDuration(Duration? duration){
  if(duration ==null) {
    return '--:--:--';
  } else {
    String hours = duration.inHours.toString().padLeft(2,'0');
    String minutes = duration.inMinutes.toString().padLeft(2,'0');
    String seconds = duration.inSeconds.remainder(60).toString().padLeft(2,'0');
    return '$hours:$minutes:$seconds';
  }
}

Stream<MediaState> get mediaStateStream => Rx.combineLatest2<MediaItem?, Duration, MediaState>(
    audioHandler.mediaItem,
    AudioService.position,
        (mediaItem, position) => MediaState(mediaItem, position));

void scrollPlaylist(int songIndex, ScrollController scrollController){
  scrollController.animateTo(
    56.0 * songIndex,
    duration: const Duration(milliseconds: 500),
    curve: Curves.linear,
  );
}