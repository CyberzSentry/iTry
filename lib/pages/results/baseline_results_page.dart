import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/material.dart';
import 'package:itry/fragments/drawer_fragment.dart';
import 'package:itry/pages/results/raport_page.dart';
import 'package:itry/pages/tests/acuity_contrast_test_page.dart';
import 'package:itry/pages/tests/anixety_survey_page.dart';
import 'package:itry/pages/tests/creativity_productivity_survey_page.dart';
import 'package:itry/pages/tests/creativity_productivity_test_page.dart';
import 'package:itry/pages/tests/depression_survey_page.dart';
import 'package:itry/pages/tests/finger_tapping_test_page.dart';
import 'package:itry/pages/tests/pavsat_test_page.dart';
import 'package:itry/pages/tests/spatial_memory_test_page.dart';
import 'package:itry/pages/tests/stress_survey_page.dart';
import 'package:itry/services/acuity_contrast_test_service.dart';
import 'package:itry/services/ads_service.dart';
import 'package:itry/services/anxiety_survey_service.dart';
import 'package:itry/services/creativity_productivity_survey_service.dart';
import 'package:itry/services/creativity_productivity_test_service.dart';
import 'package:itry/services/depression_survey_service.dart';
import 'package:itry/services/finger_tapping_test_service.dart';
import 'package:itry/services/pavsat_test_service.dart';
import 'package:itry/services/spatial_memory_test_service.dart';
import 'package:itry/services/stress_survey_service.dart';

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
  StressSurveyService _ssService = StressSurveyService();
  AnxietySurveyService _asService = AnxietySurveyService();
  AcuityContrastTestService _actService = AcuityContrastTestService();
  PavsatTestService _pstService = PavsatTestService();

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
  ]; // finger_tapping, cp_survey, cp_test, spatial_mem, depression_survey, stress_survey, anxiety_survey, acuity_contrast, pavsat

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
      var depressionListFiltered = await _dsService.getBetweenDates(_from, _to);
      for (var item in depressionListFiltered) {
        depressionData.add(GraphDataType(
            item.date.difference(_from).inDays, item.percentageScore));
      }
      depressionData.sort((a, b) => a.day.compareTo(b.day));
      data.depressionSurveyData = depressionData;
    }
    if (_enabledDataTypes[5]) {
      List<GraphDataType> stressData = <GraphDataType>[];
      var stressListFiltered = await _ssService.getBetweenDates(_from, _to);
      for (var item in stressListFiltered) {
        stressData.add(GraphDataType(
            item.date.difference(_from).inDays, item.percentageScore));
      }
      stressData.sort((a, b) => a.day.compareTo(b.day));
      data.stressSurveyData = stressData;
    }
    if (_enabledDataTypes[6]) {
      List<GraphDataType> anxietyData = <GraphDataType>[];
      var anxietyListFiltered = await _asService.getBetweenDates(_from, _to);
      for (var item in anxietyListFiltered) {
        anxietyData.add(GraphDataType(
            item.date.difference(_from).inDays, item.percentageScore));
      }
      anxietyData.sort((a, b) => a.day.compareTo(b.day));
      data.anxietySurveyData = anxietyData;
    }

    if (_enabledDataTypes[7]) {
      List<GraphDataType> acuityContrData = <GraphDataType>[];
      var acuityContrastListFiltered = await _actService.getBetweenDates(_from, _to);
      for (var item in acuityContrastListFiltered) {
        acuityContrData.add(GraphDataType(
            item.date.difference(_from).inDays, item.percentageScore));
      }
      acuityContrData.sort((a, b) => a.day.compareTo(b.day));
      data.acuityContrastTestData = acuityContrData;
    }
    if (_enabledDataTypes[8]) {
      List<GraphDataType> pavsatData = <GraphDataType>[];
      var pavsatListFiltered = await _actService.getBetweenDates(_from, _to);
      for (var item in pavsatListFiltered) {
        pavsatData.add(GraphDataType(
            item.date.difference(_from).inDays, item.percentageScore));
      }
      pavsatData.sort((a, b) => a.day.compareTo(b.day));
      data.pavsatTestData = pavsatData;
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

    if (data.stressSurveyData != null) {
      seriesList.add(
        chart.Series(
            id: 'StressSurvey',
            data: data.stressSurveyData,
            colorFn: (_, __) => chart.MaterialPalette.cyan.shadeDefault,
            domainFn: (GraphDataType point, _) => point.day,
            measureFn: (GraphDataType point, _) => point.result),
      );
    }

    if (data.anxietySurveyData != null) {
      seriesList.add(
        chart.Series(
            id: 'AnxietySurvey',
            data: data.anxietySurveyData,
            colorFn: (_, __) => chart.MaterialPalette.teal.shadeDefault,
            domainFn: (GraphDataType point, _) => point.day,
            measureFn: (GraphDataType point, _) => point.result),
      );
    }

    if (data.acuityContrastTestData != null) {
      seriesList.add(
        chart.Series(
            id: 'AcuityContrastTest',
            data: data.acuityContrastTestData,
            colorFn: (_, __) => chart.MaterialPalette.pink.shadeDefault,
            domainFn: (GraphDataType point, _) => point.day,
            measureFn: (GraphDataType point, _) => point.result),
      );
    }

    if (data.pavsatTestData != null) {
      seriesList.add(
        chart.Series(
            id: 'PavsatTest',
            data: data.pavsatTestData,
            colorFn: (_, __) => chart.MaterialPalette.deepOrange.shadeDefault,
            domainFn: (GraphDataType point, _) => point.day,
            measureFn: (GraphDataType point, _) => point.result),
      );
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
        // if (Orientation.portrait == orientation) {
        //   AdsService().showBanner();
        // } else {
        //   AdsService().hideBanner();
        // }

        return Scaffold(
          drawer: DrawerFragment(),
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
                      GestureDetector(
                        child: SwitchListTile(
                          value: _enabledDataTypes[0],
                          onChanged: (val) => setState(() {
                            _enabledDataTypes[0] = val;
                          }),
                          title: Text(FingerTappingTestPage.title),
                          subtitle: Text('Hold down for details'),
                          activeColor: Colors.blue,
                        ),
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ReportPage(
                                testService: _fttService,
                                dateFrom: _from,
                                dateTo: _to,
                                raportName: FingerTappingTestPage.title,
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: SwitchListTile(
                          value: _enabledDataTypes[1],
                          onChanged: (val) => setState(() {
                            _enabledDataTypes[1] = val;
                          }),
                          title: Text(CreativityProductivitySurveyPage.title),
                          subtitle: Text('Hold down for details'),
                          activeColor: Colors.purple,
                        ),
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ReportPage(
                                testService: _cpsService,
                                dateFrom: _from,
                                dateTo: _to,
                                raportName: CreativityProductivitySurveyPage.title,
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: SwitchListTile(
                          value: _enabledDataTypes[2],
                          onChanged: (val) => setState(() {
                            _enabledDataTypes[2] = val;
                          }),
                          title: Text(CreativityProductivityTestPage.title),
                          subtitle: Text('Hold down for details'),
                          activeColor: Colors.red,
                        ),
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ReportPage(
                                testService: _cptService,
                                dateFrom: _from,
                                dateTo: _to,
                                raportName: CreativityProductivityTestPage.title,
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: SwitchListTile(
                          value: _enabledDataTypes[3],
                          onChanged: (val) => setState(() {
                            _enabledDataTypes[3] = val;
                          }),
                          title: Text(SpatialMemoryTestPage.title),
                          subtitle: Text('Hold down for details'),
                          activeColor: Colors.lime,
                        ),
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ReportPage(
                                testService: _smtService,
                                dateFrom: _from,
                                dateTo: _to,
                                raportName: SpatialMemoryTestPage.title,
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: SwitchListTile(
                          value: _enabledDataTypes[4],
                          onChanged: (val) => setState(() {
                            _enabledDataTypes[4] = val;
                          }),
                          title: Text(DepressionSurveyPage.title),
                          subtitle: Text('Hold down for details'),
                          activeColor: Colors.green,
                        ),
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ReportPage(
                                testService: _dsService,
                                dateFrom: _from,
                                dateTo: _to,
                                raportName: DepressionSurveyPage.title,
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: SwitchListTile(
                          value: _enabledDataTypes[5],
                          onChanged: (val) => setState(() {
                            _enabledDataTypes[5] = val;
                          }),
                          title: Text(StressSurveyPage.title),
                          subtitle: Text('Hold down for details'),
                          activeColor: Colors.cyan,
                        ),
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ReportPage(
                                testService: _ssService,
                                dateFrom: _from,
                                dateTo: _to,
                                raportName: StressSurveyPage.title,
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: SwitchListTile(
                          value: _enabledDataTypes[6],
                          onChanged: (val) => setState(() {
                            _enabledDataTypes[6] = val;
                          }),
                          title: Text(AnxietySurveyPage.title),
                          subtitle: Text('Hold down for details'),
                          activeColor: Colors.teal,
                        ),
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ReportPage(
                                testService: _asService,
                                dateFrom: _from,
                                dateTo: _to,
                                raportName: AnxietySurveyPage.title,
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: SwitchListTile(
                          value: _enabledDataTypes[7],
                          onChanged: (val) => setState(() {
                            _enabledDataTypes[7] = val;
                          }),
                          title: Text(AcuityContrastTestPage.title),
                          subtitle: Text('Hold down for details'),
                          activeColor: Colors.pink,
                        ),
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ReportPage(
                                testService: _actService,
                                dateFrom: _from,
                                dateTo: _to,
                                raportName: AcuityContrastTestPage.title,
                              ),
                            ),
                          );
                        },
                      ),
                      GestureDetector(
                        child: SwitchListTile(
                          value: _enabledDataTypes[8],
                          onChanged: (val) => setState(() {
                            _enabledDataTypes[8] = val;
                          }),
                          title: Text(PavsatTestPage.title),
                          subtitle: Text('Hold down for details'),
                          activeColor: Colors.deepOrange,
                        ),
                        onLongPress: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (BuildContext context) => ReportPage(
                                testService: _pstService,
                                dateFrom: _from,
                                dateTo: _to,
                                raportName: PavsatTestPage.title,
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(),
                    ],
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
  List<GraphDataType> fingerTappingTestData;
  List<GraphDataType> creativityProductivitySurveyData;
  List<GraphDataType> creativityProductivityTestData;
  List<GraphDataType> spatialMemoryTestData;
  List<GraphDataType> depressionSurveyData;
  List<GraphDataType> stressSurveyData;
  List<GraphDataType> anxietySurveyData;
  List<GraphDataType> acuityContrastTestData;
  List<GraphDataType> pavsatTestData;
}

class GraphDataType {
  int day;
  double result;

  GraphDataType(this.day, this.result);
}
