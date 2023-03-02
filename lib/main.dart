import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:workout_app/data.dart';
import 'package:drift/drift.dart' as drift;
// import 'package:web_ffi/web_ffi.dart';

void main() {
  runApp(const MyApp());
}

final db = MyDatabase();
final _defaultLightColorScheme =
    ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 166, 118, 255));

final _defaultDarkColorScheme =
    _defaultLightColorScheme.copyWith(brightness: Brightness.dark);

ThemeMode? _themeMode;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // static final _defaultLightColorScheme =
  // ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 187, 94, 196));

  // static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
  //     primarySwatch: Colors.purple, brightness: Brightness.dark);

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
        darkTheme: ThemeData(
          // primarySwatch: Colors.indigo,
          useMaterial3: true,
          colorScheme: _defaultDarkColorScheme,
        ),
        themeMode: ThemeMode.light,
        // routes: {
        //   // This route needs to be registered, Because
        //   //  we are pushing this on the main Navigator Stack on line 754 (isRootNavigator:true)
        //   ProfileEdit.route: (context) => const ProfileEdit(),
        // },
        home: const NavBarHandler());
  }
}

class MenuItem {
  const MenuItem(this.iconData, this.text);
  final IconData iconData;
  final String text;
}

Future<void> navigate(BuildContext context, String route,
        {bool isDialog = false,
        bool isRootNavigator = true,
        Map<String, dynamic>? arguments}) =>
    Navigator.of(context, rootNavigator: isRootNavigator)
        .pushNamed(route, arguments: arguments);

final homeKey = GlobalKey<
    NavigatorState>(); //These are global variables to be used for Navigator (the method that helps link different pages)
final planKey = GlobalKey<NavigatorState>();
final exKey = GlobalKey<NavigatorState>();
final NavbarNotifier _navbarNotifier = NavbarNotifier();
// List<Color> colors = [mediumPurple, lightYellow, lightBlue];
// const Color mediumPurple = Color.fromRGBO(70, 107, 2, 1);
// const Color lightYellow = Color.fromRGBO(90, 138, 0, 1);
// const Color lightBlue = Color.fromRGBO(121, 187, 0, 1);
const String placeHolderText = 'This is placeholder text to be replaced.';

class NavBarHandler extends StatefulWidget {
  const NavBarHandler({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  State<NavBarHandler> createState() => _NavBarHandlerState();
}

class _NavBarHandlerState extends State<NavBarHandler>
    with SingleTickerProviderStateMixin {
  //this method is what handles the bottomNavBar: showing items, transitions
  final _buildBody = const <Widget>[HomePage(), PlanPage(), ExPage()];

  late List<BottomNavigationBarItem> _bottomList = <BottomNavigationBarItem>[];

  final menuItemlist = const <MenuItem>[
    MenuItem(Icons.home_rounded, 'Home'),
    MenuItem(Icons.all_inbox_rounded, 'Plans'),
    MenuItem(Icons.sunny, 'Excercises'),
  ];

  late Animation<double> fadeAnimation;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    fadeAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _bottomList = List.generate(
        _buildBody.length,
        (index) => BottomNavigationBarItem(
              // backgroundColor: Theme.of(context).colorScheme.primary,
              icon: Icon(menuItemlist[index].iconData),
              label: menuItemlist[index].text,
            )).toList();
    _controller.forward();
  }

  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 600),
        margin: EdgeInsets.only(
            bottom: kBottomNavigationBarHeight, right: 2, left: 2),
        content: Text('Tap back button again to exit'),
      ),
    );
  }

  void hideSnackBar() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  DateTime oldTime = DateTime.now();
  DateTime newTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final bool isExitingApp = await _navbarNotifier.onBackButtonPressed();
        if (isExitingApp) {
          newTime = DateTime.now();
          int difference = newTime.difference(oldTime).inMilliseconds;
          oldTime = newTime;
          if (difference < 1000) {
            hideSnackBar();
            return isExitingApp;
          } else {
            showSnackBar();
            return false;
          }
        } else {
          return isExitingApp;
        }
      },
      child: Material(
        child: AnimatedBuilder(
            animation: _navbarNotifier,
            builder: (context, snapshot) {
              return Stack(
                children: [
                  IndexedStack(
                    index: _navbarNotifier.index,
                    children: [
                      for (int i = 0; i < _buildBody.length; i++)
                        FadeTransition(
                            opacity: fadeAnimation, child: _buildBody[i])
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: AnimatedNavBar(
                        model: _navbarNotifier,
                        onItemTapped: (x) {
                          // User pressed  on the same tab twice
                          if (_navbarNotifier.index == x) {
                            _navbarNotifier.popAllRoutes(x);
                          } else {
                            _navbarNotifier.index = x;
                            _controller.reset();
                            _controller.forward();
                          }
                        },
                        menuItems: menuItemlist),
                  ),
                ],
              );
            }),
      ),
    );
  }
}

class NavbarNotifier extends ChangeNotifier {
  int _index = 0;
  int get index => _index;
  // bool _hideBottomNavBar = false;             //This variable was used to hide the bottom navigation with scrolling, but it was annoying so I disabled it lol

  set index(int x) {
    _index = x;
    notifyListeners();
  }

  // pop routes from the nested navigator stack and not the main stack
  // this is done based on the currentIndex of the bottom navbar
  // if the backButton is pressed on the initial route the app will be terminated
  FutureOr<bool> onBackButtonPressed() async {
    bool exitingApp = true;
    switch (_navbarNotifier.index) {
      case 0:
        if (homeKey.currentState != null && homeKey.currentState!.canPop()) {
          homeKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 1:
        if (planKey.currentState != null && planKey.currentState!.canPop()) {
          planKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      case 2:
        if (exKey.currentState != null && exKey.currentState!.canPop()) {
          exKey.currentState!.pop();
          exitingApp = false;
        }
        break;
      default:
        return false;
    }
    if (exitingApp) {
      return true;
    } else {
      return false;
    }
  }

  // pops all routes except first, if there are more than 1 route in each navigator stack
  void popAllRoutes(int index) {
    switch (index) {
      case 0:
        if (homeKey.currentState!.canPop()) {
          homeKey.currentState!.popUntil((route) => route.isFirst);
        }
        return;
      case 1:
        if (planKey.currentState!.canPop()) {
          planKey.currentState!.popUntil((route) => route.isFirst);
        }
        return;
      case 2:
        if (exKey.currentState!.canPop()) {
          exKey.currentState!.popUntil((route) => route.isFirst);
        }
        return;
      default:
        break;
    }
  }
}

class AnimatedNavBar extends StatefulWidget {
  const AnimatedNavBar(
      {Key? key,
      required this.model,
      required this.menuItems,
      required this.onItemTapped})
      : super(key: key);
  final List<MenuItem> menuItems;
  final NavbarNotifier model;
  final Function(int) onItemTapped;

  @override
  _AnimatedNavBarState createState() => _AnimatedNavBarState();
}

class _AnimatedNavBarState extends State<AnimatedNavBar>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this)
      ..addListener(() => setState(() {}));
    animation = Tween(begin: 0.0, end: 100.0).animate(_controller);
  }

  late AnimationController _controller;
  late Animation<double> animation;
  bool isHidden = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animation,
        builder: (BuildContext context, Widget? child) {
          return Transform.translate(
            offset: Offset(0, animation.value),
            child: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(2, -2),
                ),
              ]),
              child: BottomNavigationBar(
                // backgroundColor: Theme.of(context).colorScheme.primary,
                type: BottomNavigationBarType.shifting,
                currentIndex: widget.model.index,
                onTap: (x) {
                  widget.onItemTapped(x);
                },
                elevation: 16.0,
                showUnselectedLabels: true,
                unselectedItemColor: Colors.white54,
                selectedItemColor: Colors.white,
                items: widget.menuItems
                    .map((MenuItem menuItem) => BottomNavigationBarItem(
                          // backgroundColor: colors[widget.model.index],
                          backgroundColor:
                              //     // const Color.fromARGB(244, 255, 45, 45),
                              Theme.of(context).colorScheme.secondary,
                          // Theme.of(context).bottomNavigationBarTheme.copyWith(backgroundColor: Theme.of(context).colorScheme.primary),
                          icon: Icon(menuItem.iconData),
                          label: menuItem.text,
                        ))
                    .toList(),
              ),
            ),
          );
        });
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: homeKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext _) => const HomeFeeds();
              break;
            case FeedDetail.route:
              builder = (BuildContext _) {
                final id = (settings.arguments as Map)['id'];
                return FeedDetail(
                  feedId: id,
                );
              };
              break;
            default:
              builder = (BuildContext _) => const HomeFeeds();
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        });
  }
}

class PlanPage extends StatelessWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: planKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext _) => const PlanList();
              break;
            case PlanDetail.route:
              final id = (settings.arguments as Map)['id'];
              builder = (BuildContext _) {
                return PlanDetail(
                  id: id,
                );
              };
              break;
            // case PlanComments.route:
            //   final id = (settings.arguments as Map)['id'];
            //   builder = (BuildContext _) {
            //     return PlanComments(
            //       id: id,
            //     );
            //   };
            //   break;
            default:
              builder = (BuildContext _) => const PlanList();
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        });
  }
}

class ExPage extends StatelessWidget {
  const ExPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: exKey,
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          WidgetBuilder builder;
          switch (settings.name) {
            case '/':
              builder = (BuildContext _) => const ExScreen();
              break;
            // case ProfileEdit.route:
            //   builder = (BuildContext _) => const ProfileEdit();
            //   break;
            default:
              builder = (BuildContext _) => const ExScreen();
          }
          return MaterialPageRoute(builder: builder, settings: settings);
        });
  }
}

class HomeFeeds extends StatefulWidget {
  //creates state for home page
  const HomeFeeds({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  State<HomeFeeds> createState() => _HomeFeedsState();
}

class _HomeFeedsState extends State<HomeFeeds> {
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

  // void _addScrollListener() {              //this acts like an actionListener for the scrollbar to hide the bottomNavBar
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.userScrollDirection ==
  //         ScrollDirection.forward) {
  //       if (_navbarNotifier.hideBottomNavBar) {
  //         _navbarNotifier.hideBottomNavBar = false;
  //       }
  //     } else {
  //       if (!_navbarNotifier.hideBottomNavBar) {
  //         _navbarNotifier.hideBottomNavBar = true;
  //       }
  //     }
  //   });
  // }

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
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        foregroundColor:
                            Theme.of(context).colorScheme.tertiaryContainer),
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

class FeedTile extends StatelessWidget {
  final int index;
  const FeedTile({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      color: Colors.grey.withOpacity(0.4),
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 4,
            left: 4,
            child: Container(
              color: Colors.grey,
              height: 180,
            ),
          ),
          Positioned(
              bottom: 12,
              right: 12,
              left: 12,
              child: Text(placeHolderText.substring(0, 200)))
        ],
      ),
    );
  }
}

class FeedDetail extends StatelessWidget {
  final String feedId;
  const FeedDetail({Key? key, this.feedId = '1'}) : super(key: key);
  static const String route = '/feeds/detail';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(172, 239, 255, 195),
      appBar: AppBar(
        title: Text('Feed $feedId'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Placeholder(
                fallbackHeight: 200,
                fallbackWidth: 300,
              ),
              Text(placeHolderText),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanList extends StatefulWidget {
  const PlanList({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  State<PlanList> createState() => _PlanListState();
}

class _PlanListState extends State<PlanList> {
  //contains content for the second page
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(172, 239, 255, 195),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        title: Text(
          'Plans',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: const Center(
        child: Text(
          'Second page ;)',
          selectionColor: Color.fromARGB(0, 231, 140, 20),
          style: TextStyle(fontSize: 40),
        ),
      ),
    );
  }
}

class PlanTile extends StatelessWidget {
  //this will be used to show each of the exercise tiles / plans, will be shown on the second page.
  //this is for indiv. tiles in the Plan page
  final int index;
  const PlanTile({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        color: const Color.fromARGB(255, 240, 25, 25).withOpacity(0.5),
        height: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: const EdgeInsets.all(8),
              height: 75,
              width: 75,
              color: Colors.grey,
            ),
            Text('Plan $index'),
          ],
        ));
  }
}

class PlanDetail extends StatelessWidget {
  //will be changed to ExDescriptions
  //this is the detail within the Plan tiles
  final String id;
  const PlanDetail({Key? key, this.id = '1'}) : super(key: key);
  static const String route = '/Plan/detail';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan $id'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text('My AWESOME Plan $id'),
          const Center(
            child: Placeholder(
              fallbackHeight: 200,
              fallbackWidth: 300,
            ),
          ),
        ],
      ),
    );
  }
}

class ExScreen extends StatefulWidget {
  const ExScreen({Key? key}) : super(key: key);

  @override
  State<ExScreen> createState() => ExPageContent();
}

class ExPageContent extends State<ExScreen> {
  //contains content for the exercises page (to enter)
  static const String route = '/';

  // late MyDatabase _db;

  final _db = MyDatabase();

  final _controllerName = TextEditingController();
  final _controllerDes = TextEditingController();
  final _controllerMin = TextEditingController();
  final _controllerSec = TextEditingController();
  final _controllerTitleUpdate = TextEditingController();
  final _controllerDesUpdate = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    // Future forBuilder = _db.getExercises();
    // _buildList();
    super.initState();
  }

  @override
  void dispose() {
    _db.close();
    _controllerName.dispose();
    _controllerDes.dispose();
    _controllerMin.dispose();
    _controllerSec.dispose();
    _controllerTitleUpdate.dispose();
    _controllerDesUpdate.dispose();
    // super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // _db = MyDatabase();
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
          centerTitle: false,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.edit),
          //     onPressed: () {
          //       navigate(context, ProfileEdit.route);
          //     },
          //   )
          // ],
          title: Text(
            'Excercises',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: _controllerName,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter the exercise name',
                          suffixIcon: IconButton(
                            onPressed: _controllerName.clear,
                            icon: const Icon(Icons.clear),
                          )),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    'Enter the estimated time to complete:   ',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      // keyboardType: TextInputType.number,
                      controller: _controllerMin,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Minutes',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 100,
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      controller: _controllerSec,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Seconds',
                      ),
                    ),
                  ),
                  // Text('sec'),
                ],
              ),
            ),
            Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 300,
                      child: TextField(
                        controller: _controllerDes,
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'Enter the description of the exercise',
                            suffixIcon: IconButton(
                              onPressed: _controllerDes.clear,
                              icon: const Icon(Icons.clear),
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                        height: 50, //height of button
                        width: 100, //width of button
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20)),
                          onPressed: () {
                            addExercise();
                            setState(() {});
                          },
                          child: const Text('Submit'),
                        )),
                  ],
                )),
            Expanded(
              flex: 5,
              child: _buildGrid(),
            ),
            SizedBox(
                height: kBottomNavigationBarHeight + 10,
                width: MediaQuery.of(context).size.width)
          ],
        ),
      ),
    );
  }

  Widget _buildGrid() {
    return FutureBuilder<List<ExerciseData>>(
        future: _db.getExercises(),
        builder: (context, snapshot) {
          final List<ExerciseData>? exercises = snapshot.data;

          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (exercises != null) {
            // print("here in the gridbuilder");
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                controller: _scroll,
                // reverse: true,
                // shrinkWrap: true,
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: ((context) => AlertDialog(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(32.0))),
                                  title: Text(exercise.title.toString()),
                                  content:
                                      Text(exercise.description.toString()),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () => {
                                              // _db.deleteExercise(exercise.id),
                                              setState(() {
                                                _db.deleteExercise(exercise.id);
                                              }),
                                              Navigator.pop(context)
                                            },
                                        child: const Text("Delete")),
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"))
                                  ],
                                )));
                      },
                      child: Card(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  flex: 2,
                                  child: ListTile(
                                    // leading: Icon(Icons.album),
                                    title: Center(
                                        child: Text(
                                      exercise.title.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onTertiaryContainer),
                                    )),
                                    // trailing: const Icon(Icons.more_horiz),
                                    // subtitle: Text(exercise.description.toString()),
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        IconButton(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiaryContainer,
                                            onPressed: () => {
                                                  setState(() {
                                                    _db.deleteExercise(
                                                        exercise.id);
                                                  }),
                                                },
                                            icon: const Icon(Icons.delete)),
                                        IconButton(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onTertiaryContainer,
                                            onPressed: () => {
                                                  showDialog(
                                                      context: context,
                                                      builder:
                                                          ((context) =>
                                                              AlertDialog(
                                                                backgroundColor: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .tertiaryContainer,
                                                                shape: const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(32.0))),
                                                                title:
                                                                    TextField(
                                                                  // style: TextStyle(
                                                                  // color: Theme.of(
                                                                  //         context)
                                                                  //     .colorScheme
                                                                  //     .onTertiaryContainer),
                                                                  controller: _controllerTitleUpdate
                                                                    ..text = exercise
                                                                        .title
                                                                        .toString(),
                                                                  decoration: InputDecoration(
                                                                      // border:
                                                                      //     const OutlineInputBorder(),
                                                                      suffixIcon: IconButton(
                                                                    onPressed:
                                                                        _controllerTitleUpdate
                                                                            .clear,
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .clear),
                                                                  )),
                                                                ),
                                                                content:
                                                                    TextField(
                                                                  controller: _controllerDesUpdate
                                                                    ..text = exercise
                                                                        .description
                                                                        .toString(),
                                                                  decoration: InputDecoration(
                                                                      // border: const OutlineInputBorder(),
                                                                      // labelText: exercise
                                                                      //     .description
                                                                      //     .toString(),
                                                                      suffixIcon: IconButton(
                                                                    onPressed:
                                                                        _controllerDesUpdate
                                                                            .clear,
                                                                    icon: const Icon(
                                                                        Icons
                                                                            .clear),
                                                                  )),
                                                                ),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                      onPressed: () =>
                                                                          Navigator.pop(
                                                                              context),
                                                                      child: const Text(
                                                                          "Cancel")),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () =>
                                                                              {
                                                                                updateExercise(exercise.id),
                                                                                Navigator.pop(context),
                                                                                setState(() {})
                                                                              },
                                                                      child: const Text(
                                                                          "Update")),
                                                                ],
                                                              )))
                                                },
                                            icon: const Icon(Icons.edit))
                                      ])),
                            ]),
                      ),
                    ),
                  );
                });
          }
          return const Text('Santa is coming');
        });
    //   ],
    // );
  }

  void addExercise() {
    final entity = ExerciseCompanion(
        title: drift.Value(_controllerName.text),
        description: drift.Value(_controllerDes.text),
        minutes: drift.Value(int.tryParse(_controllerMin.text) == null
            ? 0
            : int.parse(_controllerMin.text)),
        seconds: drift.Value(int.tryParse(_controllerSec.text) == null
            ? 0
            : int.parse(_controllerSec.text)));
    _db.insertExercise(entity);

    _controllerName.clear();
    _controllerDes.clear();
    _controllerMin.clear();
    _controllerSec.clear();
  }

  void updateExercise(int id) {
    final entity = ExerciseCompanion(
      id: drift.Value(id),
      title: drift.Value(_controllerTitleUpdate.text),
      description: drift.Value(_controllerDesUpdate.text),
      // minutes: drift.Value(int.tryParse(_controllerMin.text) == null
      //     ? 0
      //     : int.parse(_controllerMin.text)),
      // seconds: drift.Value(int.tryParse(_controllerSec.text) == null
      //     ? 0
      //     : int.parse(_controllerSec.text)));
    );

    _db.updateEx(entity);
  }
}
