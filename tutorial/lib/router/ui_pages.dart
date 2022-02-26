import 'package:flutter/cupertino.dart';

import '../app_state.dart';

// The constants above define the paths or routes of each screen.
const String SplashPath = '/splash';
const String LoginPath = '/login';
const String CreateAccountPath = '/createAccount';
const String ListItemsPath = '/listItems';
const String DetailsPath = '/details';
const String CartPath = '/cart';
const String CheckoutPath = '/checkout';
const String SettingsPath = '/settings';

// It’s important to represent the UI for each page. This is done with an enum
enum Pages {
  Splash,
  Login,
  CreateAccount,
  List,
  Details,
  Cart,
  Checkout,
  Settings
}

class PageConfiguration {
  final String key;
  final String path;
  final Pages uiPage;
  PageAction currentPageAction;

  PageConfiguration(
      {@required this.key,
      @required this.path,
      @required this.uiPage,
      this.currentPageAction});
}

PageConfiguration SplashPageConfig = PageConfiguration(
    key: 'Splash',
    path: SplashPath,
    uiPage: Pages.Splash,
    currentPageAction: null);

PageConfiguration LoginPageConfig = PageConfiguration(
    key: 'Login',
    path: LoginPath,
    uiPage: Pages.Login,
    currentPageAction: null);

PageConfiguration CreateAccountPageConfig = PageConfiguration(
    key: 'CreateAccount',
    path: CreateAccountPath,
    uiPage: Pages.CreateAccount,
    currentPageAction: null);

PageConfiguration ListItemsPageConfig = PageConfiguration(
    key: 'ListItems',
    path: ListItemsPath,
    uiPage: Pages.List,
    currentPageAction: null);

PageConfiguration DetailsPageConfig = PageConfiguration(
    key: 'Details',
    path: DetailsPath,
    uiPage: Pages.Details,
    currentPageAction: null);

PageConfiguration CartPageConfig = PageConfiguration(
    key: 'Cart', path: CartPath, uiPage: Pages.Cart, currentPageAction: null);

PageConfiguration CheckoutPageConfig = PageConfiguration(
    key: 'Checkout',
    path: CheckoutPath,
    uiPage: Pages.Checkout,
    currentPageAction: null);

PageConfiguration SettingsPageConfig = PageConfiguration(
    key: 'Settings',
    path: SettingsPath,
    uiPage: Pages.Settings,
    currentPageAction: null);
