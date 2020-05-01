import 'package:flutter/material.dart';

class TestDescriptionFragment extends StatelessWidget {
  final List<Widget> children;
  final String title;

  TestDescriptionFragment({this.children, this.title});

  @override
  Widget build(BuildContext context) {
    children.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          MaterialButton(
            color: Colors.green,
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Continue'),
          )
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: children,
          ),
        ),
      ),
    );
  }
}
