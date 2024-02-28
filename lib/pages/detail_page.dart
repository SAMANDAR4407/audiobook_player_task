import 'package:audiobook_player/bloc/detail/detail_bloc.dart';
import 'package:audiobook_player/core/model/audiofile.dart';
import 'package:audiobook_player/pages/player_page.dart';
import 'package:audiobook_player/util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/model/book.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.book});

  final Book book;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final files = <AudioFile>[];

  var status = EnumStatus.initial;

  bool hasBook = false;

  @override
  void initState() {
    BlocProvider.of<DetailBloc>(context).add(CheckBook(book: widget.book));
    BlocProvider.of<DetailBloc>(context).add(LoadAudioFiles(book: widget.book));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.97),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text.rich(TextSpan(children: [
          TextSpan(text: 'Book', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          TextSpan(text: 'Detail', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300)),
        ])),
      ),
      body: BlocBuilder<DetailBloc, DetailState>(
        builder: (context, state) {
          hasBook = BlocProvider.of<DetailBloc>(context).hasBook;
          files.clear();
          files.addAll(state.list);
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Hero(
                        tag: '${widget.book.id}_image',
                        child: Container(
                          height: MediaQuery.sizeOf(context).width * 0.8,
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          // padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: CachedNetworkImage(imageUrl: widget.book.image, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.book.title,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 8),
                    Text(widget.book.author!,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            decoration: TextDecoration.underline)),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            child: Text(
                              'Rating: ${widget.book.rating ?? 'N/A'}',
                              style: const TextStyle(fontSize: 17, color: Colors.white),
                            ),
                          ),
                        ),
                        hasBook
                            ? Material(
                                color: Colors.blue.shade600,
                                borderRadius: BorderRadius.circular(10),
                                clipBehavior: Clip.antiAlias,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: _openPlayer,
                                      child: const Material(
                                        color: Colors.blue,
                                        child: Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: Icon(Icons.play_circle_outline_rounded,
                                                      color: Colors.white)),
                                              SizedBox(width: 5),
                                              Text(
                                                'Play Audio',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          showDragHandle: true,
                                          backgroundColor: Colors.white,
                                          useSafeArea: true,
                                          isScrollControlled: false,
                                          builder: (context) {
                                            return SingleChildScrollView(
                                              padding: const EdgeInsets.all(20),
                                              child: Column(
                                                children: List.generate(
                                                  state.list.length,
                                                  (index) => ListTile(
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                      _openPlayer();
                                                      playAudio(index);
                                                    },
                                                    title: Text(state.list[index].title!),
                                                    leading: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(50),
                                                          border: Border.all(
                                                              color: Colors.black,
                                                              width: 2,
                                                              style: BorderStyle.solid)),
                                                      child: const Icon(Icons.music_note_outlined),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: state.status == EnumStatus.loading
                                            ? const CupertinoActivityIndicator(
                                                color: Colors.white, radius: 12)
                                            : const Icon(Icons.arrow_drop_down_sharp,
                                                color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Material(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () {
                                    status = EnumStatus.loading;
                                    BlocProvider.of<DetailBloc>(context)
                                        .add(SaveBookToDb(book: widget.book));
                                    status = EnumStatus.success;
                                  },
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                    child: status == EnumStatus.loading
                                        ? const Center(
                                            child: CupertinoActivityIndicator(color: Colors.white))
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  width: 25,
                                                  height: 25,
                                                  child: Icon(
                                                      status == EnumStatus.success
                                                          ? Icons.bookmark_added
                                                          : Icons.bookmark_add_outlined,
                                                      color: Colors.white)),
                                              const SizedBox(width: 5),
                                              Text(
                                                status == EnumStatus.success
                                                    ? state.message
                                                    : 'Save book',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              )
                      ],
                    ),
                    const SizedBox(height: 20),
                    hasBook
                        ? const SizedBox()
                        : Center(
                            child: Material(
                              color: Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(10),
                              clipBehavior: Clip.antiAlias,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: _openPlayer,
                                    child: const Material(
                                      color: Colors.blue,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                                width: 25,
                                                height: 25,
                                                child: Icon(Icons.play_circle_outline_rounded,
                                                    color: Colors.white)),
                                            SizedBox(width: 5),
                                            Text(
                                              'Play Audio',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        showDragHandle: true,
                                        backgroundColor: Colors.white,
                                        useSafeArea: true,
                                        isScrollControlled: false,
                                        builder: (context) {
                                          return SingleChildScrollView(
                                            padding: const EdgeInsets.all(20),
                                            child: Column(
                                              children: List.generate(
                                                state.list.length,
                                                (index) => ListTile(
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    _openPlayer();
                                                    playAudio(index);
                                                  },
                                                  title: Text(state.list[index].title!),
                                                  leading: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(50),
                                                        border: Border.all(
                                                            color: Colors.black,
                                                            width: 2,
                                                            style: BorderStyle.solid)),
                                                    child: const Icon(Icons.music_note_outlined),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: state.status == EnumStatus.loading
                                          ? const CupertinoActivityIndicator(
                                              color: Colors.white, radius: 12)
                                          : const Icon(Icons.arrow_drop_down_sharp,
                                              color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                    const SizedBox(height: 20),
                    Text(widget.book.description!,
                        style: const TextStyle(
                            fontSize: 17, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openPlayer() {
    loadPlaylist(widget.book, files);
    Navigator.push(
      context,
      ModalBottomSheetRoute(
        builder: (context) => PlayerPage(book: widget.book, list: files),
        useSafeArea: true,
        modalBarrierColor: Colors.black,
        isScrollControlled: true,
      ),
    );
  }
}
