import 'package:audiobook_player/pages/home_page.dart';
import 'package:audiobook_player/pages/saved_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _selectedIndex = 0;

  final _pages = [const HomePage(),/* const SearchPage(),*/ const SavedPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.97),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Image.asset('assets/images/logo.png', fit: BoxFit.fitHeight),
        ),
        title: const Text.rich(TextSpan(children: [
          TextSpan(text: 'Audio', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700)),
          TextSpan(text: 'Books', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w300)),
        ])),
      ),
      bottomNavigationBar: NavigationBar(
        height: 65,
        indicatorColor: Colors.grey.shade200,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        indicatorShape: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        onDestinationSelected: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        selectedIndex: _selectedIndex,
        destinations: const [
          NavigationDestination(icon: Icon(CupertinoIcons.house), label: 'Home'),
          // NavigationDestination(icon: Icon(CupertinoIcons.search), label: 'Search'),
          NavigationDestination(icon: Icon(CupertinoIcons.bookmark), label: 'Saved'),
        ],
      ),
      // body: _pages[_selectedIndex],
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
    );
  }
}
