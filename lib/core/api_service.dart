
import 'package:dio/dio.dart';

import 'model/audiofile.dart';
import 'model/book.dart';

const _metadata = "https://archive.org/metadata/";
const _commonParams = "q=collection:(librivoxaudio)&fl=runtime,avg_rating,num_reviews,title,description,identifier,creator,date,downloads,subject,item_size";

const _latestBooksApi = "https://archive.org/advancedsearch.php?$_commonParams&sort[]=addeddate desc&output=json";

const _mostDownloaded = "https://archive.org/advancedsearch.php?$_commonParams&sort[]=downloads desc&rows=10&page=10&output=json";

class ApiService{
  final dio = Dio();

  Future<List<Book>> getBooks(int offset, int limit) async {
    final response = await dio.get('$_latestBooksApi&rows=$limit&page=${offset/limit + 1}');
    return Book.fromJsonArray(response.data['response']['docs']);
  }

  Future<List<Book>> getTopBooks() async {
    final response = await dio.get(_mostDownloaded);
    return Book.fromJsonArray(response.data['response']['docs']);
  }

  Future<List<AudioFile>> getAudioFiles(String? bookId) async {
    final response = await dio.get("$_metadata/$bookId/files");
    List<AudioFile> files = [];
    response.data["result"].forEach((item) {
      if(item["source"] == "original" && item["track"] != null) {
        item["book_id"] = bookId;
        files.add(AudioFile.fromJson(item));
      }
    });
    return files;
  }

}