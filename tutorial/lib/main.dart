/*
 * Copyright (c) 2021 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import 'app_state.dart';
// barrel files
import 'router/router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appState = AppState();
  // Define instances of ShoppingRouterDelegate and ShoppingParser
  // to use in MaterialApp.router, they are required for Navigator 2.0
  ShoppingRouterDelegate delegate;
  final parser = ShoppingParser();
  // declare back button dispatcher
  ShoppingBackButtonDispatcher backButtonDispatcher;
  // deeplinks _linkSubscription is a StreamSubscription for listening to incoming links. Call .cancel() on it to dispose of the stream.
  StreamSubscription _linkSubscription;

  _MyAppState() {
    // Create the delegate with the appState field
    delegate = ShoppingRouterDelegate(appState);
    // Set up the initial route of this app to be the Splash page using setNewRoutePath.
    delegate.setNewRoutePath(SplashPageConfig);
    // initialize backButtonDispatcher
    backButtonDispatcher = ShoppingBackButtonDispatcher(delegate);
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    // dispose linkSubscription
    if (_linkSubscription != null) {
      _linkSubscription.cancel();
    }
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Attach a listener to the Uri links stream
    // Initialize StreamSubscription by listening for any deep link events.
    _linkSubscription = getUriLinksStream().listen((Uri uri) {
      if (!mounted) return;
      setState(() {
        // Have the app's delegate parse the uri and then navigate using the previously defined parseRoute.
        delegate.parseRoute(uri);
      });
    }, onError: (Object err) {
      print('Got error $err');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => appState,
      // Since Navigator 2.0 is backward-compatible with Navigator 1.0,
      // the easiest way to start with Navigator 2.0 is to use MaterialApp's
      // MaterialApp.router(...) constructor. This requires you to provide instances of a
      // RouterDelegate and a RouteInformationParser as the ones discussed above.
      child: MaterialApp.router(
        title: 'Navigation App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        routerDelegate: delegate,
        routeInformationParser: parser,
        backButtonDispatcher: backButtonDispatcher,
      ),
    );
  }
}
