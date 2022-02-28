import 'package:flutter/material.dart';
import 'router_delegate.dart';

// currently doesn't work, have some back problems,
// leave for default RootBackButtonDispatcher implementation that works

// Note that this class doesn't do any complex back button handling here.
// Rather, it's just an example of subClassing RootBackButtonDispatcher
// to create a custom Back Button Dispatcher. If you need to do some custom
// back button handling, add your code to didPopRoute().

class ShoppingBackButtonDispatcher extends RootBackButtonDispatcher {
  // helps you link the dispatcher to the app's RouterDelegate, i.e. ShoppingRouterDelegate
  // ignore: unused_field
  final ShoppingRouterDelegate _routerDelegate;

  ShoppingBackButtonDispatcher(this._routerDelegate) : super();

  // ignore: todo
  // TODO: if enable back will have issues, ex we press back and UI don't update
  // Delegate didPopRoute to _routerDelegate.
  // @override
  // Future<bool> didPopRoute() {
  //   return _routerDelegate.popRoute();
  // }
}
