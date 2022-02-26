// ignore: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'ui_pages.dart';
import '../app_state.dart';
import '../ui/ui.dart';

// 1
class ShoppingRouterDelegate extends RouterDelegate<PageConfiguration>
    // 2
    // uses the ChangeNotifier mixin, which helps notify any listeners of this delegate to update themselves whenever notifyListeners() is invoked.
    // This class also uses PopNavigatorRouterDelegateMixin, which lets you remove pages. It’ll also be useful later when you implement BackButtonDispatcher.
    with
        ChangeNotifier,
        PopNavigatorRouterDelegateMixin<PageConfiguration> {
  // 3
  // list of Pages is the core of the app’s navigation,
  //  and it denotes the current list of pages in the navigation stack.
  // It’s private so that it can’t be modified directly, as that could lead to errors and unwanted states.
  final List<Page> _pages = [];

  // 4
  // PopNavigatorRouterDelegateMixin requires a navigatorKey used for retrieving the current navigator of the Router
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  // 5
  final AppState appState;

  // 6
  // takes in the current app state and creates a global navigator key. It’s important that you only create this key once.
  ShoppingRouterDelegate(this.appState) : navigatorKey = GlobalKey() {
    appState.addListener(() {
      notifyListeners();
    });
  }

  // 7
  /// Getter for a list that cannot be changed
  List<MaterialPage> get pages => List.unmodifiable(_pages);

  /// Number of pages function
  int numPages() => _pages.length;

  // 8
  @override
  PageConfiguration get currentConfiguration =>
      _pages.last.arguments as PageConfiguration;

  // gets called by RouterDelegate to obtain the widget tree that represents
  //// the current state. In this scenario, the current state is the navigation history of the app
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onPopPage: _onPopPage,
      pages: buildPages(),
    );
  }

// The result argument is the value with which the route completed. An example of this is the value returned from a dialog when it’s popped.
  bool _onPopPage(Route<dynamic> route, result) {
    // 1
    final didPop = route.didPop(result);
    if (!didPop) {
      return false;
    }
    // 2
    if (canPop()) {
      pop();
      return true;
    } else {
      return false;
    }
  }

  void _removePage(MaterialPage page) {
    if (page != null) {
      _pages.remove(page);
    }
  }

  void pop() {
    if (canPop()) {
      _removePage(_pages.last);
    }
  }

  bool canPop() {
    return _pages.length > 1;
  }

  @override
  Future<bool> popRoute() {
    if (canPop()) {
      _removePage(_pages.last);
      return Future.value(true);
    }
    return Future.value(false);
  }

  MaterialPage _createPage(Widget child, PageConfiguration pageConfig) {
    return MaterialPage(
        child: child,
        key: Key(pageConfig.key),
        name: pageConfig.path,
        arguments: pageConfig);
  }

// method to add this page to the navigation stack, i.e. to the _pages list
  void _addPageData(Widget child, PageConfiguration pageConfig) {
    _pages.add(
      _createPage(child, pageConfig),
    );
  }

  void addPage(PageConfiguration pageConfig) {
    // 1
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            pageConfig.uiPage;

    if (shouldAddPage) {
      // 2
      switch (pageConfig.uiPage) {
        case Pages.Splash:
          // 3
          _addPageData(const Splash(), SplashPageConfig);
          break;
        case Pages.Login:
          _addPageData(const Login(), LoginPageConfig);
          break;
        case Pages.CreateAccount:
          _addPageData(const CreateAccount(), CreateAccountPageConfig);
          break;
        case Pages.List:
          _addPageData(const ListItems(), ListItemsPageConfig);
          break;
        case Pages.Cart:
          _addPageData(const Cart(), CartPageConfig);
          break;
        case Pages.Checkout:
          _addPageData(const Checkout(), CheckoutPageConfig);
          break;
        case Pages.Settings:
          _addPageData(const Settings(), SettingsPageConfig);
          break;
        case Pages.Details:
          if (pageConfig.currentPageAction != null) {
            _addPageData(pageConfig.currentPageAction.widget, pageConfig);
          }
          break;
        default:
          break;
      }
    }
  }

  // Removes the last page, i.e the top-most page of the app,
  // and replaces it with the new page using the add method
  void replace(PageConfiguration newRoute) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    addPage(newRoute);
  }

  // Clears the entire navigation stack, i.e. the _pages list,
  // and adds all the new pages provided as the argument
  void setPath(List<MaterialPage> path) {
    _pages.clear();
    _pages.addAll(path);
  }

  // Calls setNewRoutePath. You’ll see what this method does in a moment.
  void replaceAll(PageConfiguration newRoute) {
    setNewRoutePath(newRoute);
  }

  // This is like the addPage method, but with a different name to be
  // in sync with Flutter’s push and pop naming.
  void push(PageConfiguration newRoute) {
    addPage(newRoute);
  }

  // Allows adding a new widget using the argument of type Widget.
  // This is what you’ll use for navigating to the Details page.
  void pushWidget(Widget child, PageConfiguration newRoute) {
    _addPageData(child, newRoute);
  }

  // Adds a list of pages.
  void addAll(List<PageConfiguration> routes) {
    _pages.clear();
    routes.forEach((route) {
      addPage(route);
    });
  }

  // clears the list and adds a new page,
  // thereby replacing all the pages that were there before
  @override
  Future<void> setNewRoutePath(PageConfiguration configuration) {
    final shouldAddPage = _pages.isEmpty ||
        (_pages.last.arguments as PageConfiguration).uiPage !=
            configuration.uiPage;
    if (shouldAddPage) {
      _pages.clear();
      addPage(configuration);
    }
    return SynchronousFuture(null);
  }

  // When an page action is requested, you want to record the action associated
  // with the page. The _setPageAction method will do that.
  void _setPageAction(PageAction action) {
    switch (action.page.uiPage) {
      case Pages.Splash:
        SplashPageConfig.currentPageAction = action;
        break;
      case Pages.Login:
        LoginPageConfig.currentPageAction = action;
        break;
      case Pages.CreateAccount:
        CreateAccountPageConfig.currentPageAction = action;
        break;
      case Pages.List:
        ListItemsPageConfig.currentPageAction = action;
        break;
      case Pages.Cart:
        CartPageConfig.currentPageAction = action;
        break;
      case Pages.Checkout:
        CheckoutPageConfig.currentPageAction = action;
        break;
      case Pages.Settings:
        SettingsPageConfig.currentPageAction = action;
        break;
      case Pages.Details:
        DetailsPageConfig.currentPageAction = action;
        break;
      default:
        break;
    }
  }

  List<Page> buildPages() {
    // If the splash screen hasn’t finished, just show the splash screen.
    if (!appState.splashFinished) {
      replaceAll(SplashPageConfig);
    } else {
      // Switch on the current action state.
      switch (appState.currentAction.state) {
        // If there is no action, do nothing.
        case PageState.none:
          break;
        case PageState.addPage:
          // Add a new page, given by the action’s page variable.
          _setPageAction(appState.currentAction);
          addPage(appState.currentAction.page);
          break;
        case PageState.pop:
          // Pop the top-most page.
          pop();
          break;
        case PageState.replace:
          // Replace the current page.
          _setPageAction(appState.currentAction);
          replace(appState.currentAction.page);
          break;
        case PageState.replaceAll:
          // Replace all of the pages with this page.
          _setPageAction(appState.currentAction);
          replaceAll(appState.currentAction.page);
          break;
        case PageState.addWidget:
          // Push a widget onto the stack (Details page)
          _setPageAction(appState.currentAction);
          pushWidget(
              appState.currentAction.widget, appState.currentAction.page);
          break;
        case PageState.addAll:
          // Add a list of pages.
          addAll(appState.currentAction.pages);
          break;
      }
    }
    // Reset the page state to none.
    appState.resetCurrentAction();
    return List.of(_pages);
  }

  // Parse Deep Link URI
  void parseRoute(Uri uri) {
    // Check if there are no pathSegments in the URI.
    // If there are, navigate to the Splash page.
    if (uri.pathSegments.isEmpty) {
      setNewRoutePath(SplashPageConfig);
      return;
    }

    // Handle the special case for the Details page, as the path will have
    // two pathSegments.
    // Handle navapp://deeplinks/details/#
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] == 'details') {
        // Parse the item number and push a Details page with the item number.
        // In a real app, this item number could be a product's unique ID.
        pushWidget(Details(int.parse(uri.pathSegments[1])), DetailsPageConfig);
      }
    } else if (uri.pathSegments.length == 1) {
      final path = uri.pathSegments[0];
      // Use path as an input for the switch case.
      switch (path) {
        case 'splash':
          replaceAll(SplashPageConfig);
          break;
        case 'login':
          replaceAll(LoginPageConfig);
          break;
        case 'createAccount':
          // In this case and other cases, push the pages necessary to navigate to the
          // destination using setPath.
          setPath([
            _createPage(const Login(), LoginPageConfig),
            _createPage(const CreateAccount(), CreateAccountPageConfig)
          ]);
          break;
        case 'listItems':
          replaceAll(ListItemsPageConfig);
          break;
        case 'cart':
          setPath([
            _createPage(const ListItems(), ListItemsPageConfig),
            _createPage(const Cart(), CartPageConfig)
          ]);
          break;
        case 'checkout':
          setPath([
            _createPage(const ListItems(), ListItemsPageConfig),
            _createPage(const Checkout(), CheckoutPageConfig)
          ]);
          break;
        case 'settings':
          setPath([
            _createPage(const ListItems(), ListItemsPageConfig),
            _createPage(const Settings(), SettingsPageConfig)
          ]);
          break;
      }
    }
  }
}
