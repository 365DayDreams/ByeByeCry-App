import 'dart:io';
import 'package:bye_bye_cry_new/purchase/purchas_listner.dart';
import 'package:bye_bye_cry_new/purchase/purchase_api.dart';
import 'package:bye_bye_cry_new/screens/models/music_models.dart';
import 'package:bye_bye_cry_new/start_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'confiq/store_config.dart';
import 'package:flutter_system_ringtones/flutter_system_ringtones.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final docDir = await getApplicationDocumentsDirectory();
  Hive.init(docDir.path);
  Hive.initFlutter();
  Hive.registerAdapter(MusicModelAdapter());
  await Hive.openBox("fav");
  if (Platform.isAndroid) {
    await Firebase.initializeApp();
  }

  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appleStore,
      apiKey: iosAPIKey,
    );
  } else if (Platform.isAndroid) {
    StoreConfig(
      store: Store.googlePlay,
      apiKey: googleAPIKey,
    );
  }



  print(StoreConfig.instance.apiKey);
  //audioPlayer.setReleaseMode(ReleaseMode.loop);
  PurchasListener.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bye Bye Cry',
      theme: ThemeData(fontFamily: 'Neue Einstellung'),
      home: StartPage(),
    );
  }
}
