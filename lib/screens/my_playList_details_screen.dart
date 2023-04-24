import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_image.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_svg.dart';
import 'package:bye_bye_cry_new/local_db/local_db.dart';
import 'package:bye_bye_cry_new/screens/models/music_models.dart';
import 'package:bye_bye_cry_new/screens/provider/mix_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/playlistProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:screen_brightness/screen_brightness.dart';
import '../compoment/bottom_sheet.dart';
import '../compoment/shared/custom_app_bar.dart';
import '../compoment/shared/custom_text.dart';
import '../compoment/shared/screen_size.dart';
import '../compoment/utils/color_utils.dart';
import '../compoment/utils/image_link.dart';
AudioPlayer audioPlayer1 = AudioPlayer();
class PlaylistMixSound2 extends ConsumerStatefulWidget {
  final String? playlistMixMusicId;
  final VoidCallback? onPressed;
  const PlaylistMixSound2(
      {Key? key, required this.playlistMixMusicId, this.onPressed})
      : super(key: key);

  @override
  ConsumerState<PlaylistMixSound2> createState() => _PlaylistMixSound2State();
}

class _PlaylistMixSound2State extends ConsumerState<PlaylistMixSound2>
    with TickerProviderStateMixin {
  double? Savetimer;
  double? Savetimer2;
  double? Savetimer3;

  getTimer() async {
    await LocalDB().getTimer().then((value) {
      setState(() {
        Savetimer = double.parse(value) * 60;

        print("Val_111_${Savetimer}");
      });
    });
  }

  getTimer2() async {
    await LocalDB().getTimer2().then((value) {
      setState(() {
        Savetimer2 = double.parse(value) * 60;

        print("Val_111_${Savetimer2}");
      });
    });
  }

  getTimer3() async {
    await LocalDB().getTimer3().then((value) {
      setState(() {
        Savetimer3 = double.parse(value) * 60;

        print("Val_111_${Savetimer3}");
      });
    });
  }

  double? volume1;
  double? volume2;
  double? volume3;

  getVol1() async {
    await LocalDB().getVolume().then((value) {
      setState(() {
        volume1 = double.parse(value);

        print("Volume${volume1}");
      });
    });
  }

  getVol2() async {
    await LocalDB().getVolume2().then((value) {
      setState(() {
        volume2 = double.parse(value);

        print("Volume 2${volume2}");
      });
    });
  }

  getVol3() async {
    await LocalDB().getVolume3().then((value) {
      setState(() {
        volume3 = double.parse(value);

        print("Volume 3 ${volume3}");
      });
    });
  }

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
  int selectedTime = 0;
  bool playPouse = true;
  int setDuration = 0;
  int mixPlaylistIndex = 0;
  AudioCache audioCache = AudioCache();

  // AudioPlayer audioPlayer2 = AudioPlayer();
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  Duration _duration2 = Duration.zero;
  Duration _position2 = Duration.zero;
  Duration position = Duration.zero;
  Duration duration = Duration.zero;
  // double currentVolume = 0.0;
  bool issongplaying1 = false;
  bool issongplaying2 = false;
  double brightness = 0.5;
  late StreamSubscription<double> _subscription;
  int musicIndex = 0;
  List<MusicModel> musicList = [];
  bool check = true;
  TextEditingController minController = TextEditingController();
  TextEditingController secController = TextEditingController();

  @override
  void initState() {
    getTimer();
    getTimer2();
    getTimer3();
    getVol1();
    getVol2();
    getVol3();
    startPlayer1();
    startPlayer2();
    //changeVolume();
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) async {
      // if(sliderTimer==120.0|| sliderInitial==120.0){
      //   timer.cancel();
      // }
      if (sliderInitial.toInt() == (Savetimer! - 1).toInt() ||
          sliderInitial == 120.0 ||
          sliderInitial.toInt() == (Savetimer2! - 1).toInt() ||
          sliderInitial == 120.0 ||
          sliderInitial.toInt() == (Savetimer3! - 1).toInt() ||
          sliderInitial == 120.0) {
        print("play next================");
        if(check==false) {
          changeIndex(changeIndex: true);
          pageController.nextPage(
              duration: Duration(milliseconds: 100), curve: Curves.linear);
          changeIndex(changeIndex: true);

          sliderInitial = 0.0;

          if (mounted) {
            String url = ref
                .watch(playlistProvider)
                .mixMixPlaylist[mixPlaylistIndex]
                .playListList![musicIndex]
                .first!
                .musicFile;
            await audioPlayer1.play(AssetSource(url));
            sliderInitial = 0.0;
          }

          if (mounted) {
            setState(() {});
          }
        }else{
          audioPlayer1.stop();

          sliderInitial = 0.0;

          if (mounted) {
            String url = ref
                .watch(playlistProvider)
                .mixMixPlaylist[mixPlaylistIndex]
                .playListList![musicIndex]
                .first!
                .musicFile;
            await audioPlayer1.play(AssetSource(url));
            sliderInitial = 0.0;
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
  }

  @override
  void didChangeDependencies() {
    initialization();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    audioPlayer1.dispose();
    //_subscription.cancel();
    super.dispose();
  }

  // changeVolume() {
  //   PerfectVolumeControl.hideUI = true;
  //   Future.delayed(Duration.zero, () async {
  //     currentVolume = await PerfectVolumeControl.getVolume();
  //     setState(() {
  //       //refresh UI
  //     });
  //   });
  //   _subscription = PerfectVolumeControl.stream.listen((volume) {
  //     currentVolume = volume;
  //     if (mounted) {
  //       print('sound $currentVolume');
  //       setState(() {});
  //     }
  //   });
  // }

  startPlayer1() async {
    audioPlayer1.onPlayerStateChanged.listen((state) {
      issongplaying1 = state == PlayerState.playing;
      if (!issongplaying1 || !issongplaying2) {
        if (setDuration > 0) {
          setDuration -= _duration.inSeconds;
          if (mounted) {
            pausePlayMethod();
            if (mounted) {
              setState(() {});
            }
          }
        }
      }
      if (mounted) {
        setState(() {});
      }
    });
    audioPlayer1.onDurationChanged.listen((newDuration) {
      _duration = newDuration;

      if (mounted) {
        setState(() {});
      }
    });
    audioPlayer1.onPositionChanged.listen((newPositions) {
      _position = newPositions;
      if (mounted) {
        setState(() {});
      }
    });
    if (mounted) {
      setState(() {});
    }
  }

  startPlayer2() async {
    // audioPlayer2.onPlayerStateChanged.listen((state) {
    //   issongplaying2 = state == PlayerState.playing;
    //   if (!issongplaying1 || !issongplaying2) {
    //     if (setDuration > 0) {
    //       setDuration -= _duration.inSeconds;
    //       if (mounted) {
    //         pausePlayMethod();
    //       }
    //       if (mounted) {
    //         setState(() {});
    //       }
    //     }
    //   }
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });
    // audioPlayer2.onDurationChanged.listen((newDuration) {
    //   _duration2 = newDuration;
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });
    // audioPlayer2.onPositionChanged.listen((newPositions) {
    //   _position2 = newPositions;
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });
    if (mounted) {
      setState(() {});
    }
  }

  initialization() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      mixPlaylistIndex = ref
          .watch(playlistProvider)
          .mixMixPlaylist
          .indexWhere((element) => element.id == widget.playlistMixMusicId);
      if (mounted) {
        setState(() {});
      }
      checkMounted();
    });
  }

  changeIndex({bool changeIndex = false}) {
    if (changeIndex) {
      musicIndex = (musicIndex + 1) %
          ref
              .watch(playlistProvider)
              .mixMixPlaylist[mixPlaylistIndex]
              .playListList!
              .length;
    } else {
      musicIndex = (musicIndex - 1);
      if (musicIndex < 0) {
        musicIndex = ref
            .watch(playlistProvider)
            .mixMixPlaylist[mixPlaylistIndex]
            .playListList!
            .length -
            1;
      }
    }
  }

  pausePlayMethod() async {
    if (issongplaying1 || issongplaying2) {
      await audioPlayer1.pause();

      ///await audioPlayer2.pause();
      pauseSliderTimmer();
    } else {
      String url1 = ref
          .watch(playlistProvider)
          .mixMixPlaylist[mixPlaylistIndex]
          .playListList![musicIndex]
          .first
          ?.musicFile ??
          "";

      await audioPlayer1.play(AssetSource(url1));

      resumeSliderTimmer();
    }
    if (mounted) {
      setState(() {});
    }
  }

  playMusic() async {
    String url1 = ref
        .watch(playlistProvider)
        .mixMixPlaylist[mixPlaylistIndex]
        .playListList![musicIndex]
        .first
        ?.musicFile ??
        "";

    await audioPlayer1.play(AssetSource(url1));

    sliderInitial = 0.0;
    if (mounted) {
      setState(() {});
      //resumeSliderTimmer();
    }
  }

  checkMounted() async {
    if (mounted) {
      setState(() {});
      pausePlayMethod();
    }
    print("duration2 ${_duration2.inSeconds}  duration${_duration.inSeconds}");
  }

  playMusicForBottomSheet(
      {required String id,
        required Function(void Function()) updateState}) async {
    print("playlist play button click");
    int _index = ref
        .watch(playlistProvider)
        .mixMixPlaylist[mixPlaylistIndex]
        .playListList!
        .indexWhere((element) => element.id == id);
    if (_index >= 0) {
      if (_index == musicIndex) {
        if (issongplaying1) {
          await audioPlayer1.pause();
        } else {
          String url1 = ref
              .watch(playlistProvider)
              .mixMixPlaylist[mixPlaylistIndex]
              .playListList![_index]
              .first
              ?.musicFile ??
              "";
          String url2 = ref
              .watch(playlistProvider)
              .mixMixPlaylist[mixPlaylistIndex]
              .playListList![_index]
              .second
              ?.musicFile ??
              "";
          await audioPlayer1.play(AssetSource(url1));
        }
      } else {
        musicIndex = _index;
        String url1 = ref
            .watch(playlistProvider)
            .mixMixPlaylist[mixPlaylistIndex]
            .playListList![_index]
            .first
            ?.musicFile ??
            "";
        String url2 = ref
            .watch(playlistProvider)
            .mixMixPlaylist[mixPlaylistIndex]
            .playListList![_index]
            .second
            ?.musicFile ??
            "";
        await audioPlayer1.play(AssetSource(url1));
      }
    }
    if (mounted) {
      updateState(() {});
      setState(() {});
    }
  }

  PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final height = ScreenSize(context).height;
    final width = ScreenSize(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title:
        '${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].title}',
        iconButton: false,
        onPressedButton: null,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body: PageView.builder(
        padEnds: false,
        controller: pageController,
        onPageChanged: (value) async {
          changeIndex(changeIndex: true);
          if (mounted) {
            playMusic();
          }
          if (mounted) {
            setState(() {});
          }
          // // setState(() {
          // //   musicIndex = value;
          // //   print("Music List ===${musicIndex}");
          // // });
          //
          // pageController.animateToPage(
          //   value,
          //     duration: Duration(seconds: 1), curve: Curves.easeIn);
        },
        itemCount: ref
            .watch(playlistProvider)
            .mixMixPlaylist[mixPlaylistIndex]
            .playListList!
            .length,
        itemBuilder: (context, index) {
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
                CustomImage(
                  imageUrl: ref
                      .watch(playlistProvider)
                      .mixMixPlaylist[mixPlaylistIndex]
                      .playListList![musicIndex]
                      .first
                      ?.image ??
                      "",
                  height: width * .7,
                  width: width * .9,
                  boxFit: BoxFit.fill,
                ),
                GestureDetector(
                  onTap: () {
                    // CustomBottomSheet.bottomSheet(context, isDismiss: true,
                    //     child: StatefulBuilder(
                    //   builder: (BuildContext context,
                    //       void Function(void Function()) updateState) {
                    //     // return bottomSheet(context: context);
                    //     return Container();
                    //   },
                    // ));
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: (){
                                CustomBottomSheet.bottomSheet(context, isDismiss: true,
                                    child: StatefulBuilder(
                                      builder: (BuildContext context,
                                          void Function(void Function()) updateState) {
                                        return bottomSheet(context: context);
                                      },
                                    ));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text:
                                    "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![musicIndex].first?.musicName}",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w400,
                                    color: secondaryBlackColor,
                                  ),
                                  const SizedBox(
                                      height: 8,
                                      child: CustomSvg(
                                        svg: down_arrow,
                                        color: blackColorA0,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(height: width * 0.1),

                SizedBox(height: 20,),

                Padding(
                  padding: EdgeInsets.only(bottom: 40,left: 30,right: 30),
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
                            SizedBox(width: 10,),

                            Text("Set Volume")

                          ],
                        ),
                      ),

                      InkWell(
                        onTap: (){
                          ref.read(mixMusicProvider).alertDialogStart();
                          if (mounted) {
                            setState(() {
                              check = false;
                              selectedTime = 0;
                            });
                            _showDialog(context);
                          }
                        },
                        child: Row(
                          children: [
                            Container(
                                    color: Colors.transparent,
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 8.0),
                                      child:
                                      CustomSvg(svg: timer, color: blackColor2),
                                    )),
                            SizedBox(width: 10,),

                            Text("Set Timer")

                          ],
                        ),
                      ),


                    ],
                  ),
                ),



                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: '${getHumanTimeBySecond(sliderInitial.toInt())} ',
                        fontSize: 10,
                        color: blackColor2,
                        fontWeight: FontWeight.w700,
                      ),
                      if (musicIndex == 0) ...[
                        CustomText(
                          text: Savetimer == 0.0
                              ? "2:00"
                              : '${getHumanTimeBySecond(Savetimer!.toInt())}',
                          fontSize: 10,
                          color: blackColor2,
                          fontWeight: FontWeight.w700,
                        ),
                      ] else if (musicIndex == 1) ...[
                        CustomText(
                          text: Savetimer2 == 0.0
                              ? "2:00"
                              : '${getHumanTimeBySecond(Savetimer2!.toInt())}',
                          fontSize: 10,
                          color: blackColor2,
                          fontWeight: FontWeight.w700,
                        ),
                      ] else if (musicIndex == 2) ...[
                        CustomText(
                          text: Savetimer3 == 0.0
                              ? "2:00"
                              : '${getHumanTimeBySecond(Savetimer3!.toInt())}',
                          fontSize: 10,
                          color: blackColor2,
                          fontWeight: FontWeight.w700,
                        ),
                      ]
                    ],
                  ),
                ),
                if (musicIndex == 0) ...[
                  SizedBox(
                    //color: Colors.green,
                    width: width * .95,
                    child: SliderTheme(
                      data: const SliderThemeData(
                          trackShape: RectangularSliderTrackShape(),
                          thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 10)),
                      child: Slider(
                          value: sliderInitial.floorToDouble(),
                          min: 0,
                          max: Savetimer == 0.0 ? 120.00 : Savetimer!,
                          divisions: 350,
                          activeColor: primaryPinkColor,
                          inactiveColor: primaryGreyColor2,
                          onChanged: (double newValue) async {
                            print("slider");
                            updateSlider(newValue.floorToDouble());
                            setState(() {});
                          },
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()} dollars';
                          }),
                    ),
                  ),
                ]
                else if (musicIndex == 1) ...[
                  SizedBox(
                    //color: Colors.green,
                    width: width * .95,
                    child: SliderTheme(
                      data: const SliderThemeData(
                          trackShape: RectangularSliderTrackShape(),
                          thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 10)),
                      child: Slider(
                          value: sliderInitial.floorToDouble(),
                          min: 0,
                          max: Savetimer2 == 0.0 ? 120.00 : Savetimer2!,
                          divisions: 350,
                          activeColor: primaryPinkColor,
                          inactiveColor: primaryGreyColor2,
                          onChanged: (double newValue) async {
                            print("slider");
                            updateSlider(newValue.floorToDouble());
                            setState(() {});
                          },
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()} dollars';
                          }),
                    ),
                  ),
                ] else if (musicIndex == 2) ...[
                  SizedBox(
                    //color: Colors.green,
                    width: width * .95,
                    child: SliderTheme(
                      data: const SliderThemeData(
                          trackShape: RectangularSliderTrackShape(),
                          thumbShape:
                          RoundSliderThumbShape(enabledThumbRadius: 10)),
                      child: Slider(
                          value: sliderInitial.floorToDouble(),
                          min: 0,
                          max: Savetimer3 == 0.0 ? 120.00 : Savetimer3!,
                          divisions: 350,
                          activeColor: primaryPinkColor,
                          inactiveColor: primaryGreyColor2,
                          onChanged: (double newValue) async {
                            print("slider");
                            updateSlider(newValue.floorToDouble());
                            setState(() {});
                          },
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()} dollars';
                          }),
                    ),
                  ),
                ],

                // SizedBox(
                //   //color: Colors.green,
                //   width: width * .95,
                //   child: SliderTheme(
                //     data: const SliderThemeData(
                //         trackShape: RectangularSliderTrackShape(),
                //         thumbShape:
                //             RoundSliderThumbShape(enabledThumbRadius: 10)),
                //     child: Slider(
                //         value: _position.inSeconds.toDouble() >
                //                 _position2.inSeconds.toDouble()
                //             ? _position.inSeconds.toDouble()
                //             : _position2.inSeconds.toDouble(),
                //         min: 0,
                //         max: _duration.inSeconds.toDouble() >
                //                 _duration2.inSeconds.toDouble()
                //             ? _duration.inSeconds.toDouble()
                //             : _duration2.inSeconds.toDouble(),
                //         divisions: 100,
                //         activeColor: primaryPinkColor,
                //         inactiveColor: primaryGreyColor2,
                //         onChanged: (double newValue) async {
                //           print("aaaa${_duration.inSeconds}");
                //           print("nnnnn${_position.inSeconds}");
                //           if (newValue.toInt() <= _duration.inSeconds) {
                //             await audioPlayer1
                //                 .seek(Duration(seconds: newValue.toInt()));
                //           }
                //           if (newValue.toInt() <= _duration2.inSeconds) {
                //             await audioPlayer2
                //                 .seek(Duration(seconds: newValue.toInt()));
                //           }
                //           await audioPlayer1.resume();
                //           await audioPlayer2.resume();
                //           if (mounted) {
                //             setState(() {});
                //           }
                //         },
                //         semanticFormatterCallback: (double newValue) {
                //           return '${newValue.round()} dollars';
                //         }),
                //   ),
                // ),
                Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // IconButton(
                        //     padding: const EdgeInsets.only(left: 10),
                        //     onPressed: () {
                        //       _showDialogVolume(context);
                        //     },
                        //     icon: Container(
                        //         color: Colors.transparent,
                        //         child: const CustomSvg(
                        //             svg: volume, color: blackColor2))),
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              sliderInitial = 0.0;
                              changeIndex(changeIndex: false);
                              if (mounted) {
                                playMusic();
                                sliderInitial = 0.0;
                              }
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            icon: const CustomSvg(
                                svg: left_shift, color: primaryPinkColor)),
                        Container(
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
                                    blurRadius: 10, color: secondaryWhiteColor2)
                              ]),
                          child: GestureDetector(
                            onTap: () async {
                              if (playPouse) {
                                await audioPlayer1.pause();

                                pauseSliderTimmer();
                              } else {
                                String url1 = ref
                                    .watch(playlistProvider)
                                    .mixMixPlaylist[mixPlaylistIndex]
                                    .playListList![musicIndex]
                                    .first
                                    ?.musicFile ??
                                    "";
                                String url2 = ref
                                    .watch(playlistProvider)
                                    .mixMixPlaylist[mixPlaylistIndex]
                                    .playListList![musicIndex]
                                    .second
                                    ?.musicFile ??
                                    "";
                                await audioPlayer1.play(AssetSource(url1));
                                resumeSliderTimmer();
                              }
                              playPouse = !playPouse;

                              if (mounted) {
                                setState(() {});
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(22),
                              child: CustomSvg(
                                color: primaryPinkColor,
                                svg: (issongplaying1 || issongplaying2)
                                    ? pouseButton
                                    : playButtonSvg,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              sliderInitial = 0.0;
                              changeIndex(changeIndex: true);
                              if (mounted) {
                                playMusic();
                                sliderInitial = 0.0;
                                // sliderEnd = 120.0;
                              }
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            icon: const CustomSvg(
                                svg: right_shift, color: primaryPinkColor)),
                        // IconButton(
                        //     padding: EdgeInsets.zero,
                        //     onPressed: () {
                        //       ref.read(mixMusicProvider).alertDialogStart();
                        //       if (mounted) {
                        //         setState(() {
                        //           check = false;
                        //           selectedTime = 0;
                        //         });
                        //         _showDialog(context);
                        //       }
                        //     },
                        //     icon: Container(
                        //         color: Colors.transparent,
                        //         child: const Padding(
                        //           padding: EdgeInsets.symmetric(vertical: 8.0),
                        //           child:
                        //           CustomSvg(svg: timer, color: blackColor2),
                        //         ))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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
                              if (musicIndex == 0) ...[
                                Expanded(
                                  child: Slider(
                                    value: volume1!,
                                    min: 0.0,
                                    max: 100.0,
                                    divisions: 100,
                                    activeColor: primaryPinkColor,
                                    inactiveColor: primaryGreyColor2,
                                    onChanged: (double newValue) async {
                                      updateState(() {
                                        // Screen.setBrightness(newValue);
                                        volume1 = newValue;
                                      });
                                      await audioPlayer1.setVolume(volume1!);
                                    },
                                  ),
                                ),
                              ] else if (musicIndex == 1) ...[
                                Expanded(
                                  child: Slider(
                                    value: volume2!,
                                    min: 0.0,
                                    max: 100.0,
                                    divisions: 100,
                                    activeColor: primaryPinkColor,
                                    inactiveColor: primaryGreyColor2,
                                    onChanged: (double newValue) async {
                                      updateState(() {
                                        // Screen.setBrightness(newValue);
                                        volume2 = newValue;
                                      });
                                      await audioPlayer1.setVolume(volume2!);
                                    },
                                  ),
                                ),
                              ] else if (musicIndex == 2) ...[
                                Expanded(
                                  child: Slider(
                                    value: volume3!,
                                    min: 0.0,
                                    max: 100.0,
                                    divisions: 100,
                                    activeColor: primaryPinkColor,
                                    inactiveColor: primaryGreyColor2,
                                    onChanged: (double newValue) async {
                                      updateState(() {
                                        // Screen.setBrightness(newValue);
                                        volume3 = newValue;
                                      });
                                      await audioPlayer1.setVolume(volume3!);
                                    },
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (musicIndex == 0) ...[
                            Positioned(
                                right: width * 0.25,
                                top: 10,
                                child: Transform(
                                    transform: Matrix4.identity()
                                      ..rotateZ(90 * 3.1415927 / 180),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(2),
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
                                              text: "${volume1!.floor()}%",
                                              fontSize: 10,
                                              color: secondaryBlackColor,
                                              fontWeight: FontWeight.w600,
                                            )),
                                      ),
                                    )))
                          ] else if (musicIndex == 1) ...[
                            Positioned(
                                right: width * 0.25,
                                top: 10,
                                child: Transform(
                                    transform: Matrix4.identity()
                                      ..rotateZ(90 * 3.1415927 / 180),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(2),
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
                                              text: "${volume2!.floor()}%",
                                              fontSize: 10,
                                              color: secondaryBlackColor,
                                              fontWeight: FontWeight.w600,
                                            )),
                                      ),
                                    )))
                          ] else if (musicIndex == 2) ...[
                            Positioned(
                                right: width * 0.25,
                                top: 10,
                                child: Transform(
                                    transform: Matrix4.identity()
                                      ..rotateZ(90 * 3.1415927 / 180),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(2),
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
                                              text: "${volume3!.floor()}%",
                                              fontSize: 10,
                                              color: secondaryBlackColor,
                                              fontWeight: FontWeight.w600,
                                            )),
                                      ),
                                    )))
                          ],
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
                    title: Column(
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
                    contentPadding: EdgeInsets.zero,
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: width * 0.25,
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
                        // SliderTheme(
                        //   data: const SliderThemeData(
                        //       trackShape: RectangularSliderTrackShape(),
                        //       thumbShape: RoundSliderThumbShape(
                        //           enabledThumbRadius: 10)),
                        //   child: Slider.adaptive(
                        //       value: selectedTime.toDouble(),
                        //       min: 0,
                        //       max: 7,
                        //       divisions: 7,
                        //       activeColor: primaryPinkColor,
                        //       inactiveColor: primaryGreyColor2,
                        //       onChanged: (double newValue) async {
                        //         state(() {
                        //           setDuration = 1;
                        //           selectedTime = check ? 0 : newValue.toInt();
                        //           setDuration = selectedTimes[selectedTime];
                        //           setDuration *= 60;
                        //           print("index $selectedTime");
                        //         });
                        //         setState(() {});
                        //       },
                        //       semanticFormatterCallback: (double newValue) {
                        //         return '${newValue.round()} dollars';
                        //       }),
                        // ),
                        SliderTheme(
                          data: const SliderThemeData(
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
                              ))
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
                              width: 200,
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
            secController.text = "";
            minController.text = "";
            print("asche");
          });
        }
      }
    });
  }

  Widget bottomSheet({required BuildContext context}) {
    final width = ScreenSize(context).width;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      child: StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) updateState) {
          return Wrap(
            children: [
              Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: primaryPinkColor),
                                child: const Padding(
                                  padding: EdgeInsets.all(1.0),
                                  child: CustomImage(
                                    imageUrl: playButton,
                                    height: 30,
                                    width: 30,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomText(
                                        text:
                                        "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].title}",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                        color: blackColor50),
                                    // const SizedBox(height: 5),
                                    // Flexible(
                                    //     fit: FlexFit.loose,
                                    //     child: Container(
                                    //         color: Colors.transparent,
                                    //         width: width * 0.67,
                                    //         child: CustomText(
                                    //             text:
                                    //             "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![musicIndex].first?.musicName} + ${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![musicIndex].second?.musicName} is playing",
                                    //             fontWeight: FontWeight.w400,
                                    //             fontSize: 14,
                                    //             color: blackColor50)))
                                  ],
                                ),
                              )
                            ],
                          ),
                          // const CustomSvg(svg: arrow_foreword),
                        ],
                      ),
                    ),
                    Container(height: 2, color: blackColorD9),
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          primary: false,
                          itemCount: ref
                              .watch(playlistProvider)
                              .mixMixPlaylist[mixPlaylistIndex]
                              .playListList!
                              .length,
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      // CustomText(
                                      //     text: "Sound Set ${index + 1}",
                                      //     fontSize: 16,
                                      //     fontWeight: FontWeight.w600,
                                      //     color: blackColor50),
                                      SizedBox(height: width * 0.05),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                color: Colors.transparent,
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width: width * 0.44,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          SizedBox(
                                                              height:
                                                              width * 0.1,
                                                              width:
                                                              width * 0.1,
                                                              child:
                                                              CustomImage(
                                                                imageUrl:
                                                                "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![index].first?.image}",
                                                                boxFit:
                                                                BoxFit.fill,
                                                              )),
                                                          Expanded(
                                                            child: Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .all(
                                                                  10.0),
                                                              child: CustomText(
                                                                  text:
                                                                  "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![index].first?.musicName}",
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  color:
                                                                  blackColor50),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        const CustomSvg(
                                                            svg: volume),
                                                        if(musicIndex==0)...[
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                5.0),
                                                            child: CustomText(
                                                                text:
                                                                "${(volume1!).toInt().toString().padLeft(2, "0")}%",
                                                                fontSize: 12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                                color:
                                                                blackColor50),
                                                          ),
                                                        ]else if(musicIndex==1)...[

                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                5.0),
                                                            child: CustomText(
                                                                text:
                                                                "${(volume2!).toInt().toString().padLeft(2, "0")}%",
                                                                fontSize: 12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                                color:
                                                                blackColor50),
                                                          ),
                                                        ]else if(musicIndex==2)...[
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                5.0),
                                                            child: CustomText(
                                                                text:
                                                                "${(volume3!).toInt().toString().padLeft(2, "0")}%",
                                                                fontSize: 12,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w600,
                                                                color:
                                                                blackColor50),
                                                          ),
                                                        ],

                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // SizedBox(height: width * 0.03),
                                              // Container(
                                              //   color: Colors.transparent,
                                              //   child: Row(
                                              //     mainAxisAlignment:
                                              //     MainAxisAlignment.start,
                                              //     children: [
                                              //       SizedBox(
                                              //         width: width * 0.44,
                                              //         child: Row(
                                              //           mainAxisAlignment:
                                              //           MainAxisAlignment
                                              //               .start,
                                              //           children: [
                                              //             SizedBox(
                                              //                 height:
                                              //                 width * 0.1,
                                              //                 width:
                                              //                 width * 0.1,
                                              //                 child: CustomImage(
                                              //                     imageUrl:
                                              //                     "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![index].second?.image}",
                                              //                     boxFit: BoxFit
                                              //                         .fill)),
                                              //             Padding(
                                              //               padding:
                                              //               const EdgeInsets
                                              //                   .all(10.0),
                                              //               child: CustomText(
                                              //                   text:
                                              //                   "${ref.watch(playlistProvider).mixMixPlaylist[mixPlaylistIndex].playListList![index].second?.musicName}",
                                              //                   fontSize: 16,
                                              //                   fontWeight:
                                              //                   FontWeight
                                              //                       .w600,
                                              //                   color:
                                              //                   blackColor50),
                                              //             ),
                                              //           ],
                                              //         ),
                                              //       ),
                                              //       Row(
                                              //         mainAxisAlignment:
                                              //         MainAxisAlignment
                                              //             .start,
                                              //         children: [
                                              //           const CustomSvg(
                                              //               svg: volume),
                                              //           Padding(
                                              //             padding:
                                              //             const EdgeInsets
                                              //                 .symmetric(
                                              //                 horizontal:
                                              //                 5.0),
                                              //             child: CustomText(
                                              //                 text:
                                              //                 "${(currentVolume * 100).toInt().toString().padLeft(2, "0")}%",
                                              //                 fontSize: 12,
                                              //                 fontWeight:
                                              //                 FontWeight
                                              //                     .w600,
                                              //                 color:
                                              //                 blackColor50),
                                              //           ),
                                              //         ],
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          Row(
                                            children:  [
                                              CustomSvg(svg: timer),
                                              if(index==0)...[
                                                if(Savetimer==0.0)...[
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                    child: CustomText(
                                                      text: "2.00",

                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: primaryGreyColor,
                                                    ),
                                                  )
                                                ]else...[
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                    child: CustomText(
                                                      text: "${getHumanTimeBySecond(Savetimer!.toInt())}",

                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: primaryGreyColor,
                                                    ),
                                                  )
                                                ]
                                              ]else if(index==1)...[

                                                if(Savetimer2==0.0)...[
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                    child: CustomText(
                                                      text: "2.00",

                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: primaryGreyColor,
                                                    ),
                                                  )
                                                ]else...[
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                    child: CustomText(
                                                      text: "${getHumanTimeBySecond(Savetimer2!.toInt())}",

                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: primaryGreyColor,
                                                    ),
                                                  )
                                                ]
                                              ]else if(index==2)...[
                                                if(Savetimer3==0.0)...[
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                    child: CustomText(
                                                      text: "2.00",

                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: primaryGreyColor,
                                                    ),
                                                  )
                                                ]else...[
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                    child: CustomText(
                                                      text: "${getHumanTimeBySecond(Savetimer3!.toInt())}",

                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 12,
                                                      color: primaryGreyColor,
                                                    ),
                                                  )
                                                ]

                                              ],


                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              playMusicForBottomSheet(
                                                id: ref
                                                    .watch(playlistProvider)
                                                    .mixMixPlaylist[
                                                mixPlaylistIndex]
                                                    .playListList![index]
                                                    .id,
                                                updateState: updateState,
                                              );
                                              if (mounted) {
                                                updateState(() {});
                                              }
                                            },
                                            child: Container(
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.black
                                                        .withOpacity(0.1)),
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets.all(1.0),
                                                  child: ref
                                                      .watch(
                                                      playlistProvider)
                                                      .mixMixPlaylist[
                                                  mixPlaylistIndex]
                                                      .playListList![
                                                  index]
                                                      .id !=
                                                      ref
                                                          .watch(
                                                          playlistProvider)
                                                          .mixMixPlaylist[
                                                      mixPlaylistIndex]
                                                          .playListList![
                                                      musicIndex]
                                                          .id
                                                      ? const CustomImage(
                                                    imageUrl: playButton,
                                                    height: 30,
                                                    width: 30,
                                                    color: blackColor97,
                                                  )
                                                      : issongplaying1 ||
                                                      issongplaying2
                                                      ? const Padding(
                                                    padding:
                                                    EdgeInsets
                                                        .all(
                                                        10.0),
                                                    child: CustomSvg(
                                                        svg:
                                                        pouseButton,
                                                        height: 15,
                                                        width: 15,
                                                        color:
                                                        blackColor97),
                                                  )
                                                      : const CustomImage(
                                                    imageUrl:
                                                    playButton,
                                                    height: 30,
                                                    width: 30,
                                                    color:
                                                    blackColor97,
                                                  ),
                                                )),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  index <
                                      ref
                                          .watch(playlistProvider)
                                          .mixMixPlaylist[
                                      mixPlaylistIndex]
                                          .playListList!
                                          .length -
                                          1
                                      ? const SizedBox(height: 10)
                                      : const SizedBox(),
                                  index <
                                      ref
                                          .watch(playlistProvider)
                                          .mixMixPlaylist[
                                      mixPlaylistIndex]
                                          .playListList!
                                          .length -
                                          1
                                      ? Container(
                                    width: width,
                                    height: 1.5,
                                    color: blackColorD9,
                                  )
                                      : const SizedBox(),
                                  const SizedBox(height: 20)
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
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
  //var sliderEnd =120.0;

  Timer? sliderTimer;

  void setSongDuration(int setDuration, {double initValue = 0}) {
    sliderInitial = initValue;
    Savetimer = setDuration.toDouble();

    if (sliderTimer != null) {
      sliderTimer!.cancel();
    }
    sliderTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      print("Savetimer===========================");
      print(Savetimer);
      print(Savetimer2);
      print(Savetimer3);

      if (!mounted) {
        timer.cancel();
      }

      if (Savetimer == 0.0 || sliderInitial==120.0) {
        if (Savetimer! > sliderInitial) {
          timer.cancel();
          sliderInitial = 0.0;
          audioPlayer1.stop();
        }
      } else {
        if (Savetimer! <= sliderInitial) {
          timer.cancel();
          sliderInitial = 0.0;
          audioPlayer1.stop();
        }
      }

      if (Savetimer2 == 0.0 || sliderInitial==120.0) {
        if (Savetimer2! > sliderInitial) {
          timer.cancel();
          sliderInitial = 0.0;
          audioPlayer1.stop();
        }
      } else {
        if (Savetimer2! <= sliderInitial) {
          timer.cancel();
          sliderInitial = 0.0;
          audioPlayer1.stop();
        }
      }

      if (Savetimer3 == 0.0 || sliderInitial==120.0) {
        if (Savetimer3! > sliderInitial) {
          timer.cancel();
          sliderInitial = 0.0;
          audioPlayer1.stop();
        }
      } else {
        if (Savetimer3! <= sliderInitial) {
          timer.cancel();
          sliderInitial = 0.0;
          audioPlayer1.stop();
        }
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
    if (musicIndex == 0) {
      setSongDuration(Savetimer!.toInt(), initValue: sliderInitial);
    } else if (musicIndex == 1) {
      setSongDuration(Savetimer2!.toInt(), initValue: sliderInitial);
    } else if (musicIndex == 2) {
      setSongDuration(Savetimer3!.toInt(), initValue: sliderInitial);
    }
  }
}

