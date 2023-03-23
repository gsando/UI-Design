import 'dart:async';
import 'package:flutter/material.dart';
// import 'main.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:workout_app/main.dart';

List<Color> themeColors = const [
  Color.fromARGB(255, 131, 52, 0),
  Color.fromARGB(234, 255, 85, 85),
  Color.fromARGB(234, 255, 248, 148),
  Color.fromARGB(234, 222, 255, 77),
  Color.fromARGB(234, 143, 255, 152),
  Color.fromARGB(234, 126, 255, 227),
  Color.fromARGB(234, 131, 236, 255),
  Color.fromARGB(234, 124, 155, 255),
  Color.fromARGB(234, 234, 128, 255),
  Color.fromARGB(234, 255, 156, 164),
];

class Home extends StatefulWidget {
  //creates state for home page
  const Home({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //contains the page content for home screen
  final _scrollController = ScrollController();
  String timeString = '';
  @override
  void initState() {
    String hour = (DateTime.now().hour < 10)
        ? "0${DateTime.now().hour}"
        : "${DateTime.now().hour}";
    String minute = (DateTime.now().minute < 10)
        ? "0${DateTime.now().minute}"
        : "${DateTime.now().minute}";
    String second = (DateTime.now().second < 10)
        ? "0${DateTime.now().second}"
        : "${DateTime.now().second}";

    timeString = "$hour : $minute : $second";
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
    // _addScrollListener();
  }

  void _getCurrentTime() {
    setState(() {
      String hour = (DateTime.now().hour < 10)
          ? "0${DateTime.now().hour}"
          : "${DateTime.now().hour}";
      String minute = (DateTime.now().minute < 10)
          ? "0${DateTime.now().minute}"
          : "${DateTime.now().minute}";
      String second = (DateTime.now().second < 10)
          ? "0${DateTime.now().second}"
          : "${DateTime.now().second}";

      timeString = "$hour : $minute : $second";
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool selectFlag = false;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          IconButton(
              onPressed: () => {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor:
                                  const Color.fromARGB(255, 105, 105, 105),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(32.0))),
                              // ignore: sized_box_for_whitespace
                              content: Container(
                                // color: Colors.white,
                                width: 300,
                                height: 120,
                                child: GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent: 60),
                                  itemCount: 10,
                                  itemBuilder: ((context, index) {
                                    return IconButton(
                                        onPressed: () => {
                                              seedColor = themeColors[index],
                                              updateColor(),
                                              Phoenix.rebirth(context),
                                            },
                                        icon: Icon(
                                          Icons.circle,
                                          color: themeColors[index],
                                          size: 50,
                                        ));
                                  }),
                                ),
                              ),
                            ))
                  },
              icon: Icon(
                Icons.brush,
                color: Theme.of(context).colorScheme.onSecondary,
              )),
          IconButton(
            icon: Icon(
              Icons.dark_mode,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
            onPressed: () {
              if (modeFlag) {
                modeFlag = false;
              } else {
                modeFlag = true;
              }
              Phoenix.rebirth(context);
            },
          )
        ],
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(children: [
        Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Text(
                  timeString,
                  style: TextStyle(
                      fontSize: 60,
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                  textAlign: TextAlign.center,
                ))
              ],
            )),
        Expanded(
            flex: 3,
            child: Row(
                //this is the second row of the single column (holds the placeholder widget)
                // ignore: prefer_const_literals_to_create_immutables
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(), //<-- SEE HERE
                        minimumSize: MediaQuery.of(context).size,
                        padding: const EdgeInsets.all(20),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary),
                    child: const Icon(
                      //<-- SEE HERE
                      Icons
                          .brightness_5_rounded, //auto_awesome_outlined, blur_on
                      // color: Theme.of(context).colorScheme.tertiaryContainer,
                      size: 200,
                    ),
                  ),
                ])),
        SizedBox(
            height: kBottomNavigationBarHeight + 20,
            width: MediaQuery.of(context).size.width)
      ])),
    );
  }

  void updateColor() {
    colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: seedColor,
    );
    darkColorScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: seedColor,
    );
  }
}
