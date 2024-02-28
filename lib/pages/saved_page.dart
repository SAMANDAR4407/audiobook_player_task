import 'package:audiobook_player/bloc/saved/saved_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../util.dart';
import '../widgets/listtile_db_book_item.dart';

class SavedPage extends StatefulWidget {
  const SavedPage({super.key});

  @override
  State<SavedPage> createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  @override
  void initState() {
    BlocProvider.of<SavedBloc>(context).add(LoadBooks());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedBloc, SavedState>(
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
                        height: MediaQuery.sizeOf(context).height * 0.8,
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
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.books.length,
                    separatorBuilder: (context, index) => const SizedBox(),
                    itemBuilder: (context, index) => ListTileBookItem(book: state.books[index]),
                  ),
        );
      },
    );
  }

  Future<void> _onRefresh() async {
    BlocProvider.of<SavedBloc>(context).add(LoadBooks());
  }
}
