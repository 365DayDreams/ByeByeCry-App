import 'package:bye_bye_cry_new/local_db/local_db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../compoment/utils/image_link.dart';
import '../models/music_models.dart';

final addProvider = ChangeNotifierProvider((ref) => AddMusicProvider());

class AddMusicProvider extends ChangeNotifier {
  List<String> nameList = [];
  List<String> playListIds = [];
  List<MusicModel> musicList = [];
  bool homePage = true;
  List<MusicModel> playList = [];
  int pageNumber = 0;
  bool showAddPlaylist = false;
  String musicId = "";
  bool changeToPlayNow = false;
  bool playFromPlayList = false;

  playFromPlaylistActive({bool change = false}){
    playFromPlayList = change;
    notifyListeners();
  }
  setMusicId({String normalMusicId = ''}){
    musicId = normalMusicId;
    notifyListeners();
  }
  changePlay({bool change = false}){
    changeToPlayNow = change;
    notifyListeners();
  }
  showPlusPlaylist({bool playlistPlusBottom = false,}){
    showAddPlaylist = playlistPlusBottom;
    notifyListeners();
  }
  addMusic(){

    musicList.add(MusicModel(musicName: 'Blender', musicFile: "babyCry/Blender.wav", id: '1', image: Blender));
    musicList.add(MusicModel(musicName: "Brown noise", musicFile: "babyCry/Brownnoise.wav", id: "2", image: BrwonNoise));
    musicList.add(MusicModel(musicName: "Chainsaw", musicFile: "babyCry/Chainsaw.wav", id: '3', image: Chainsawww));
    musicList.add(MusicModel(musicName: "Classical", musicFile: "babyCry/Classical.wav", id: "4", image: ClassiCal));
    musicList.add(MusicModel(musicName: 'Dryer', musicFile: "babyCry/Dryer.wav", id: "5", image: Dryer));
    musicList.add(MusicModel(musicName: "Fan", musicFile: "babyCry/Fan.wav", id: "6", image: FAN));
    musicList.add(MusicModel(musicName: 'Garbage disposal', musicFile: "babyCry/Garbagedisposal.wav", id: '7', image: Garbage));
    musicList.add(MusicModel(musicName: 'Hair dryer', musicFile: "babyCry/Hairdryer.wav", id: '8', image: HAirDryer));
    musicList.add(MusicModel(musicName: "Jackhammer", musicFile: "babyCry/Jackhammer.wav", id: "9", image: JackMmer));
    musicList.add(MusicModel(musicName: "Lawn Mower", musicFile: "babyCry/LawnMower.wav", id: "10", image: LawnMower));
    musicList.add(MusicModel(musicName: "Leaf Blowerr", musicFile: "babyCry/LeafBlower.wav", id: "11", image: LeafBlower));
    musicList.add(MusicModel(musicName: "Ocean", musicFile: "babyCry/Ocean.wav", id: "12", image: Ocean));
    musicList.add(MusicModel(musicName: "Pink noise", musicFile: "babyCry/Pinknoise.wav", id: "13", image: PinkNoise));
    musicList.add(MusicModel(musicName: "Rain", musicFile: "babyCry/Rain.wav", id: "14", image: Rain));
    musicList.add(MusicModel(musicName: "Shop vac", musicFile: "babyCry/Shopvac.wav", id: "15", image: ShopVac));
    musicList.add(MusicModel(musicName: "Sushing", musicFile: "babyCry/Sushing.wav", id: "16", image: SuShing));
    musicList.add(MusicModel(musicName: "Vacuum", musicFile: "babyCry/Vacuum.wav", id: "17", image: Vaccum));
    musicList.add(MusicModel(musicName: "Vacuum Moving", musicFile: "babyCry/VacuumMoving.wav", id: "18", image: VacuumMoving));
    musicList.add(MusicModel(musicName: "Washer", musicFile: "babyCry/Washer.wav", id: "19", image: Washer));
    musicList.add(MusicModel(musicName: "Weedwacker", musicFile: "babyCry/Weedwacker.wav", id: "20", image: WeedWacker));
    musicList.add(MusicModel(musicName: "White noise", musicFile: "babyCry/Whitenoise.wav", id: "21", image: WhiteNoise));

    print("music add ${musicList.length}");
    notifyListeners();
  }
  changeHomePage(){
    homePage = false;
    notifyListeners();
  }
  changePage(int pageNum){
    pageNumber = pageNum;
    notifyListeners();
  }
  assignAllPlaylist()async{
    playList = await LocalDB.getPlayListItem() ?? [];
    playListIds = [];
    for(int index = 0; index < playList.length;index++){
      playListIds.add(playList[index].id);
    }
    notifyListeners();
  }
  addOrRemovePlayList({required String id})async{
    if(musicList.isNotEmpty){
      int index = musicList.indexWhere((element) => element.id == id);
      if(!playListIds.contains(id)) {
        if(index >= 0) {
          playList.add(musicList[index]);
          playListIds.add(id);
          await LocalDB.setPlayListItem(playList);
          print('added');
        }
      }else {
        if(index >= 0) {
          playList.remove(musicList[index]);
          playListIds.remove(id);
          await LocalDB.setPlayListItem(playList);
          print('remove');
        }
      }
    }
    notifyListeners();
  }
}
