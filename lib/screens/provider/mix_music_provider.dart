
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../local_db/local_db.dart';
import '../models/music_models.dart';

final mixMusicProvider = ChangeNotifierProvider((ref) => MixMusicProvider());

class MixMusicProvider extends ChangeNotifier{
  List<String> mixPlayListIds = [];
  MusicModel? musicModelFirst,musicModelSecond;
  List<MixMusicModel> combinationList = [];
  List<MixMusicModel> mixPlaylist = [];
  MixMusicModel? mixMusicModel;
  bool alertDiaLog = false;

  clearMixMusics(){
    musicModelFirst = null;
    musicModelSecond = null;
    notifyListeners();
  }
  mixFirstMusic(MusicModel firstMixMusicModel){
    musicModelFirst = firstMixMusicModel;
    notifyListeners();
  }
  mixSecondMusic(MusicModel secondMixMusicModel){
    musicModelSecond = secondMixMusicModel;
    notifyListeners();
  }
  createMix(MixMusicModel mixMusicModel)async{
    combinationList.add(mixMusicModel);
    await LocalDB.setMixMusicListItem(combinationList);
    print('added mix ${mixMusicModel.id}');
    /*int index = combinationList.indexWhere((element) => element.id == mixMusicModel.id);
    if(!mixPlayListIds.contains(mixMusicModel.id)) {
      if(index < 0) {
        combinationList.add(mixMusicModel);
      *//*  mixPlayListIds.add(mixMusicModel.id);
        await LocalDB.setMixPlayListItem(combinationList);*//*
        print('added mix ${mixMusicModel.id}');
      }
    }else {
      if(index >= 0) {
        combinationList.remove(mixMusicModel);
       *//* mixPlayListIds.remove(mixMusicModel.id);
        await LocalDB.setMixPlayListItem(combinationList);*//*
        print('remove');
      }
    }*/
  }
  assignMixAllPlaylist()async{
    mixPlaylist = await LocalDB.getMixPlayListItem()??[];
    mixPlayListIds = [];
    for(int index = 0; index < mixPlaylist.length;index++){
      mixPlayListIds.add(mixPlaylist[index].id);
    }
    notifyListeners();
  }
  assignMixMusicList()async{
    combinationList = await LocalDB.getMixMusicListItem()??[];
  }
  addOrRemoveMixPlayList({required String id})async{
    if(combinationList.isNotEmpty){
      int index = combinationList.indexWhere((element) => element.id == id);
      if(!mixPlayListIds.contains(id)) {
        if(index >= 0) {
          mixPlaylist.add(combinationList[index]);
          mixPlayListIds.add(id);
          await LocalDB.setMixPlayListItem(mixPlaylist);
          print('added mix musix');
        }
      }else {
        if(index >= 0) {
          mixPlaylist.remove(combinationList[index]);
          mixPlayListIds.remove(id);
          await LocalDB.setMixPlayListItem(mixPlaylist);
          print('remove mix music');
        }
      }
    }
    notifyListeners();
  }

  alertDialogStart(){
    alertDiaLog = true;
    notifyListeners();
  }
  alertDialogStop(){
    alertDiaLog = false;
    notifyListeners();
  }
}