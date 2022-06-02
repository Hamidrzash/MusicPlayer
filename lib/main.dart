import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/Model/songs_data.dart';
import 'package:music_player/features/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TrackDataAdapter());
  var box = await Hive.openBox('trackDataBox');
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(systemNavigationBarColor: Color(0xff1E1B2E)));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
          scrollbarTheme: const ScrollbarThemeData().copyWith(
        thumbColor: MaterialStateProperty.all(
          const Color(0xff46435A).withOpacity(0.8),
        ),
      )),
      home: const MainPage(),
    );
  }
}
