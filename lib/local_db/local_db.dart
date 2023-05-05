import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/models/music_models.dart';

class LocalDB {
  static setMixMusicListItem(List<MixMusicModel> mixMusicList) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString("mixMusicList", jsonEncode(mixMusicList));
  }

  static setCurrentPlayingMusic({required title,
    required type,
    required id,
    int songIndex=0,
    isPlaying = true}) async {
    // music title, type, isplaying,
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("currentPlaying", jsonEncode({
      "title":  title,
      "type":type,
      "id":id,
      "musicIndex":songIndex,
    "isPlaying": isPlaying
    }));
  }
  static Future<Map<String, dynamic>> getCurrentPlayingMusic() async {
    // music title, type, isplaying,
    final prefs = await SharedPreferences.getInstance();
    var data=prefs.getString("currentPlaying")??"";
    try {
      Map<String, dynamic> map= jsonDecode(data);
      return map;
    }  catch (e) {
      return {};
    }

  }

  static Future<List<MixMusicModel>?> getMixMusicListItem() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      if (prefs.containsKey("mixMusicList")) {
        List<dynamic> jsonData =
            jsonDecode(prefs.getString("mixMusicList") ?? "[]");
        List<MixMusicModel> realData =
            jsonData.map((e) => MixMusicModel.fromJson(e)).toList();
        return realData;
      }
    }  catch (e) {
      // TODO
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

  // setAccessToken(bool accessToken) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setBool("access_token", accessToken);
  // }
  //
  // Future getAccessToken() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   bool? token = prefs.getBool("access_token");
  //   return token ?? false;
  // }

  setTimer(String timer) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("timer", timer);
  }

  Future getTimer() async {
    final prefs = await SharedPreferences.getInstance();
    String? timer = prefs.getString("timer");
    return timer ?? "";
  }

  setTimer2(String timer) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("timer2", timer);
  }

  Future getTimer2() async {
    final prefs = await SharedPreferences.getInstance();
    String? timer = prefs.getString("timer2");
    return timer ?? "";
  }

  setTimer3(String timer) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("timer3", timer);
  }

  Future getTimer3() async {
    final prefs = await SharedPreferences.getInstance();
    String? timer = prefs.getString("timer3");
    return timer ?? "";
  }

  setVolume(String timer) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("vol", timer);
  }

  Future getVolume() async {
    final prefs = await SharedPreferences.getInstance();
    String? timer = prefs.getString("vol");
    return timer ?? "";
  }

  setVolume2(String timer) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("vol2", timer);
  }

  Future getVolume2() async {
    final prefs = await SharedPreferences.getInstance();
    String? timer = prefs.getString("vol2");
    return timer ?? "";
  }

  setVolume3(String timer) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("vol3", timer);
  }

  Future getVolume3() async {
    final prefs = await SharedPreferences.getInstance();
    String? timer = prefs.getString("vol3");
    return timer ?? "";
  }
}
