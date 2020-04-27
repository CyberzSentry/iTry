import 'package:flutter/material.dart';
import 'package:itry/fragments/drawer_fragment.dart';
import 'package:itry/pages/tests/creativity_productivity_survey_page.dart';
import 'package:itry/pages/tests/creativity_productivity_test_page.dart';
import 'package:itry/pages/tests/finger_tapping_test_page.dart';
import 'package:itry/pages/tests/spatial_memory_test_page.dart';
import 'package:itry/services/ads_service.dart';
import 'package:itry/services/creativity_productivity_survey_service.dart';
import 'package:itry/services/creativity_productivity_test_service.dart';
import 'package:itry/services/finger_tapping_test_service.dart';
import 'package:itry/services/spatial_memory_test_service.dart';
import 'package:itry/services/test_service_interface.dart';
import 'package:tuple/tuple.dart';

class TestsPage extends StatefulWidget {
  static const String routeName = '/tests';
  static const String title = "Tests";
  static const IconData icon = Icons.folder_open;

  @override
  _TestsPageState createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  List<Tuple3<TestServiceInterface, String, String>> _tests = [
    Tuple3<TestServiceInterface, String, String>(FingerTappingTestService(),
        FingerTappingTestPage.title, FingerTappingTestPage.routeName),
    Tuple3<TestServiceInterface, String, String>(
        CreativityProductivitySurveyService(),
        CreativityProductivitySurveyPage.title,
        CreativityProductivitySurveyPage.routeName),
    Tuple3<TestServiceInterface, String, String>(
        CreativityProductivityTestService(),
        CreativityProductivityTestPage.title,
        CreativityProductivityTestPage.routeName),
    Tuple3<TestServiceInterface, String, String>(SpatialMemoryTestService(),
        SpatialMemoryTestPage.title, SpatialMemoryTestPage.routeName),
  ];

  Future<List<Widget>> _buildTestsList() async {
    var result = <Widget>[];

    var currDate = DateTime.now();

    for (var test in _tests) {
      if (await test.item1.isActive(currDate)) {
        result.insert(
          0,
          Container(
            child: ListTile(
              title: Text(test.item2),
              trailing: null,
              onTap: () => Navigator.of(context)
                  .pushNamed(test.item3)
                  .whenComplete(() {
                AdsService().showBanner();
              }),
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
              title: Text(test.item2),
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
    }
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

  @override
  void initState() {
    AdsService().showBanner();
    super.initState();
  }
}
