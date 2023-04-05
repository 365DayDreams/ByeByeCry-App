import 'package:audioplayers/audioplayers.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_image.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_svg.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_text.dart';
import 'package:bye_bye_cry_new/compoment/shared/screen_size.dart';
import 'package:bye_bye_cry_new/local_db/wishList_controller.dart';
import 'package:bye_bye_cry_new/screens/mix_screen.dart';
import 'package:bye_bye_cry_new/screens/playlist_mix_sound.dart';
import 'package:bye_bye_cry_new/screens/provider/add_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/mix_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/playlistProvider.dart';
import 'package:bye_bye_cry_new/sounds_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../compoment/shared/custom_app_bar.dart';
import '../compoment/shared/outline_button.dart';
import '../compoment/utils/color_utils.dart';
import '../compoment/utils/image_link.dart';
import '../local_db/local_db.dart';
import 'listen_mix_sound.dart';
import 'models/music_models.dart';
import 'now_palying_screen.dart';
import 'package:get/get.dart';

class SoundScreen extends ConsumerStatefulWidget {
  const SoundScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SoundScreen> createState() => _SoundScreenState();
}

class _SoundScreenState extends ConsumerState<SoundScreen> {
  TextEditingController searchController = TextEditingController();
  bool changeToPlayNow = false;
  bool changeToMixPlayNow = false;
  bool changeToMixPlayListNow = false;
  MusicModel? music;
  String mixMusicId = '';
  String mixPlaylistMixMusicId = '';
  AudioCache audioCache = AudioCache();
  final WishListController wishListController = Get.put(WishListController());

  bool issongplaying = false;
  int index = 0;
  String musicId = "";
  bool deleteShow = false;
 // List<bool> fav = [false];
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
    // wishListController.getCartData();
    // initialized();
    // startPlayer();

    // deleteShow = false;
    // ref.read(addProvider).showAddPlaylist= false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return changeToPlayNow
        ? NowPlayingScreen(
            musicId: musicId,
            onPressed: () {
              if (ref.watch(addProvider).playFromPlayList) {
                if (mounted) {
                  ref.read(addProvider).changePage(3);
                }
                if (mounted) {
                  changeToPlayNow = false;
                  setState(() {});
                }
              } else {
                setState(() {
                  changeToPlayNow = false;
                });
              }
            },
          )
        : changeToMixPlayNow
            ? ListenMixSound(
                mixMusicModelId: mixMusicId,
                onPressed: () {
                  if (ref.watch(mixMusicProvider).playFromPlayList) {
                    changeToMixPlayNow = false;
                    if (mounted) {
                      ref.read(addProvider).changePage(3);
                    }
                    if (mounted) {
                      setState(() {});
                    }
                  } else {
                    setState(() {
                      changeToMixPlayNow = false;
                    });
                  }
                })
            : changeToMixPlayListNow
                ? PlaylistMixSound(
                    playlistMixMusicId: mixPlaylistMixMusicId,
                    onPressed: () {
                      setState(() {
                        changeToMixPlayListNow = false;
                      });
                      if (mounted) {
                        ref.read(addProvider).changePage(3);
                      }
                    },
                  )
                : Scaffold(
                    appBar: CustomAppBar(
                        title: deleteShow ? 'Edit My Sounds' : 'My Sounds',
                        actionTitle: deleteShow ? "" : 'Edit',
                        onPressedButton: () {
                          deleteShow = true;
                          if (mounted) {
                            setState(() {});
                          }
                        },
                        onPressed: () {
                          deleteShow = false;
                          if (ref.watch(addProvider).showAddPlaylist) {
                            ref.read(addProvider).showPlusPlaylist();
                          }
                          if (mounted) {
                            setState(() {});
                          }
                        }),
                    body: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              color: secondaryWhiteColor2,
                              child: ListTile(
                                dense: true,
                                title: TextField(
                                  onChanged: (val) {
                                    setState(() {
                                      searchval = val;
                                      print("Search__$searchval");
                                    });
                                  },
                                  controller: searchController,
                                  decoration: const InputDecoration(
                                      hintStyle: TextStyle(
                                          color: blackColorA0,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400),
                                      hintText: 'Search music',
                                      border: InputBorder.none),
                                ),
                                trailing: const CustomSvg(
                                  svg: "asset/images/search_icon.svg",
                                ),
                              ),
                            ),
                          ), //combinationList
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
                          ref.watch(addProvider).showAddPlaylist
                              ? const SizedBox(
                                  height: 15,
                                )
                              : Column(
                                  children: [
                                    Column(
                                        children: List.generate(
                                      ref
                                              .watch(mixMusicProvider)
                                              .combinationList
                                              .isEmpty
                                          ? 0
                                          : ref
                                              .watch(mixMusicProvider)
                                              .combinationList
                                              .length,
                                      (index) => Column(
                                        children: [
                                          Container(
                                            color: index % 2 == 0
                                                ? Colors.transparent
                                                : pinkLightColor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                              child: mixImageList(
                                                  context: context,
                                                  mixMusicModel: ref
                                                      .watch(mixMusicProvider)
                                                      .combinationList[index],
                                                  index: index),
                                            ),
                                          ), // const SizedBox(height: 5,)
                                        ],
                                      ),
                                    )),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => MixScreen(
                                                      type: "1",
                                                    )));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 25.0, vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 60,
                                              // height: 50,
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                color: primaryPinkColor,
                                              ),
                                              child: const CustomImage(
                                                boxFit: BoxFit.fill,
                                                imageUrl: whitePlus,
                                                scale: 1,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            const CustomText(
                                              text: 'Mix Two Sounds',
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: blackColor50,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    )
                                  ],
                                )
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
    /// fav.add(false);
    // wishListController.getCartData();
    if (searchval == null || searchval == "") {
      return ValueListenableBuilder(
          valueListenable: Hive.box("fav").listenable(),
          builder: (context, box, _) {
            return GestureDetector(
              onTap: () async {
                // if (issongplaying) await audioPlayer.dispose();
                // await Future.delayed(Duration(seconds: 2));
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SoundDetailsScreen(
                              musicId: musicModel.id,
                              onPressed: () async {
                                if (ref.watch(addProvider).playFromPlayList) {
                                  if (mounted) {
                                    ref.read(addProvider).changePage(3);
                                  }
                                  if (mounted) {
                                    changeToPlayNow = false;
                                    setState(() {});
                                  }
                                } else {
                                  setState(() {
                                    changeToPlayNow = false;
                                  });
                                }
                              },
                            )));
              },
              // onTap: ref.watch(addProvider).showAddPlaylist?null:(){
              //   if(mounted){
              //     ref.read(addProvider).playFromPlaylistActive(change: false);
              //   }
              //   setState(() {
              //     music = musicModel;
              //     musicId = musicModel.id;
              //     changeToPlayNow = ref.watch(addProvider).showAddPlaylist?false:deleteShow?false:true;
              //     print("change");
              //   });
              // },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "${musicModel.image}",
                          height: 60,
                          fit: BoxFit.contain,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 5.0),
                      //   child: CustomImage(imageUrl: musicModel.image),
                      // ),
                      const SizedBox(
                        width: 10,
                      ),
                      CustomText(
                        text: musicModel.musicName,
                        color: blackColor50,
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: Colors.black.withOpacity(0.05),
                          ),
                          child: ref.read(addProvider).showAddPlaylist
                              ? GestureDetector(
                                  onTap: () async {
                                    musicId = musicModel.id;
                                    if (mounted) {
                                      //playMusic(id: musicId);
                                    }
                                    print("OK");
                                  },
                                  child: musicId == musicModel.id
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
                                        ),
                                )
                              : deleteShow
                                  ? SizedBox()
                                  : InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (box.containsKey(musicModel.id)) {
                                            box.delete(musicModel.id);
                                          } else {
                                            box.put(musicModel.id, musicModel);
                                          }

                                          // wishListController.addToCart(musicModel);
                                        });

                                        // Navigator.push(context, MaterialPageRoute(builder: (_)=> SoundDetailsScreen(
                                        //   musicId: musicModel.id,
                                        // onPressed: ()async{
                                        //   if(ref.watch(addProvider).playFromPlayList){
                                        //     if(mounted){
                                        //       ref.read(addProvider).changePage(3);
                                        //     }
                                        //     if(mounted){
                                        //       changeToPlayNow = false;
                                        //       setState(() {});
                                        //     }
                                        //   } else{
                                        //     setState(() {
                                        //       changeToPlayNow = false;
                                        //     });
                                        //   }
                                        // },
                                        // )));
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Hive.box("fav")
                                                  .containsKey(musicModel.id)
                                              ? Icon(
                                                  Icons.favorite,
                                                  size: 35,
                                                  color: primaryPinkColor,
                                                )
                                              : Icon(
                                                  Icons.favorite_border,
                                                  size: 35,
                                                  color: primaryPinkColor,
                                                ))),
                        ),
                        ref.read(addProvider).showAddPlaylist
                            ? Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black.withOpacity(0.1)),
                                  child: GestureDetector(
                                    onTap: () {
                                      ref.read(addProvider).changePage(3);
                                      if (ref
                                          .watch(playlistProvider)
                                          .addInPlayListTrueFalse) {
                                        if (mounted) {
                                          ref
                                              .read(playlistProvider)
                                              .showMixPlayList(
                                                  goMixPlaylist: true);
                                          //Change.
                                          //   ref.read(addProvider).showAddPlaylist=false;
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
                                        ref.read(addProvider).changePage(2);
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
                                        //  ref.read(addProvider).showAddPlaylist=false;
                                      }
                                    },
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
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          });
    } else {
      if (musicModel.musicName.toLowerCase().contains(search!.toLowerCase())) {
        // return GestureDetector(
        //   onTap: () async {
        //    // if (issongplaying) await audioPlayer.dispose();
        //     // await Future.delayed(Duration(seconds: 2));
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (_) => SoundDetailsScreen(
        //                   musicId: musicModel.id,
        //                   onPressed: () async {
        //                     if (ref.watch(addProvider).playFromPlayList) {
        //                       if (mounted) {
        //                         ref.read(addProvider).changePage(3);
        //                       }
        //                       if (mounted) {
        //                         changeToPlayNow = false;
        //                         setState(() {});
        //                       }
        //                     } else {
        //                       setState(() {
        //                         changeToPlayNow = false;
        //                       });
        //                     }
        //                   },
        //                 )));
        //   },
        //   // onTap: ref.watch(addProvider).showAddPlaylist?null:(){
        //   //   if(mounted){
        //   //     ref.read(addProvider).playFromPlaylistActive(change: false);
        //   //   }
        //   //   setState(() {
        //   //     music = musicModel;
        //   //     musicId = musicModel.id;
        //   //     changeToPlayNow = ref.watch(addProvider).showAddPlaylist?false:deleteShow?false:true;
        //   //     print("change");
        //   //   });
        //   // },
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Row(
        //         children: [
        //           Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Image.asset(
        //               "${musicModel.image}",
        //               height: 60,
        //               fit: BoxFit.contain,
        //             ),
        //           ),
        //           // Padding(
        //           //   padding: const EdgeInsets.only(top: 5.0),
        //           //   child: CustomImage(imageUrl: musicModel.image),
        //           // ),
        //           const SizedBox(
        //             width: 10,
        //           ),
        //           CustomText(
        //             text: musicModel.musicName,
        //             color: blackColor50,
        //             fontWeight: FontWeight.w600,
        //             fontSize: 20,
        //           ),
        //         ],
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 8.0),
        //         child: Row(
        //           children: [
        //             Container(
        //               decoration: BoxDecoration(
        //                 shape: BoxShape.circle,
        //                 color: Colors.black.withOpacity(0.05),
        //               ),
        //               child: ref.read(addProvider).showAddPlaylist
        //                   ? GestureDetector(
        //                       onTap: () async {
        //                         musicId = musicModel.id;
        //                         if (mounted) {
        //                           //playMusic(id: musicId);
        //                         }
        //                         print("OK");
        //                       },
        //                       child: musicId == musicModel.id
        //                           ? Padding(
        //                               padding: const EdgeInsets.all(15.0),
        //                               child: issongplaying
        //                                   ? const CustomSvg(
        //                                       svg: pouseButton,
        //                                       color: blackColor97,
        //                                       height: 12,
        //                                       width: 12,
        //                                     )
        //                                   : const CustomImage(
        //                                       imageUrl: playButton,
        //                                       scale: 0.8,
        //                                     ),
        //                             )
        //                           : const Padding(
        //                               padding: EdgeInsets.all(15.0),
        //                               child: CustomImage(
        //                                 scale: 0.8,
        //                                 imageUrl: playButton,
        //                               ),
        //                             ),
        //                     )
        //                   : deleteShow
        //                       ? const SizedBox()
        //                       : InkWell(
        //                           onTap: () {
        //                             setState(() {
        //                               fav[musicIndex] = !fav[musicIndex];
        //                             });
        //
        //                             // Navigator.push(context, MaterialPageRoute(builder: (_)=> SoundDetailsScreen(
        //                             //   musicId: musicModel.id,
        //                             // onPressed: ()async{
        //                             //   if(ref.watch(addProvider).playFromPlayList){
        //                             //     if(mounted){
        //                             //       ref.read(addProvider).changePage(3);
        //                             //     }
        //                             //     if(mounted){
        //                             //       changeToPlayNow = false;
        //                             //       setState(() {});
        //                             //     }
        //                             //   } else{
        //                             //     setState(() {
        //                             //       changeToPlayNow = false;
        //                             //     });
        //                             //   }
        //                             // },
        //                             // )));
        //                           },
        //                           child: Padding(
        //                               padding: EdgeInsets.all(15.0),
        //                               child: !fav[musicIndex]
        //                                   ? Icon(
        //                                       Icons.favorite_border,
        //                                       size: 35,
        //                                       color: primaryPinkColor,
        //                                     )
        //                                   : Icon(
        //                                       Icons.favorite,
        //                                       size: 35,
        //                                       color: primaryPinkColor,
        //                                     ))),
        //             ),
        //             ref.read(addProvider).showAddPlaylist
        //                 ? Padding(
        //                     padding: const EdgeInsets.only(left: 20.0),
        //                     child: Container(
        //                       decoration: BoxDecoration(
        //                           shape: BoxShape.circle,
        //                           color: Colors.black.withOpacity(0.1)),
        //                       child: GestureDetector(
        //                         onTap: () {
        //                           ref.read(addProvider).changePage(3);
        //                           if (ref
        //                               .watch(playlistProvider)
        //                               .addInPlayListTrueFalse) {
        //                             if (mounted) {
        //                               ref
        //                                   .read(playlistProvider)
        //                                   .showMixPlayList(goMixPlaylist: true);
        //                             }
        //                             if (mounted) {
        //                               ref
        //                                   .read(playlistProvider)
        //                                   .setMusic(setMusicModel: musicModel);
        //                             }
        //                             if (mounted) {
        //                               ref
        //                                   .read(playlistProvider)
        //                                   .addInPlaylistFalse();
        //                             }
        //                           } else {
        //                             ref.read(addProvider).changePage(2);
        //                             if (ref
        //                                 .read(mixMusicProvider)
        //                                 .selectMixSound) {
        //                               ref
        //                                   .read(mixMusicProvider)
        //                                   .mixFirstMusic(musicModel);
        //                             } else {
        //                               ref
        //                                   .read(mixMusicProvider)
        //                                   .mixSecondMusic(musicModel);
        //                             }
        //                             ref.read(addProvider).showPlusPlaylist(
        //                                 playlistPlusBottom: false);
        //                           }
        //                         },
        //                         child: const Padding(
        //                           padding: EdgeInsets.all(5.0),
        //                           child: Icon(
        //                             Icons.add,
        //                             color: blackColorA0,
        //                           ),
        //                         ),
        //                       ),
        //                     ),
        //                   )
        //                 : const SizedBox(),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
        // );
        return ValueListenableBuilder(
            valueListenable: Hive.box("fav").listenable(),
            builder: (context, box, _) {
              return GestureDetector(
                onTap: () async {
                  // if (issongplaying) await audioPlayer.dispose();
                  // await Future.delayed(Duration(seconds: 2));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => SoundDetailsScreen(
                            musicId: musicModel.id,
                            onPressed: () async {
                              if (ref.watch(addProvider).playFromPlayList) {
                                if (mounted) {
                                  ref.read(addProvider).changePage(3);
                                }
                                if (mounted) {
                                  changeToPlayNow = false;
                                  setState(() {});
                                }
                              } else {
                                setState(() {
                                  changeToPlayNow = false;
                                });
                              }
                            },
                          )));
                },
                // onTap: ref.watch(addProvider).showAddPlaylist?null:(){
                //   if(mounted){
                //     ref.read(addProvider).playFromPlaylistActive(change: false);
                //   }
                //   setState(() {
                //     music = musicModel;
                //     musicId = musicModel.id;
                //     changeToPlayNow = ref.watch(addProvider).showAddPlaylist?false:deleteShow?false:true;
                //     print("change");
                //   });
                // },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            "${musicModel.image}",
                            height: 60,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 5.0),
                        //   child: CustomImage(imageUrl: musicModel.image),
                        // ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomText(
                          text: musicModel.musicName,
                          color: blackColor50,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              // color: Colors.black.withOpacity(0.05),
                            ),
                            child: ref.read(addProvider).showAddPlaylist
                                ? GestureDetector(
                              onTap: () async {
                                musicId = musicModel.id;
                                if (mounted) {
                                  //playMusic(id: musicId);
                                }
                                print("OK");
                              },
                              child: musicId == musicModel.id
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
                              ),
                            )
                                : deleteShow
                                ? SizedBox()
                                : InkWell(
                                onTap: () {
                                  setState(() {
                                    if (box.containsKey(musicModel.id)) {
                                      box.delete(musicModel.id);
                                    } else {
                                      box.put(musicModel.id, musicModel);
                                    }

                                    // wishListController.addToCart(musicModel);
                                  });

                                  // Navigator.push(context, MaterialPageRoute(builder: (_)=> SoundDetailsScreen(
                                  //   musicId: musicModel.id,
                                  // onPressed: ()async{
                                  //   if(ref.watch(addProvider).playFromPlayList){
                                  //     if(mounted){
                                  //       ref.read(addProvider).changePage(3);
                                  //     }
                                  //     if(mounted){
                                  //       changeToPlayNow = false;
                                  //       setState(() {});
                                  //     }
                                  //   } else{
                                  //     setState(() {
                                  //       changeToPlayNow = false;
                                  //     });
                                  //   }
                                  // },
                                  // )));
                                },
                                child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Hive.box("fav")
                                        .containsKey(musicModel.id)
                                        ? Icon(
                                      Icons.favorite,
                                      size: 35,
                                      color: primaryPinkColor,
                                    )
                                        : Icon(
                                      Icons.favorite_border,
                                      size: 35,
                                      color: primaryPinkColor,
                                    ))),
                          ),
                          ref.read(addProvider).showAddPlaylist
                              ? Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.1)),
                              child: GestureDetector(
                                onTap: () {
                                  ref.read(addProvider).changePage(3);
                                  if (ref
                                      .watch(playlistProvider)
                                      .addInPlayListTrueFalse) {
                                    if (mounted) {
                                      ref
                                          .read(playlistProvider)
                                          .showMixPlayList(
                                          goMixPlaylist: true);
                                      //Change.
                                      //   ref.read(addProvider).showAddPlaylist=false;
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
                                    ref.read(addProvider).changePage(2);
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
                                    //  ref.read(addProvider).showAddPlaylist=false;
                                  }
                                },
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
                              : const SizedBox(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
      }
    }
    return Container();
  }

  Widget mixImageList(
      {required MixMusicModel mixMusicModel,
      required BuildContext context,
      required int index}) {
    return GestureDetector(
      onTap: () {
        if (mounted) {
          ref.read(mixMusicProvider).playFromPlayListActive(change: false);
        }
        if (mounted) {
          setState(() {
            mixMusicId = mixMusicModel.id;
            changeToMixPlayNow = ref.watch(addProvider).showAddPlaylist
                ? false
                : deleteShow
                    ? false
                    : true;
          });
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: CustomImage(imageUrl: dummy),
                ),
                const SizedBox(
                  width: 10,
                ),
                Flexible(
                    fit: FlexFit.loose,
                    child: Container(
                        color: Colors.transparent,
                        //width: ScreenSize(context).width * 0.55,
                        child: CustomText(
                          text:
                              "${mixMusicModel.first?.musicName} + ${mixMusicModel.second?.musicName}",
                          color: blackColor50,
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                ref.watch(addProvider).showAddPlaylist
                    ? const SizedBox()
                    : deleteShow
                        ? const SizedBox()
                        : InkWell(
                            onTap: () {
                              setState(() {
                                //fav[index] = !fav[index];
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,

                                //color: Colors.black.withOpacity(0.1),
                              ),
                              child: Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child:  Icon(
                                          Icons.favorite_border,
                                          size: 35,
                                          color: primaryPinkColor,
                                        )
                                     ),
                            ),
                          ),
                deleteShow
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.1)),
                          child: GestureDetector(
                            onTap: () {
                              _showDialog(
                                  firstMusicName:
                                      mixMusicModel.first?.musicName ?? "",
                                  secondMusicName:
                                      mixMusicModel.second?.musicName ?? '',
                                  context,
                                  mixId: mixMusicModel.id);
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: CustomSvg(svg: deleteSvg),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context,
      {required String firstMusicName,
      required String secondMusicName,
      required String mixId}) {
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
                      text: '$firstMusicName + $secondMusicName',
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
                      ref.read(mixMusicProvider).deleteMix(mixId: mixId);
                      if (mounted) {
                        Navigator.pop(context);
                      }
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
