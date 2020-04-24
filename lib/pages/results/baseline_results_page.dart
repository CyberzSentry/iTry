import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/material.dart';
import 'package:itry/fragments/drawer_fragment.dart';
import 'package:itry/services/creativity_productivity_survey_service.dart';
import 'package:itry/services/finger_tapping_test_service.dart';

class BaselineResultsPage extends StatefulWidget {
  static const String routeName = '/baselineResults';
  static const String title = "Baseline";

  @override
  _BaselineResultsPageState createState() => _BaselineResultsPageState();
}

class _BaselineResultsPageState extends State<BaselineResultsPage> {
  FingerTappingTestService _fttService = FingerTappingTestService();
  CreativityProductivitySurveyService _cpsService = CreativityProductivitySurveyService();

  var _enabledDataTypes = [true, true]; // finger_tapping, cp_service

  DateTime _from = DateTime.now().subtract(Duration(days: 30));
  DateTime _to = DateTime.now();

  Future<GraphData> _getGraphData() async {
    GraphData data = GraphData();

    if (_enabledDataTypes[0]) {
      List<GraphDataType> fingerTappingData = <GraphDataType>[];
      var creativityProductivityListFiltered = await _fttService.getBetweenDates(_from, _to);
      for (var item in creativityProductivityListFiltered) {
        fingerTappingData.add(GraphDataType(
            item.date.difference(_from).inDays, item.percentageScore));
      }
      fingerTappingData.sort((a, b) => a.day.compareTo(b.day));
      data.fingerTappingTestData = fingerTappingData;
    }
    if (_enabledDataTypes[1]) {
      List<GraphDataType> creativityProductivityData = <GraphDataType>[];
      var creativityProductivityListFiltered = await _cpsService.getBetweenDates(_from, _to);
      for (var item in creativityProductivityListFiltered) {
        creativityProductivityData.add(GraphDataType(
            item.date.difference(_from).inDays, item.percentageScore));
      }
      creativityProductivityData.sort((a, b) => a.day.compareTo(b.day));
      data.creativityProductivitySurveyData = creativityProductivityData;
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
                      title: Text('Dexterity'),
                      activeColor: Colors.blue,
                    ),
                    SwitchListTile(
                      value: _enabledDataTypes[1],
                      onChanged: (val) => setState(() {
                        _enabledDataTypes[1] = val;
                      }),
                      title: Text('Creativity productivity survey'),
                      activeColor: Colors.purple,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GraphData {
  List<GraphDataType> fingerTappingTestData;
  List<GraphDataType> creativityProductivitySurveyData;
}

class GraphDataType {
  int day;
  double result;

  GraphDataType(this.day, this.result);
}
