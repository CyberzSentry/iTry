import 'package:flutter/material.dart';

class MenuWrapper extends StatelessWidget {
  MenuWrapper({Key key, this.title, this.child}) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            RaisedButton(
              child: Text('Options'),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/options');
              },
            ),
            ListTile(
              title: Text('Home'),
            ),
            ListTile(
              title: Text('Tests'),
            ),
            ListTile(
              title: Text('Experiments'),
            ),
          ],
        ),
      ),
      body: child,
    );
  }
}
