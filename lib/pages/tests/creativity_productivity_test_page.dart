import 'package:flutter/material.dart';

class CreativityProductivityTestPage extends StatefulWidget {
  static final String routeName = '/creativityProductivityTest';
  static final String title = "Creativity and productivity test";

  @override
  _CreativityProductivityTestPageState createState() =>
      _CreativityProductivityTestPageState();
}

class _CreativityProductivityTestPageState
    extends State<CreativityProductivityTestPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CreativityProductivityTestDescriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CreativityProductivityTestPage.title),
      ),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Center(
          child: Text("description"),
        ),
      ),
    );
  }
}
