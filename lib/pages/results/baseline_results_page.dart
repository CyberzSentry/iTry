import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/material.dart';
import 'package:itry/database/accessors/finger_tapping_test_accesor.dart';
import 'package:itry/database/accessors/first_test_accessor.dart';

class BaselineResultsPage extends StatefulWidget {
  static const String routeName = '/baselineResults';
  static const String title = "Baseline";

  @override
  _BaselineResultsPageState createState() => _BaselineResultsPageState();
}

class _BaselineResultsPageState extends State<BaselineResultsPage> {
  FirstTestAccessor _fta = FirstTestAccessor();
  FingerTappingTestAccessor _ftta = FingerTappingTestAccessor();

  var _enabledDataTypes = [true, true]; //first_test, finger_tapping,

  DateTime _from = DateTime.now().subtract(Duration(days: 30));
  DateTime _to = DateTime.now();

  Future<GraphData> _getGraphData() async {
    GraphData data = GraphData();

    if (_enabledDataTypes[0]) {
      List<GraphDataType> firstTestData = <GraphDataType>[];
      var firstTestList = await _fta.getAll();
      var firstTestListFiltered = firstTestList.where((x) =>
          x.date.isAfter(_from.add(Duration(days: -1))) &
          x.date.isBefore(_to.add(Duration(days: 1))));

      for (var item in firstTestListFiltered) {
        firstTestData.add(GraphDataType(
            item.date.difference(_from).inDays, item.score / 100));
      }
      firstTestData.sort((a, b) => a.day.compareTo(b.day));
      data.firstTestData = firstTestData;
    }
    if (_enabledDataTypes[1]) {
      List<GraphDataType> fingerTappingData = <GraphDataType>[];
      var fingerTappingTestList = await _ftta.getAll();
      var fingerTappingTestListFiltered = fingerTappingTestList.where((x) =>
          x.date.isAfter(_from.add(Duration(days: -1))) &
          x.date.isBefore(_to.add(Duration(days: 1))));

      for (var item in fingerTappingTestListFiltered) {
        fingerTappingData.add(GraphDataType(
            item.date.difference(_from).inDays, item.percentageScore));
      }
      fingerTappingData.sort((a, b) => a.day.compareTo(b.day));
      data.fingerTappingTestData = fingerTappingData;
    }
    return data;
  }

  chart.LineChart _generateChart(GraphData data) {
    var seriesList = <chart.Series<GraphDataType, int>>[];

    if (data.firstTestData != null) {
      seriesList.add(
        chart.Series(
            id: 'FirstTest',
            data: data.firstTestData,
            colorFn: (_, __) => chart.MaterialPalette.red.shadeDefault,
            domainFn: (GraphDataType point, _) => point.day,
            measureFn: (GraphDataType point, _) => point.result),
      );
    }

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
                      title: Text('Test'),
                      activeColor: Colors.red,
                    ),
                    SwitchListTile(
                      value: _enabledDataTypes[1],
                      onChanged: (val) => setState(() {
                        _enabledDataTypes[1] = val;
                      }),
                      title: Text('Dexterity'),
                      activeColor: Colors.blue,
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
  List<GraphDataType> firstTestData;
  List<GraphDataType> fingerTappingTestData;
}

class GraphDataType {
  int day;
  double result;

  GraphDataType(this.day, this.result);
}
