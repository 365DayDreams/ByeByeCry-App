// To parse this JSON data, do
//
//     final homePageFavModel = homePageFavModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive/hive.dart';
part 'home_page_fav_model.g.dart';

HomePageFavModel homePageFavModelFromJson(String str) =>
    HomePageFavModel.fromJson(json.decode(str));

String homePageFavModelToJson(HomePageFavModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 1)
class HomePageFavModel extends HiveObject {
  HomePageFavModel({
    this.id,
    this.text,
  });
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? text;

  factory HomePageFavModel.fromJson(Map<String, dynamic> json) =>
      HomePageFavModel(
        id: json["id"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
      };
}
