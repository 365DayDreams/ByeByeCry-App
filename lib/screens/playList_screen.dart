import 'package:bye_bye_cry_new/compoment/shared/custom_image.dart';
import 'package:bye_bye_cry_new/compoment/shared/custom_text.dart';
import 'package:bye_bye_cry_new/screens/provider/add_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/mix_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/playlistProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../compoment/shared/custom_app_bar.dart';
import '../compoment/shared/custom_navigation.dart';
import '../compoment/shared/custom_svg.dart';
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
      appBar:  CustomAppBar(
        title: 'My Playlist',
        //actionTitle: 'Edit',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, top: 10, bottom: 10),
              child: Container(
                height: 60,
                margin: const EdgeInsets.all(16),
                color: secondaryWhiteColor2,
                child: ListTile(
                  dense: true,
                  title: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: blackColorA0,fontSize: 14,fontWeight: FontWeight.w400),
                        hintText: 'Search music', border: InputBorder.none
                    ),
                  ),
                  trailing: GestureDetector(onTap:(){},child: const CustomSvg(svg: "asset/images/search_icon.svg",)),
                ),
              ),
            ),
            Column(
              children: List.generate(
                ref.watch(playlistProvider).mixMixPlaylist.length,
                    (index) => Container(
                    color: index % 2 == 0?Colors.transparent:pinkLightColor,
                    child: mixMixMusicList(musicName: "${ref.watch(playlistProvider).mixMixPlaylist[index].title}",musicId: ref.watch(playlistProvider).mixMixPlaylist[index].id)),
              ),
            ),
            Column(
              children: List.generate(
                ref.watch(addProvider).playList.length,
                (index) => Container(
                    color: index % 2 == 0?Colors.transparent:pinkLightColor,
                    child: musicList(musicName: ref.watch(addProvider).playList[index].musicName,musicId:  ref.watch(addProvider).playList[index].id)),
              ),
            ),
            Column(
              children: List.generate(
                ref.watch(mixMusicProvider).mixPlaylist.length,
                    (index) => Container(
                    color: index % 2 == 0?Colors.transparent:pinkLightColor,
                    child: mixMusicList(musicName: "${ref.watch(mixMusicProvider).mixPlaylist[index].first?.musicName}+${ref.watch(mixMusicProvider).mixPlaylist[index].second?.musicName}",musicId:  ref.watch(mixMusicProvider).mixPlaylist[index].id)),
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
              //  height: height * .07,
                color: pinkLightColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 5),
                  child: Row(
                    children: [
                      IconButton(
                        iconSize: 40,
                        icon: const Icon(
                          Icons.add,
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(width: height * .05),
                      const CustomText(
                        text: 'Add Playlist',
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
  Widget musicList({required String musicName,required String musicId}) {
    final height = ScreenSize(context).height;
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 5),
      child: Row(
        //  crossAxisAlignment: CrossAxisAlignment.start,
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
              ),
              const SizedBox(width: 20),
              CustomText(
                text: musicName,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          GestureDetector(
            onTap: (){
              if(mounted){
                ref.read(addProvider).setMusicId(normalMusicId: musicId);
              }
              if(mounted){
                ref.read(addProvider).changePage(1);
              }
              if(mounted){
                ref.read(addProvider).changePlay(change: true);
              }
              if(mounted){
                ref.read(addProvider).playFromPlaylistActive(change: true);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.1)
              ),
              child: const Padding(
                padding: EdgeInsets.all(1.0),
                child: CustomImage(
                  imageUrl: playButton,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget mixMusicList({required String musicName,required String musicId}) {
    final height = ScreenSize(context).height;
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 5, bottom: 5),
      child: Row(
        //  crossAxisAlignment: CrossAxisAlignment.start,
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
              ),
              const SizedBox(width: 20),
              CustomText(
                text: musicName,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          GestureDetector(
            onTap: (){
              if(mounted){
                ref.read(mixMusicProvider).setMusicId(mixMusicId: musicId);
              }
              if(mounted){
                ref.read(addProvider).changePage(1);
              }
              if(mounted){
                ref.read(mixMusicProvider).changeMixPlay(change:true);
              }
              if(mounted){
                ref.read(mixMusicProvider).playFromPlayListActive(change:true);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.1)
              ),
              child: const Padding(
                padding: EdgeInsets.all(1.0),
                child: CustomImage(
                  imageUrl: playButton,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget mixMixMusicList({required String musicName,required String musicId}) {
    final height = ScreenSize(context).height;
    return Padding(
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
              ),
              const SizedBox(width: 20),
              CustomText(
                text: musicName,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
          GestureDetector(
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
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.1)
              ),
              child: const Padding(
                padding: EdgeInsets.all(1.0),
                child: CustomImage(
                  imageUrl: playButton,
                  height: 30,
                  width: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
