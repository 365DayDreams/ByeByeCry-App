import 'dart:async';
import 'package:bye_bye_cry_new/compoment/shared/custom_image.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_svg.dart';
import 'package:bye_bye_cry_new/local_db/local_db.dart';
import 'package:bye_bye_cry_new/main.dart';
import 'package:bye_bye_cry_new/screens/models/AppData.dart';
import 'package:bye_bye_cry_new/screens/models/music_models.dart';
import 'package:bye_bye_cry_new/screens/provider/add_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/mix_music_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screen_wake/flutter_screen_wake.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart' as justAudio;
import 'package:perfect_volume_control/perfect_volume_control.dart';
import '../compoment/shared/custom_text.dart';
import '../compoment/shared/screen_size.dart';
import '../compoment/utils/color_utils.dart';
import '../compoment/utils/image_link.dart';

bool check = true;
Timer? songTimer;

int selectedDuration = 120;
var sliderInitial = 0.0;
var sliderEnd = 120.0;
Timer? sliderTimer;

class SoundDetailsScreen extends ConsumerStatefulWidget {
  final String musicId;
  final VoidCallback? onPressed;

  const SoundDetailsScreen({Key? key, required this.musicId, this.onPressed})
      : super(key: key);

  @override
  ConsumerState<SoundDetailsScreen> createState() => _SoundDetailsScreenState();
}

class _SoundDetailsScreenState extends ConsumerState<SoundDetailsScreen>
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

  Duration _position = Duration.zero;
  Duration _slider = Duration(seconds: 0);
  double currentVolume = 50.0;
  bool issongplaying = false;
  double brightness = 0.5;
  late StreamSubscription<double> _subscription;
  int index = 0;
  int selectedTime = 0;

  bool playPouse = true;

  isOldSong() {
    print("ins.currentAudio()");
    print(widget.musicId);
    print(AppData.idCurrentMusic);

    var value = widget.musicId == AppData.idCurrentMusic;
    if (!value) {
      check = true;
    }
    return value;
  }

  @override
  void initState() {
    initialization();
    startPlayer();
    // audioPlayer1.dispose();
    super.initState();
    print('checkkking--$check');

    if (songTimer != null) {
      songTimer!.cancel();
    }
    songTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (check == true) {
        ins.seek(Duration(seconds: 120));
        setSongDuration(120, initValue: 0);
      }
    });

    print('checkkking--"rrrrrrrrrrrrrrrrrrr"');
  }

  @override
  void dispose() {
    try {
      _subscription.cancel();
    } catch (e) {
      // TODO
    }
    super.dispose();
  }

  List<MusicModel>? musicList;

  initialization() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

      musicList= ref
          .watch(addProvider)
          .musicList;

      int _index = ref
          .watch(addProvider)
          .musicList
          .indexWhere((element) => element.id == widget.musicId);
      if (_index >= 0) {
        index = _index;
        if (mounted) {
          if (!ins.isPlaying()) {
            pausePlayMethod();
          } else {
            if (isOldSong()) {
              resumeSliderTimmer();
            } else {
              check=true;
              ins.stop();
              pausePlayMethod();
              setSongDuration(120, initValue: 0);
            }
          }
          setState(() {});
        }
      }
    });
  }

  changeVolume() {
    PerfectVolumeControl.hideUI = true;
    Future.delayed(Duration.zero, () async {
      currentVolume = await PerfectVolumeControl.getVolume();
      setState(() {
        //refresh UI
      });
    });
    _subscription = PerfectVolumeControl.stream.listen((volume) {
      currentVolume = volume;
      if (mounted) {
        print('sound $currentVolume');
        setState(() {});
      }
    });
  }

  startPlayer() async {
    _position = _slider;

    //pausePlayMethod();

    /*  if (mounted) {
      setState(() {});
    }*/
  }

  pausePlayMethod() async {
    if (ins.isPlaying()) {
      await ins.stop();
      pauseSliderTimmer();
      print("pause");
    } else {
      if (check == true) {
        String url = ref.watch(addProvider).musicList[index].musicFile;

        ins.playAudio(Duration(hours: 8), "assets/$url");
        LocalDB.setCurrentPlayingMusic(
            title: ref.watch(addProvider).musicList[index].musicName,
            id: ref.watch(addProvider).musicList[index].id,
            type: "single");

        resumeSliderTimmer();
        print("play");
      } else {
        String url = ref.watch(addProvider).musicList[index].musicFile;

        ins.playAudio(Duration(minutes: 2), "assets/$url");
        LocalDB.setCurrentPlayingMusic(
            title: ref.watch(addProvider).musicList[index].musicName,
            id: ref.watch(addProvider).musicList[index].id,
            type: "single");

        resumeSliderTimmer();
        print("play");
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  changeIndex({bool changeIndex = false}) {
    print("change index");
    if (changeIndex) {
      index = (index + 1) % ref.watch(addProvider).musicList.length;
    } else {
      index = (index - 1);
      if (index < 0) {
        index = ref.watch(addProvider).musicList.length - 1;
      }
    }
    print('new index $index');
    if (mounted) {
      setState(() {});
    }
  }

  PageController pageController = PageController();
  int value = 0;
  bool positive = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final height = ScreenSize(context).height;
    final width = ScreenSize(context).width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: secondaryPinkColor,
        elevation: 0,
        title: const Text(
          "Now Playing",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: secondaryBlackColor,
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Container(
            height: 20,
            width: 20,
            margin: const EdgeInsets.all(5.0),
            padding: const EdgeInsets.all(2.0),
            decoration: const BoxDecoration(
                color: primaryPinkColor, shape: BoxShape.circle),
            child: IconButton(
              iconSize: 15,
              icon: const Icon(
                Icons.arrow_back_ios,
                color: secondaryBlackColor,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      // appBar: CustomAppBar(
      //
      //   title: 'Now Playing',
      //   iconButton: false,
      //   onPressedButton: null,
      //   onPressed: widget.onPressed,
      // ),
      body: PageView.builder(
        padEnds: false,
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (value) async {},
        itemCount: ref.watch(addProvider).musicList.length,
        itemBuilder: (_, indexxxx) {
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
                  imageUrl: ref.watch(addProvider).musicList[index].image,
                  height: 300,
                  width: 380,
                  // height: width * .7,
                  // width: width * .9,
                  boxFit: BoxFit.fill,
                ),
                Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text:
                              ref.watch(addProvider).musicList[index].musicName,
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: secondaryBlackColor,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: width * 0.06),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          _showDialogVolume(context);
                        },
                        child: Row(
                          children: [
                            Container(
                                color: Colors.transparent,
                                child: const CustomSvg(
                                    svg: volume, color: blackColor2)),
                            SizedBox(
                              width: 6,
                            ),
                            Text("Set Volume"),
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
                        onTap: () {
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
                            Text("Set Timer"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: width * 0.1),
                if (check == true) ...[
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
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text:
                              '${getHumanTimeBySecond(sliderInitial.toInt())}',
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
                if (check == true) ...[
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
                ] else ...[
                  SizedBox(
                    //color: Colors.green,
                    width: width * .95,
                    child: SliderTheme(
                      data: const SliderThemeData(
                          trackShape: RectangularSliderTrackShape(),
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 10)),
                      child: Builder(builder: (context) {
                        print(
                            "sliderInitial==end=========================================-0=-=00=-0=0=");
                        print(sliderInitial);
                        print(sliderEnd);

                        return Slider(
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
                                  seconds:
                                      (sliderEnd - sliderInitial).toInt()));
                              setState(() {});
                            },
                            semanticFormatterCallback: (double newValue) {
                              return '${newValue.round()} dollars';
                            });
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
                            selectedDuration = 120;
                            check = true;
                            if (mounted) {
                              if (check == true) {
                                String url = ref
                                    .watch(addProvider)
                                    .musicList[index]
                                    .musicFile;
                                await ins.stop();
                                ins.playAudio(
                                    Duration(hours: 8), "assets/$url");
                                LocalDB.setCurrentPlayingMusic(
                                    title: ref
                                        .watch(addProvider)
                                        .musicList[index]
                                        .musicName,
                                    id: ref
                                        .watch(addProvider)
                                        .musicList[index]
                                        .id,
                                    type: "single");

                                sliderInitial = 0.0;
                                sliderEnd = 120.0;
                              } else {
                                String url = ref
                                    .watch(addProvider)
                                    .musicList[index]
                                    .musicFile;
                                await ins.stop();
                                ins.playAudio(
                                    Duration(minutes: 2), "assets/$url");
                                LocalDB.setCurrentPlayingMusic(
                                    title: ref
                                        .watch(addProvider)
                                        .musicList[index]
                                        .musicName,
                                    id: ref
                                        .watch(addProvider)
                                        .musicList[index]
                                        .id,
                                    type: "single");

                                sliderInitial = 0.0;
                                sliderEnd = 120.0;
                              }
                            }

                            if (mounted) {
                              setState(() {});
                            }
                          },
                          icon: const CustomSvg(
                              svg: left_shift, color: primaryPinkColor),
                        ),
                        GestureDetector(
                          onTap: () async {
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
                              if (check == true) {
                                ins.playAudio(
                                    Duration(hours: 8), "assets/$url");
                                LocalDB.setCurrentPlayingMusic(
                                    title: ref
                                        .watch(addProvider)
                                        .musicList[index]
                                        .musicName,
                                    id: ref
                                        .watch(addProvider)
                                        .musicList[index]
                                        .id,
                                    type: "single");
                              } else {
                                ins.playAudio(
                                    Duration(
                                        seconds: (sliderEnd - sliderInitial)
                                            .toInt()),
                                    "assets/$url");
                                LocalDB.setCurrentPlayingMusic(
                                    title: ref
                                        .watch(addProvider)
                                        .musicList[index]
                                        .musicName,
                                    id: ref
                                        .watch(addProvider)
                                        .musicList[index]
                                        .id,
                                    type: "single");
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
                              padding: EdgeInsets.all(22),
                              child: Obx(() {
                                AppData.isPlaying.value;
                                return CustomSvg(
                                  color: primaryPinkColor,
                                  svg: AppData.isPlaying.value
                                      ? pouseButton
                                      : playButtonSvg,
                                );
                              }),
                            ),
                          ),
                        ),
                        //player next
                        IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () async {
                              changeIndex(changeIndex: true);
                              selectedTime = 0;
                              selectedDuration = 120;
                              check = true;
                              if (mounted) {
                                String url = ref
                                    .watch(addProvider)
                                    .musicList[index]
                                    .musicFile;

                                await ins.stop();
                                if (check == true) {
                                  ins.playAudio(
                                      Duration(hours: 8), "assets/$url");
                                  LocalDB.setCurrentPlayingMusic(
                                      title: ref
                                          .watch(addProvider)
                                          .musicList[index]
                                          .musicName,
                                      id: ref
                                          .watch(addProvider)
                                          .musicList[index]
                                          .id,
                                      type: "single");

                                  sliderInitial = 0.0;
                                  sliderEnd = 120.0;
                                } else {
                                  ins.playAudio(
                                      Duration(minutes: 2), "assets/$url");
                                  LocalDB.setCurrentPlayingMusic(
                                      title: ref
                                          .watch(addProvider)
                                          .musicList[index]
                                          .musicName,
                                      id: ref
                                          .watch(addProvider)
                                          .musicList[index]
                                          .id,
                                      type: "single");

                                  sliderInitial = 0.0;
                                  sliderEnd = 120.0;
                                }

                                // selected timer....

                              }

                              if (mounted) {
                                setState(() {});
                              }
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
                    height: width * 0.23,
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
                                      await FlutterScreenWake.setBrightness(
                                          brightness);
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
                                    await ins.setVolume(currentVolume * 0.01);
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
                                max: 6,
                                divisions: 6,
                                activeColor: primaryPinkColor,
                                inactiveColor: primaryGreyColor2,
                                onChanged: (double newValue) async {
                                  state(() {
                                    // setDuration = 1;
                                    selectedTime = newValue.toInt();
                                    selectedDuration =
                                        selectedTimes[selectedTime] == 0
                                            ? 120
                                            : selectedTimes[selectedTime];

                                    selectedDuration *= 60;
                                    setSongDuration(selectedDuration == 0
                                        ? 120
                                        : selectedDuration);
                                    ins.seek(Duration(
                                        seconds: selectedDuration == 0
                                            ? 120
                                            : selectedDuration));
                                    print("index 111 $selectedDuration");
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
                                    setSongDuration(120, initValue: 0);
                                    selectedDuration = 120;
                                  }
                                });
                              }),
                          TextButton(
                              onPressed: () async {
                                // if (mounted) {
                                //   Navigator.pop(context);
                                // }
                              },
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
                      GestureDetector(
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



  void setSongDuration(int setDuration, {double initValue = 0}) {
    sliderInitial = initValue;
    sliderEnd = setDuration.toDouble();
    if (sliderTimer != null) {
      sliderTimer!.cancel();
    }
    sliderTimer = Timer.periodic(Duration(seconds: 1), (timer) {

      print("sliderInitial===========================================single");
      sliderInitial++;
      print(sliderInitial);
      print(sliderEnd);

      if (sliderEnd <= sliderInitial) {
        playnext();
        check=true;
      }else{
        if(!mounted){
          if(!ins.isPlaying()){
            timer.cancel();
          }
        }
      }

      if (mounted) {
        setState(() {});
      }
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
    if (check == true) {
      setSongDuration(120, initValue: 0);
      sliderInitial = 0.0;
    } else {
      setSongDuration(sliderEnd.toInt(), initValue: sliderInitial);
    }
  }

  playnext() async {
    if(index<musicList!.length){
      index++;
    }else{
      index=0;
    }

    String url = musicList![index]
        .musicFile;

    await ins.stop();

    ins.playAudio(
        Duration(minutes: 2), "assets/$url");
    LocalDB.setCurrentPlayingMusic(
        title:  musicList![index]
            .musicName,
        id:  musicList![index]
            .id,
        type: "single");

    sliderInitial = 0.0;
    sliderEnd = 120.0;
  }

}
