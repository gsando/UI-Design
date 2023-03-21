import 'package:flutter/material.dart';
import 'package:workout_app/data.dart';
import 'navigation.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(Phoenix(child: const MyApp()));
// }

final _db = MyDatabase(); //opens the database connection

void main() {
  runApp(
    Provider<MyDatabase>(
      create: (context) => MyDatabase(),
      child: Phoenix(child: const MyApp()),
      dispose: (context, _db) => _db.close(),
    ),
  );
}

// final _db = MyDatabase();

const seedColor = Color.fromARGB(
    255, 58, 143, 255); //change this color to change the app's color scheme

final db = MyDatabase();
bool modeFlag = false;
final _defaulttColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: seedColor,
);

final _defaultDarkColorScheme =
    ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: seedColor);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  State<MyApp> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Wellness App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              (modeFlag ? _defaultDarkColorScheme : _defaulttColorScheme),
        ),
        // routes: {
        //   // This route needs to be registered, Because
        //   //  we are pushing this on the main Navigator Stack on line 754 (isRootNavigator:true)
        //   ProfileEdit.route: (context) => const ProfileEdit(),
        // },
        home: const NavBarHandler());
  }
}
