
import 'package:bye_bye_cry_new/screens/blog_screen.dart';
import 'package:bye_bye_cry_new/screens/botom_nev_bar/bootom_nav_bar.dart';
import 'package:bye_bye_cry_new/screens/home_page_again.dart';
import 'package:bye_bye_cry_new/screens/mix_screen.dart';
import 'package:bye_bye_cry_new/screens/playList_screen.dart';
import 'package:bye_bye_cry_new/screens/provider/add_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/mix_music_provider.dart';
import 'package:bye_bye_cry_new/screens/sound_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  addMusic(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(addProvider).addMusic();
      if(mounted){
        ref.read(mixMusicProvider).assignMixMusicList();
      }
      if(mounted){
        ref.read(mixMusicProvider).assignMixAllPlaylist();
      }
      if(mounted){
        ref.read(addProvider).assignAllPlaylist();
      }
      setState((){});
    });
  }
  initialized(){
      pageList = [
        const HomePageAgain(),
        const SoundScreen(),
        MixScreen(onPressed: (){
          setState(() {
            selectedIndex = 1;
          });
          print("from mix $selectedIndex");
        },),
        const PlayListScreen(),
        const BlogScreen(),
      ];
      setState(() {});
    print("asche");
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
      body: pageList.isEmpty?const SizedBox():pageList[ref.watch(addProvider).pageNumber],
    );
  }
}