import 'package:bye_bye_cry_new/local_db/local_db.dart';
import 'package:get/get.dart';

class AppData{
  static final AppData _singleton = AppData._internal();

  factory AppData() {
   
    return _singleton;
  }

  AppData._internal(){
    getMusicTitle();
  }
  
  static String titleCurrentMusic="";
  static String typeCurrentMusic="";
  static String idCurrentMusic="";
  static int? musicIndexData;
  static RxBool isPlaying=false.obs;

  Future<Map<String, dynamic>> getMusicTitle() async{
   var data= await LocalDB.getCurrentPlayingMusic();
   titleCurrentMusic=data["title"];
   typeCurrentMusic=data["type"];
   idCurrentMusic=data["id"];
   try {
     musicIndexData=data["musicIndex"];
   } catch (e) {
     // TODO
   }
   print(data);
  return data;
  }


}