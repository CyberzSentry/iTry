import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:itry/database/accessors/first_test_accessor.dart';
import 'package:itry/database/models/first_test.dart';

class BaselineResultsPage extends StatefulWidget {
  static const String routeName = '/baselineResults';
  static const String title = "Baseline";

  @override
  _BaselineResultsPageState createState() => _BaselineResultsPageState();
}

class _BaselineResultsPageState extends State<BaselineResultsPage> {
  FirstTestAccessor fta = FirstTestAccessor();

  var _enabledDataTypes = [true];

  DateTime _from = DateTime.now().subtract(new Duration(days: 30));
  DateTime _to = DateTime.now().add(new Duration(days: 1));

  Future<GraphData> _getGraphData() async {
    GraphData data = GraphData();

    if (_enabledDataTypes[0]) {
      List<GraphDataType> firstTestData = <GraphDataType>[];
      var firstTestList = await fta.getAll();
      var firstTestListFiltered = firstTestList
          .where((x) => x.date.isAfter(_from) & x.date.isBefore(_to));

      for (var item in firstTestListFiltered) {
        firstTestData.add(GraphDataType(
            item.date.difference(_from).inDays, item.score / 100));
      }
      firstTestData.sort((a, b) => a.day.compareTo(b.day));
      data.firstTestData = firstTestData;
    }
    return data;
  }

  LineChart _generateChart(GraphData data) {
    var seriesList = <Series<GraphDataType, int>>[];

    if (data.firstTestData != null) {
      seriesList.add(
        Series(
            id: 'FirstTest',
            data: data.firstTestData,
            domainFn: (GraphDataType point, _) => point.day,
            measureFn: (GraphDataType point, _) => point.result),
      );
    }

    return LineChart(seriesList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(BaselineResultsPage.title),
      ),
      body: Container(
        child: Column(
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
          ],
        ),
      ),
    );
  }
}

class GraphData {
  List<GraphDataType> firstTestData;
}

class GraphDataType {
  int day;
  double result;

  GraphDataType(this.day, this.result);
}
