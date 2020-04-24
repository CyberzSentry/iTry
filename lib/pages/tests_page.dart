import 'package:flutter/material.dart';
import 'package:itry/fragments/drawer_fragment.dart';
import 'package:itry/pages/tests/creativity_productivity_survey_page.dart';
import 'package:itry/pages/tests/creativity_productivity_test_page.dart';
import 'package:itry/pages/tests/finger_tapping_test_page.dart';
import 'package:itry/services/creativity_productivity_survey_service.dart';
import 'package:itry/services/finger_tapping_test_service.dart';

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

  Future<List<Widget>> _buildTestsList() async {
    var result = <Widget>[];

    var currDate = DateTime.now();

    if (await FingerTappingTestService().isActive(currDate)) {
      result.insert(
        0,
        Container(
          child: ListTile(
            title: Text(FingerTappingTestPage.title),
            trailing: null,
            onTap: () => Navigator.of(context)
                .pushNamed(FingerTappingTestPage.routeName),
          ),
          decoration: BoxDecoration(
              // border: Border(bottom: BorderSide(width: 0.5, color: Colors.blueAccent)),
              ),
        ),
      );
    } else {
      result.add(
        Container(
          child: ListTile(
            title: Text(FingerTappingTestPage.title),
            trailing: Icon(
              Icons.check,
              color: Colors.blue,
            ),
            onTap: null,
          ),
          decoration: BoxDecoration(
              // border: Border(bottom: BorderSide(width: 0.5, color: Colors.blueAccent)),
              ),
        ),
      );
    }

    if (await CreativityProductivitySurveyService().isActive(currDate)) {
      result.insert(
        0,
        Container(
          child: ListTile(
            title: Text(CreativityProductivitySurveyPage.title),
            trailing: null,
            onTap: () => Navigator.of(context)
                .pushNamed(CreativityProductivitySurveyPage.routeName),
          ),
          decoration: BoxDecoration(
              //border: Border(bottom: BorderSide(width: 0.3, color: Colors.blueAccent)),
              ),
        ),
      );
    } else {
      result.add(
        Container(
          child: ListTile(
            title: Text(CreativityProductivitySurveyPage.title),
            trailing: Icon(
              Icons.check,
              color: Colors.blue,
            ),
            onTap: null,
          ),
          decoration: BoxDecoration(
              //border: Border(bottom: BorderSide(width: 0.3, color: Colors.blueAccent)),
              ),
        ),
      );
    }

    result.add(
      ListTile(
        title: Text(CreativityProductivityTestPage.title),
        trailing: null,
        onTap: () => Navigator.of(context)
            .pushNamed(CreativityProductivityTestPage.routeName),
      ),
    );

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TestsPage.title),
      ),
      drawer: DrawerFragment(),
      body: FutureBuilder<List<Widget>>(
        future: _buildTestsList(),
        builder: (BuildContext context, AsyncSnapshot<List<Widget>> snapshot) {
          if (snapshot.hasData) {
            return ListView(children: snapshot.data);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
