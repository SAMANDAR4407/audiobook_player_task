
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/model/book.dart';

class BookItem extends StatelessWidget {
  const BookItem({
    super.key,
    required this.book, required this.onTap,
  });

  final Function() onTap;
  final Book book;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Hero(
            tag: '${book.id}_image',
            child: Container(
              height: MediaQuery.sizeOf(context).height*0.25,
              width: MediaQuery.sizeOf(context).height*0.25,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(book.image),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          Container(
            height: MediaQuery.sizeOf(context).height*0.25,
            width: MediaQuery.sizeOf(context).height*0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                colors: [Colors.transparent, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: MediaQuery.sizeOf(context).width*0.4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    book.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    book.author ?? 'no author',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
