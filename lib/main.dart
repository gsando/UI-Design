// import 'dart:isolate';

// import 'package:drift/isolate.dart';
import 'package:flutter/material.dart';
import 'package:workout_app/data.dart';
import 'package:workout_app/homePage.dart';
import 'navigation.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(Phoenix(child: const MyApp()));
// }

// final db = MyDatabase(); //opens the database connection
int i = 0;

List<String> assetAddresses = [
  'assets/images/31384010_7819378.jpg',
  'assets/images/33107626_8006483.jpg',
  'assets/images/20029964_6216724.jpg', //3
  'assets/images/6148163_3163475.jpg',
  'assets/images/20826365_6331545.jpg',
  'assets/images/22769281_6679192.jpg',
  'assets/images/20553205_6323198.jpg',
  'assets/images/32453804_7947855.jpg',
  'assets/images/32476995_7957723.jpg',
  // 'assets/images/13802680_5342228.jpg',
];

void main() {
  runApp(
    Provider<MyDatabase>(
      create: (context) => MyDatabase(),
      child: Phoenix(child: const MyApp()),
      dispose: (context, db) => {
        db.close(),
      },
    ),
  );
}

// final _db = MyDatabase();

var seedColor =
    themeColors[0]; //change this color to change the app's color scheme

// final db = MyDatabase();
bool modeFlag = false;
var colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: seedColor,
);

var darkColorScheme =
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
          colorScheme: (modeFlag ? darkColorScheme : colorScheme),
        ),
        // routes: {
        //   // This route needs to be registered, Because
        //   //  we are pushing this on the main Navigator Stack on line 754 (isRootNavigator:true)
        //   ProfileEdit.route: (context) => const ProfileEdit(),
        // },
        home: const NavBarHandler());
  }

  // String rotatePics() {
  //   int hold = assetAddresses.length;
  //   if (i == (assetAddresses.length)) {
  //     i = 0;
  //     // print("This is $i and address.length $hold");
  //   }
  //   ++i;
  //   // print("This is $i and address.length $hold");
  //   return assetAddresses[i - 1];
  // }
}
