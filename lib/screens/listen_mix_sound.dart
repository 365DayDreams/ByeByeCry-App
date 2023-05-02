// import 'dart:async';
// import 'package:bye_bye_cry_new/compoment/shared/custom_image.dart';
// import 'package:bye_bye_cry_new/compoment/shared/custom_svg.dart';
// import 'package:bye_bye_cry_new/screens/models/music_models.dart';
// import 'package:bye_bye_cry_new/screens/provider/mix_music_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screen_wake/flutter_screen_wake.dart';
// import 'package:perfect_volume_control/perfect_volume_control.dart';
// import 'package:screen_brightness/screen_brightness.dart';
// import '../compoment/shared/custom_app_bar.dart';
// import '../compoment/shared/custom_text.dart';
// import '../compoment/shared/screen_size.dart';
// import '../compoment/utils/color_utils.dart';
// import '../compoment/utils/image_link.dart';
// import '../main.dart';
// import 'my_playList_details_screen.dart';
//
// class ListenMixSound extends ConsumerStatefulWidget {
//   final String? mixMusicModelId;
//   final VoidCallback? onPressed;
//   const ListenMixSound(
//       {Key? key, required this.mixMusicModelId, this.onPressed})
//       : super(key: key);
//
//   @override
//   ConsumerState<ListenMixSound> createState() => _ListenMixSoundState();
// }
//
// class _ListenMixSoundState extends ConsumerState<ListenMixSound>
//     with TickerProviderStateMixin {
//   List<String> times = [
//     "0",
//     "10 min",
//     "30 min",
//     "60 min",
//     "90 min",
//     "120 min",
//     "150 min",
//   ];
//   List<int> selectedTimes = [0, 10, 30, 60, 90, 120, 150];
//   PageController pageController = PageController();
//
//   int selectedTime = 0;
//   bool playPouse = true;
//   int setDuration = 0;
//   // AudioCache audioCache = AudioCache();
//   // AudioPlayer audioPlayer1 = AudioPlayer();
//   // AudioPlayer audioPlayer2 = AudioPlayer();
//   Duration _duration = Duration.zero;
//   Duration _position = Duration.zero;
//   Duration _duration2 = Duration.zero;
//   Duration _position2 = Duration.zero;
//   Duration position = Duration.zero;
//   Duration duration = Duration.zero;
//   double currentVolume = 40.0;
//   bool issongplaying1 = false;
//   bool issongplaying2 = false;
//   double brightness = 0.5;
//   late StreamSubscription<double> _subscription;
//   int musicIndex = 0;
//   List<MusicModel> musicList = [];
//   int index = 0;
//   bool check = true;
//   TextEditingController minController = TextEditingController();
//   TextEditingController secController = TextEditingController();
//
//   @override
//   void initState() {
//     //.//audioPlayer1.dispose();
//     // startPlayer1();
//     // startPlayer2();
//
//     //brightNess();
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       Timer.periodic(Duration(seconds: 1), (timer) async {
//         print(_position);
//         if (sliderInitial.toInt() == (sliderEnd - 1).toInt()) {
//           if (check == false) {
//             pageController.nextPage(
//                 duration: Duration(milliseconds: 100), curve: Curves.linear);
//
//             sliderInitial = 0.0;
//             sliderEnd = 120.0;
//             selectedTime = 0;
//             setDuration = 0;
//             check=true;
//             changeIndex(changeIndex: true);
//
//             if (mounted) {
//               // String url = ref
//               //     .watch(addProvider)
//               //     .musicList[index]
//               //     .musicFile;
//               String url1 = ref
//                   .watch(mixMusicProvider)
//                   .combinationList[index]
//                   .first!
//                   .musicFile;
//               String url2 = ref
//                   .watch(mixMusicProvider)
//                   .combinationList[index]
//                   .first!
//                   .musicFile;
//               // await audioPlayer1.play(AssetSource(url1));
//               await ins.playAudio(Duration(minutes: 2), "assets/" + url1);
//               // await audioPlayer2.play(AssetSource(url2));
//               await ins.playAudio(Duration(minutes: 2), "assets/" + url2);
//               // sliderInitial=0.0;
//             }
//
//             if (mounted) {
//               setState(() {});
//             }
//           } else {
//             ins.stop();
//             if (mounted) {
//               // String url = ref
//               //     .watch(addProvider)
//               //     .musicList[index]
//               //     .musicFile;
//               sliderInitial = 0.0;
//               sliderEnd = 120.0;
//               selectedTime = 0;
//               setDuration = 0;
//               check=true;
//               String url1 = ref
//                   .watch(mixMusicProvider)
//                   .combinationList[index]
//                   .first!
//                   .musicFile;
//               String url2 = ref
//                   .watch(mixMusicProvider)
//                   .combinationList[index]
//                   .first!
//                   .musicFile;
//               // await audioPlayer1.play(AssetSource(url1));
//               await ins.playAudio(Duration(minutes: 2), "assets/" + url1);
//               // await audioPlayer2.play(AssetSource(url2));
//               await ins.playAudio(Duration(minutes: 2), "assets/" + url2);
//             }
//           }
//           if (!mounted) {
//             timer.cancel();
//             return;
//           }
//         }
//       });
//
//     });
//   }
//
//   @override
//   void didChangeDependencies() {
//     initialization();
//     super.didChangeDependencies();
//   }
//
//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }
//
//
//
//   Future<void> brightNess() async {
//     try {
//       brightness = await FlutterScreenWake
//           .brightness; //get the current screen brightness
//       if (brightness > 1) {
//         brightness = brightness / 10;
//       }
//       print(brightness);
//       setState(() {
//         brightness = brightness;
//       });
//     } on PlatformException {
//       brightness = 0.0;
//     }
//     if (!mounted) return;
//   }
//
//
//   initialization() {
//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       musicIndex = ref
//           .read(mixMusicProvider)
//           .combinationList
//           .indexWhere((element) => element.id == widget.mixMusicModelId);
//       print("music index $musicIndex");
//       if (mounted) {
//         setState(() {});
//       }
//       checkMounted();
//     });
//   }
//
//   changeIndex({bool changeIndex = false}) {
//     if (changeIndex) {
//       musicIndex =
//           (musicIndex + 1) % ref.watch(mixMusicProvider).combinationList.length;
//     } else {
//       musicIndex = (musicIndex - 1);
//       if (musicIndex < 0) {
//         musicIndex = ref.watch(mixMusicProvider).combinationList.length - 1;
//       }
//     }
//     /*if(mounted){
//         musicList = [];
//         musicList.add(ref.watch(mixMusicProvider).combinationList[musicIndex].first!);
//         musicList.add(ref.watch(mixMusicProvider).combinationList[musicIndex].second!);
//         index = 0;
//         setState((){});
//       }*/
//   }
//
//   pausePlayMethod() async {
//     if (ins.isPlaying()) {
//       await ins.stop();
//
//       pauseSliderTimmer();
//     } else {
//       String url1 = ref
//               .watch(mixMusicProvider)
//               .combinationList[musicIndex]
//               .first
//               ?.musicFile ??
//           "";
//       String url2 = ref
//               .watch(mixMusicProvider)
//               .combinationList[musicIndex]
//               .second
//               ?.musicFile ??
//           "";
//       // print("${audioPlayer1.getDuration().then((value) => print("duration value$value"))}");
//       // await audioPlayer1.play(AssetSource(url1));
//       await ins.playAudio(Duration(minutes: 2), "assets/" + url1);
//       // await audioPlayer2.play(AssetSource(url2));
//       await ins.playAudio(Duration(minutes: 2), "assets/" + url2);
//       resumeSliderTimmer();
//     }
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   playMusic() async {
//     String url1 = ref
//             .watch(mixMusicProvider)
//             .combinationList[musicIndex]
//             .first
//             ?.musicFile ??
//         "";
//     String url2 = ref
//             .watch(mixMusicProvider)
//             .combinationList[musicIndex]
//             .second
//             ?.musicFile ??
//         "";
//     // await audioPlayer1.play(AssetSource(url1));
//     await ins.playAudio(Duration(minutes: 2), "assets/" + url1);
//     // await audioPlayer2.play(AssetSource(url2));
//     await ins.playAudio(Duration(minutes: 2), "assets/" + url2);
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   checkMounted() async {
//     if (mounted) {
//       setState(() {});
//       pausePlayMethod();
//     }
//     print("duration2 ${_duration2.inSeconds}  duration${_duration.inSeconds}");
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final height = ScreenSize(context).height;
//     final width = ScreenSize(context).width;
//     return Scaffold(
//         backgroundColor: Colors.white,
//         appBar: CustomAppBar(
//           title: 'Mix sound playing',
//           iconButton: false,
//           onPressedButton: null,
//           onPressed: widget.onPressed,
//         ),
//         body: PageView.builder(
//           onPageChanged: (int index) {
//             changeIndex(changeIndex: true);
//             if (mounted) {
//               // playMusic();
//             }
//             if (mounted) {
//               setState(() {});
//             }
//           },
//           controller: pageController,
//           itemCount: ref.watch(mixMusicProvider).combinationList.length,
//           itemBuilder: (_, index) {
//             return SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Container(
//                         color: Colors.transparent,
//                         child: GestureDetector(
//                           onTap: () {
//                             _showDialogBrightNess(context);
//                           },
//                           child: Padding(
//                             padding: EdgeInsets.only(right: width * .07),
//                             child: CustomImage(
//                               imageUrl:
//                                   'asset/images/icon_png/now_playing_icon/Sun.png',
//                               color: Colors.orangeAccent.shade100,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: Center(
//                           child: Padding(
//                             padding: const EdgeInsets.only(left: 8.0),
//                             child: CustomImage(
//                               imageUrl: ref
//                                       .watch(mixMusicProvider)
//                                       .combinationList[musicIndex]
//                                       .first
//                                       ?.image ??
//                                   "",
//                               // height: width * .7,
//                               // width: width * .5,
//                               // boxFit: BoxFit.contain,
//                             ),
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: Center(
//                           child: Padding(
//                             padding: const EdgeInsets.only(right: 8.0),
//                             child: CustomImage(
//
//                               imageUrl: ref
//                                       .watch(mixMusicProvider)
//                                       .combinationList[musicIndex]
//                                       .second
//                                       ?.image ??
//                                   "",
//                               // height: width * .7,
//                               // width: width * .4,
//                               // boxFit: BoxFit.contain,
//                             ),
//                           ),
//                         ),
//                       ),
//
//
//                     ],
//                   ),
//                   Container(
//                     color: Colors.transparent,
//                     child: Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Expanded(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 CustomText(
//                                   text:
//                                       "${ref.watch(mixMusicProvider).combinationList[musicIndex].first?.musicName}+${ref.watch(mixMusicProvider).combinationList[musicIndex].second?.musicName}",
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.w400,
//                                   color: secondaryBlackColor,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: width * 0.07),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         InkWell(
//                           onTap: (){
//                             _showDialogVolume(context);
//                           },
//                           child: Row(
//                             children: [
//                               Container(
//                                   color: Colors.transparent,
//                                   child: const CustomSvg(
//                                       svg: volume, color: blackColor2)),
//                               SizedBox(width: 6,),
//                               Text("Set Volume"),
//                               // GestureDetector(
//                               //     onTap: () {
//                               //       ref.read(addProvider).addOrRemovePlayList(
//                               //           id: ref.watch(addProvider).musicList[index].id);
//                               //     },
//                               //     child: CustomImage(
//                               //       imageUrl: 'asset/images/icon_png/love.png',
//                               //       color: ref.watch(addProvider).playListIds.contains(
//                               //           ref.watch(addProvider).musicList[index].id)
//                               //           ? Colors.red
//                               //           : blackColorA0,
//                               //     )),
//                               // const SizedBox(
//                               //   width: 10,
//                               // ),
//
//                             ],
//                           ),
//                         ),
//                         InkWell(
//                           onTap: (){
//                             _showDialog(context);
//                           },
//                           child: Row(
//                             children: [
//                               Container(
//                                   color: Colors.transparent,
//                                   child: CustomSvg(
//                                     svg: timer,
//                                     color: blackColor2,
//                                   )),
//                               // const CustomImage(
//                               //   imageUrl: 'asset/images/icon_png/another_sound.png',
//                               //   color: blackColorA0,
//                               // ),
//                               const SizedBox(
//                                 width: 10,
//                               ),
//                               Text("Set Timer"),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Padding(
//                   //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                   //   child: Row(
//                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   //     children: [
//                   //       Row(
//                   //         children: [
//                   //         Icon(
//                   //               Icons.add,
//                   //               size: 30,
//                   //               color: ref
//                   //                       .watch(mixMusicProvider)
//                   //                       .mixPlayListIds
//                   //                       .contains(ref
//                   //                           .watch(mixMusicProvider)
//                   //                           .combinationList[musicIndex]
//                   //                           .id)
//                   //                   ? Colors.red
//                   //                   : Colors.black,
//                   //             ),
//                   //
//                   //           // GestureDetector(
//                   //           //     onTap: (){
//                   //           //     },
//                   //           //     child: CustomImage(imageUrl: 'asset/images/icon_png/love.png',color: ref.watch(mixMusicProvider).mixPlayListIds.contains(ref.watch(mixMusicProvider).combinationList[musicIndex].id)? Colors.red:blackColorA0,)),
//                   //           const SizedBox(
//                   //             width: 5,
//                   //           ),
//                   //           Padding(
//                   //             padding: const EdgeInsets.only(top: 4.0),
//                   //             child: const CustomText(
//                   //               text: 'Add To Playlist',
//                   //               fontSize: 16,
//                   //               fontWeight: FontWeight.w400,
//                   //             ),
//                   //           ),
//                   //         ],
//                   //       ),
//                   //     ],
//                   //   ),
//                   // ),
//                   SizedBox(height: width * 0.1),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 30.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         CustomText(
//                           text:
//                               '${getHumanTimeBySecond(sliderInitial.toInt())}',
//                           fontSize: 10,
//                           color: blackColor2,
//                           fontWeight: FontWeight.w700,
//                         ),
//                         CustomText(
//                           text: '${getHumanTimeBySecond(sliderEnd.toInt())}',
//                           fontSize: 10,
//                           color: blackColor2,
//                           fontWeight: FontWeight.w700,
//                         ),
//                         // CustomText(
//                         //   text: '${_position.inSeconds ~/ 60} : ${(_position.inSeconds % 60).toInt()}',
//                         //   fontSize: 10,
//                         //   color: blackColor2,
//                         //   fontWeight: FontWeight.w700,
//                         // ),
//                         // CustomText(
//                         //   text: '${_duration.inSeconds ~/ 60} : ${(_duration.inSeconds % 60).toInt()}',
//                         //   fontSize: 10,
//                         //   color: blackColor2,
//                         //   fontWeight: FontWeight.w700,
//                         // ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     //color: Colors.green,
//                     width: width * .95,
//                     child: SliderTheme(
//                       data: const SliderThemeData(
//                           trackShape: RectangularSliderTrackShape(),
//                           thumbShape:
//                               RoundSliderThumbShape(enabledThumbRadius: 10)),
//                       child: Slider(
//                           value: sliderInitial <= sliderEnd
//                               ? sliderInitial
//                               : sliderEnd,
//                           min: 0,
//                           max: sliderEnd,
//                           divisions: 350,
//                           activeColor: primaryPinkColor,
//                           inactiveColor: primaryGreyColor2,
//                           onChanged: (double newValue) async {
//                             print("slider");
//                             updateSlider(newValue);
//
//                             ins.seek(Duration(
//                                 seconds: (sliderEnd - sliderInitial).toInt()));
//                             setState(() {});
//                           },
//                           semanticFormatterCallback: (double newValue) {
//                             return '${newValue.round()} dollars';
//                           }),
//                     ),
//                   ),
//                   // SizedBox(
//                   //   //color: Colors.green,
//                   //   width: width * .95,
//                   //   child: SliderTheme(
//                   //     data: const SliderThemeData(
//                   //         trackShape: RectangularSliderTrackShape(),
//                   //         thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)),
//                   //     child: Slider(
//                   //         value: position.inSeconds.toDouble() < _position2.inSeconds.toDouble()?_position.inSeconds.toDouble():_position2.inSeconds.toDouble(),
//                   //         min: 0,
//                   //         max: _duration.inSeconds.toDouble() < _duration2.inSeconds.toDouble()?_duration.inSeconds.toDouble():_duration2.inSeconds.toDouble(),
//                   //         divisions: 100,
//                   //         activeColor: primaryPinkColor,
//                   //         inactiveColor: primaryGreyColor2,
//                   //         onChanged: (double newValue) async{
//                   //           if(newValue.toInt() <= _duration.inSeconds){
//                   //             await audioPlayer1.seek(Duration(seconds: newValue.toInt()));
//                   //           }
//                   //           if(newValue.toInt() <= _duration2.inSeconds){
//                   //             await audioPlayer2.seek(Duration(seconds: newValue.toInt()));
//                   //           }
//                   //           await audioPlayer1.resume();
//                   //           await audioPlayer2.resume();
//                   //           if(mounted){
//                   //             setState(() {});
//                   //           }
//                   //         },
//                   //         semanticFormatterCallback: (double newValue) {
//                   //           return '${newValue.round()} dollars';
//                   //         }),
//                   //   ),
//                   // ),
//                   Container(
//                     color: Colors.transparent,
//                     child: Padding(
//                       padding: const EdgeInsets.only(left: 20.0, right: 20),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           // IconButton(
//                           //     padding: const EdgeInsets.only(left: 10),
//                           //     onPressed: () {
//                           //       _showDialogVolume(context);
//                           //     },
//                           //     icon: Container(
//                           //         color: Colors.transparent,
//                           //         child: const CustomSvg(
//                           //             svg: volume, color: blackColor2))),
//                           IconButton(
//                               padding: EdgeInsets.zero,
//                               onPressed: () async {
//                                 changeIndex(changeIndex: false);
//                                 selectedTime = 0;
//                                 setDuration = 0;
//                                 check=true;
//                                 if (mounted) {
//                                   playMusic();
//                                   sliderInitial = 0.0;
//                                   sliderEnd = 120.0;
//                                 }
//                                 if (mounted) {
//                                   setState(() {});
//                                 }
//                               },
//                               icon: const CustomSvg(
//                                   svg: left_shift, color: primaryPinkColor)),
//                           GestureDetector(
//                             onTap: ()async{
//                               if (ins.isPlaying()) {
//                                 await ins.stop();
//                                 // await audioPlayer2.pause();
//                                 pauseSliderTimmer();
//                               } else {
//                                 String url1 = ref
//                                     .watch(mixMusicProvider)
//                                     .combinationList[musicIndex]
//                                     .first
//                                     ?.musicFile ??
//                                     "";
//                                 String url2 = ref
//                                     .watch(mixMusicProvider)
//                                     .combinationList[musicIndex]
//                                     .second
//                                     ?.musicFile ??
//                                     "";
//                                 //   await audioPlayer1.play(AssetSource(url1));
//                                 await ins.playAudio(
//                                     Duration(minutes: 2), "assets/" + url1);
//                                 // await audioPlayer2.play(AssetSource(url2));
//                                 await ins.playAudio(
//                                     Duration(minutes: 2), "assets/" + url2);
//                                 resumeSliderTimmer();
//                               }
//                               playPouse = !playPouse;
//                               if (mounted) {
//                                 setState(() {});
//                               }
//                               setState(() {});
//                             },
//                             child: Container(
//                               // color: Colors.red,
//                               height: width * 0.18,
//                               width: width * 0.18,
//                               clipBehavior: Clip.hardEdge,
//                               decoration: BoxDecoration(
//                                   color: secondaryWhiteColor2,
//                                   shape: BoxShape.circle,
//                                   border: Border.all(
//                                       color: Colors.transparent, width: 0),
//                                   boxShadow: const [
//                                     BoxShadow(
//                                         blurRadius: 10,
//                                         color: secondaryWhiteColor2)
//                                   ]),
//                               child: Padding(
//                                 padding: const EdgeInsets.all(22),
//                                 child: CustomSvg(
//                                   color: primaryPinkColor,
//                                   svg: ins.isPlaying()
//                                       ? pouseButton
//                                       : playButtonSvg,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           IconButton(
//                               padding: EdgeInsets.zero,
//                               onPressed: () async {
//                                 changeIndex(changeIndex: true);
//                                 sliderInitial = 0.0;
//                                 selectedTime = 0;
//                                 setDuration = 0;
//                                 check=true;
//                                 if (mounted) {
//                                   playMusic();
//                                   sliderInitial = 0.0;
//                                   sliderEnd = 120.0;
//                                 }
//                                 if (mounted) {
//                                   setState(() {});
//                                 }
//                               },
//                               icon: const CustomSvg(
//                                   svg: right_shift, color: primaryPinkColor)),
//                           // IconButton(
//                           //     padding: EdgeInsets.zero,
//                           //     onPressed: () {
//                           //       ref.read(mixMusicProvider).alertDialogStart();
//                           //       if (mounted) {
//                           //         setState(() {
//                           //           check = false;
//                           //           selectedTime = 0;
//                           //         });
//                           //         _showDialog(context);
//                           //       }
//                           //     },
//                           //     icon: Container(
//                           //         color: Colors.transparent,
//                           //         child: const Padding(
//                           //           padding:
//                           //               EdgeInsets.symmetric(vertical: 8.0),
//                           //           child: CustomSvg(
//                           //               svg: timer, color: blackColor2),
//                           //         ))),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ));
//   }
//
//   void _showDialogBrightNess(BuildContext context) {
//     final height = ScreenSize(context).height;
//     final width = ScreenSize(context).width;
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context,
//               void Function(void Function()) updateState) {
//             return Align(
//               alignment: Alignment.topCenter,
//               child: Wrap(
//                 children: [
//                   Container(
//                     color: Colors.transparent,
//                     height: width * 0.24,
//                     child: AlertDialog(
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(15)),
//                       backgroundColor: Colors.white,
//                       contentPadding: EdgeInsets.zero,
//                       content: SizedBox(
//                         height: width * 0.25,
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: SliderTheme(
//                                 data: const SliderThemeData(
//                                     trackShape: RectangularSliderTrackShape(),
//                                     thumbShape: RoundSliderThumbShape(
//                                         enabledThumbRadius: 10)),
//                                 child: Slider(
//                                     value: brightness,
//                                     min: 0.0,
//                                     max: 1.0,
//                                     divisions: 100,
//                                     activeColor: primaryPinkColor,
//                                     inactiveColor: primaryGreyColor2,
//                                     onChanged: (double newValue) async {
//                                       updateState(() {
//                                         // Screen.setBrightness(newValue);
//                                         brightness = newValue;
//                                         print("$brightness");
//                                       });
//                                       await ScreenBrightness()
//                                           .setScreenBrightness(brightness);
//                                     },
//                                     semanticFormatterCallback:
//                                         (double newValue) {
//                                       return '${newValue.round()} dollars';
//                                     }),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(right: 10),
//                               child: Container(
//                                 color: Colors.transparent,
//                                 height: width * 0.1,
//                                 child: const CustomImage(
//                                   boxFit: BoxFit.fill,
//                                   imageUrl:
//                                       'asset/images/icon_png/now_playing_icon/Sun.png',
//                                   color: primaryPinkColor,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _showDialogVolume(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final width = ScreenSize(context).width;
//         return StatefulBuilder(
//           builder: (BuildContext context,
//               void Function(void Function()) updateState) {
//             return Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Transform(
//                   transform: Matrix4.identity()..rotateZ(-90 * 3.1415927 / 180),
//                   child: AlertDialog(
//                     alignment: Alignment.centerLeft,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15)),
//                     backgroundColor: Colors.white,
//                     contentPadding: EdgeInsets.zero,
//                     content: Container(
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Stack(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.only(
//                                     left: 20.0, top: 15, right: 0, bottom: 0),
//                                 child: Transform(
//                                   alignment: Alignment.topCenter,
//                                   transform: Matrix4.identity()
//                                     ..rotateZ(90 * 3.1415927 / 180),
//                                   child: const CustomSvg(
//                                     svg: volume,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Slider(
//                                   value: currentVolume,
//                                   min: 0.0,
//                                   max: 100.0,
//                                   divisions: 100,
//                                   activeColor: primaryPinkColor,
//                                   inactiveColor: primaryGreyColor2,
//                                   onChanged: (double newValue) async {
//                                     updateState(() {
//                                       // Screen.setBrightness(newValue);
//                                       currentVolume = newValue;
//                                       print("volume $currentVolume");
//                                     });
//                                     // await ins.setVolume(0.5);
//
//                                      ins.setVolume(currentVolume * 0.01);
//                                     // await PerfectVolumeControl.setVolume(currentVolume);
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                           Positioned(
//                               right: width * 0.25,
//                               top: 10,
//                               child: Transform(
//                                   transform: Matrix4.identity()
//                                     ..rotateZ(90 * 3.1415927 / 180),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(2),
//                                         boxShadow: [
//                                           BoxShadow(
//                                               color: secondaryBlackColor
//                                                   .withOpacity(0.2),
//                                               blurRadius: 0.2,
//                                               spreadRadius: 0.5)
//                                         ]),
//                                     child: Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 4.0, vertical: 5),
//                                       child: Center(
//                                           child: CustomText(
//                                         text:
//                                             "${(currentVolume).toInt().toString().padLeft(2, "0")}%",
//                                         fontSize: 10,
//                                         color: secondaryBlackColor,
//                                         fontWeight: FontWeight.w600,
//                                       )),
//                                     ),
//                                   )))
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
//   void _showDialog(BuildContext context) {
//     final height = ScreenSize(context).height;
//     final width = ScreenSize(context).width;
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder:
//               (BuildContext context, void Function(void Function()) state) {
//             /* if(mounted) {
//               //startTimer(state);
//               if(mounted){
//                 state((){});
//               }
//             }*/
//             return Align(
//               alignment: Alignment.center,
//               child: Wrap(
//                 children: [
//                   AlertDialog(
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15)),
//                     backgroundColor: Colors.white,
//                     title: Padding(
//                       padding: const EdgeInsets.only(left: 18.0, right: 18),
//                       child: Column(
//                         children: const [
//                           CustomText(
//                             text: 'Select Duration',
//                             textAlign: TextAlign.center,
//                             fontSize: 20,
//                             fontWeight: FontWeight.w600,
//                             color: primaryGreyColor,
//                           ),
//                           SizedBox(height: 20),
//                         ],
//                       ),
//                     ),
//                     contentPadding: EdgeInsets.zero,
//                     content: Padding(
//                       padding: const EdgeInsets.only(left: 8.0, right: 18),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Container(
//                             width: width * 0.27,
//                             padding: const EdgeInsets.symmetric(vertical: 8),
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(5),
//                               color: greyEC,
//                             ),
//                             child: Center(
//                                 child: CustomText(
//                                     text:
//                                     "${(selectedTimes[selectedTime] ~/ 60).toString().padLeft(2, "0")} : ${(selectedTimes[selectedTime] % 60).toString().padLeft(2, "0")} min")),
//                           ),
//                           SliderTheme(
//                             data: const SliderThemeData(
//                                 trackHeight: 5.0,
//                                 trackShape: RectangularSliderTrackShape(),
//                                 thumbShape: RoundSliderThumbShape(
//                                     enabledThumbRadius: 10)),
//                             child: Slider.adaptive(
//                                 value: selectedTime.toDouble(),
//                                 min: 0,
//                                 max: 7,
//                                 divisions: 7,
//                                 activeColor: primaryPinkColor,
//                                 inactiveColor: primaryGreyColor2,
//                                 onChanged: (double newValue) async {
//                                   state(() {
//                                     selectedTime = newValue.toInt();
//                                     setDuration = selectedTimes[selectedTime];
//
//                                     setDuration *= 60;
//                                     setSongDuration(setDuration);
//                                     ins.seek(Duration(seconds: setDuration));
//                                     print("index 111 $setDuration");
//                                     print(
//                                         "index 222 ${selectedTimes[selectedTime]}");
//                                     if (selectedTimes[selectedTime] == 0) {
//                                       check = true;
//                                       sliderEnd = 120.0;
//                                     } else {
//                                       check = false;
//                                     }
//                                   });
//                                   setState(() {});
//                                 },
//                                 semanticFormatterCallback: (double newValue) {
//                                   return '${newValue.round()} dollars';
//                                 }),
//                           ),
//                           SizedBox(
//                             width: width * 0.59,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: List.generate(
//                                   times.length,
//                                       (index) => CustomText(
//                                       text: times[index],
//                                       fontWeight: FontWeight.w400,
//                                       fontSize: 8,
//                                       color: secondaryBlackColor)),
//                             ),
//                           ),
//                           const SizedBox(height: 15),
//                         ],
//                       ),
//                     ),
//                     actionsAlignment: MainAxisAlignment.start,
//                     actionsPadding: const EdgeInsets.only(left: 48, bottom: 30),
//                     actions: <Widget>[
//                       Row(
//                         children: [
//                           Checkbox(
//                               side: const BorderSide(color: blackColorA0),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               activeColor: primaryPinkColor,
//                               value: check,
//                               onChanged: (newValue) {
//                                 state(() {
//                                   check = newValue!;
//                                   if (check) {
//                                     selectedTime = 0;
//                                   }
//                                 });
//                               }),
//                           TextButton(
//                               onPressed: check
//                                   ? () async {
//                                 if (mounted) {
//                                   Navigator.pop(context);
//                                 }
//                               }
//                                   : null,
//                               child: const CustomText(
//                                 text: "continuous play",
//                                 fontSize: 19,
//                                 fontWeight: FontWeight.w400,
//                                 color: primaryGreyColor,
//                               )),
//                         ],
//                       ),
//                       SizedBox(
//                         height: 6,
//                       ),
//                       InkWell(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 38.0),
//                           child: Center(
//                             child: Container(
//                               alignment: Alignment.center,
//                               height: 50,
//                               width: 100,
//                               decoration: BoxDecoration(
//                                   color: primaryPinkColor,
//                                   borderRadius: BorderRadius.circular(30)),
//                               child: Text(
//                                 "OK",
//                                 style: TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     ).then((value) {
//       if (mounted) {
//         ref.read(mixMusicProvider).alertDialogStop();
//         if (mounted) {
//           setState(() {
//             print("asche");
//           });
//         }
//       }
//     });
//   }
//
//   // void _showDialog(BuildContext context) {
//   //   final height = ScreenSize(context).height;
//   //   final width = ScreenSize(context).width;
//   //   showDialog(
//   //     context: context,
//   //     builder: (BuildContext context) {
//   //       return StatefulBuilder(
//   //         builder:
//   //             (BuildContext context, void Function(void Function()) state) {
//   //           /* if(mounted) {
//   //             //startTimer(state);
//   //             if(mounted){
//   //               state((){});
//   //             }
//   //           }*/
//   //           return Align(
//   //             alignment: Alignment.center,
//   //             child: Wrap(
//   //               children: [
//   //                 AlertDialog(
//   //                   shape: RoundedRectangleBorder(
//   //                       borderRadius: BorderRadius.circular(15)),
//   //                   backgroundColor: Colors.white,
//   //                   title: Padding(
//   //                     padding: const EdgeInsets.only(left:18.0, right: 18),
//   //                     child: Column(
//   //
//   //                       children: const [
//   //                         CustomText(
//   //                           text: 'Select Duration',
//   //                           textAlign: TextAlign.center,
//   //                           fontSize: 20,
//   //                           fontWeight: FontWeight.w600,
//   //                           color: primaryGreyColor,
//   //                         ),
//   //                         SizedBox(height: 20),
//   //                       ],
//   //                     ),
//   //                   ),
//   //                   contentPadding: EdgeInsets.zero,
//   //                   content: Padding(
//   //                     padding: const EdgeInsets.only(left: 8.0, right: 18),
//   //                     child: Column(
//   //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                       children: [
//   //                         Container(
//   //                           width: width * 0.27,
//   //                           padding: const EdgeInsets.symmetric(vertical: 8),
//   //                           decoration: BoxDecoration(
//   //                             borderRadius: BorderRadius.circular(5),
//   //                             color: greyEC,
//   //                           ),
//   //                           child: Center(
//   //                               child: CustomText(
//   //                                   text:
//   //                                       "${(selectedTimes[selectedTime] ~/ 60).toString().padLeft(2, "0")} : ${(selectedTimes[selectedTime] % 60).toString().padLeft(2, "0")} min")),
//   //                         ),
//   //                         SliderTheme(
//   //                           data: const SliderThemeData(
//   //                               trackShape: RectangularSliderTrackShape(),
//   //                               thumbShape: RoundSliderThumbShape(
//   //                                   enabledThumbRadius: 10)),
//   //                           child: Slider.adaptive(
//   //                               value: selectedTime.toDouble(),
//   //                               min: 0,
//   //                               max: 7,
//   //                               divisions: 7,
//   //                               activeColor: primaryPinkColor,
//   //                               inactiveColor: primaryGreyColor2,
//   //                               onChanged: (double newValue) async {
//   //                                 state(() {
//   //                                   setDuration = 1;
//   //                                   selectedTime = check ? 0 : newValue.toInt();
//   //                                   setDuration = selectedTimes[selectedTime];
//   //
//   //                                   setDuration *= 60;
//   //                                   setSongDuration(setDuration);
//   //                                   ins.seek(Duration(seconds: setDuration));
//   //
//   //                                   print("index $selectedTime");
//   //                                 });
//   //                                 setState(() {});
//   //                               },
//   //                               semanticFormatterCallback: (double newValue) {
//   //                                 return '${newValue.round()} dollars';
//   //                               }),
//   //                         ),
//   //                         // SliderTheme(
//   //                         //   data: const SliderThemeData(
//   //                         //       trackShape: RectangularSliderTrackShape(),
//   //                         //       thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10)),
//   //                         //   child: Slider.adaptive(
//   //                         //       value: selectedTime.toDouble(),
//   //                         //       min: 0,
//   //                         //       max: 7,
//   //                         //       divisions: 7,
//   //                         //       activeColor: primaryPinkColor,
//   //                         //       inactiveColor: primaryGreyColor2,
//   //                         //       onChanged: (double newValue) async{
//   //                         //         state(() {
//   //                         //           setDuration = 1;
//   //                         //           selectedTime = check?0:newValue.toInt();
//   //                         //           setDuration = selectedTimes[selectedTime];
//   //                         //           setDuration *= 60;
//   //                         //           print("index $selectedTime");
//   //                         //         });
//   //                         //         setState(() {});
//   //                         //       },
//   //                         //       semanticFormatterCallback: (double newValue) {
//   //                         //         return '${newValue.round()} dollars';
//   //                         //       }),
//   //                         // ),
//   //                         SizedBox(
//   //                           width: width * 0.59,
//   //                           child: Row(
//   //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                             children: List.generate(
//   //                                 times.length,
//   //                                 (index) => CustomText(
//   //                                     text: times[index],
//   //                                     fontWeight: FontWeight.w400,
//   //                                     fontSize: 8,
//   //                                     color: secondaryBlackColor)),
//   //                           ),
//   //                         ),
//   //                         const SizedBox(height: 15),
//   //                       ],
//   //                     ),
//   //                   ),
//   //                   actionsAlignment: MainAxisAlignment.start,
//   //                   actionsPadding: const EdgeInsets.only(left: 48, bottom: 30),
//   //                   actions: <Widget>[
//   //                     Column(
//   //                       children: [
//   //                         Row(
//   //                           children: [
//   //                             Checkbox(
//   //                                 side: const BorderSide(color: blackColorA0),
//   //                                 shape: RoundedRectangleBorder(
//   //                                   borderRadius: BorderRadius.circular(5),
//   //                                 ),
//   //                                 activeColor: primaryPinkColor,
//   //                                 value: check,
//   //                                 onChanged: (newValue) {
//   //                                   state(() {
//   //                                     check = newValue!;
//   //                                     if (check) {
//   //                                       selectedTime = 0;
//   //                                     }
//   //                                   });
//   //                                 }),
//   //                             TextButton(
//   //                                 onPressed: check
//   //                                     ? () async {
//   //                                         if (mounted) {
//   //                                           Navigator.pop(context);
//   //                                         }
//   //                                       }
//   //                                     : null,
//   //                                 child: const CustomText(
//   //                                   text: "continuous play",
//   //                                   fontSize: 16,
//   //                                   fontWeight: FontWeight.w400,
//   //                                   color: primaryGreyColor,
//   //                                 ))
//   //                           ],
//   //                         ),
//   //                         SizedBox(
//   //                           height: 6,
//   //                         ),
//   //                         InkWell(
//   //                           onTap: () {
//   //                             Navigator.pop(context);
//   //                           },
//   //                           child: Padding(
//   //                             padding: const EdgeInsets.only(right: 38.0),
//   //                             child: Center(
//   //                               child: Container(
//   //                                 alignment: Alignment.center,
//   //                                 height: 50,
//   //                                 width: 200,
//   //                                 decoration: BoxDecoration(
//   //                                     color: primaryPinkColor,
//   //                                     borderRadius: BorderRadius.circular(30)),
//   //                                 child: Text(
//   //                                   "OK",
//   //                                   style: TextStyle(
//   //                                       fontSize: 18,
//   //                                       fontWeight: FontWeight.bold),
//   //                                 ),
//   //                               ),
//   //                             ),
//   //                           ),
//   //                         )
//   //                         // Text("A")
//   //                       ],
//   //                     ),
//   //                   ],
//   //                 ),
//   //               ],
//   //             ),
//   //           );
//   //         },
//   //       );
//   //     },
//   //   ).then((value) {
//   //     if (mounted) {
//   //       ref.read(mixMusicProvider).alertDialogStop();
//   //       if (mounted) {
//   //         setState(() {
//   //           secController.text = "";
//   //           minController.text = "";
//   //           print("asche");
//   //         });
//   //       }
//   //     }
//   //   });
//   // }
//
//   String getHumanTimeBySecond(int seconds) {
//     int hours = (seconds / 3600).floor();
//     int minutes = ((seconds - (hours * 3600)) / 60).floor();
//     int secs = seconds - (hours * 3600) - (minutes * 60);
//
//     String hoursStr = (hours < 10) ? "0$hours" : hours.toString();
//     String minutesStr = (minutes < 10) ? "0$minutes" : minutes.toString();
//     String secondsStr = (secs < 10) ? "0$secs" : secs.toString();
//
//     return "$hoursStr:$minutesStr:$secondsStr";
//   }
//
//   var sliderInitial = 0.0;
//   var sliderEnd = 120.0;
//
//   Timer? sliderTimer;
//
//   void setSongDuration(int setDuration, {double initValue = 0}) {
//     sliderInitial = initValue;
//     sliderEnd = setDuration.toDouble();
//     if (sliderTimer != null) {
//       sliderTimer!.cancel();
//     }
//     sliderTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (!mounted) {
//         timer.cancel();
//       }
//
//       if (sliderEnd <= sliderInitial) {
//         timer.cancel();
//         sliderInitial = 0.0;
//         ins.stop();
//       }
//       sliderInitial++;
//       setState(() {});
//     });
//   }
//
//   void updateSlider(double newValue) {
//     sliderInitial = newValue;
//     setState(() {});
//   }
//
//   void pauseSliderTimmer() {
//     print("=========${sliderTimer!.isActive}");
//     print("=========");
//     sliderTimer!.cancel();
//   }
//
//   void resumeSliderTimmer() {
//     setSongDuration(sliderEnd.toInt(), initValue: sliderInitial);
//   }
// }
import 'dart:async';
import 'package:bye_bye_cry_new/compoment/shared/custom_image.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_svg.dart';
import 'package:bye_bye_cry_new/screens/models/music_models.dart';
import 'package:bye_bye_cry_new/screens/provider/add_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/mix_music_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:screen_brightness/screen_brightness.dart';
import '../compoment/shared/custom_app_bar.dart';
import '../compoment/shared/custom_text.dart';
import '../compoment/shared/screen_size.dart';
import '../compoment/utils/color_utils.dart';
import '../compoment/utils/image_link.dart';
import '../main.dart';
import 'my_playList_details_screen.dart';

class ListenMixSound extends ConsumerStatefulWidget {
  final String? mixMusicModelId;
  final VoidCallback? onPressed;
  const ListenMixSound(
      {Key? key, required this.mixMusicModelId, this.onPressed})
      : super(key: key);

  @override
  ConsumerState<ListenMixSound> createState() => _ListenMixSoundState();
}

class _ListenMixSoundState extends ConsumerState<ListenMixSound>
    with TickerProviderStateMixin {
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
  PageController pageController = PageController();

  int selectedTime = 0;
  bool playPouse = true;
  int setDuration = 0;
  // AudioCache audioCache = AudioCache();
  // AudioPlayer audioPlayer1 = AudioPlayer();
  // AudioPlayer audioPlayer2 = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Duration _duration2 = Duration.zero;
  Duration _position2 = Duration.zero;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  double currentVolume = 40.0;
  bool issongplaying1 = false;
  bool issongplaying2 = false;
  double brightness = 0.5;
  late StreamSubscription<double> _subscription;
  int musicIndex = 0;
  List<MusicModel> musicList = [];
  int index = 0;
  bool check = true;
  TextEditingController minController = TextEditingController();
  TextEditingController secController = TextEditingController();

  @override
  void initState() {
    //.//audioPlayer1.dispose();
    // startPlayer1();
    // startPlayer2();

    //brightNess();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Timer.periodic(Duration(seconds: 1), (timer) async {
        print(_position);
        if (sliderInitial.toInt() == (sliderEnd - 1).toInt()) {

          // if (check == false) {
          //   pageController.nextPage(
          //       duration: Duration(milliseconds: 100), curve: Curves.linear);
          //
          //   sliderInitial = 0.0;
          //   sliderEnd = 120.0;
          //   selectedTime = 0;
          //   setDuration = 0;
          //   check=true;
          //   changeIndex(changeIndex: true);
          //
          //   if (mounted) {
          //     // String url = ref
          //     //     .watch(addProvider)
          //     //     .musicList[index]
          //     //     .musicFile;
          //     String url1 = ref
          //         .watch(mixMusicProvider)
          //         .combinationList[index]
          //         .first!
          //         .musicFile;
          //     String url2 = ref
          //         .watch(mixMusicProvider)
          //         .combinationList[index]
          //         .first!
          //         .musicFile;
          //     // await audioPlayer1.play(AssetSource(url1));
          //     await ins.playAudio(Duration(minutes: 2), "assets/" + url1);
          //     // await audioPlayer2.play(AssetSource(url2));
          //     await ins.playAudio(Duration(minutes: 2), "assets/" + url2);
          //     // sliderInitial=0.0;
          //   }
          //
          //   if (mounted) {
          //     setState(() {});
          //   }
          // } else {
          //   ins.stop();
          //   if (mounted) {
          //     // String url = ref
          //     //     .watch(addProvider)
          //     //     .musicList[index]
          //     //     .musicFile;
          //     sliderInitial = 0.0;
          //     sliderEnd = 120.0;
          //     selectedTime = 0;
          //     setDuration = 0;
          //     check=true;
          //     String url1 = ref
          //         .watch(mixMusicProvider)
          //         .combinationList[index]
          //         .first!
          //         .musicFile;
          //     String url2 = ref
          //         .watch(mixMusicProvider)
          //         .combinationList[index]
          //         .first!
          //         .musicFile;
          //     // await audioPlayer1.play(AssetSource(url1));
          //     await ins.playAudio(Duration(minutes: 2), "assets/" + url1);
          //     // await audioPlayer2.play(AssetSource(url2));
          //     await ins.playAudio(Duration(minutes: 2), "assets/" + url2);
          //   }
          // }
          if (check == false) {

            sliderInitial = 0.0;
            sliderEnd = 120.0;
            selectedTime = 0;
            setDuration = 0;
            check=true;



            if (mounted) {
              if(check==true){
                changeIndex(changeIndex: true);
                String url1 = ref
                    .watch(mixMusicProvider)
                    .combinationList[index]
                    .first!
                    .musicFile;
                String url2 = ref
                    .watch(mixMusicProvider)
                    .combinationList[index]
                    .first!
                    .musicFile;
                // await audioPlayer1.play(AssetSource(url1));
                await ins.playAudio(Duration(hours: 10), "assets/" + url1);
                // await audioPlayer2.play(AssetSource(url2));
                await ins.playAudio(Duration(hours: 10), "assets/" + url2);
                // sliderInitial=0.0;


                print("IF URL __$url1");
              }
              else{
                String url1 = ref
                    .watch(mixMusicProvider)
                    .combinationList[index]
                    .first!
                    .musicFile;
                String url2 = ref
                    .watch(mixMusicProvider)
                    .combinationList[index]
                    .first!
                    .musicFile;
                // await audioPlayer1.play(AssetSource(url1));
                await ins.playAudio(Duration(minutes: 2), "assets/" + url1);
                // await audioPlayer2.play(AssetSource(url2));
                await ins.playAudio(Duration(minutes: 2), "assets/" + url2);
                // sliderInitial=0.0;
                changeIndex(changeIndex: true);
                pageController.nextPage(
                    duration: Duration(milliseconds: 100), curve: Curves.linear);
                print("IF URL __$url1");
              }

            }

            if (mounted) {
              setState(() {});
            }
          }
          else {
            ins.stop();

            sliderInitial = 0.0;
            sliderEnd = 120.0;
            selectedTime = 0;
            setDuration = 0;
            check=true;

            if (mounted) {
              String url = ref.watch(addProvider).musicList[index].musicFile;
              await ins.playAudio(Duration(minutes: 2), "assets/" + url);
              // sliderInitial=0.0;
              print("else URL __$url");
            }

            if (mounted) {
              setState(() {});
            }
          }
          if (!mounted) {
            timer.cancel();
            return;
          }
        }
      });

    });
  }

  @override
  void didChangeDependencies() {
    initialization();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }



  Future<void> brightNess() async {
    try {
      brightness = await FlutterScreenWake
          .brightness; //get the current screen brightness
      if (brightness > 1) {
        brightness = brightness / 10;
      }
      print(brightness);
      setState(() {
        brightness = brightness;
      });
    } on PlatformException {
      brightness = 0.0;
    }
    if (!mounted) return;
  }


  initialization() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      musicIndex = ref
          .read(mixMusicProvider)
          .combinationList
          .indexWhere((element) => element.id == widget.mixMusicModelId);
      print("music index $musicIndex");
      if (mounted) {
        setState(() {});
      }
      checkMounted();
    });
  }

  changeIndex({bool changeIndex = false}) {
    if (changeIndex) {
      musicIndex =
          (musicIndex + 1) % ref.watch(mixMusicProvider).combinationList.length;
    } else {
      musicIndex = (musicIndex - 1);
      if (musicIndex < 0) {
        musicIndex = ref.watch(mixMusicProvider).combinationList.length - 1;
      }
    }
    /*if(mounted){
        musicList = [];
        musicList.add(ref.watch(mixMusicProvider).combinationList[musicIndex].first!);
        musicList.add(ref.watch(mixMusicProvider).combinationList[musicIndex].second!);
        index = 0;
        setState((){});
      }*/
  }

  pausePlayMethod() async {
    if (ins.isPlaying()) {
      await ins.stop();

      pauseSliderTimmer();
    } else {
      if(check==true){
        String url1 = ref
            .watch(mixMusicProvider)
            .combinationList[musicIndex]
            .first
            ?.musicFile ??
            "";
        String url2 = ref
            .watch(mixMusicProvider)
            .combinationList[musicIndex]
            .second
            ?.musicFile ??
            "";
        // print("${audioPlayer1.getDuration().then((value) => print("duration value$value"))}");
        // await audioPlayer1.play(AssetSource(url1));
        await ins.playAudio(Duration(hours: 10), "assets/" + url1);
        // await audioPlayer2.play(AssetSource(url2));
        await ins.playAudio(Duration(hours: 10), "assets/" + url2);
        resumeSliderTimmer();
        print("play");
      }else{
        String url1 = ref
            .watch(mixMusicProvider)
            .combinationList[musicIndex]
            .first
            ?.musicFile ??
            "";
        String url2 = ref
            .watch(mixMusicProvider)
            .combinationList[musicIndex]
            .second
            ?.musicFile ??
            "";
        // print("${audioPlayer1.getDuration().then((value) => print("duration value$value"))}");
        // await audioPlayer1.play(AssetSource(url1));
        await ins.playAudio(Duration(minutes: 2), "assets/" + url1);
        // await audioPlayer2.play(AssetSource(url2));
        await ins.playAudio(Duration(minutes: 2), "assets/" + url2);
        resumeSliderTimmer();
        print("play");
      }




    }
    if (mounted) {
      setState(() {});
    }
  }

  // playMusic() async {
  //   String url1 = ref
  //           .watch(mixMusicProvider)
  //           .combinationList[musicIndex]
  //           .first
  //           ?.musicFile ??
  //       "";
  //   String url2 = ref
  //           .watch(mixMusicProvider)
  //           .combinationList[musicIndex]
  //           .second
  //           ?.musicFile ??
  //       "";
  //   // await audioPlayer1.play(AssetSource(url1));
  //   await ins.playAudio(Duration(minutes: 2), "assets/" + url1);
  //   // await audioPlayer2.play(AssetSource(url2));
  //   await ins.playAudio(Duration(minutes: 2), "assets/" + url2);
  //   if (mounted) {
  //     setState(() {});
  //   }
  // }

  checkMounted() async {
    if (mounted) {
      setState(() {});
      pausePlayMethod();
    }
    print("duration2 ${_duration2.inSeconds}  duration${_duration.inSeconds}");
  }

  @override
  Widget build(BuildContext context) {
    final height = ScreenSize(context).height;
    final width = ScreenSize(context).width;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          title: 'Mix sound playing',
          iconButton: false,
          onPressedButton: null,
          onPressed: widget.onPressed,
        ),
        body: PageView.builder(
          onPageChanged: (int index) {
            changeIndex(changeIndex: true);
            if (mounted) {
              // playMusic();
            }
            if (mounted) {
              setState(() {});
            }
          },
          controller: pageController,
          itemCount: ref.watch(mixMusicProvider).combinationList.length,
          itemBuilder: (_, index) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: () {
                            _showDialogBrightNess(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.only(right: width * .07),
                            child: CustomImage(
                              imageUrl:
                              'asset/images/icon_png/now_playing_icon/Sun.png',
                              color: Colors.orangeAccent.shade100,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: CustomImage(
                              imageUrl: ref
                                  .watch(mixMusicProvider)
                                  .combinationList[musicIndex]
                                  .first
                                  ?.image ??
                                  "",
                              // height: width * .7,
                              // width: width * .5,
                              // boxFit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: CustomImage(

                              imageUrl: ref
                                  .watch(mixMusicProvider)
                                  .combinationList[musicIndex]
                                  .second
                                  ?.image ??
                                  "",
                              // height: width * .7,
                              // width: width * .4,
                              // boxFit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                  SizedBox(height: 30,),
                  Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text:
                                  "${ref.watch(mixMusicProvider).combinationList[musicIndex].first?.musicName}+${ref.watch(mixMusicProvider).combinationList[musicIndex].second?.musicName}",
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: secondaryBlackColor,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: width * 0.07),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            _showDialogVolume(context);
                          },
                          child: Row(
                            children: [
                              Container(
                                  color: Colors.transparent,
                                  child: const CustomSvg(
                                      svg: volume, color: blackColor2)),
                              SizedBox(width: 6,),
                              Text("Set Volume",style: TextStyle(
                                fontWeight: FontWeight.w500
                              ),),
                              // GestureDetector(
                              //     onTap: () {
                              //       ref.read(addProvider).addOrRemovePlayList(
                              //           id: ref.watch(addProvider).musicList[index].id);
                              //     },
                              //     child: CustomImage(
                              //       imageUrl: 'asset/images/icon_png/love.png',
                              //       color: ref.watch(addProvider).playListIds.contains(
                              //           ref.watch(addProvider).musicList[index].id)
                              //           ? Colors.red
                              //           : blackColorA0,
                              //     )),
                              // const SizedBox(
                              //   width: 10,
                              // ),

                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            _showDialog(context);
                          },
                          child: Row(
                            children: [
                              Container(
                                  color: Colors.transparent,
                                  child: CustomSvg(
                                    svg: timer,
                                    color: blackColor2,
                                  )),
                              // const CustomImage(
                              //   imageUrl: 'asset/images/icon_png/another_sound.png',
                              //   color: blackColorA0,
                              // ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text("Set Timer",style: TextStyle(
                                  fontWeight: FontWeight.w500
                              ),),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: width * 0.1),
                  if(check==true)...[
                    Container()
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       CustomText(
                    //         text: '${getHumanTimeBySecond(sliderInitial.toInt())}',
                    //         fontSize: 10,
                    //         color: blackColor2,
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //       CustomText(
                    //         text: '${getHumanTimeBySecond(sliderEnd.toInt())}',
                    //         fontSize: 10,
                    //         color: blackColor2,
                    //         fontWeight: FontWeight.w700,
                    //       ),
                    //     ],
                    //   ),
                    // ),

                  ]else...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomText(
                            text: '${getHumanTimeBySecond(sliderInitial.toInt())}',
                            fontSize: 10,
                            color: blackColor2,
                            fontWeight: FontWeight.w700,
                          ),
                          CustomText(
                            text: '${getHumanTimeBySecond(sliderEnd.toInt())}',
                            fontSize: 10,
                            color: blackColor2,
                            fontWeight: FontWeight.w700,
                          ),
                        ],
                      ),
                    ),
                  ],
                  if(check==true)...[
                    Visibility(
                      visible: false,
                      child: SizedBox(
                        //color: Colors.green,
                        width: width * .95,
                        child: SliderTheme(
                          data: const SliderThemeData(
                              trackShape: RectangularSliderTrackShape(),
                              thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 10)),
                          child: Slider(
                              value: 0.0,
                              min: 0.0,
                              max: 30000000000000000.0,
                              divisions: 40000000000000000,
                              activeColor: primaryPinkColor,
                              inactiveColor: primaryGreyColor2,
                              onChanged: (double newValue) async {
                                print("slider");
                                // updateSlider(newValue);
                                // ins.seek(Duration(
                                //     seconds: (sliderEnd - sliderInitial).toInt()));
                                // setState(() {});
                              },
                              semanticFormatterCallback: (double newValue) {
                                return '${newValue.round()} dollars';
                              }),
                        ),
                      ),
                    ),

                  ]else...[
                    SizedBox(
                      //color: Colors.green,
                      width: width * .95,
                      child: SliderTheme(
                        data: const SliderThemeData(
                            trackShape: RectangularSliderTrackShape(),
                            thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 10)),
                        child: Slider(
                            value: sliderInitial <= sliderEnd
                                ? sliderInitial
                                : sliderEnd,
                            min: 0.0,
                            max: sliderEnd,
                            divisions: 350,
                            activeColor: primaryPinkColor,
                            inactiveColor: primaryGreyColor2,
                            onChanged: (double newValue) async {
                              print("slider");
                              updateSlider(newValue);
                              ins.seek(Duration(
                                  seconds: (sliderEnd - sliderInitial).toInt()));
                              setState(() {});
                            },
                            semanticFormatterCallback: (double newValue) {
                              return '${newValue.round()} dollars';
                            }),
                      ),
                    ),

                  ],

                  Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                changeIndex(changeIndex: false);
                                selectedTime = 0;
                                setDuration = 0;
                                check=true;
                                if (mounted) {
                                  if(check==true){

                                    await ins.stop();
                                    String url1 = ref
                                        .watch(mixMusicProvider)
                                        .combinationList[musicIndex]
                                        .first
                                        ?.musicFile ??
                                        "";
                                    String url2 = ref
                                        .watch(mixMusicProvider)
                                        .combinationList[musicIndex]
                                        .second
                                        ?.musicFile ??
                                        "";
                                    // await audioPlayer1.play(AssetSource(url1));
                                    await ins.playAudio(Duration(hours: 10), "assets/" + url1);
                                    // await audioPlayer2.play(AssetSource(url2));
                                    await ins.playAudio(Duration(hours: 10), "assets/" + url2);
                                    sliderInitial = 0.0;
                                    sliderEnd = 522222222220.0;
                                  }else{

                                    await ins.stop();
                                    String url1 = ref
                                        .watch(mixMusicProvider)
                                        .combinationList[musicIndex]
                                        .first
                                        ?.musicFile ??
                                        "";
                                    String url2 = ref
                                        .watch(mixMusicProvider)
                                        .combinationList[musicIndex]
                                        .second
                                        ?.musicFile ??
                                        "";
                                    // await audioPlayer1.play(AssetSource(url1));
                                    await ins.playAudio(Duration(minutes: 2), "assets/" + url1);
                                    // await audioPlayer2.play(AssetSource(url2));
                                    await ins.playAudio(Duration(minutes: 2), "assets/" + url2);
                                    if (mounted) {
                                      setState(() {});
                                    }
                                    sliderInitial = 0.0;
                                    sliderEnd = 120.0;
                                  }

                                }

                                if (mounted) {
                                  setState(() {});
                                }
                              },
                              icon: const CustomSvg(
                                  svg: left_shift, color: primaryPinkColor)),
                          GestureDetector(
                            onTap: ()async{
                              // if (ins.isPlaying()) {
                              //   await ins.stop();
                              //   // await audioPlayer2.pause();
                              //   pauseSliderTimmer();
                              // } else {
                              //   String url1 = ref
                              //       .watch(mixMusicProvider)
                              //       .combinationList[musicIndex]
                              //       .first
                              //       ?.musicFile ??
                              //       "";
                              //   String url2 = ref
                              //       .watch(mixMusicProvider)
                              //       .combinationList[musicIndex]
                              //       .second
                              //       ?.musicFile ??
                              //       "";
                              //   //   await audioPlayer1.play(AssetSource(url1));
                              //   await ins.playAudio(
                              //       Duration(minutes: 2), "assets/" + url1);
                              //   // await audioPlayer2.play(AssetSource(url2));
                              //   await ins.playAudio(
                              //       Duration(minutes: 2), "assets/" + url2);
                              //   resumeSliderTimmer();
                              // }
                              // playPouse = !playPouse;
                              // if (mounted) {
                              //   setState(() {});
                              // }
                              // setState(() {});
                              if (ins.isPlaying()) {
                                if (mounted) {
                                  playPouse = false;
                                }
                                ins.stop();
                                pauseSliderTimmer();
                                print("pause solution");
                              } else {
                                if (mounted) {
                                  playPouse = true;
                                }
                                String url = ref
                                    .watch(addProvider)
                                    .musicList[index]
                                    .musicFile;
                                //await audioPlayer.play(AssetSource(url));
                                print("play");
                                resumeSliderTimmer();
                                //  ins.silenceIncomingCalls();
                                if(check==true){
                                  String url1 = ref
                                      .watch(mixMusicProvider)
                                      .combinationList[musicIndex]
                                      .first
                                      ?.musicFile ??
                                      "";
                                  String url2 = ref
                                      .watch(mixMusicProvider)
                                      .combinationList[musicIndex]
                                      .second
                                      ?.musicFile ??
                                      "";
                                  //   await audioPlayer1.play(AssetSource(url1));
                                  await ins.playAudio(
                                      Duration(hours: 10), "assets/" + url1);
                                  // await audioPlayer2.play(AssetSource(url2));
                                  await ins.playAudio(
                                      Duration(hours: 10), "assets/" + url2);
                                  resumeSliderTimmer();
                                }else{
                                  String url1 = ref
                                      .watch(mixMusicProvider)
                                      .combinationList[musicIndex]
                                      .first
                                      ?.musicFile ??
                                      "";
                                  String url2 = ref
                                      .watch(mixMusicProvider)
                                      .combinationList[musicIndex]
                                      .second
                                      ?.musicFile ??
                                      "";
                                  //   await audioPlayer1.play(AssetSource(url1));
                                  await ins.playAudio(
                                      Duration(minutes: 2), "assets/" + url1);
                                  // await audioPlayer2.play(AssetSource(url2));
                                  await ins.playAudio(
                                      Duration(minutes: 2), "assets/" + url2);
                                  resumeSliderTimmer();
                                }
                                playPouse = !playPouse;
                                if (mounted) {
                                  setState(() {});
                                }
                                //  ins.silenceIncomingCalls();
                              }
                              setState(() {});
                            },
                            child: Container(
                              // color: Colors.red,
                              height: width * 0.18,
                              width: width * 0.18,
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  color: secondaryWhiteColor2,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.transparent, width: 0),
                                  boxShadow: const [
                                    BoxShadow(
                                        blurRadius: 10,
                                        color: secondaryWhiteColor2)
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(22),
                                child: CustomSvg(
                                  color: primaryPinkColor,
                                  svg: ins.isPlaying()
                                      ? pouseButton
                                      : playButtonSvg,
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () async {
                                changeIndex(changeIndex: true);
                                selectedTime = 0;
                                setDuration = 0;
                                check=true;
                                if (mounted) {


                                  await ins.stop();
                                  if(check==true){
                                    String url1 = ref
                                        .watch(mixMusicProvider)
                                        .combinationList[musicIndex]
                                        .first
                                        ?.musicFile ??
                                        "";
                                    String url2 = ref
                                        .watch(mixMusicProvider)
                                        .combinationList[musicIndex]
                                        .second
                                        ?.musicFile ??
                                        "";
                                    // await audioPlayer1.play(AssetSource(url1));
                                    await ins.playAudio(Duration(hours: 10), "assets/" + url1);
                                    // await audioPlayer2.play(AssetSource(url2));
                                    await ins.playAudio(Duration(hours: 10), "assets/" + url2);
                                    if (mounted) {
                                      setState(() {});
                                    }
                                    sliderInitial = 0.0;
                                    sliderEnd = 522222222220.0;
                                  }else{
                                    String url1 = ref
                                        .watch(mixMusicProvider)
                                        .combinationList[musicIndex]
                                        .first
                                        ?.musicFile ??
                                        "";
                                    String url2 = ref
                                        .watch(mixMusicProvider)
                                        .combinationList[musicIndex]
                                        .second
                                        ?.musicFile ??
                                        "";
                                    // await audioPlayer1.play(AssetSource(url1));
                                    await ins.playAudio(Duration(minutes: 2), "assets/" + url1);
                                    // await audioPlayer2.play(AssetSource(url2));
                                    await ins.playAudio(Duration(minutes: 2), "assets/" + url2);
                                    if (mounted) {
                                      setState(() {});
                                    }
                                    sliderInitial = 0.0;
                                    sliderEnd = 120.0;
                                  }



                                  // selected timer....


                                }

                                if (mounted) {
                                  setState(() {});
                                }
                                // changeIndex(changeIndex: true);
                                // sliderInitial = 0.0;
                                // selectedTime = 0;
                                // setDuration = 0;
                                // check=true;
                                // if (mounted) {
                                //   playMusic();
                                //   sliderInitial = 0.0;
                                //   sliderEnd = 120.0;
                                // }
                                // if (mounted) {
                                //   setState(() {});
                                // }
                              },
                              icon: const CustomSvg(
                                  svg: right_shift, color: primaryPinkColor)),

                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  void _showDialogBrightNess(BuildContext context) {
    final height = ScreenSize(context).height;
    final width = ScreenSize(context).width;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context,
              void Function(void Function()) updateState) {
            return Align(
              alignment: Alignment.topCenter,
              child: Wrap(
                children: [
                  Container(
                    color: Colors.transparent,
                    height: width * 0.24,
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      backgroundColor: Colors.white,
                      contentPadding: EdgeInsets.zero,
                      content: SizedBox(
                        height: width * 0.25,
                        child: Row(
                          children: [
                            Expanded(
                              child: SliderTheme(
                                data: const SliderThemeData(
                                    trackShape: RectangularSliderTrackShape(),
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 10)),
                                child: Slider(
                                    value: brightness,
                                    min: 0.0,
                                    max: 1.0,
                                    divisions: 100,
                                    activeColor: primaryPinkColor,
                                    inactiveColor: primaryGreyColor2,
                                    onChanged: (double newValue) async {
                                      updateState(() {
                                        // Screen.setBrightness(newValue);
                                        brightness = newValue;
                                        print("$brightness");
                                      });
                                      await ScreenBrightness()
                                          .setScreenBrightness(brightness);
                                    },
                                    semanticFormatterCallback:
                                        (double newValue) {
                                      return '${newValue.round()} dollars';
                                    }),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Container(
                                color: Colors.transparent,
                                height: width * 0.1,
                                child: const CustomImage(
                                  boxFit: BoxFit.fill,
                                  imageUrl:
                                  'asset/images/icon_png/now_playing_icon/Sun.png',
                                  color: primaryPinkColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
                                  max: 100.0,
                                  divisions: 100,
                                  activeColor: primaryPinkColor,
                                  inactiveColor: primaryGreyColor2,
                                  onChanged: (double newValue) async {
                                    updateState(() {
                                      // Screen.setBrightness(newValue);
                                      currentVolume = newValue;
                                      print("volume $currentVolume");
                                    });
                                    // await ins.setVolume(0.5);

                                    ins.setVolume(currentVolume * 0.01);
                                    // await PerfectVolumeControl.setVolume(currentVolume);
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
                                            "${(currentVolume).toInt().toString().padLeft(2, "0")}%",
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
                                    selectedTime = newValue.toInt();
                                    setDuration = selectedTimes[selectedTime];

                                    setDuration *= 60;
                                    setSongDuration(setDuration);
                                    ins.seek(Duration(seconds: setDuration));
                                    print("index 111 $setDuration");
                                    print(
                                        "index 222 ${selectedTimes[selectedTime]}");
                                    if (selectedTimes[selectedTime] == 0) {
                                      check = true;
                                      sliderEnd = 120.0;
                                    } else {
                                      check = false;
                                    }
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
                                fontSize: 19,
                                fontWeight: FontWeight.w400,
                                color: primaryGreyColor,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 38.0),
                          child: Center(
                            child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                  color: primaryPinkColor,
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                "OK",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
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
        ins.stop();
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
    if(check==true){
      setSongDuration(4554545445545454, initValue: sliderInitial);

    }else{
      setSongDuration(sliderEnd.toInt(), initValue: sliderInitial);

    }
  }
}
