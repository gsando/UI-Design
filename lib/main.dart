import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Wellness App',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
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

final homeKey = GlobalKey<NavigatorState>();
final planKey = GlobalKey<NavigatorState>();
final exKey = GlobalKey<NavigatorState>();
final NavbarNotifier _navbarNotifier = NavbarNotifier();
List<Color> colors = [mediumPurple, lightYellow, lightBlue];
const Color mediumPurple = Color.fromRGBO(219, 157, 255, 1);
const Color lightYellow = Color.fromRGBO(247, 173, 62, 1);
const Color lightBlue = Color.fromRGBO(101, 197, 189, 1);
const String placeHolderText = 'This is placeholder text to be replaced.';

class NavBarHandler extends StatefulWidget {
  const NavBarHandler({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  State<NavBarHandler> createState() => _NavBarHandlerState();
}

class _NavBarHandlerState extends State<NavBarHandler>
    with SingleTickerProviderStateMixin {
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
  bool _hideBottomNavBar = false;

  set index(int x) {
    _index = x;
    notifyListeners();
  }

  bool get hideBottomNavBar => _hideBottomNavBar;
  set hideBottomNavBar(bool x) {
    _hideBottomNavBar = x;
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
                          backgroundColor: colors[widget.model.index],
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
    return Theme(
      data: ThemeData(
          colorScheme:
              Theme.of(context).colorScheme.copyWith(primary: mediumPurple)),
      child: Navigator(
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
          }),
    );
  }
}

class PlanPage extends StatelessWidget {
  const PlanPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          colorScheme:
              Theme.of(context).colorScheme.copyWith(primary: colors[1])),
      child: Navigator(
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
              case PlanComments.route:
                final id = (settings.arguments as Map)['id'];
                builder = (BuildContext _) {
                  return PlanComments(
                    id: id,
                  );
                };
                break;
              default:
                builder = (BuildContext _) => const PlanList();
            }
            return MaterialPageRoute(builder: builder, settings: settings);
          }),
    );
  }
}

class ExPage extends StatelessWidget {
  const ExPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          colorScheme:
              Theme.of(context).colorScheme.copyWith(primary: colors[2])),
      child: Navigator(
          key: exKey,
          initialRoute: '/',
          onGenerateRoute: (RouteSettings settings) {
            WidgetBuilder builder;
            switch (settings.name) {
              case '/':
                builder = (BuildContext _) => const ExPageContent();
                break;
              // case ProfileEdit.route:
              //   builder = (BuildContext _) => const ProfileEdit();
              //   break;
              default:
                builder = (BuildContext _) => const ExPageContent();
            }
            return MaterialPageRoute(builder: builder, settings: settings);
          }),
    );
  }
}

class HomeFeeds extends StatefulWidget {
  const HomeFeeds({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  State<HomeFeeds> createState() => _HomeFeedsState();
}

class _HomeFeedsState extends State<HomeFeeds> {
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
    _addScrollListener();
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

  void _addScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_navbarNotifier.hideBottomNavBar) {
          _navbarNotifier.hideBottomNavBar = false;
        }
      } else {
        if (!_navbarNotifier.hideBottomNavBar) {
          _navbarNotifier.hideBottomNavBar = true;
        }
      }
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
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(children: [
        Container(
            //creating container for the row to add padding
            padding: const EdgeInsets.all(20),
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
        Row(

            //this is the second row of the single column (holds the placeholder widget)
            // ignore: prefer_const_literals_to_create_immutables
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[Placeholder()])
      ])),
    );
    //   body: ListView.builder(
    //     controller: _scrollController,
    //     itemCount: 3,
    //     itemBuilder: (context, index) {
    //       return InkWell(
    //           onTap: () {
    //             _navbarNotifier.hideBottomNavBar = false;
    //             navigate(context, FeedDetail.route,
    //                 isRootNavigator: false,
    //                 arguments: {'id': index.toString()});
    //           },
    //           child: FeedTile(index: index));
    //     },
    //   ),
    // );
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
      appBar: AppBar(
        title: const Text('Plans'),
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
          // TextButton(
          //     onPressed: () {
          //       _navbarNotifier.hideBottomNavBar = false;
          //       navigate(context, PlanComments.route,
          //           isRootNavigator: false, arguments: {'id': id.toString()});
          //     },
          //     child: const Text('show comments'))
        ],
      ),
    );
  }
}

class PlanComments extends StatelessWidget {
  //this has been commented out as we will not need comments
  final String id;
  const PlanComments({Key? key, this.id = '1'}) : super(key: key);
  static const String route = '/Plan/detail/comments';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments on Plan $id'),
      ),
      body: ListView.builder(itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 60,
            child: ListTile(
              tileColor: Colors.grey.withOpacity(0.5),
              title: Text('Comment $index'),
            ),
          ),
        );
      }),
    );
  }
}

class ExPageContent extends StatelessWidget {
  static const String route = '/';

  const ExPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: false,
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.edit),
          //     onPressed: () {
          //       navigate(context, ProfileEdit.route);
          //     },
          //   )
          // ],
          title: const Text('Excercises')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('Enter an excercise'),
                SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    decoration: InputDecoration(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileEdit extends StatelessWidget {
  static const String route = '/profile/edit';

  const ProfileEdit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Edit')),
      body: const Center(
        child: Text('Notice this page does not have bottom navigation bar'),
      ),
    );
  }
}
