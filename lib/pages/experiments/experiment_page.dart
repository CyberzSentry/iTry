import 'package:charts_flutter/flutter.dart' as chart;
import 'package:flutter/material.dart';
import 'package:itry/database/models/experiments/dose.dart';
import 'package:itry/database/models/experiments/experiment.dart';
import 'package:itry/pages/experiments/add_experiment_page.dart';
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
import 'package:itry/services/experiments/dose_service.dart';
import 'package:itry/services/experiments/experiment_service.dart';
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
import 'package:charts_common/common.dart' as chart_comm;

class ExperimentPage extends StatefulWidget {
  static const String routeName = '/experiment';
  static const String title = "Custom experiment";
  final int experimentId;

  ExperimentPage(this.experimentId);

  @override
  _ExperimentPageState createState() => _ExperimentPageState(experimentId);
}

class _ExperimentPageState extends State<ExperimentPage> {
  _ExperimentPageState(int experimentId) {
    _id = experimentId;
  }

  static List<Tuple4<TestServiceInterface, String, MaterialColor, chart.Color>>
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

  var _enabledDataTypes = List.filled(graphElements.length, true);
  //  [
  //   true,
  //   true,
  //   true,
  //   true,
  //   true,
  //   true,
  //   true,
  //   true,
  //   true,
  //   true,
  // ]; // finger_tapping, cp_survey, cp_test, spatial_mem, depression_survey, stress_survey, anxiety_survey, acuity_contrast, pavsat, chronic_pain

  var _improvementValues = List.filled(graphElements.length, 0);

  int _id;
  ExperimentService _experimentService = ExperimentService();
  DoseService _doseService = DoseService();
  Experiment _experiment;
  List<Dose> _doses;
  chart.TimeSeriesChart _chart;

  Future<bool> _experimentData() async {
    _experiment = await _experimentService.getSingle(_id);
    _doses = await _doseService.getAllFromExperiment(_experiment.id);
    _doses.sort((dose1, dose2) {
      return dose1.date.compareTo(dose2.date);
    });
    return true;
  }

  Future<bool> _raportData() async {
    final doses = <TimeSeriesElement>[];
    for (var dose in _doses) {
      doses.add(TimeSeriesElement(date: dose.date));
    }

    List<chart.Series<TimeSeriesElement, DateTime>> series = [
      chart.Series<TimeSeriesElement, DateTime>(
        id: 'Doses',
        colorFn: (_, __) => chart.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesElement dose, _) => dose.date,
        domainUpperBoundFn: (TimeSeriesElement dose, _) => dose.date,
        domainLowerBoundFn: (TimeSeriesElement dose, _) => dose.date,
        measureFn: (_, __) => null,
        data: doses,
      )
        // Configure our custom symbol annotation renderer for this series.
        ..setAttribute(chart.rendererIdKey, 'customSymbolAnnotation')
        // Optional radius for the annotation shape. If not specified, this will
        // default to the same radius as the points.
        ..setAttribute(chart.boundsLineRadiusPxKey, 2.5),
    ];

    for (int i = 0; i < graphElements.length; i++) {
      if (_enabledDataTypes[i]) {
        var graphData = <TimeSeriesElement>[];
        var data = await graphElements[i].item1.getAll();

        for (var it in data) {
          graphData
              .add(TimeSeriesElement(date: it.date, value: it.percentageScore));
        }

        series.add(
          chart.Series<TimeSeriesElement, DateTime>(
            id: graphElements[i].item2,
            colorFn: (_, __) => graphElements[i].item4,
            domainFn: (TimeSeriesElement data, __) => data.date,
            measureFn: (TimeSeriesElement data, __) => data.value,
            domainLowerBoundFn: (_, __) => null,
            domainUpperBoundFn: (_, __) => null,
            data: graphData,
          ),
        );
      }
    }

    _chart = chart.TimeSeriesChart(
      series,
      animate: true,
      customSeriesRenderers: [
        chart.SymbolAnnotationRendererConfig(
            // ID used to link series to this renderer.
            customRendererId: 'customSymbolAnnotation')
      ],
      behaviors: [
        new chart.SeriesLegend.customLayout(CustomLegendBuilder(),
            outsideJustification: chart.OutsideJustification.start)
      ],
      dateTimeFactory: const chart.LocalDateTimeFactory(),
    );

    return true;
  }

  List<Widget> _switchListTiles() {
    var output = <Widget>[];

    output.add(
      SizedBox(height: 250, child: _chart),
    );

    for (int i = 0; i < graphElements.length; i++) {
      output.add(
        SwitchListTile(
          value: _enabledDataTypes[i],
          onChanged: (val) => setState(() {
            _enabledDataTypes[i] = val;
          }),
          title: Text(graphElements[i].item2),
          activeColor: graphElements[i].item3,
          secondary: Text(
            _improvementValues[i].toString() + '%',
            style: TextStyle(
                color: _improvementValues[i] >= 0 ? Colors.green : Colors.red),
          ),
        ),
      );
    }

    return output;
  }

  void _deleteExperiment() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text('Are you sure you want to delete this experiment?'),
            actions: <Widget>[
              FlatButton(
                color: Colors.red,
                onPressed: () {
                  _experimentService.delete(_experiment.id);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text('Continue'),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Abort'),
              )
            ],
          );
        });
  }

  void _addDose() async {
    AdsService().hideBanner();
    await showDialog(
      context: context,
      builder: (context) {
        DateTime dateGlob = DateTime.now();
        String value = "";
        final _formKey = GlobalKey<FormState>();
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    ListTile(
                      title: Text(
                        'Date:',
                        style: Theme.of(context).textTheme.caption,
                      ),
                      subtitle: Text(
                        dateGlob.toString().substring(0, 16),
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      onTap: () async {
                        var date = await showDatePicker(
                            context: context,
                            initialDate: dateGlob,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now().add(Duration(days: 365)));
                        if (date != null) {
                          var time = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          if (time != null) {
                            setState(() {
                              dateGlob = DateTime(date.year, date.month,
                                  date.day, time.hour, time.minute);
                            });
                          }
                        }
                      },
                    ),
                    ListTile(
                      title: Text('Value',
                          style: Theme.of(context).textTheme.caption),
                      subtitle: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          var output = double.tryParse(value);
                          if (output == null) {
                            return "Can not be empty";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          value = val;
                        },
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_experiment.unit.stringValue()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  color: Colors.green,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      var output = Dose();
                      output.value = double.parse(value);
                      output.date = dateGlob;
                      output.experimentId = _experiment.id;
                      var out = await _doseService.insert(output);
                      if (out.id != null) {
                        if (_experiment.baselineFrom == null &&
                            _experiment.baselineTo == null) {
                          if (_doses.length == 0) {

                            _experiment.baselineTo =
                                out.date.subtract(Duration(days: 1));
                            _experiment.baselineFrom =
                                out.date.subtract(Duration(days: 31));
                            var out2 =_experimentService.updateExperiment(_experiment);
                          } else if (_doses[0].date.compareTo(out.date) > 0) {
                            _experiment.baselineTo =
                                out.date.subtract(Duration(days: 1));
                            _experiment.baselineFrom =
                                out.date.subtract(Duration(days: 31));
                            var out2 = _experimentService.updateExperiment(_experiment);
                          }
                        }
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Save'),
                ),
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancel'),
                )
              ],
            );
          },
        );
      },
    );
    AdsService().showBanner();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: FutureBuilder<bool>(
        future: _experimentData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var doses = <Widget>[];
            doses.add(
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add dose'),
                onTap: _addDose,
              ),
            );

            var output = <Widget>[];
            output.add(
              ListTile(
                title: Text('Add dose'),
                trailing: Icon(Icons.add),
                onTap: _addDose,
              ),
            );

            for (var dose in _doses) {
              output.add(Dismissible(
                  background: Container(color: Colors.red),
                  confirmDismiss: (direction) {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Delete'),
                          content: Text(
                              'Are you sure you want to delete this value?'),
                          actions: <Widget>[
                            FlatButton(
                              color: Colors.red,
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Continue'),
                            ),
                            FlatButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Abort'),
                            )
                          ],
                        );
                      },
                    );
                  },
                  onDismissed: (direction) async {
                    await _doseService.delete(dose.id);
                    _doses.remove(dose);
                  },
                  key: Key(dose.id.toString()),
                  child: ListTile(
                    title: Text(
                      dose.value.toString(),
                    ),
                    subtitle: Text(
                      dose.date.toString().substring(0, 16),
                    ),
                    trailing: Text(_experiment.unit.stringValue()),
                  )));
            }

            return Scaffold(
              appBar: AppBar(
                title: Text(_experiment.name),
                bottom: TabBar(
                  tabs: [
                    Tab(
                      icon: Icon(Icons.insert_chart),
                      text: 'Results',
                    ),
                    Tab(
                      icon: Icon(Icons.content_paste),
                      text: 'Doses',
                    ),
                    Tab(
                      icon: Icon(Icons.settings),
                      text: 'Settings',
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 51),
                child: TabBarView(
                  children: [
                    _doses.length > 0
                        ? FutureBuilder(
                            future: _raportData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return SingleChildScrollView(
                                  child: Column(
                                    children: _switchListTiles(),
                                  ),
                                );
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          )
                        : Center(child: Text("Add doses to start experiment.")),
                    ListView(
                      children: output,
                    ),
                    ListView(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            'Name',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          subtitle: Text(
                            _experiment.name,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Unit',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          subtitle: Text(
                            _experiment.unit.stringValue(),
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Description',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          subtitle: Text(
                            _experiment.description,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Baseline from',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          subtitle: Text(
                            _experiment.baselineFrom != null
                                ? _experiment.baselineFrom.toString().substring(0, 10)
                                : "",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'Baseline to',
                            style: Theme.of(context).textTheme.caption,
                          ),
                          subtitle: Text(
                            _experiment.baselineTo != null
                                ? _experiment.baselineTo.toString().substring(0, 10)
                                : "",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        ListTile(
                            title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                              onPressed: () => Navigator.of(context)
                                  .push(
                                MaterialPageRoute(
                                  builder: (context) => AddExperimentPage(
                                    id: _experiment.id,
                                  ),
                                ),
                              )
                                  .then((value) {
                                setState(() {});
                              }),
                              child: Text('Modify'),
                            ),
                            MaterialButton(
                              color: Colors.red,
                              onPressed: _deleteExperiment,
                              child: Text('Delete'),
                            )
                          ],
                        ))
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('Experiment'),
              ),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}

class TimeSeriesElement {
  DateTime date;
  double value;
  TimeSeriesElement({this.date, this.value});
}

class CustomLegendBuilder extends chart.LegendContentBuilder {
  @override
  Widget build(BuildContext context, chart_comm.LegendState legendState,
      chart_comm.Legend legend,
      {bool showMeasures}) {
    /*
      Implement your custom layout logic here. You should take into account how long
      your legend names are and how many legends you have. For starters you
      could put each legend on its own line.
    */

    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 5),
            child: Icon(
              Icons.brightness_1,
              color: Colors.blue,
              size: 12,
            ),
          ),
          Text('Doses')
        ],
      ),
    );
  }
}
