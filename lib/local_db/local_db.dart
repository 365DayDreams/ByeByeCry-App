import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/models/music_models.dart';

class LocalDB {
  static setMixMusicListItem(List<MixMusicModel> mixMusicList) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("mixMusicList")) {
      prefs.remove("mixMusicList");
    }
    prefs.setString("mixMusicList", jsonEncode(mixMusicList));
  }

  static Future<List<MixMusicModel>?> getMixMusicListItem() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("mixMusicList")) {
      List<dynamic> jsonData =
          jsonDecode(prefs.getString("mixMusicList") ?? "[]");
      List<MixMusicModel> realData =
          jsonData.map((e) => MixMusicModel.fromJson(e)).toList();
      return realData;
    }
    return null;
  }

  static setMixPlayListItem(List<MixMusicModel> mixMusicList) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("mixPlayList")) {
      prefs.remove("mixPlayList");
    }
    prefs.setString("mixPlayList", jsonEncode(mixMusicList));
  }

  static Future<List<MixMusicModel>?> getMixPlayListItem() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("mixPlayList")) {
      List<dynamic> jsonData =
          jsonDecode(prefs.getString("mixPlayList") ?? "[]");
      List<MixMusicModel> realData =
          jsonData.map((e) => MixMusicModel.fromJson(e)).toList();
      return realData;
    }
    return null;
  }

  static setPlayListItem(List<MusicModel> musicPlayList) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("playList")) {
      prefs.remove("playList");
    }
    prefs.setString(
        "playList", jsonEncode(musicPlayList.map((e) => e.toJson()).toList()));
  }

  static Future<List<MusicModel>?> getPlayListItem() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("playList")) {
      List<dynamic> jsonData = jsonDecode(prefs.getString("playList") ?? "[]");
      List<MusicModel> realData =
          jsonData.map((e) => MusicModel.fromJson(e)).toList();
      return realData;
    }
    return null;
  }

  static setMixPlayList(List<PlayListModel> playListModel) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("listMixPlayList")) {
      prefs.remove("listMixPlayList");
    }
    prefs.setString("listMixPlayList",
        jsonEncode(playListModel.map((e) => e.toJson()).toList()));
    print("added ${playListModel.length}");
  }

  static Future<List<PlayListModel>?> getMixPlayList() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("listMixPlayList")) {
      List<dynamic> jsonData =
          jsonDecode(prefs.getString("listMixPlayList") ?? "[]");
      List<PlayListModel> realData =
          jsonData.map((e) => PlayListModel.fromJson(e)).toList();
      return realData;
    }
    return null;
  }

  //PlayListModel

  setAccessToken(bool accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("access_token", accessToken);
  }

  Future getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    bool? token = prefs.getBool("access_token");
    return token ?? false;
  }
}
