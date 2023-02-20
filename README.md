# workout_app

This is a workout app being developed for UI Design.

This is in it's starting stages.


FYI:

NavBarHandler and _NavBarHandlerState have to do with the bottom navigation bar, essentially creates the widget and ensures it is always visible
    _NavBarHandlerState creates a widget stack in order to navigate between the pages

NavBarNotifier is called when the index of the bottomNavBar is changed (one of the three buttons are clicked to navigate to a different page) and pops the chosen page out of the stack. *Currently, the profile edit function is commented out, so if wanting to add it back in, the route must be added again in the MyApp class*

AnimatedNavBar and _AnimatedNavBarState is what makes the bottom navigation bar move and transition as different options are clicked

HomePage acts as the directions for the route to the home page, which is _HomeFeedsState


**Drift does not support web developement!**

***When in developement***
Run 
    flutter build windows
    flutter run
    *select 1, windows*


