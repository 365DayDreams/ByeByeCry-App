import 'package:bye_bye_cry_new/local_db/local_db.dart';
import 'package:bye_bye_cry_new/screens/blog_screen.dart';
import 'package:bye_bye_cry_new/screens/botom_nev_bar/bootom_nav_bar.dart';
import 'package:bye_bye_cry_new/screens/home_page_again.dart';
import 'package:bye_bye_cry_new/screens/listen_mix_sound.dart';
import 'package:bye_bye_cry_new/screens/mix_screen.dart';
import 'package:bye_bye_cry_new/screens/models/AppData.dart';
import 'package:bye_bye_cry_new/screens/my_playList_details_screen.dart';
import 'package:bye_bye_cry_new/screens/playList_screen.dart';
import 'package:bye_bye_cry_new/screens/provider/add_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/mix_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/playlistProvider.dart';
import 'package:bye_bye_cry_new/screens/sound_screen.dart';
import 'package:bye_bye_cry_new/wishlist_Screen/wishlist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'compoment/shared/custom_image.dart';
import 'compoment/utils/color_utils.dart';
import 'compoment/utils/image_link.dart';
import 'sounds_details_screen.dart';

class StartPage extends ConsumerStatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StartPage> createState() => _StartPageState();
}

class _StartPageState extends ConsumerState<StartPage> {
  var selectedIndex = 0;
  List<Widget> pageList = [];

  @override
  void initState() {
    addMusic();
    initialized();
    super.initState();
  }

  addMusic() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(addProvider).addMusic();
      if (mounted) {
        ref.read(mixMusicProvider).assignMixMusicList();
      }
      if (mounted) {
        ref.read(mixMusicProvider).assignMixAllPlaylist();
      }
      if (mounted) {
        ref.read(addProvider).assignAllPlaylist();
      }
      if (mounted) {
        ref.read(playlistProvider).assignMixPlayList();
      }
      setState(() {});
    });
  }

  initialized() {
    pageList = [
      const HomePageAgain(),
      const SoundScreen(),
      MixScreen(
        onPressed: () {
          // selectedIndex==1;
        },
      ),
      const PlayListScreen(),
      const WishListScreen(),
      const BlogScreen(),
    ];
    setState(() {});
    print("asche");
  }

  getTitleName(type) {
    switch (type) {
      case "Playlist":
        return "(PlayList)";
      case "mixSound":
        return "(Mix Sounds)";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomAppBar(
        onPressed: (index) {
          setState(() {
            selectedIndex = index;
            ref.watch(addProvider).changePage(index);
            print('${selectedIndex}');
          });
        },
        index: selectedIndex,
      ),
      body: pageList.isEmpty
          ? const SizedBox()
          : Column(
              children: [
                Expanded(child: pageList[ref.watch(addProvider).pageNumber]),
                Obx(() {
                  AppData.isPlaying.value;
                  return FutureBuilder<Map<String, dynamic>>(
                    future: AppData().getMusicTitle(),
                    builder: (_, snapshot) {
                      if (AppData.isPlaying.value)
                        return InkWell(
                          onTap: () {
                            print("AppData.idCurrentMusic.toString()");
                            print(snapshot.data);
                            if (snapshot.data!["type"] == "mixSound") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ListenMixSound(
                                            mixMusicModelId:
                                                snapshot.data!["id"],
                                            onPressed: () async {
                                              if (ref
                                                  .watch(mixMusicProvider)
                                                  .playFromPlayList) {
                                                if (mounted) {
                                                  ref
                                                      .read(addProvider)
                                                      .changePage(3);
                                                }
                                                if (mounted) {
                                                  //  changeToPlayNow = false;
                                                  setState(() {});
                                                }
                                              } else {
                                                setState(() {
                                                  //changeToPlayNow = false;
                                                });
                                              }
                                            },
                                          )));
                            } else if (snapshot.data!["type"] == "single") {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SoundDetailsScreen(
                                            musicId: snapshot.data!["id"],
                                            onPressed: () async {
                                              if (ref
                                                  .watch(addProvider)
                                                  .playFromPlayList) {
                                                if (mounted) {
                                                  ref
                                                      .read(addProvider)
                                                      .changePage(3);
                                                }
                                                if (mounted) {
                                                  //  changeToPlayNow = false;
                                                  setState(() {});
                                                }
                                              } else {
                                                setState(() {
                                                  //changeToPlayNow = false;
                                                });
                                              }
                                            },
                                          )));
                            } else if (snapshot.data!["type"] == "Playlist") {
                              setData() {
                                if (mounted) {
                                  ref
                                      .read(playlistProvider)
                                      .setMixPlaylistMusicId(
                                          setMixPlaylistId:
                                              snapshot.data!["id"]);
                                }
                                if (mounted) {
                                  ref.read(addProvider).changePage(1);
                                }
                                if (mounted) {
                                  ref
                                      .read(playlistProvider)
                                      .changePlaying(change: true);
                                }
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PlaylistMixSound2(
                                    playlistMixMusicId: snapshot.data!["id"],
                                    onPressed: setData,
                                    songIndex: snapshot.data!['musicIndex'],
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                           // height: 80,
                            decoration: BoxDecoration(
                              color: secondaryPinkColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.08),
                                        borderRadius:
                                            BorderRadius.circular(150.0)),
                                    child: CustomImage(
                                      scale: 0.8,
                                      imageUrl: playButton,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 16,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Now Playing ${getTitleName(snapshot.data!["type"])}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 2.0),
                                        child: Text(
                                          "${snapshot.data!['title']}",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Icon(Icons.arrow_forward, size: 28,)
                                ],
                              ),
                            ),
                            // child: Material(
                            //   elevation: 10, borderRadius: BorderRadius.circular(12),
                            //   child: Padding(
                            //     padding: const EdgeInsets.all(8.0),
                            //     child: Text("${snapshot.data!['title']}"),
                            //   ),
                            // ),
                          ),
                        );
                      return Container();
                    },
                  );
                  return Container();
                })
              ],
            ),
    );
  }
}
