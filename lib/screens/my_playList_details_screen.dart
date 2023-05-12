import 'dart:async';
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
import '../main.dart';
import 'models/AppData.dart';

class PlaylistMixSound2 extends ConsumerStatefulWidget {
  final String? playlistMixMusicId;
  final int songIndex;
  final VoidCallback? onPressed;
  const PlaylistMixSound2(
      {Key? key,
      required this.playlistMixMusicId,
      this.onPressed,
      this.songIndex = 0})
      : super(key: key);

  @override
  ConsumerState<PlaylistMixSound2> createState() => _PlaylistMixSound2State();
}

var sliderEnd = 120;
var sliderInitial = 0.0;
var check = false;
var songTimer;
var volumePlayer = 50.0;
var selectedTime = 0;
Timer? sliderTimer;

class _PlaylistMixSound2State extends ConsumerState<PlaylistMixSound2>
    with TickerProviderStateMixin {
  getTimer() async {
    if (musicIndex == 0)
      await LocalDB().getTimer().then((value) {
        sliderEnd = int.parse(value == "00" ? "120" : value);
      });
    if (musicIndex == 1)
      await LocalDB().getTimer2().then((value) {
        sliderEnd = int.parse(value == "00" ? "120" : value);
      });
    if (musicIndex == 3)
      await LocalDB().getTimer3().then((value) {
        sliderEnd = int.parse(value == "00" ? "120" : value);
      });

    print("sliderEnd=======================");
    print(sliderEnd);
  }

  getVol1() async {
    await LocalDB().getVolume().then((value) {
      ins.setVolume(double.parse(value) * 0.01);
      volumePlayer = double.parse(value);
    });
  }

  getVol2() async {
    await LocalDB().getVolume2().then((value) {
      ins.setVolume(double.parse(value) * 0.01);
      volumePlayer = double.parse(value);
    });
  }

  getVol3() async {
    await LocalDB().getVolume3().then((value) {
      ins.setVolume(double.parse(value) * 0.01);
      volumePlayer = double.parse(value);
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

  int musicIndex = 0;

  var mixPlaylistIndex = 0;
  List<PlayListModel>? playingMusic;

  isOldSong() {
    print("ins.currentAudio()");
    print(widget.songIndex);
    print(AppData.musicIndexData);

    if ((widget.playlistMixMusicId == AppData.idCurrentMusic) &&
        ins.isPlaying()) {
      var value = (widget.songIndex == AppData.musicIndexData) &&
          AppData.isPlaying.value;
      if (!value) {
        // check = true;
      }
      return value;
    }
    return false;
  }

  bool isLastSong() {
    try {
      if (musicIndex ==
          playingMusic![mixPlaylistIndex].playListList!.length - 1) {
        print("last song play0000000000000000000000000");

        return true;
      }
    } catch (e) {
      if (musicIndex ==
          ref
                  .watch(playlistProvider)
                  .mixMixPlaylist[mixPlaylistIndex]
                  .playListList!
                  .length -
              1) {
        print("last song play0000000000000000000000000");

        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getVol1();
    getVol2();
    getVol3();
    musicIndex = widget.songIndex;
    initialization();

    if (songTimer != null) {
      songTimer!.cancel();
    }

    songTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      if (check) {
        selectedTime=0;
        sliderInitial = 0;
        ins.seek(Duration(seconds: 120));
      }
    });
  }

  initialization() async {
    await Future.delayed(Duration(microseconds: 1));

    setState(() {
      mixPlaylistIndex = ref
          .watch(playlistProvider)
          .mixMixPlaylist
          .indexWhere((element) => element.title == widget.playlistMixMusicId);
    });
    playingMusic = ref.watch(playlistProvider).mixMixPlaylist;
    if (isOldSong()) {
      resumeSliderTimmer();
    } else {
      await getTimer();
      ins.stop();
      pausePlayMethod();
      sliderInitial = 0;
      check=false;
    }
  }

  changeIndex({bool changeIndex = false}) {
    if (changeIndex) {
      musicIndex = (musicIndex + 1) %
          playingMusic![mixPlaylistIndex].playListList!.length;
    } else {
      musicIndex =
          (musicIndex) % playingMusic![mixPlaylistIndex].playListList!.length;
      //musicIndex = (musicIndex - 1);
      /* if (musicIndex < 0) {
        musicIndex = ref
                .watch(playlistProvider)
                .mixMixPlaylist[mixPlaylistIndex]
                .playListList!
                .length -
            1;
      }*/
    }
  }

  pausePlayMethod() async {
    await getTimer();

    if (ins.isPlaying()) {
      await ins.stop();
      pauseSliderTimmer();
    } else {
      String url = ref
              .watch(playlistProvider)
              .mixMixPlaylist[mixPlaylistIndex]
              .playListList![musicIndex]
              .first
              ?.musicFile ??
          "";

      ins.playAudio(Duration(seconds: sliderEnd), "assets/$url");
      resumeSliderTimmer();
      LocalDB.setCurrentPlayingMusic(
          title: ref
              .watch(playlistProvider)
              .mixMixPlaylist[mixPlaylistIndex]
              .playListList![musicIndex]
              .first!
              .musicName,
          type: "Playlist",
          id: widget.playlistMixMusicId,
          songIndex: musicIndex);
    }

    if (mounted) {
      setState(() {});
    }
  }

  playMusicForBottomSheet(
      {required String id,
      required Function(void Function()) updateState}) async {
    int _index = ref
        .watch(playlistProvider)
        .mixMixPlaylist[mixPlaylistIndex]
        .playListList!
        .indexWhere((element) => element.id == id);

    if (_index == musicIndex) {
      if(ins.isPlaying()){
        ins.stop();
        pauseSliderTimmer();
      }else{



        String url1 = ref
            .watch(playlistProvider)
            .mixMixPlaylist[mixPlaylistIndex]
            .playListList![_index]
            .first
            ?.musicFile ??
            "";

        await ins.playAudio(Duration(seconds: sliderEnd), "assets/$url1");
        resumeSliderTimmer();
      }

    } else {

      String url1 = ref
              .watch(playlistProvider)
              .mixMixPlaylist[mixPlaylistIndex]
              .playListList![_index]
              .first
              ?.musicFile ??
          "";
      sliderEnd= await getTimeByIndex(_index);
      print("sliderEnd==============asdasdasdasd=");

      print(sliderEnd);
      await ins.playAudio(Duration(seconds: sliderEnd), "assets/$url1");
      resumeSliderTimmer();
    }
    musicIndex = _index;

    if(isLastSong()){
      check=true;
    }else{
      check=false;
    }

    LocalDB.setCurrentPlayingMusic(
        title: ref
            .watch(playlistProvider)
            .mixMixPlaylist[mixPlaylistIndex]
            .playListList![musicIndex]
            .first!
            .musicName,
        type: "Playlist",
        id: widget.playlistMixMusicId,
        songIndex: musicIndex);

    /*  int _index = ref
        .watch(playlistProvider)
        .mixMixPlaylist[mixPlaylistIndex]
        .playListList!
        .indexWhere((element) => element.id == id);
    if (_index >= 0) {
      if (_index == musicIndex) {
        if (ins.isPlaying()) {
          await ins.stop();

          pauseSliderTimmer();
        } else {
          if (_index ==
              ref
                      .watch(playlistProvider)
                      .mixMixPlaylist[mixPlaylistIndex]
                      .playListList!
                      .length -
                  1) {


          } else {


            await ins.playAudio(Duration(minutes: 2), "assets/$url1");
            resumeSliderTimmer();
            LocalDB.setCurrentPlayingMusic(
                title: ref
                    .watch(playlistProvider)
                    .mixMixPlaylist[mixPlaylistIndex]
                    .playListList![musicIndex]
                    .first!
                    .musicName,
                type: "Playlist",
                id: widget.playlistMixMusicId,
                songIndex: musicIndex);
          }
        }
      } else {
        sliderInitial = 0.0;
        musicIndex = _index;
        if (_index ==
            ref
                    .watch(playlistProvider)
                    .mixMixPlaylist[mixPlaylistIndex]
                    .playListList!
                    .length -
                1) {
          String url1 = ref
                  .watch(playlistProvider)
                  .mixMixPlaylist[mixPlaylistIndex]
                  .playListList![_index]
                  .first
                  ?.musicFile ??
              "";

          await ins.playAudio(Duration(hours: 10), "assets/$url1");
          resumeSliderTimmer();
          LocalDB.setCurrentPlayingMusic(
              title: ref
                  .watch(playlistProvider)
                  .mixMixPlaylist[mixPlaylistIndex]
                  .playListList![musicIndex]
                  .first!
                  .musicName,
              type: "Playlist",
              id: widget.playlistMixMusicId,
              songIndex: musicIndex);
        } else {
          String url1 = ref
                  .watch(playlistProvider)
                  .mixMixPlaylist[mixPlaylistIndex]
                  .playListList![_index]
                  .first
                  ?.musicFile ??
              "";

          await ins.playAudio(Duration(minutes: 2), "assets/$url1");
          resumeSliderTimmer();
          LocalDB.setCurrentPlayingMusic(
              title: ref
                  .watch(playlistProvider)
                  .mixMixPlaylist[mixPlaylistIndex]
                  .playListList![musicIndex]
                  .first!
                  .musicName,
              type: "Playlist",
              id: widget.playlistMixMusicId,
              songIndex: musicIndex);
        }
        // sliderInitial = 0.0;
        // musicIndex = _index;
        //
        // String url1 = ref
        //         .watch(playlistProvider)
        //         .mixMixPlaylist[mixPlaylistIndex]
        //         .playListList![_index]
        //         .first
        //         ?.musicFile ??
        //     "";
        //
        // await ins.playAudio(Duration(minutes: 2), "assets/$url1");
        // resumeSliderTimmer();
      }
    }*/
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
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: (value) async {},
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
                              onTap: () {
                                CustomBottomSheet.bottomSheet(context,
                                    isDismiss: true, child: StatefulBuilder(
                                  builder: (BuildContext context,
                                      void Function(void Function())
                                          updateState) {
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

                SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 40, left: 30, right: 30),
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
                              width: 10,
                            ),
                            Text("Set Volume")
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          ref.read(mixMusicProvider).alertDialogStart();
                          _showDialog(context);
                          // if (mounted) {
                          //   setState(() {
                          //     check = false;
                          //     selectedTime = 0;
                          //   });
                          //
                          // }
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
                            SizedBox(
                              width: 10,
                            ),
                            Text("Set Timer")
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (!check) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                          text:
                              '${getHumanTimeBySecond(sliderInitial.toInt())} ',
                          fontSize: 10,
                          color: blackColor2,
                          fontWeight: FontWeight.w700,
                        ),
                        CustomText(
                          text: getHumanTimeBySecond(sliderEnd!.toInt()),
                          fontSize: 10,
                          color: blackColor2,
                          fontWeight: FontWeight.w700,
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container()
                ],

                if (!check) ...[
                  SizedBox(
                    //color: Colors.green,
                    width: width * .95,
                    child: SliderTheme(
                      data: const SliderThemeData(
                          trackShape: RectangularSliderTrackShape(),
                          thumbShape:
                              RoundSliderThumbShape(enabledThumbRadius: 10)),
                      child: Slider(
                          value: (sliderInitial <= sliderEnd
                                  ? sliderInitial
                                  : sliderEnd)
                              .toDouble(),
                          min: 0,
                          max: sliderEnd.toDouble(),
                          divisions: 350,
                          activeColor: primaryPinkColor,
                          inactiveColor: primaryGreyColor2,
                          onChanged: (double newValue) async {
                            updateSlider(newValue.floorToDouble());
                            setState(() {});
                          },
                          semanticFormatterCallback: (double newValue) {
                            return '${newValue.round()} dollars';
                          }),
                    ),
                  ),
                ] else ...[
                  Container()
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
                            changeIndex(changeIndex: true);

                            String url = ref
                                    .watch(playlistProvider)
                                    .mixMixPlaylist[mixPlaylistIndex]
                                    .playListList![musicIndex]
                                    .first
                                    ?.musicFile ??
                                "";

                            await ins.stop();
                            await getTimer();

                            if (isLastSong()) {
                              check = true;
                              setState(() {});
                            } else{
                              check = false;
                            }
                            ins.playAudio(
                                Duration(seconds: sliderEnd), "assets/$url");
                            resumeSliderTimmer();

                            LocalDB.setCurrentPlayingMusic(
                                title: ref
                                    .watch(playlistProvider)
                                    .mixMixPlaylist[mixPlaylistIndex]
                                    .playListList![musicIndex]
                                    .first!
                                    .musicName,
                                type: "Playlist",
                                id: widget.playlistMixMusicId,
                                songIndex: musicIndex);

                            sliderInitial = 0.0;

                            if (mounted) {
                              setState(() {});
                            }
                          },
                          icon: const CustomSvg(
                              svg: left_shift, color: primaryPinkColor),
                        ),
                        GestureDetector(
                          onTap: () async {
                            pausePlayMethod();
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

                              String url = ref
                                      .watch(playlistProvider)
                                      .mixMixPlaylist[mixPlaylistIndex]
                                      .playListList![musicIndex]
                                      .first
                                      ?.musicFile ??
                                  "";

                              await ins.stop();
                              await getTimer();
                              if (isLastSong()) {
                                check = true;
                                setState(() {});
                              } else{
                                check = false;
                              }
                              ins.playAudio(
                                  Duration(seconds: sliderEnd), "assets/$url");
                              resumeSliderTimmer();

                              LocalDB.setCurrentPlayingMusic(
                                  title: ref
                                      .watch(playlistProvider)
                                      .mixMixPlaylist[mixPlaylistIndex]
                                      .playListList![musicIndex]
                                      .first!
                                      .musicName,
                                  type: "Playlist",
                                  id: widget.playlistMixMusicId,
                                  songIndex: musicIndex);

                              sliderInitial = 0.0;

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

  var brightness = 0.5;
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
                                  value: volumePlayer,
                                  min: 0.0,
                                  max: 100.0,
                                  divisions: 100,
                                  activeColor: primaryPinkColor,
                                  inactiveColor: primaryGreyColor2,
                                  onChanged: (double newValue) async {
                                    await ins.setVolume(volumePlayer * 0.01);
                                    updateState(() {
                                      // Screen.setBrightness(newValue);
                                      volumePlayer = newValue;
                                    });
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
                                        text: "${volumePlayer.floor()}%",
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
                        SliderTheme(
                          data: const SliderThemeData(
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
                                  selectedTime = newValue.toInt();
                                  if (selectedTime == 0) {
                                    check = true;
                                    getTimer();
                                  } else {
                                    check = false;
                                    setSongDuration(
                                        selectedTimes[selectedTime] * 60);
                                    ins.seek(Duration(
                                        seconds:
                                            selectedTimes[selectedTime] * 60));
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
                                  selectedTime = 0;
                                  getTimer();
                                });
                              }),
                          TextButton(
                            onPressed: () async {},
                            child: const CustomText(
                              text: "continuous play",
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: primaryGreyColor,
                            ),
                          ),
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
          setState(() {});
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
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      5.0),
                                                          child: CustomText(
                                                              text:
                                                                  "${(volumePlayer).toInt().toString().padLeft(2, "0")}%",
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  blackColor50),
                                                        ),
                                                        SizedBox(
                                                          width: 20,
                                                        ),
                                                        FutureBuilder<dynamic>(
                                                            future:
                                                                getTimeByIndex(
                                                                    index),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (!snapshot
                                                                  .hasData) {
                                                                return Container();
                                                              }
                                                              return CustomText(
                                                                  text:
                                                                      "${getHumanTimeBySecond(snapshot.data)}",
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      blackColor50);
                                                            }),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              await playMusicForBottomSheet(
                                                id: ref
                                                    .watch(playlistProvider)
                                                    .mixMixPlaylist[
                                                        mixPlaylistIndex]
                                                    .playListList![index]
                                                    .id,
                                                updateState: updateState,
                                              );
                                              updateState(() {});
                                              setState(() {});
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
                                                      : ins.isPlaying()
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

  Future<void> setSongDuration(int setDuration, {double initValue = 0}) async {
    if (setDuration == 0) {
      return;
    }

    sliderInitial = initValue;
    sliderEnd = setDuration;
    ins.seek(Duration(seconds: (setDuration - initValue).toInt()));

    if (sliderTimer != null) {
      sliderTimer!.cancel();
    }
    sliderTimer = Timer.periodic(Duration(seconds: 1), (timer) async {
      sliderInitial++;

      print("sliderInitial======");
      print(sliderInitial);

      if (sliderInitial >= sliderEnd) {
        await playSong();
      }else{
        if(!mounted){
          if(!ins.isPlaying()){
            timer.cancel();
          }
        }
      }

      if (mounted) setState(() {});
    });
  }

  void updateSlider(double newValue) {
    sliderInitial = newValue;
    setSongDuration(sliderEnd, initValue: sliderInitial);
    /* ins.seek(Duration(
        seconds: (setDuration - sliderInitial)
            .toInt()));*/
    setState(() {});
  }

  void pauseSliderTimmer() {
    sliderTimer!.cancel();
  }

  Future<void> resumeSliderTimmer() async {
    setSongDuration(sliderEnd, initValue: sliderInitial);
  }

  getTimeByIndex(int index) async {

    print("indexmusicIndex=====================+++++++++++++");
    print(index);
    print(musicIndex);

    var time;

    if (index == musicIndex) {

      return  (sliderEnd);
    }

    if (index == 0) {
      await LocalDB().getTimer().then((value) {
        time = int.parse(value == "00" ? "120" : value);
      });
    }
    if (index == 1) {
      await LocalDB().getTimer2().then((value) {
        time = int.parse(value == "00" ? "120" : value);
      });
    }
    if (index == 2) {
      await LocalDB().getTimer3().then((value) {
        time = int.parse(value == "00" ? "120" : value);
      });
    }

    return (time);
  }

  Future<void> playSong() async {
    sliderInitial = 0;

    changeIndex(changeIndex: true);

    String url = playingMusic![mixPlaylistIndex]
            .playListList![musicIndex]
            .first
            ?.musicFile ??
        "";

    await ins.stop();
    await getTimer();
    if (isLastSong()) {
      check = true;
      if (mounted) setState(() {});
    }else{
      check = false;
    }
    ins.playAudio(Duration(seconds: sliderEnd), "assets/$url");
    resumeSliderTimmer();

    LocalDB.setCurrentPlayingMusic(
        title: playingMusic![mixPlaylistIndex]
            .playListList![musicIndex]
            .first!
            .musicName,
        type: "Playlist",
        id: widget.playlistMixMusicId,
        songIndex: musicIndex);

    sliderInitial = 0.0;

    if (mounted) {
      setState(() {});
    }
  }
}
