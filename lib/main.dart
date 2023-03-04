import 'dart:io';
import 'package:bye_bye_cry_new/initial_home_page.dart';
import 'package:bye_bye_cry_new/purchase/purchas_listner.dart';
import 'package:bye_bye_cry_new/purchase/purchase_api.dart';
import 'package:bye_bye_cry_new/test_page/test_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'confiq/store_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(
      store: Store.appleStore,
      apiKey: iosAPIKey,
    );
  } else if (Platform.isAndroid) {
    // Run the app passing --dart-define=AMAZON=true
   // const useAmazon = bool.fromEnvironment("amazon");
    StoreConfig(
      store: Store.googlePlay,
      apiKey:  googleAPIKey,
    );
  }

  PurchasListener.init();

  //await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bye Bye Cry',
      theme: ThemeData(fontFamily: 'Neue Einstellung'),
      home:   const InitialHomePage(),
      //home: const SignIn(),
    );
  }
}
