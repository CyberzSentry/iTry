import 'package:flutter/material.dart';
import 'package:itry/database/models/creativity_productivity_survey.dart';
import 'package:itry/database/models/creativity_productivity_test.dart';
import 'package:itry/database/models/finger_tapping_test.dart';
import 'package:itry/database/models/spatial_memory_test.dart';
import 'package:itry/fragments/drawer_fragment.dart';
import 'package:itry/pages/tests/creativity_productivity_survey_page.dart';
import 'package:itry/pages/tests/creativity_productivity_test_page.dart';
import 'package:itry/pages/tests/finger_tapping_test_page.dart';
import 'package:itry/pages/tests/spatial_memory_test_page.dart';
import 'package:itry/services/ads_service.dart';
import 'package:itry/services/creativity_productivity_survey_service.dart';
import 'package:itry/services/creativity_productivity_test_service.dart';
import 'package:itry/services/finger_tapping_test_service.dart';
import 'package:itry/services/settings_service.dart';
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
  List<Tuple4<TestServiceInterface, String, String, Duration>> _tests = [
    Tuple4<TestServiceInterface, String, String, Duration>(
        FingerTappingTestService(),
        FingerTappingTestPage.title,
        FingerTappingTestPage.routeName,
        FingerTappingTest.testInterval),
    Tuple4<TestServiceInterface, String, String, Duration>(
        CreativityProductivitySurveyService(),
        CreativityProductivitySurveyPage.title,
        CreativityProductivitySurveyPage.routeName,
        CreativityProductivitySurvey.testInterval),
    Tuple4<TestServiceInterface, String, String, Duration>(
        CreativityProductivityTestService(),
        CreativityProductivityTestPage.title,
        CreativityProductivityTestPage.routeName,
        CreativityProductivityTest.testInterval),
    Tuple4<TestServiceInterface, String, String, Duration>(
        SpatialMemoryTestService(),
        SpatialMemoryTestPage.title,
        SpatialMemoryTestPage.routeName,
        SpatialMemoryTest.testInterval),
  ];

  Future<List<Widget>> _buildTestsList() async {
    var result = <Widget>[];

    var currDate = DateTime.now();

    var settings = await SettingsService().settings;

    for (var test in _tests) {
      if (await test.item1.isActive(currDate)) {
        result.insert(
          0,
          Container(
            child: ListTile(
              title: Text(test.item2),
              trailing: null,
              onTap: () =>
                  Navigator.of(context).pushNamed(test.item3).whenComplete(() {
                setState(() {});
                AdsService().showBanner();
              }),
            ),
            decoration: BoxDecoration(
                // border: Border(bottom: BorderSide(width: 0.5, color: Colors.blueAccent)),
                ),
          ),
        );
      } else {
        if (settings.testTimeBlocking) {
          result.add(
            Container(
              child: ListTile(
                title: Text(test.item2),
                trailing: Icon(
                  Icons.check,
                  color: Colors.blue,
                ),
                onTap: () => showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Test already done'),
                        content: Text(
                          'You already did this test in the past ' +
                              test.item4.inDays.toString() +
                              ' days. You can continue but the results wont be saved to the database.\n\nYou can disable \'test intervals\' in the settings tab.',
                          style: TextStyle(fontSize: 14),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context)
                                  .pushNamed(test.item3)
                                  .whenComplete(() {
                                setState(() {});
                                AdsService().showBanner();
                              });
                            },
                            child: Text('Continue'),
                          ),
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('Cancel'),
                          )
                        ],
                      );
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
        }
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
