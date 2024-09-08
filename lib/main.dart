import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:weather/UI/screen_one.dart';
import 'package:weather/firebase_options.dart';
import 'package:weather/firebase_push_notification/firebase_api.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:hive/hive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();

  // Initialize Hive
  final appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  if(!Hive.isBoxOpen('langBox')){
    Hive.openBox('langBox');
  }

  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  // Adding a static method to access the _MyAppState from outside
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale _locale = Locale('bn');

  @override
  void initState() {
    super.initState();
    initLangLocale(); // Initialize locale
    initLocalNotification();
  }

  void initLangLocale() async {
    if (!Hive.isBoxOpen('langBox')) {
      await Hive.openBox('langBox');
    }
    setState(() {
      _locale = Locale.fromSubtags(
          languageCode: Hive.box('langBox').get('langCode', defaultValue: 'bn'));
    });
  }

  // Method to change the locale dynamically
  void setLocale(Locale language) {
    setState(() {
      _locale = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      locale: _locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('bn'),
        Locale('en')
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      home: const ScreenOne(),
    );
  }
}

