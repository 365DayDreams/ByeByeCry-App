import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_text.dart';
import 'package:bye_bye_cry_new/screens/provider/add_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/mix_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/playlistProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../compoment/shared/custom_app_bar.dart';
import '../compoment/shared/custom_image.dart';
import '../compoment/shared/custom_svg.dart';
import '../compoment/shared/outline_button.dart';
import '../compoment/shared/screen_size.dart';
import '../compoment/utils/color_utils.dart';
import '../compoment/utils/image_link.dart';
import 'add_to_playlist.dart';
import 'my_playList_details_screen.dart';

class PlayListScreen extends ConsumerStatefulWidget {
  const PlayListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PlayListScreen> createState() => _PlayListScreenState();
}

class _PlayListScreenState extends ConsumerState<PlayListScreen> {

  TextEditingController searchController = TextEditingController();
  bool goMixPlayList = false;
  List<bool> fav = [false];

  bool deleteShow = false;


  List<String> times = [
    "0",
    "10 min",
    "30 min",
    "60 min",
    "90 min",
    "120 min",
    "150 min",
  ];
  List<int> selectedTimes = [0, 10, 30, 60, 90, 120, 150];
  AudioCache audioCache = AudioCache();
  AudioPlayer audioPlayer = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Duration _slider = Duration(seconds: 0);
  double currentVolume = 0.0;
  bool issongplaying = false;
  double brightness = 0.5;
  late StreamSubscription<double> _subscription;
  int index = 0;
  int selectedTime = 0;
  int setDuration = 0;
  bool check = false;
  bool playPouse = true;



  @override
  Widget build(BuildContext context) {
    final height = ScreenSize(context).height;
    return ref.watch(playlistProvider).goMixPlaylistScreen? AddToPlayListPage(
      onPressed: (){
        ref.read(playlistProvider).showMixPlayList(goMixPlaylist: false);
        if(mounted){
          setState(() {});
        }
      },
    ):
    Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   automaticallyImplyLeading: false,
      //   centerTitle: true,
      //   backgroundColor: primaryPinkColor,
      //   title: Text("My Playlist",style: TextStyle(
      //     fontSize: 22,color: Colors.black,
      //     fontWeight: FontWeight.w700
      //   ),),
      // ),
      appBar:  AppBar(
        actions: [
          InkWell(
            onTap: (){
              setState(() {
                deleteShow = !deleteShow;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18.0),
              child: Center(
                child: Text('Edit',style: TextStyle(
                    fontSize: 18,color: secondaryBlackColor,
                    fontWeight: FontWeight.bold
                ),),
              ),
            ),
          )
        ],
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryPinkColor,
        title: Text('My Playlist',style: TextStyle(
          fontSize: 22,color: secondaryBlackColor,
          fontWeight: FontWeight.bold
        ),)


        //actionTitle: 'Edit',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),

            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 20.0, right: 20, top: 10, bottom: 10),
            //   child: Container(
            //     height: 60,
            //     margin: const EdgeInsets.all(16),
            //     color: secondaryWhiteColor2,
            //     child: ListTile(
            //       dense: true,
            //       title: TextField(
            //         controller: searchController,
            //         decoration: const InputDecoration(
            //             hintStyle: TextStyle(color: blackColorA0,fontSize: 14,fontWeight: FontWeight.w400),
            //             hintText: 'Search music', border: InputBorder.none
            //         ),
            //       ),
            //       trailing: GestureDetector(onTap:(){},child: const CustomSvg(svg: "asset/images/search_icon.svg",)),
            //     ),
            //   ),
            // ),
          Column(
              children: List.generate(
                ref.watch(playlistProvider).mixMixPlaylist.length,
                    (index) => Container(
                    color: index % 2 == 0?Colors.transparent:pinkLightColor,
                    child: mixMixMusicList(musicName: "${ref.watch(playlistProvider).mixMixPlaylist[index].title}",musicId: ref.watch(playlistProvider).mixMixPlaylist[index].id,musicIndex: index, ),),
              ),
            ),
            Column(
              children: List.generate(
                ref.watch(addProvider).playList.length,
                (index) => Container(
                    color: index % 2 == 0?Colors.transparent:pinkLightColor,
                    child: musicList(musicName: ref.watch(addProvider).playList[index].musicName,musicId:  ref.watch(addProvider).playList[index].id,index: index,image:  ref.watch(addProvider).playList[index].image)),
              ),
            ),
            Column(
              children: List.generate(
                ref.watch(mixMusicProvider).mixPlaylist.length,
                    (index) => Container(
                    color: index % 2 == 0?Colors.transparent:pinkLightColor,
                    child: mixMusicList(musicName: "${ref.watch(mixMusicProvider).mixPlaylist[index].first?.musicName}+${ref.watch(mixMusicProvider).mixPlaylist[index].second?.musicName}",musicId:  ref.watch(mixMusicProvider).mixPlaylist[index].id,index: index,image: ref.watch(addProvider).playList[index].image),),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: (){
                ref.read(playlistProvider).showMixPlayList(goMixPlaylist:true);
                if(mounted){
                  setState(() {});
                }
              },
              child: Container(
                height: height * .07,
                color: pinkLightColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5),
                  child: Row(
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(
                          Icons.add,
                        ),
                        onPressed: () {},
                      ),
                      //SizedBox(width: height * .05),
                      const CustomText(
                        text: 'Add PlayList',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: blackColor2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget musicList({required String musicName,required String musicId,required int index,required String image}) {
    final height = ScreenSize(context).height;
    return InkWell(
      onTap: (){
        setFuck(){
          if(mounted){
            ref.read(playlistProvider).setMixPlaylistMusicId(setMixPlaylistId: musicId);
          }
          if(mounted){
            ref.read(addProvider).changePage(1);
          }
          if(mounted){
            ref.read(playlistProvider).changePlaying(change: true);
          }
        }

        Navigator.push(context, MaterialPageRoute(builder: (_)=> PlaylistMixSound2(
          playlistMixMusicId: musicId,
          onPressed: setFuck,

        )));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: height * .07,
                  width: height * .07,
                  decoration: const BoxDecoration(
                      color: primaryPinkColor,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Image.asset("${image}"),
                ),
                const SizedBox(width: 20),
                CustomText(
                  text: musicName,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),


            deleteShow==true? InkWell(
              onTap: (){
                _showDialogdelete(context, firstMusicName: musicName, secondMusicName: musicName, index22: index);
              },
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: CustomSvg(svg: deleteSvg),
              ),
            ):    Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.05),
                ),
                child:  Padding(
                  padding: EdgeInsets.all(15.0),
                  child: CustomImage(
                    scale: 0.8,
                    imageUrl: playButton,
                  ),
                )),
            // Row(
            //   children: [
            //     InkWell(
            //       onTap: (){
            //         _showDialog(context);
            //       },
            //       child: Row(
            //         children: [
            //           CustomSvg(
            //             svg: timer,
            //             color: blackColor2,
            //           ),
            //
            //           SizedBox(width: 5,),
            //
            //           Padding(
            //               padding: const EdgeInsets.only(top: 4.0),
            //               child: CustomText(
            //                   text:
            //                   "${(selectedTimes[selectedTime] ~/ 60).toString().padLeft(2, "0")} : ${(selectedTimes[selectedTime] % 60).toString().padLeft(2, "0")} min")
            //           )
            //         ],
            //       ),
            //     ),
            //     SizedBox(width: 20,),
            //     InkWell(
            //       onTap: (){
            //         _showDialogVolume(context);
            //       },
            //       child: Row(
            //         children: [
            //           CustomSvg(
            //             svg: volume,
            //             color: blackColor2,
            //           ),
            //
            //           SizedBox(width: 5,),
            //
            //           Padding(
            //             padding: const EdgeInsets.only(top: 4.0),
            //             child: Text("${currentVolume.toString().replaceAll("0.", "")}"),
            //           )
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
    // return Padding(
    //   padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 5),
    //   child: Row(
    //     //  crossAxisAlignment: CrossAxisAlignment.start,
    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //     children: [
    //       Row(
    //         children: [
    //           Container(
    //             height: height * .07,
    //             width: height * .07,
    //             decoration: const BoxDecoration(
    //                 color: primaryPinkColor,
    //                 borderRadius: BorderRadius.all(Radius.circular(10))),
    //           ),
    //           const SizedBox(width: 20),
    //           CustomText(
    //             text: musicName,
    //             fontSize: 18,
    //             fontWeight: FontWeight.w600,
    //           ),
    //         ],
    //       ),
    //       GestureDetector(
    //         onTap: (){
    //           if(mounted){
    //             ref.read(addProvider).setMusicId(normalMusicId: musicId);
    //           }
    //           if(mounted){
    //             ref.read(addProvider).changePage(1);
    //           }
    //           if(mounted){
    //             ref.read(addProvider).changePlay(change: true);
    //           }
    //           if(mounted){
    //             ref.read(addProvider).playFromPlaylistActive(change: true);
    //           }
    //         },
    //         child: Container(
    //           decoration: BoxDecoration(
    //               shape: BoxShape.circle,
    //               color: Colors.black.withOpacity(0.1)
    //           ),
    //           child: const Padding(
    //             padding: EdgeInsets.all(1.0),
    //             child: CustomImage(
    //               imageUrl: playButton,
    //               height: 30,
    //               width: 30,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
  Widget mixMusicList({required String musicName,required String musicId,required int index, required String image}) {
    final height = ScreenSize(context).height;
    return InkWell(
      onTap: (){
        setFuck(){
          if(mounted){
            ref.read(playlistProvider).setMixPlaylistMusicId(setMixPlaylistId: musicId);
          }
          if(mounted){
            ref.read(addProvider).changePage(1);
          }
          if(mounted){
            ref.read(playlistProvider).changePlaying(change: true);
          }
        }

        Navigator.push(context, MaterialPageRoute(builder: (_)=> PlaylistMixSound2(
          playlistMixMusicId: musicId,
          onPressed: setFuck,

        )));
      },
      child:
      Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: height * .07,
                  width: height * .07,
                  decoration: const BoxDecoration(
                      color: primaryPinkColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Image.asset('$image'),
                ),
                const SizedBox(width: 20),
                CustomText(
                  text: musicName,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            deleteShow==true? InkWell(
              onTap: (){
                _showDialogdelete(context, firstMusicName: musicName, secondMusicName: musicName, index22: index);
              },
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: CustomSvg(svg: deleteSvg),
              ),
            ):    Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.05),
                ),
                child:  Padding(
                  padding: EdgeInsets.all(15.0),
                  child: CustomImage(
                    scale: 0.8,
                    imageUrl: playButton,
                  ),
                )),
            // Row(
            //   children: [
            //     InkWell(
            //       onTap: (){
            //         _showDialog(context);
            //       },
            //       child: Row(
            //         children: [
            //           CustomSvg(
            //             svg: timer,
            //             color: blackColor2,
            //           ),
            //
            //           SizedBox(width: 5,),
            //
            //           Padding(
            //               padding: const EdgeInsets.only(top: 4.0),
            //               child: CustomText(
            //                   text:
            //                   "${(selectedTimes[selectedTime] ~/ 60).toString().padLeft(2, "0")} : ${(selectedTimes[selectedTime] % 60).toString().padLeft(2, "0")} min")
            //           )
            //         ],
            //       ),
            //     ),
            //     SizedBox(width: 20,),
            //     InkWell(
            //       onTap: (){
            //         _showDialogVolume(context);
            //       },
            //       child: Row(
            //         children: [
            //           CustomSvg(
            //             svg: volume,
            //             color: blackColor2,
            //           ),
            //
            //           SizedBox(width: 5,),
            //
            //           Padding(
            //             padding: const EdgeInsets.only(top: 4.0),
            //             child: Text("${currentVolume.toString().replaceAll("0.", "")}"),
            //           )
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
    // return InkWell(
    //   onTap: (){
    //     if(mounted){
    //       ref.read(mixMusicProvider).setMusicId(mixMusicId: musicId);
    //     }
    //     if(mounted){
    //       ref.read(addProvider).changePage(1);
    //     }
    //     if(mounted){
    //       ref.read(mixMusicProvider).changeMixPlay(change:true);
    //     }
    //     if(mounted){
    //       ref.read(mixMusicProvider).playFromPlayListActive(change:true);
    //     }
    //   },
    //   child: Padding(
    //     padding: const EdgeInsets.only(left: 20.0, right: 15, top: 5, bottom: 5),
    //     child: Row(
    //       //  crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //       children: [
    //         Row(
    //           children: [
    //             Container(
    //               height: height * .07,
    //               width: height * .07,
    //               decoration: const BoxDecoration(
    //                   color: primaryPinkColor,
    //                   borderRadius: BorderRadius.all(Radius.circular(10))),
    //             ),
    //             const SizedBox(width: 20),
    //             CustomText(
    //               text: musicName,
    //               fontSize: 18,
    //               fontWeight: FontWeight.w600,
    //             ),
    //           ],
    //         ),
    //         GestureDetector(
    //           onTap: (){
    //             setState(() {
    //               fav[index] = !fav[index];
    //             });
    //
    //
    //           },
    //           child: Container(
    //             decoration: BoxDecoration(
    //                 shape: BoxShape.circle,
    //             ),
    //             child:
    //             Padding(
    //                 padding: EdgeInsets.all(15.0),
    //                 child: !fav[index]
    //                     ? Icon(
    //                   Icons.favorite_border,
    //                   size: 35,
    //                   color: primaryPinkColor,
    //                 )
    //                     : Icon(
    //                   Icons.favorite,
    //                   size: 35,
    //                   color: primaryPinkColor,
    //                 )),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
  Widget mixMixMusicList({required String musicName,required String musicId,required int musicIndex}) {

    final height = ScreenSize(context).height;
    return InkWell(
      onTap: (){
        setFuck(){
          if(mounted){
            ref.read(playlistProvider).setMixPlaylistMusicId(setMixPlaylistId: musicId);
          }
          if(mounted){
            ref.read(addProvider).changePage(1);
          }
          if(mounted){
            ref.read(playlistProvider).changePlaying(change: true);
          }
        }

        Navigator.push(context, MaterialPageRoute(builder: (_)=> PlaylistMixSound2(
          playlistMixMusicId: musicId,
          onPressed: setFuck,

        )));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: height * .07,
                  width: height * .07,
                  decoration: const BoxDecoration(
                      color: primaryPinkColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  // child: Image.asset("${image}"),
                ),
                const SizedBox(width: 20),
                CustomText(
                  text: musicName,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),

        deleteShow==true? InkWell(
          onTap: (){
            _showDialogdelete(context, firstMusicName: musicName, secondMusicName: musicName, index22: musicIndex);
          },
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: CustomSvg(svg: deleteSvg),
          ),
        ):    Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.05),
              ),
              child:  Padding(
                padding: EdgeInsets.all(15.0),
                child: CustomImage(
                  scale: 0.8,
                  imageUrl: playButton,
                ),
              )),



            // Row(
            //   children: [
            //     InkWell(
            //       onTap: (){
            //         _showDialog(context);
            //       },
            //       child: Row(
            //         children: [
            //           CustomSvg(
            //             svg: timer,
            //             color: blackColor2,
            //           ),
            //
            //           SizedBox(width: 5,),
            //
            //           Padding(
            //             padding: const EdgeInsets.only(top: 4.0),
            //             child: CustomText(
            //                 text:
            //                 "${(selectedTimes[selectedTime] ~/ 60).toString().padLeft(2, "0")} : ${(selectedTimes[selectedTime] % 60).toString().padLeft(2, "0")} min")
            //           )
            //         ],
            //       ),
            //     ),
            //     SizedBox(width: 20,),
            //     InkWell(
            //       onTap: (){
            //         _showDialogVolume(context);
            //       },
            //       child: Row(
            //         children: [
            //           CustomSvg(
            //             svg: volume,
            //             color: blackColor2,
            //           ),
            //
            //           SizedBox(width: 5,),
            //
            //           Padding(
            //             padding: const EdgeInsets.only(top: 4.0),
            //             child: Text("${currentVolume.toString().replaceAll("0.", "")}"),
            //           )
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  void _showDialog(BuildContext context) {
    final height = ScreenSize(context).height;
    final width = ScreenSize(context).width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder:
              (BuildContext context, void Function(void Function()) state) {
            /* if(mounted) {
              //startTimer(state);
              if(mounted){
                state((){});
              }
            }*/
            return Align(
              alignment: Alignment.center,
              child: Wrap(
                children: [
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.white,
                    title: Padding(
                      padding: const EdgeInsets.only(left: 18.0, right: 18),
                      child: Column(
                        children: const [
                          CustomText(
                            text: 'Select Duration',
                            textAlign: TextAlign.center,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: primaryGreyColor,
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    content: Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 18),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: width * 0.27,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: greyEC,
                            ),
                            child: Center(
                                child: CustomText(
                                    text:
                                    "${(selectedTimes[selectedTime] ~/ 60).toString().padLeft(2, "0")} : ${(selectedTimes[selectedTime] % 60).toString().padLeft(2, "0")} min")),
                          ),
                          SliderTheme(
                            data: const SliderThemeData(
                                trackHeight: 5.0,
                                trackShape: RectangularSliderTrackShape(),
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 10)),
                            child: Slider.adaptive(
                                value: selectedTime.toDouble(),
                                min: 0,
                                max: 7,
                                divisions: 7,
                                activeColor: primaryPinkColor,
                                inactiveColor: primaryGreyColor2,
                                onChanged: (double newValue) async {
                                  state(() {
                                    setDuration = 1;
                                    selectedTime = check ? 0 : newValue.toInt();
                                    setDuration = selectedTimes[selectedTime];

                                    setDuration *= 60;
                                    setSongDuration(setDuration);
                                    print("index $selectedTime");
                                  });
                                  setState(() {});
                                },
                                semanticFormatterCallback: (double newValue) {
                                  return '${newValue.round()} dollars';
                                }),
                          ),
                          SizedBox(
                            width: width * 0.59,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(
                                  times.length,
                                      (index) => CustomText(
                                      text: times[index],
                                      fontWeight: FontWeight.w400,
                                      fontSize: 8,
                                      color: secondaryBlackColor)),
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.start,
                    actionsPadding: const EdgeInsets.only(left: 48, bottom: 30),
                    actions: <Widget>[
                      Row(
                        children: [
                          Checkbox(
                              side: const BorderSide(color: blackColorA0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              activeColor: primaryPinkColor,
                              value: check,
                              onChanged: (newValue) {
                                state(() {
                                  check = newValue!;
                                  if (check) {
                                    selectedTime = 0;
                                  }
                                });
                              }),
                          TextButton(
                              onPressed: check
                                  ? () async {
                                if (mounted) {
                                  Navigator.pop(context);
                                }
                              }
                                  : null,
                              child: const CustomText(
                                text: "continuous play",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: primaryGreyColor,
                              )),



                        ],
                      ),
                      SizedBox(height: 6,),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 38.0),
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 200,
                              decoration: BoxDecoration(
                                  color: primaryPinkColor,
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              child: Text("OK",style: TextStyle(
                                  fontSize: 18,fontWeight: FontWeight.bold
                              ),),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      if (mounted) {
        ref.read(mixMusicProvider).alertDialogStop();
        if (mounted) {
          setState(() {
            print("asche");
          });
        }
      }
    });
  }

  String getHumanTimeBySecond(int seconds) {
    int hours = (seconds / 3600).floor();
    int minutes = ((seconds - (hours * 3600)) / 60).floor();
    int secs = seconds - (hours * 3600) - (minutes * 60);

    String hoursStr = (hours < 10) ? "0$hours" : hours.toString();
    String minutesStr = (minutes < 10) ? "0$minutes" : minutes.toString();
    String secondsStr = (secs < 10) ? "0$secs" : secs.toString();

    return "$hoursStr:$minutesStr:$secondsStr";
  }

  var sliderInitial = 0.0;
  var sliderEnd = 120.0;

  Timer? sliderTimer;

  void setSongDuration(int setDuration, {double initValue = 0}) {
    sliderInitial = initValue;
    sliderEnd = setDuration.toDouble();
    if (sliderTimer != null) {
      sliderTimer!.cancel();
    }
    sliderTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
      }

      if (sliderEnd <= sliderInitial) {
        timer.cancel();
        sliderInitial = 0.0;
        audioPlayer.stop();
      }
      sliderInitial++;
      setState(() {});
    });
  }

  void updateSlider(double newValue) {
    sliderInitial = newValue;
    setState(() {});
  }

  void pauseSliderTimmer() {
    print("=========${sliderTimer!.isActive}");
    print("=========");
    sliderTimer!.cancel();
  }

  void resumeSliderTimmer() {
    setSongDuration(sliderEnd.toInt(), initValue: sliderInitial);
  }
  void _showDialogVolume(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final width = ScreenSize(context).width;
        return StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) updateState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Transform(
                  transform: Matrix4.identity()..rotateZ(-90 * 3.1415927 / 180),
                  child: AlertDialog(
                    alignment: Alignment.centerLeft,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    backgroundColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    content: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 15, right: 0, bottom: 0),
                                child: Transform(
                                  alignment: Alignment.topCenter,
                                  transform: Matrix4.identity()
                                    ..rotateZ(90 * 3.1415927 / 180),
                                  child: const CustomSvg(
                                    svg: volume,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Slider(
                                  value: currentVolume,
                                  min: 0.0,
                                  max: 1.0,
                                  divisions: 100,
                                  activeColor: primaryPinkColor,
                                  inactiveColor: primaryGreyColor2,
                                  onChanged: (double newValue) async {
                                    updateState(() {
                                      // Screen.setBrightness(newValue);
                                      currentVolume = newValue;
                                      print("volume $currentVolume");
                                    });
                                    await audioPlayer.setVolume(
                                        currentVolume);

                                  },
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                              right: width * 0.25,
                              top: 10,
                              child: Transform(
                                  transform: Matrix4.identity()
                                    ..rotateZ(90 * 3.1415927 / 180),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(2),
                                        boxShadow: [
                                          BoxShadow(
                                              color: secondaryBlackColor
                                                  .withOpacity(0.2),
                                              blurRadius: 0.2,
                                              spreadRadius: 0.5)
                                        ]),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 5),
                                      child: Center(
                                          child: CustomText(
                                            text:
                                            "${(currentVolume * 100).toInt().toString().padLeft(2, "0")}%",
                                            fontSize: 10,
                                            color: secondaryBlackColor,
                                            fontWeight: FontWeight.w600,
                                          )),
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDialogdelete(BuildContext context,
      {required String firstMusicName,
        required String secondMusicName,
        required int index22}) {
    final width = ScreenSize(context).width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: Wrap(
            children: [
              AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                backgroundColor: Colors.white,
                title: const CustomText(
                  text: 'You ave removed',
                  textAlign: TextAlign.center,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: secondaryBlackColor,
                ),
                content: Column(
                  children: [
                    CustomText(
                      text: '$firstMusicName',
                      fontSize: 18,
                      color: primaryGreyColor,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(
                      height: 13,
                    ),
                    const CustomText(
                      text: 'from Sound List',
                      fontSize: 20,
                      color: secondaryBlackColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                actionsAlignment: MainAxisAlignment.center,
                actionsPadding: const EdgeInsets.only(bottom: 20),
                actions: <Widget>[
                  OutLineButton(
                    height: width * .08,
                    width: width * .16,
                    text: 'Ok',
                    textColor: primaryGreyColor,
                    textFontSize: 20,
                    textFontWeight: FontWeight.w600,
                    borderRadius: 48,
                    onPressed: () {
                      ref.watch(playlistProvider).mixMixPlaylist.removeAt(index22);
                      // ref.read(mixMusicProvider).deleteMix(mixId: mixId);

                        Navigator.pop(context);
                        setState(() {

                        });

                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
