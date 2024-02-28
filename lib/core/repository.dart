

import 'package:audiobook_player/core/api_service.dart';
import 'package:audiobook_player/core/db_service.dart';
import 'package:audiobook_player/core/model/audiofile.dart';

import 'model/book.dart';

class AppRepository{
  final _apiList = [ApiService()];
  final _dbList = [DatabaseHelper()];

  Future<List<Book>> getApiBooks(int offset, int limit) async {
    List<Book> books;
    books = await _apiList[0].getBooks(offset, limit);
    return books;
  }

  Future<List<Book>> getDbBooks() async {
    List<Book> books;
    books = await _dbList[0].getBooks();
    return books;
  }
  
  Future<List<Book>> getTopBooks() async {
    List<Book> books;
    books = await _apiList[0].getTopBooks();
    return books;
  }

  Future<List<AudioFile>> getAudioFiles(String? bookId) async {
    List<AudioFile> audioFiles;
    audioFiles = await _dbList[0].getAudioFiles(bookId);
    if(audioFiles.isEmpty) {
      audioFiles = await _apiList[0].getAudioFiles(bookId);
      // dbList[0].saveAudioFiles(audioFiles);
    }
    return audioFiles;
  }

  Future<void> saveBook(Book book) async {
    _dbList[0].saveBook(book);
  }
}