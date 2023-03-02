import 'dart:async';
import 'package:flutter/material.dart';
import 'homePage.dart';
import 'planPage.dart';
import 'exPage.dart';

final homeKey = GlobalKey<
    NavigatorState>(); //These are global variables to be used for Navigator (the method that helps link different pages)
final planKey = GlobalKey<NavigatorState>();
final exKey = GlobalKey<NavigatorState>();
final NavbarNotifier _navbarNotifier = NavbarNotifier();

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

const String placeHolderText = 'This is placeholder text to be replaced.';

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
              builder = (BuildContext _) => const Home();
              break;
            default:
              builder = (BuildContext _) => const Home();
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
