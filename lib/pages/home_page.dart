import 'package:audiobook_player/bloc/home/home_bloc.dart';
import 'package:audiobook_player/pages/detail_page.dart';
import 'package:audiobook_player/widgets/bottom_loader.dart';
import 'package:audiobook_player/widgets/listtile_book_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/model/book.dart';
import '../util.dart';
import '../widgets/book_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    BlocProvider.of<HomeBloc>(context).add(GetTopBooks());
    BlocProvider.of<HomeBloc>(context).add(GetBooks());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return RefreshIndicator(
          color: Colors.blue,
          onRefresh: () {
            return _onRefresh();
          },
          child: state.status == EnumStatus.fail
              ? ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height*0.8,
                      child: const Center(
                        child: Text(
                          'Sorry, unable to load data...\nPlease check the internet connection\nand pull down to refresh!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                )
              : CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    const SliverPadding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'Most Popular Books',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.25,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: state.topBooks!.length,
                            separatorBuilder: (context, index) => const SizedBox(width: 10),
                            itemBuilder: (c, i) {
                              final book = state.topBooks![i];
                              return BookItem(book: book, onTap: () => _openDetail(context, book));
                            },
                          ),
                        ),
                      ),
                    ),
                    const SliverPadding(
                      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
                      sliver: SliverToBoxAdapter(
                        child: Text(
                          'Recent Books',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          childCount: BlocProvider.of<HomeBloc>(context).hasReachedMax
                              ? state.books?.length
                              : state.books!.length + 1,
                          (context, index) => index >= state.books!.length
                              ? const BottomLoader()
                              : ListTileBookItem(book: state.books![index]),
                        ),
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final offset = _scrollController.position.pixels;
    if (maxScroll - offset <= _scrollThreshold) {
      BlocProvider.of<HomeBloc>(context).add(GetBooks());
    }
  }

  void _openDetail(BuildContext context, Book book) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) => DetailPage(book: book)));
  }

  Future<void> _onRefresh() async {
    BlocProvider.of<HomeBloc>(context).add(GetTopBooks());
    BlocProvider.of<HomeBloc>(context).add(GetBooks());
  }
}
