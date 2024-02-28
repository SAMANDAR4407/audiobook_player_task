import 'package:shared_preferences/shared_preferences.dart';

class PrefHelper {
  SharedPreferences? prefs;

  Future<void> setLastPosition(int pos) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs?.setInt('audioPosition', pos);
  }

  Future<int> getLastPosition() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs?.getInt('audioPosition') ?? 0;
  }

  Future<String> getLastBook() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs?.getString('lastBook') ?? '';
  }

  Future<void> setLastBook(String book) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs?.setString('lastBook', book);
  }

  Future<int> getAudioIndex() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs?.getInt('audioIndex') ?? 0;
  }

  Future<void> setAudioIndex(int index) async {
    prefs ??= await SharedPreferences.getInstance();
    await prefs?.setInt('audioIndex', index);
  }

}