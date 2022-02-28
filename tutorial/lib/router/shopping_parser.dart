import 'package:flutter/material.dart';

import 'ui_pages.dart';

// A RouteInformationParser is a delegate used by Router
// to parse a route’s information into a configuration of any type T
// which in your case would be PageConfiguration.

// RouterInformationParser requires that its subclasses override
// parseRouteInformation and restoreRouteInformation.

class ShoppingParser extends RouteInformationParser<PageConfiguration> {
  // parseRouteInformation converts the given route information into
  // parsed data PageConfiguration in this case — to pass to RouterDelegate
  @override
  Future<PageConfiguration> parseRouteInformation(
      RouteInformation routeInformation) async {
    // location from routeInformation is a String that represents the location
    // of the application. The string is usually in the format of multiple string identifiers
    // with slashes between — for example: `/`, `/path` or `/path/to/the/app`.
    // It’s equivalent to the URL in a web application. Use parse from Uri to
    // create a Uri from this String.
    final uri = Uri.parse(routeInformation.location!);
    // If there are no paths, which is most likely the case when the user is
    // launching the app, return SplashPage.
    if (uri.pathSegments.isEmpty) {
      return SplashPageConfig;
    }

    // Otherwise, get the first path segment from the pathSegments list of the uri.
    final path = uri.pathSegments[0];

    // Then return the PageConfiguration corresponding to this first path segment.
    switch (path) {
      case SplashPath:
        return SplashPageConfig;
      case LoginPath:
        return LoginPageConfig;
      case CreateAccountPath:
        return CreateAccountPageConfig;
      case ListItemsPath:
        return ListItemsPageConfig;
      case DetailsPath:
        return DetailsPageConfig;
      case CartPath:
        return CartPageConfig;
      case CheckoutPath:
        return CheckoutPageConfig;
      case SettingsPath:
        return SettingsPageConfig;
      default:
        return SplashPageConfig;
    }
  }

  // restoreRouteInformation isn't required if you don't opt for the route information reporting,
  // which is mainly used for updating browser history for web applications.
  // If you decide to opt in, you must also override this method to
  // return RouteInformation based on the provided PageConfiguration.
  //
  // So, override restoreRouteInformation. In a way, this method does the exact opposite
  // of the previously defined parseRouteInformation by taking in a PageDate
  // and returning an object of type RouteInformation:
  //
  // This method uses uiPage from Page to return a RouteInformation with its location
  // set to the given path. Notice that there's a RouteInformation with the location
  // of SplashPath in case there are no matches for uiPage.
  @override
  RouteInformation restoreRouteInformation(PageConfiguration configuration) {
    switch (configuration.uiPage) {
      case Pages.Splash:
        return const RouteInformation(location: SplashPath);
      case Pages.Login:
        return const RouteInformation(location: LoginPath);
      case Pages.CreateAccount:
        return const RouteInformation(location: CreateAccountPath);
      case Pages.List:
        return const RouteInformation(location: ListItemsPath);
      case Pages.Details:
        return const RouteInformation(location: DetailsPath);
      case Pages.Cart:
        return const RouteInformation(location: CartPath);
      case Pages.Checkout:
        return const RouteInformation(location: CheckoutPath);
      case Pages.Settings:
        return const RouteInformation(location: SettingsPath);
      default:
        //  in case there are no matches for uiPage, always show splash
        return const RouteInformation(location: SplashPath);
    }
  }
}
