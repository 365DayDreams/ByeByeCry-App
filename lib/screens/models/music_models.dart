import 'package:hive/hive.dart';
part 'music_models.g.dart';

class PlayListModel {
  String? title;
  String id;
  List<MixMusicModel>? playListList;

  PlayListModel({this.title, required this.id, this.playListList});

  factory PlayListModel.fromJson(Map<String, dynamic> json) {
    return PlayListModel(
      id: json['id'],
      title: json['title'],
      playListList: List<MixMusicModel>.from(
          json["playListList"].map((x) => MixMusicModel.fromJson(x))),
    );
  }
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "playListList":
            List<dynamic>.from(playListList!.map((x) => x.toJson())),
      };
}

class MixMusicModel {
  String id;
  MusicModel? first;
  MusicModel? second;
  MixMusicModel({this.first, this.second, required this.id});


  factory MixMusicModel.fromJson(Map<String, dynamic> json) {
    if( json['second']==null){
      return MixMusicModel(
        id: json['id'],
        first: MusicModel.fromJson(json['first']),
        // second:  MusicModel.fromJson(
        //   json['second'],
        // ),
      );
    }else {
      return MixMusicModel(
        id: json['id'],
        first: MusicModel.fromJson(json['first']),
        second: MusicModel.fromJson(
          json['second'],
        ),
      );
    }
  }
  Map<String, dynamic> toJson() => {"id": id, "first": first, "second": second};
}

@HiveType(typeId: 0)
class MusicModel extends HiveObject {
  @HiveField(0)
  final String musicName;
  @HiveField(1)
  final String musicFile;
  @HiveField(2)
  final String id;
  @HiveField(3)
  final String image;
  MusicModel(
      {required this.musicName,
      required this.musicFile,
      required this.id,
      required this.image});

  factory MusicModel.fromJson(Map<String, dynamic> json) {
    return MusicModel(
        musicName: json['musicName'],
        musicFile: json['musicFile'],
        id: json['id'],
        image: json['image']);
  }

  Map<String, dynamic> toJson() => {
        "musicName": musicName,
        "musicFile": musicFile,
        "id": id,
        "image": image
      };
}
