import 'package:flutter/material.dart';
import 'package:itry/fragments/drawer_fragment.dart';
import 'package:itry/pages/tests/finger_tapping_test_page.dart';
import 'package:itry/pages/tests/first_test_page.dart';

class TestsPage extends StatefulWidget {
  static const String routeName = '/tests';
  static const String title = "Tests";
  static const IconData icon = Icons.folder_open;

  @override
  _TestsPageState createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  // List<Widget> _buildRow(String text){
  //   final bool doneToday = true;
  //   return  ListTile(
  //           title: Text(text),
  //           trailing: doneToday ? Icon(Icons.done, color: Colors.blue) : null,
  //         );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TestsPage.title),
      ),
      drawer: DrawerFragment(),
      body: ListView(
        children: <Widget>[
          Container(
            child: ListTile(
              title: Text(FirstTestPage.title),
              trailing: null,
              onTap: () =>
                  Navigator.of(context).pushNamed(FirstTestPage.routeName),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
          ),
          Container(
            child: ListTile(
              title: Text(FingerTappingTestPage.title),
              trailing: null,
              onTap: () =>
                  Navigator.of(context).pushNamed(FingerTappingTestPage.routeName),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
