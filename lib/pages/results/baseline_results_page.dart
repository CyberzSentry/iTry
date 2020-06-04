import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/material.dart';
import 'package:itry/pages/results/raport_page.dart';
import 'package:itry/pages/tests/acuity_contrast_test_page.dart';
import 'package:itry/pages/tests/anixety_survey_page.dart';
import 'package:itry/pages/tests/chronic_pain_survey_page.dart';
import 'package:itry/pages/tests/creativity_productivity_survey_page.dart';
import 'package:itry/pages/tests/creativity_productivity_test_page.dart';
import 'package:itry/pages/tests/depression_survey_page.dart';
import 'package:itry/pages/tests/finger_tapping_test_page.dart';
import 'package:itry/pages/tests/pavsat_test_page.dart';
import 'package:itry/pages/tests/spatial_memory_test_page.dart';
import 'package:itry/pages/tests/stress_survey_page.dart';
import 'package:itry/services/ads_service.dart';
import 'package:itry/services/tests/acuity_contrast_test_service.dart';
import 'package:itry/services/tests/anxiety_survey_service.dart';
import 'package:itry/services/tests/chronic_pain_survey_service.dart';
import 'package:itry/services/tests/creativity_productivity_survey_service.dart';
import 'package:itry/services/tests/creativity_productivity_test_service.dart';
import 'package:itry/services/tests/depression_survey_service.dart';
import 'package:itry/services/tests/finger_tapping_test_service.dart';
import 'package:itry/services/tests/pavsat_test_service.dart';
import 'package:itry/services/tests/spatial_memory_test_service.dart';
import 'package:itry/services/tests/stress_survey_service.dart';
import 'package:itry/services/tests/test_service_interface.dart';
import 'package:tuple/tuple.dart';

class BaselineResultsPage extends StatefulWidget {
  static const String routeName = '/baselineResults';
  static const String title = "Baseline";

  @override
  _BaselineResultsPageState createState() => _BaselineResultsPageState();
}

class _BaselineResultsPageState extends State<BaselineResultsPage> {
  List<Tuple4<TestServiceInterface, String, MaterialColor, chart.Color>>
      graphElements = [
    Tuple4<TestServiceInterface, String, MaterialColor, chart.Color>(
        FingerTappingTestService(),
        FingerTappingTestPage.title,
        Colors.blue,
        chart.MaterialPalette.blue.shadeDefault),
    Tuple4<TestServiceInterface, String, MaterialColor, chart.Color>(
        CreativityProductivitySurveyService(),
        CreativityProductivitySurveyPage.title,
        Colors.purple,
        chart.MaterialPalette.purple.shadeDefault),
    Tuple4<TestServiceInterface, String, MaterialColor, chart.Color>(
        CreativityProductivityTestService(),
        CreativityProductivityTestPage.title,
        Colors.red,
        chart.MaterialPalette.red.shadeDefault),
    Tuple4<TestServiceInterface, String, MaterialColor, chart.Color>(
        SpatialMemoryTestService(),
        SpatialMemoryTestPage.title,
        Colors.lime,
        chart.MaterialPalette.lime.shadeDefault),
    Tuple4<TestServiceInterface, String, MaterialColor, chart.Color>(
        DepressionSurveyService(),
        DepressionSurveyPage.title,
        Colors.green,
        chart.MaterialPalette.green.shadeDefault),
    Tuple4<TestServiceInterface, String, MaterialColor, chart.Color>(
        StressSurveyService(),
        StressSurveyPage.title,
        Colors.cyan,
        chart.MaterialPalette.cyan.shadeDefault),
    Tuple4<TestServiceInterface, String, MaterialColor, chart.Color>(
        AnxietySurveyService(),
        AnxietySurveyPage.title,
        Colors.teal,
        chart.MaterialPalette.teal.shadeDefault),
    Tuple4<TestServiceInterface, String, MaterialColor, chart.Color>(
        AcuityContrastTestService(),
        AcuityContrastTestPage.title,
        Colors.pink,
        chart.MaterialPalette.pink.shadeDefault),
    Tuple4<TestServiceInterface, String, MaterialColor, chart.Color>(
        PavsatTestService(),
        PavsatTestPage.title,
        Colors.deepOrange,
        chart.MaterialPalette.deepOrange.shadeDefault),
    Tuple4<TestServiceInterface, String, MaterialColor, chart.Color>(
        ChronicPainSurveyService(),
        ChronicPainSurveyPage.title,
        Colors.indigo,
        chart.MaterialPalette.indigo.shadeDefault),
  ];

  var _enabledDataTypes = [
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
    true,
  ]; // finger_tapping, cp_survey, cp_test, spatial_mem, depression_survey, stress_survey, anxiety_survey, acuity_contrast, pavsat, chronic_pain

  DateTime _from = DateTime.now().subtract(Duration(days: 30));
  DateTime _to = DateTime.now();

  Future<GraphData> _getGraphData() async {
    GraphData data = GraphData();

    for (int i = 0; i < graphElements.length; i++) {
      if (_enabledDataTypes[i] == true) {
        List<GraphDataType> testData = <GraphDataType>[];
        var listFiltered =
            await graphElements[i].item1.getBetweenDates(_from, _to);
        for (var item in listFiltered) {
          testData.add(GraphDataType(
              item.date.difference(_from).inDays, item.percentageScore));
        }
        testData.sort((a, b) => a.day.compareTo(b.day));
        data.data.add(testData);
      } else {
        data.data.add(null);
      }
    }

    return data;
  }

  chart.LineChart _generateChart(GraphData data) {
    var seriesList = <chart.Series<GraphDataType, int>>[];

    for (int i = 0; i < graphElements.length; i++) {
      if (data.data[i] != null) {
        seriesList.add(
          chart.Series(
              id: graphElements[i].item2,
              data: data.data[i],
              colorFn: (_, __) => graphElements[i].item4,
              domainFn: (GraphDataType point, _) => point.day,
              measureFn: (GraphDataType point, _) => point.result),
        );
      }
    }

    return chart.LineChart(
      seriesList,
      // defaultRenderer:
      //     chart.LineRendererConfig(includeArea: true, stacked: true),
      animate: true,
      defaultInteractions: true,
      primaryMeasureAxis: chart.NumericAxisSpec(
        renderSpec: chart.NoneRenderSpec(),
      ),
      // domainAxis: chart.NumericAxisSpec(
      //   renderSpec: chart.NoneRenderSpec(),
      //   showAxisLine: true,
      //   tickProviderSpec: chart.StaticNumericTickProviderSpec(
      //     <chart.TickSpec<num>>[
      //       chart.TickSpec<num>(0),
      //       chart.TickSpec<num>(_to.difference(_from).inDays),
      //     ],
      //   ),
      // ),
    );
  }

  List<Widget> _bulidListView() {
    var output = <Widget>[
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
    ];

    for (int i = 0; i < graphElements.length; i++) {
      output.add(GestureDetector(
        child: SwitchListTile(
          value: _enabledDataTypes[i],
          onChanged: (val) => setState(() {
            _enabledDataTypes[i] = val;
          }),
          title: Text(graphElements[i].item2),
          subtitle: Text('Hold down for details'),
          activeColor: graphElements[i].item3,
        ),
        onLongPress: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => ReportPage(
                testService: graphElements[i].item1,
                dateFrom: _from,
                dateTo: _to,
                raportName: graphElements[i].item2,
              ),
            ),
          );
        },
      ));
    }

    output.add(ListTile());

    return output;
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
    return OrientationBuilder(
      builder: (context, orientation) {
        return Scaffold(
          appBar: AppBar(
            title: Text(BaselineResultsPage.title),
          ),
          body: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Flexible(
                  child: FutureBuilder<GraphData>(
                    future: _getGraphData(),
                    builder: (BuildContext context,
                        AsyncSnapshot<GraphData> snapshot) {
                      if (snapshot.hasData) {
                        return _generateChart(snapshot.data);
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
                Flexible(
                  child: ListView(
                    children: _bulidListView(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    AdsService().showBanner();
    super.initState();
  }
}

class GraphData {
  List<List<GraphDataType>> data = List<List<GraphDataType>>();
}

class GraphDataType {
  int day;
  double result;

  GraphDataType(this.day, this.result);
}
