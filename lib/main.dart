import 'package:flutter/material.dart';
import 'package:workout_app/data.dart';
import 'navigation.dart';

void main() {
  runApp(const MyApp());
}

final db = MyDatabase();
final _defaultLightColorScheme =
    ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 71, 227, 255));

final _defaultDarkColorScheme =
    _defaultLightColorScheme.copyWith(brightness: Brightness.dark);

ThemeMode? _themeMode;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wellness App',
        theme: ThemeData(
          // primarySwatch: Colors.indigo,
          useMaterial3: true,
          colorScheme: _defaultLightColorScheme,
        ),
        // routes: {
        //   // This route needs to be registered, Because
        //   //  we are pushing this on the main Navigator Stack on line 754 (isRootNavigator:true)
        //   ProfileEdit.route: (context) => const ProfileEdit(),
        // },
        home: const NavBarHandler());
  }
}
