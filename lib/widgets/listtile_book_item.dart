import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/model/book.dart';
import '../pages/detail_page.dart';

class ListTileBookItem extends StatelessWidget {
  const ListTileBookItem({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Hero(
            tag: '${book.id}_image',
            child: Container(
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                    image: CachedNetworkImageProvider(book.image), fit: BoxFit.cover),
              ),
            ),
          ),
          title: Text(book.title),
          subtitle: Text(book.author!),
          onTap: () {
            Navigator.push(context, CupertinoPageRoute(builder: (context) => DetailPage(book: book)));
          },
        ),
        const Divider()
      ],
    );
  }
}
