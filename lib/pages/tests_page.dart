import 'package:flutter/material.dart';
import 'package:itry/fragments/drawer_fragment.dart';

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
      body:  Column(
        children: <Widget>[
          ListTile(
            title: Text("First test"),
            trailing: null,
            onTap: () => Navigator.of(context).pushNamed('/firstTest'),
          )
        ],
      ),
    );
  }
}