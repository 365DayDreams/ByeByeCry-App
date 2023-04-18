import 'package:audioplayers/audioplayers.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_image.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_svg.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_text.dart';
import 'package:bye_bye_cry_new/compoment/shared/screen_size.dart';
import 'package:bye_bye_cry_new/local_db/wishList_controller.dart';
import 'package:bye_bye_cry_new/screens/provider/add_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/mix_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/playlistProvider.dart';
import 'package:bye_bye_cry_new/sounds_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../compoment/shared/custom_app_bar.dart';
import '../compoment/shared/outline_button.dart';
import '../compoment/utils/color_utils.dart';
import '../compoment/utils/image_link.dart';
import 'package:get/get.dart';

import '../screens/models/music_models.dart';

class MyPlayListNewSoundScreen extends ConsumerStatefulWidget {
  const MyPlayListNewSoundScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<MyPlayListNewSoundScreen> createState() => _MyPlayListNewSoundScreenState();
}

class _MyPlayListNewSoundScreenState extends ConsumerState<MyPlayListNewSoundScreen> {
  TextEditingController searchController = TextEditingController();
  bool changeToPlayNow = false;
  bool changeToMixPlayNow = false;
  bool changeToMixPlayListNow = false;
  AudioPlayer audioPlayer = AudioPlayer();


  MusicModel? music;
  String mixMusicId = '';
  String mixPlaylistMixMusicId = '';
  AudioCache audioCache = AudioCache();
  final WishListController wishListController = Get.put(WishListController());
  playMusic({required String id}) async{
    print("playlist play button click");
    int _index = ref.watch(addProvider).musicList.indexWhere((element) => element.id == id);
    if(_index >= 0){
      if(_index == index){
        if(issongplaying){
          await audioPlayer.pause();
        }else{
          String url = ref.watch(addProvider).musicList[index].musicFile;
          await audioPlayer.play(AssetSource(url));
        }
      }else{
        index = _index;
        String url = ref.watch(addProvider).musicList[index].musicFile;
        await audioPlayer.play(AssetSource(url));
      }
    }
    if(mounted){
      setState(() {});
    }
  }

  startPlayer()async{
    audioPlayer.onPlayerStateChanged.listen((state) {
      issongplaying = state == PlayerState.playing;
      if(mounted){
        setState((){});
      }
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      if(mounted){
        setState(() {});
      }
    });
    audioPlayer.onPositionChanged.listen((newPositions) {
      if(mounted){
        setState(() {});
      }
    });
    if(mounted){
      setState(() {});
    }
  }
  pausePlayMethod()async{
    if(issongplaying){
      await audioPlayer.pause();
      print("pause");
    }else{
      String url = ref.watch(addProvider).musicList[index].musicFile;
      await audioPlayer.play(AssetSource(url));
      print("play");
    }
    if(mounted){
      setState(() {});
    }
  }


  bool issongplaying = false;
  int index = 0;
  String musicId = "";
  bool deleteShow = false;
  List<bool> fav = [false];
  bool fav2 = false;

  List<String> imageUrl = [
    chainsaw,
    vaccum,
    jackhammer,
    blowdryer,
    lawnmower,
    washer,
    ocean,
    dummy,
    dummy,
    dummy,
  ];
  List<String> textUrl = [
    'Chainshaw',
    'Vaccum',
    'Jackhammer',
    'Blowdryer',
    'Lawnmower',
    'Washer',
    'Ocean',
    'Ocean + Rain',
    'Lawnmower + Ocean',
    'Mix Two Sounds'
  ];

  @override
  void dispose() {
    //audioPlayer.dispose();
    super.dispose();
  }

  String? searchval;

  @override
  void initState() {
    startPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CustomAppBar(

          title:  'Add Sounds',
          onPressed: () {
            Navigator.pop(context);
          }),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Column(
                children: List.generate(
                  ref.watch(addProvider).musicList.isEmpty
                      ? 0
                      : ref.watch(addProvider).musicList.length,
                      (index) {
                    return Column(
                      children: [
                        Container(
                          color: index % 2 == 0
                              ? Colors.transparent
                              : pinkLightColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15.0),
                            child: imageList(
                              context: context,
                              musicModel: ref
                                  .watch(addProvider)
                                  .musicList[index],
                              musicIndex: index,
                              search: searchval,
                            ),
                          ),
                        ), // const SizedBox(height: 5,)
                      ],
                    );
                  },
                )), // ref.watch(addProvider).showAddPlaylist?


          ],
        ),
      ),
    );
  }

  Widget imageList(
      {required MusicModel musicModel,
        required BuildContext context,
        required int musicIndex,
        String? search}) {


    return     Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  "${musicModel.image}",
                  height: 60,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: CustomText(
                  text: musicModel.musicName,
                  color: blackColor50,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () async {
                  musicId = musicModel.id;
                  if (mounted) {
                    playMusic(id: musicId);
                  }
                  print("OK");
                },
                child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.05),
                    ),
                    child:  musicId == musicModel.id
                        ? Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: issongplaying
                          ? const CustomSvg(
                        svg: pouseButton,
                        color: blackColor97,
                        height: 12,
                        width: 12,
                      )
                          : const CustomImage(
                        imageUrl: playButton,
                        scale: 0.8,
                      ),
                    )
                        : const Padding(
                      padding: EdgeInsets.all(15.0),
                      child: CustomImage(
                        scale: 0.8,
                        imageUrl: playButton,
                      ),
                    )

                ),
              ),
              GestureDetector(
                onTap: () async {
                  await audioPlayer.pause();
                  Navigator.pop(context);
                  if (ref
                      .watch(playlistProvider)
                      .addInPlayListTrueFalse) {
                    if (mounted) {
                      ref
                          .read(playlistProvider)
                          .showMixPlayList(
                          goMixPlaylist: true);
                      //Change.
                      ref.read(addProvider).showAddPlaylist=false;
                    }
                    if (mounted) {
                      ref.read(playlistProvider).setMusic(
                          setMusicModel: musicModel);
                    }
                    if (mounted) {
                      ref
                          .read(playlistProvider)
                          .addInPlaylistFalse();
                    }
                  } else {



                    Navigator.pop(context);

                    //  ref.read(addProvider).changePage(2);
                    if (ref
                        .read(mixMusicProvider)
                        .selectMixSound) {
                      ref
                          .read(mixMusicProvider)
                          .mixFirstMusic(musicModel);
                    } else {
                      ref
                          .read(mixMusicProvider)
                          .mixSecondMusic(musicModel);
                    }
                    ref.read(addProvider).showPlusPlaylist(
                        playlistPlusBottom: false);
                    //Change...
                    ref.read(addProvider).showAddPlaylist=false;
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.1)),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Icon(
                        Icons.add,
                        color: blackColorA0,
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
        ),
      ],
    );
  }



}
