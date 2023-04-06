
import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_input.dart';
import 'package:bye_bye_cry_new/screens/provider/add_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/mix_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/playlistProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../compoment/shared/custom_app_bar.dart';
import '../compoment/shared/custom_image.dart';
import '../compoment/shared/custom_svg.dart';
import '../compoment/shared/custom_text.dart';
import '../compoment/shared/outline_button.dart';
import '../compoment/shared/screen_size.dart';
import '../compoment/utils/color_utils.dart';
import '../compoment/utils/image_link.dart';
import 'models/music_models.dart';

class AddToPlayListPage extends ConsumerStatefulWidget {
  final VoidCallback? onPressed;
  const AddToPlayListPage({Key? key,this.onPressed}) : super(key: key);

  @override
  ConsumerState<AddToPlayListPage> createState() => _AddToPlayListPageState();
}

class _AddToPlayListPageState extends ConsumerState<AddToPlayListPage> {
  double currentvol = 1;
  double currentvol2 = 1;
  TextEditingController nameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  bool goMixPlayList = false;
  List<bool> fav = [false];


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
  void initState() {
    super.initState();
  }
  addMusicToMixPlaylist(){
    if(mounted){
      ref.read(playlistProvider).showMixPlayList(goMixPlaylist: false);
    }
    if(mounted){
      ref.read(addProvider).showPlusPlaylist(playlistPlusBottom: false);
    }
    if(mounted){
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = ScreenSize(context).width;
    final height = ScreenSize(context).height;
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: (){
          _showDialog(context);
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 58.0,right: 58,bottom: 11),
          child: Container(
            decoration: BoxDecoration(
              color:primaryPinkColor ,
              borderRadius: BorderRadius.circular(33),
            ),
            alignment: Alignment.center,
            height: 50,
            child: Text('Save To My Playlist',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: secondaryBlackColor
            ),),



          ),
        ),
      ),

      appBar: CustomAppBar(title: 'My Playlist',onPressed: widget.onPressed),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Column(
            //   children:
            //   // List.generate(ref.watch(playlistProvider).mixPlayList.length, (index) =>
            //   //    ),
            // ),


            ListView.builder(
              itemCount: ref.watch(playlistProvider).mixPlayList.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (_,index){
                return  Container(

                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Column(
                      children: [
                     //   const SizedBox(height: 20),
                        //  CustomText(text: "Sound Set ${index+1}",fontWeight: FontWeight.w600,fontSize: 20,color: primaryGreyColor),
                        const SizedBox(height: 20),
                        Column(
                          children: [
                            Row(
                              children: [



                                Padding(
                                  padding: const EdgeInsets.only(left: 18.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                          ref.read(addProvider).showPlusPlaylist(playlistPlusBottom:true);
                                          if(mounted){
                                            ref.read(addProvider).changePage(1);
                                          }
                                          if(mounted){
                                            ref.read(playlistProvider).addInPlaylistTrue();
                                          }
                                          if(mounted){
                                            ref.read(playlistProvider).setIndex(setIndex: index);
                                          }
                                          if(mounted){
                                            ref.read(playlistProvider).setMusicFirstOrSecond(setFirstOrSecondMusic: true);
                                          }
                                          if(mounted){
                                            setState(() {});
                                          }
                                        },
                                        child: Row(
                                          children: [
                                            ref.watch(playlistProvider).mixPlayList[index]?.first == null?Container(
                                              // height: width * .3,
                                              // width: width * .3,
                                              decoration: BoxDecoration(
                                                  color: secondaryPickColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child:  Padding(
                                                padding: EdgeInsets.all(25.0),
                                                child: CustomSvg(


                                                  svg: musicJust,
                                                ),
                                              ),
                                            ):CustomImage(
                                              imageUrl: "${ref.watch(playlistProvider).mixPlayList[index]?.first?.image}",
                                              height: width * .15,
                                              width: width * .15,
                                              boxFit: BoxFit.cover,
                                            ),
                                           SizedBox(width: 30,),
                                            Center(
                                              child: CustomText(
                                                text: ref.watch(playlistProvider).mixPlayList[index]?.first?.musicName ?? "Add a Sound",
                                                textAlign: TextAlign.center,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,

                                                color: primaryGreyColor,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0,bottom: 4),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          _showDialog2(context);
                                        },
                                        child: Row(
                                          children: [
                                            CustomSvg(
                                              svg: timer,
                                              color: blackColor2,
                                            ),

                                            SizedBox(width: 2,),

                                            Padding(
                                                padding: const EdgeInsets.only(top: 4.0),
                                                child: Text(

                                                    "${(selectedTimes[selectedTime] ~/ 60).toString().padLeft(2, "0")} : ${(selectedTimes[selectedTime] % 60).toString().padLeft(2, "0").toString()} min".replaceAll("00 :", ""),style: TextStyle(
                                                  fontSize: 14
                                                ),),

                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 20,),
                                      InkWell(
                                        onTap: (){
                                          _showDialogVolume(context);
                                        },
                                        child: Row(
                                          children: [
                                            CustomSvg(
                                              svg: volume,
                                              color: blackColor2,
                                            ),

                                            SizedBox(width: 5,),

                                            Padding(
                                              padding: const EdgeInsets.only(top: 4.0),
                                              child: Text("${currentVolume.toString().replaceAll("0.", "")}"),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),



                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                );

              },
            ),




            ref.watch(playlistProvider).mixPlayList.length <3?const SizedBox(height: 20):const SizedBox(),
            ref.watch(playlistProvider).mixPlayList.length <3?GestureDetector(
              onTap: (){
               ref.read(playlistProvider).createMusic();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(
                      Icons.add,
                      color: primaryGreyColor,
                    ),
                    CustomText(text: "Add another Sound Set",fontSize: 16,fontWeight: FontWeight.w600,color: primaryGreyColor),
                  ],
                ),
              ),
            ):const SizedBox(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  void _showDialog(BuildContext context) {
    final width = ScreenSize(context).height;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.center,
          child: Wrap(
            children: [
              AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)
                ),
                backgroundColor: secondaryPinkColor,
                title: const CustomText(
                  text: 'Name Your Sound',
                  textAlign: TextAlign.center,
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: secondaryBlackColor,
                ),
                content: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: CustomTextInputField(textEditingController: nameController,cursorColor: primaryPinkColor,borderColor: Colors.transparent,),
                ),
                actionsAlignment: MainAxisAlignment.center,
                actionsPadding: const EdgeInsets.only(bottom: 10),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: OutLineButton(
                      height: width * .06,
                      width: width * .25,
                      text: 'Save',
                      textColor: secondaryBlackColor2,
                      textFontSize: 20,
                      textFontWeight: FontWeight.w600,
                      borderRadius: 48,
                      onPressed: () {
                       if(nameController.text.isNotEmpty){
                         addMusicToMixPlaylist();
                         if(mounted){
                           ref.read(playlistProvider).addInPlaylistFalse();
                         }
                         if(mounted){
                           ref.read(playlistProvider).createMixMusicPlaylist(mixTitle: nameController.text);
                         }
                         if(mounted){
                           setState(() {});
                         }
                         if(mounted){
                           Navigator.pop(context);
                         }
                       }else{
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                             backgroundColor: Colors.white,
                             behavior: SnackBarBehavior.floating,
                             content: const Text("Give The Title Name",style: TextStyle(color: Colors.black,),textAlign: TextAlign.center,),
                             margin: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10)
                             ),
                         ));
                       }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDialog2(BuildContext context) {
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
      //  audioPlayer.stop();
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
                                    // await audioPlayer.setVolume(
                                    //     currentVolume);

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
}
