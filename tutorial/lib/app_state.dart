import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'router/ui_pages.dart';

const String LoggedInKey = 'LoggedIn';

//  defines what types of page states the app can be in.
// If the app is in the none state, nothing needs to be done.
// If it is in the addPage state, then a page needs to be added.
// To pop a page, set the page state to pop.
enum PageState { none, addPage, addAll, addWidget, pop, replace, replaceAll }

// wraps several items that allow the router to handle a page action.
class PageAction {
  PageState state;
  // The page, pages and widget are all optional fields
  // and each are used differently depending on the page state
  PageConfiguration? page;
  List<PageConfiguration>? pages;
  Widget? widget;

  PageAction(
      {this.state = PageState.none,
      this.page = null,
      this.pages = null,
      this.widget = null});
}

// AppState. This class holds the logged-in flag, shopping cart items and current page action
class AppState extends ChangeNotifier {
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  bool _splashFinished = false;
  bool get splashFinished => _splashFinished;

  final cartItems = [];

  String? emailAddress;

  String? password;

  PageAction _currentAction = PageAction();
  PageAction get currentAction => _currentAction;
  set currentAction(PageAction action) {
    _currentAction = action;
    notifyListeners();
  }

  AppState() {
    getLoggedInState();
  }

  void resetCurrentAction() {
    _currentAction = PageAction();
  }

  void addToCart(String item) {
    cartItems.add(item);
    notifyListeners();
  }

  void removeFromCart(String item) {
    cartItems.add(item);
    notifyListeners();
  }

  void clearCart() {
    cartItems.clear();
    notifyListeners();
  }

  void setSplashFinished() {
    // Set the splash state to be finished
    _splashFinished = true;
    // If the user is logged in, show the list page.
    if (_loggedIn) {
      _currentAction =
          PageAction(state: PageState.replaceAll, page: ListItemsPageConfig);
    }
    // Otherwise show the login page.
    else {
      _currentAction =
          PageAction(state: PageState.replaceAll, page: LoginPageConfig);
    }
    // By setting the current action and calling notifyListeners,
    // you will trigger a state change and the router will update
    // its list of pages based on the current app state.
    notifyListeners();
  }

  void login() {
    _loggedIn = true;
    saveLoginState(loggedIn);
    _currentAction =
        PageAction(state: PageState.replaceAll, page: ListItemsPageConfig);
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    saveLoginState(loggedIn);
    _currentAction =
        PageAction(state: PageState.replaceAll, page: LoginPageConfig);
    notifyListeners();
  }

  void saveLoginState(bool loggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(LoggedInKey, loggedIn);
  }

  void getLoggedInState() async {
    final prefs = await SharedPreferences.getInstance();
    _loggedIn = prefs.getBool(LoggedInKey)!;
  }
}
