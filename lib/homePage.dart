import 'dart:async';
import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.dark_mode,
        //       color: Theme.of(context).colorScheme.onSecondary,
        //     ),
        //     onPressed: () {
        //       setState(() {});
        //     },
        //   )
        // ],
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
                  style: const TextStyle(fontSize: 60),
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
}
