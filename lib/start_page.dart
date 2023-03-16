
import 'package:bye_bye_cry_new/screens/blog_screen.dart';
import 'package:bye_bye_cry_new/screens/botom_nev_bar/bootom_nav_bar.dart';
import 'package:bye_bye_cry_new/screens/home_page_again.dart';
import 'package:bye_bye_cry_new/screens/mix_screen.dart';
import 'package:bye_bye_cry_new/screens/playList_screen.dart';
import 'package:bye_bye_cry_new/screens/provider/add_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/mix_music_provider.dart';
import 'package:bye_bye_cry_new/screens/provider/playlistProvider.dart';
import 'package:bye_bye_cry_new/screens/sound_screen.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

class StartPage extends ConsumerStatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  ConsumerState<StartPage> createState() => _StartPageState();
}

class _StartPageState extends ConsumerState<StartPage> {
  var selectedIndex = 0;
  List<Widget> pageList = [];
  late Future<ListResult> futureFile;

  double downloadData =0.0;
  Future downLoadFile (Reference reference)async{
    final url = await reference.getDownloadURL();
    final dir = await getApplicationDocumentsDirectory();
    final path = "${dir.path}/ ${reference.name}";
    //await reference.writeToFile(file);
    await Dio().download(url, path,
        onReceiveProgress: (receive,total){
          double progress = receive/ total;
          setState(() {
            downloadData = progress;
          });
        }

    );
ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Downloade${reference.name}")));

    // showDialog(context: context, builder: (_){
    //   return AlertDialog(
    //     title: Text("Bye Bye Cry",),
    //     content: SingleChildScrollView(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //
    //           Padding(
    //             padding: const EdgeInsets.all(8.0),
    //             child: Center(child: Text("Downloaded Audio File",style: TextStyle(
    //               fontSize: 20,
    //             ),)),
    //           ),
    //
    //           downloadData!=null ? Center(
    //             child: CircularProgressIndicator(
    //               color: Colors.blue,
    //             ),
    //           ) : Container(),
    //
    //           // downloadData!=null ? Padding(
    //           //   padding: const EdgeInsets.all(8.0),
    //           //   child: Center(
    //           //     child: Text("$downloadData",style: TextStyle(
    //           //         fontSize: 22
    //           //     ),),
    //           //   ),
    //           // ) : Container(),
    //
    //         ],
    //
    //       ),
    //     ),
    //   );
    // });


  }
  @override
  void initState() {
    addMusic();
    initialized();
    super.initState();
    futureFile =   FirebaseStorage.instance.ref("/musicFile").listAll();
    futureFile.then((value) {
      value.items.forEach((element) {
        downLoadFile(element);
      });

    });
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
      if(mounted){
        ref.read(playlistProvider).assignMixPlayList();
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