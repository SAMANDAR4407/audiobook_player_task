import 'package:audio_service/audio_service.dart';
import 'package:audiobook_player/core/model/book.dart';
import 'package:audiobook_player/widgets/player_buttons.dart';
import 'package:audiobook_player/widgets/seekbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';
import 'package:path_provider/path_provider.dart';

import '../core/model/audiofile.dart';
import '../di/get_it.dart';
import '../main.dart';
import '../util.dart';
import '../widgets/playlist_item.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key, required this.book, required this.list});

  final List<AudioFile> list;
  final Book book;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> with TickerProviderStateMixin {
  final pageController = PageController();
  final scrollController = ScrollController();
  int pageIndex = 0;
  int songIndex = 0;

  final audioPlayer = getIt<AudioPlayer>();

  String path = '';
  List<String> paths = [];
  final cancelToken = CancelToken();

  void loadPath() async {
    final dir = await getApplicationDocumentsDirectory();
    path = dir.path;
  }

  @override
  void initState() {
    loadPath();
    for (var audio in widget.list) {
      paths.add("$path/${audio.title}");
    }
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final book = widget.book;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            audioHandler.stop();
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close_rounded),
          color: Colors.white,
        ),
        title: const Text.rich(TextSpan(children: [
          TextSpan(
              text: 'Play',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white)),
          TextSpan(
              text: 'Audio',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300, color: Colors.white)),
        ])),
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.sizeOf(context).height * .5,
            child: PageView(
              controller: pageController,
              onPageChanged: (value) {
                setState(() {
                  pageIndex = value;
                });
              },
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.all(40),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    clipBehavior: Clip.antiAlias,
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    height: MediaQuery.sizeOf(context).width * 0.8,
                    child: CachedNetworkImage(imageUrl: book.image, fit: BoxFit.cover),
                  ),
                ),
                StreamBuilder<MediaState>(
                  stream: mediaStateStream,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white.withOpacity(0.85),
                        clipBehavior: Clip.antiAlias,
                        child: ListView.separated(
                          controller: scrollController,
                          itemCount: widget.list.length,
                          separatorBuilder: (__, _) => const SizedBox(),
                          itemBuilder: (c, i) {
                            final audio = widget.list[i];
                            return PlaylistItem(
                              positionData: positionData,
                              audio: audio,
                              audioPlayer: audioPlayer,
                              scrollController: scrollController,
                              index: i,
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 5,
                width: 22,
                decoration: BoxDecoration(
                    color: pageIndex == 0 ? Colors.red : Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(width: 20),
              Container(
                height: 5,
                width: 22,
                decoration: BoxDecoration(
                    color: pageIndex == 1 ? Colors.red : Colors.white,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          StreamBuilder<MediaState>(
            stream: mediaStateStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: SizedBox(
                  height: 30,
                  child: Marquee(
                    text: positionData?.mediaItem?.title ?? 'Loading...',
                    blankSpace: 100,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              book.author!,
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 30),
          StreamBuilder<MediaState>(
            stream: mediaStateStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SeekBar(
                  position: positionData?.position ?? Duration.zero,
                  duration: positionData?.mediaItem?.duration ?? Duration.zero,
                ),
              );
            },
          ),
          const SizedBox(height: 30),
          PlayerButtons(
            audioPlayer: audioPlayer,
            onNext: () {
              mediaStateStream.listen((event) {
                for (int i = 0; i < widget.list.length; i++) {
                  if (event.mediaItem?.title == widget.list[i].title) {
                    scrollPlaylist(i, scrollController);
                  }
                }
              });
            },
            onPrev: () {
              mediaStateStream.listen((event) {
                for (int i = 0; i < widget.list.length; i++) {
                  if (event.mediaItem?.title == widget.list[i].title) {
                    scrollPlaylist(i, scrollController);
                  }
                }
              });
            },
          )
        ],
      ),
    );
  }
}

class MediaState {
  final MediaItem? mediaItem;
  final Duration position;

  MediaState(this.mediaItem, this.position);
}
