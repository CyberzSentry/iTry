import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/material.dart';
import 'package:itry/fragments/drawer_fragment.dart';
import 'package:itry/pages/tests/creativity_productivity_survey_page.dart';
import 'package:itry/pages/tests/creativity_productivity_test_page.dart';
import 'package:itry/pages/tests/depression_survey_page.dart';
import 'package:itry/pages/tests/finger_tapping_test_page.dart';
import 'package:itry/pages/tests/spatial_memory_test_page.dart';
import 'package:itry/services/ads_service.dart';
import 'package:itry/services/creativity_productivity_survey_service.dart';
import 'package:itry/services/creativity_productivity_test_service.dart';
import 'package:itry/services/depression_survey_service.dart';
import 'package:itry/services/finger_tapping_test_service.dart';
import 'package:itry/services/spatial_memory_test_service.dart';

class BaselineResultsPage extends StatefulWidget {
  static const String routeName = '/baselineResults';
  static const String title = "Baseline";

  @override
  _BaselineResultsPageState createState() => _BaselineResultsPageState();
}

class _BaselineResultsPageState extends State<BaselineResultsPage> {
  FingerTappingTestService _fttService = FingerTappingTestService();
  CreativityProductivitySurveyService _cpsService =
      CreativityProductivitySurveyService();
  CreativityProductivityTestService _cptService =
      CreativityProductivityTestService();
  SpatialMemoryTestService _smtService = SpatialMemoryTestService();
  DepressionSurveyService _dsService = DepressionSurveyService();

  var _enabledDataTypes = [
    true,
    true,
    true,
    true,
    true
  ]; // finger_tapping, cp_survey, cp_test, spatial_mem, depression_survey

  DateTime _from = DateTime.now().subtract(Duration(days: 30));
  DateTime _to = DateTime.now();

  Future<GraphData> _getGraphData() async {
    GraphData data = GraphData();

    if (_enabledDataTypes[0]) {
      List<GraphDataType> fingerTappingData = <GraphDataType>[];
      var creativityProductivityListFiltered =
          await _fttService.getBetweenDates(_from, _to);
      for (var item in creativityProductivityListFiltered) {
        fingerTappingData.add(GraphDataType(
            item.date.difference(_from).inDays, item.percentageScore));
      }
      fingerTappingData.sort((a, b) => a.day.compareTo(b.day));
      data.fingerTappingTestData = fingerTappingData;
    }
    if (_enabledDataTypes[1]) {
      List<GraphDataType> creativityProductivityData = <GraphDataType>[];
      var creativityProductivityListFiltered =
          await _cpsService.getBetweenDates(_from, _to);
      for (var item in creativityProductivityListFiltered) {
        creativityProductivityData.add(GraphDataType(
            item.date.difference(_from).inDays, item.percentageScore));
      }
      creativityProductivityData.sort((a, b) => a.day.compareTo(b.day));
      data.creativityProductivitySurveyData = creativityProductivityData;
    }
    if (_enabledDataTypes[2]) {
      List<GraphDataType> creativityProductivityData = <GraphDataType>[];
      var creativityProductivityListFiltered =
          await _cptService.getBetweenDates(_from, _to);
      for (var item in creativityProductivityListFiltered) {
        creativityProductivityData.add(GraphDataType(
            item.date.difference(_from).inDays, item.percentageScore));
      }
      creativityProductivityData.sort((a, b) => a.day.compareTo(b.day));
      data.creativityProductivityTestData = creativityProductivityData;
    }
    if (_enabledDataTypes[3]) {
      List<GraphDataType> spatialMemoryData = <GraphDataType>[];
      var spatialMemoryListFiltered =
          await _smtService.getBetweenDates(_from, _to);
      for (var item in spatialMemoryListFiltered) {
        spatialMemoryData.add(GraphDataType(
            item.date.difference(_from).inDays, item.percentageScore));
      }
      spatialMemoryData.sort((a, b) => a.day.compareTo(b.day));
      data.spatialMemoryTestData = spatialMemoryData;
    }
    if (_enabledDataTypes[4]) {
      List<GraphDataType> depressionData = <GraphDataType>[];
      var spatialMemoryListFiltered =
          await _dsService.getBetweenDates(_from, _to);
      for (var item in spatialMemoryListFiltered) {
        depressionData.add(GraphDataType(
            item.date.difference(_from).inDays, item.percentageScore));
      }
      depressionData.sort((a, b) => a.day.compareTo(b.day));
      data.depressionSurveyData = depressionData;
    }

    return data;
  }

  chart.LineChart _generateChart(GraphData data) {
    var seriesList = <chart.Series<GraphDataType, int>>[];

    if (data.fingerTappingTestData != null) {
      seriesList.add(
        chart.Series(
            id: 'FingerTappingTest',
            data: data.fingerTappingTestData,
            colorFn: (_, __) => chart.MaterialPalette.blue.shadeDefault,
            domainFn: (GraphDataType point, _) => point.day,
            measureFn: (GraphDataType point, _) => point.result),
      );
    }

    if (data.creativityProductivitySurveyData != null) {
      seriesList.add(
        chart.Series(
            id: 'CreativityProductivitySurvey',
            data: data.creativityProductivitySurveyData,
            colorFn: (_, __) => chart.MaterialPalette.purple.shadeDefault,
            domainFn: (GraphDataType point, _) => point.day,
            measureFn: (GraphDataType point, _) => point.result),
      );
    }

    if (data.creativityProductivityTestData != null) {
      seriesList.add(
        chart.Series(
            id: 'CreativityProductivityTest',
            data: data.creativityProductivityTestData,
            colorFn: (_, __) => chart.MaterialPalette.red.shadeDefault,
            domainFn: (GraphDataType point, _) => point.day,
            measureFn: (GraphDataType point, _) => point.result),
      );
    }

    if (data.spatialMemoryTestData != null) {
      seriesList.add(
        chart.Series(
            id: 'SpatialMemoryTest',
            data: data.spatialMemoryTestData,
            colorFn: (_, __) => chart.MaterialPalette.lime.shadeDefault,
            domainFn: (GraphDataType point, _) => point.day,
            measureFn: (GraphDataType point, _) => point.result),
      );
    }

    if (data.depressionSurveyData != null) {
      seriesList.add(
        chart.Series(
            id: 'DepressionSurvey',
            data: data.depressionSurveyData,
            colorFn: (_, __) => chart.MaterialPalette.green.shadeDefault,
            domainFn: (GraphDataType point, _) => point.day,
            measureFn: (GraphDataType point, _) => point.result),
      );
    }

    return chart.LineChart(
      seriesList,
      // defaultRenderer:
      //     chart.LineRendererConfig(includeArea: true, stacked: true),
      animate: true,
      //defaultInteractions: true,
      primaryMeasureAxis: chart.NumericAxisSpec(
          //renderSpec: chart.NoneRenderSpec(),
          ),
      domainAxis: chart.NumericAxisSpec(
        renderSpec: chart.NoneRenderSpec(),
        tickProviderSpec: chart.StaticNumericTickProviderSpec(
          <chart.TickSpec<num>>[
            chart.TickSpec<num>(0),
            chart.TickSpec<num>(_to.difference(_from).inDays),
          ],
        ),
      ),
    );
  }

  Future _selectFromDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _from,
        firstDate: DateTime(2000),
        lastDate: _to);
    if (picked != null) setState(() => _from = picked);
  }

  Future _selectToDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _to,
        firstDate: _from,
        lastDate: DateTime.now());
    if (picked != null) setState(() => _to = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerFragment(),
      appBar: AppBar(
        title: Text(BaselineResultsPage.title),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(
              height: 200,
              child: FutureBuilder<GraphData>(
                future: _getGraphData(),
                builder:
                    (BuildContext context, AsyncSnapshot<GraphData> snapshot) {
                  if (snapshot.hasData) {
                    return _generateChart(snapshot.data);
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            Expanded(
              child: SizedBox(
                height: 300,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: Text('Date from:'),
                      trailing: Text(_from.toString().substring(0, 10)),
                      onTap: _selectFromDate,
                    ),
                    ListTile(
                      title: Text('Date to:'),
                      trailing: Text(_to.toString().substring(0, 10)),
                      onTap: _selectToDate,
                    ),
                    SwitchListTile(
                      value: _enabledDataTypes[0],
                      onChanged: (val) => setState(() {
                        _enabledDataTypes[0] = val;
                      }),
                      title: Text(FingerTappingTestPage.title),
                      activeColor: Colors.blue,
                    ),
                    SwitchListTile(
                      value: _enabledDataTypes[1],
                      onChanged: (val) => setState(() {
                        _enabledDataTypes[1] = val;
                      }),
                      title: Text(CreativityProductivitySurveyPage.title),
                      activeColor: Colors.purple,
                    ),
                    SwitchListTile(
                      value: _enabledDataTypes[2],
                      onChanged: (val) => setState(() {
                        _enabledDataTypes[2] = val;
                      }),
                      title: Text(CreativityProductivityTestPage.title),
                      activeColor: Colors.red,
                    ),
                    SwitchListTile(
                      value: _enabledDataTypes[3],
                      onChanged: (val) => setState(() {
                        _enabledDataTypes[3] = val;
                      }),
                      title: Text(SpatialMemoryTestPage.title),
                      activeColor: Colors.lime,
                    ),
                    SwitchListTile(
                      value: _enabledDataTypes[4],
                      onChanged: (val) => setState(() {
                        _enabledDataTypes[4] = val;
                      }),
                      title: Text(DepressionSurveyPage.title),
                      activeColor: Colors.green,
                    ),
                    ListTile(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    AdsService().showBanner();
    super.initState();
  }
}

class GraphData {
  List<GraphDataType> fingerTappingTestData;
  List<GraphDataType> creativityProductivitySurveyData;
  List<GraphDataType> creativityProductivityTestData;
  List<GraphDataType> spatialMemoryTestData;
  List<GraphDataType> depressionSurveyData;
}

class GraphDataType {
  int day;
  double result;

  GraphDataType(this.day, this.result);
}
