import 'dart:async';
import 'package:flutter/material.dart';
import 'package:itry/fragments/test_description_fragment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreativityProductivityTestPage extends StatefulWidget {
  static final String routeName = '/creativityProductivityTest';
  static final String title = "Creativity and productivity test";

  @override
  _CreativityProductivityTestPageState createState() =>
      _CreativityProductivityTestPageState();
}

class _CreativityProductivityTestPageState
    extends State<CreativityProductivityTestPage> {
  Future _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seenCreativityProductivityTestPage') ?? false);

    if (_seen == false) {
      await prefs.setBool('seenCreativityProductivityTestPage', true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              CreativityProductivityTestDescriptionPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(CreativityProductivityTestPage.title),
        ),
        body: Container(
          margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
          child: Column(
            children: <Widget>[],
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 200), () {
      _checkFirstSeen();
    });
  }
}

class CreativityProductivityTestDescriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TestDescriptionFragment(
      children: <Widget>[
        Text("description")
      ],
      title: CreativityProductivityTestPage.title,
    );
  }
}
