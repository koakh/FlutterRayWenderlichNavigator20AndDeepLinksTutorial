import 'package:flutter/material.dart';
import 'package:navigation_app/ui/details.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';
import '../router/ui_pages.dart';

class ListItems extends StatelessWidget {
  const ListItems({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    final items = List<String>.generate(10000, (i) => 'Item $i');
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.lightBlue,
        title: const Text(
          'Items for sale',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => appState.currentAction =
                PageAction(state: PageState.addPage, page: SettingsPageConfig),
          ),
          IconButton(
            icon: const Icon(Icons.add_shopping_cart_sharp),
            onPressed: () => appState.currentAction =
                PageAction(state: PageState.addPage, page: CheckoutPageConfig),
          )
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              // current item #idx
              title: Text('${items[index]}'),
              onTap: () {
                appState.currentAction = PageAction(
                    state: PageState.addWidget,
                    // pass widget details
                    widget: Details(index),
                    page: DetailsPageConfig);
              },
            );
          },
        ),
      ),
    );
  }
}
