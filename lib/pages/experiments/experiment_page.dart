import 'package:flutter/material.dart';
import 'package:itry/database/models/experiments/dose.dart';
import 'package:itry/database/models/experiments/experiment.dart';
import 'package:itry/pages/experiments/add_experiment_page.dart';
import 'package:itry/services/ads_service.dart';
import 'package:itry/services/experiments/dose_service.dart';
import 'package:itry/services/experiments/experiment_service.dart';

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
    _experimentFuture = _experimentService.getSingle(experimentId);
  }
  ExperimentService _experimentService = ExperimentService();
  DoseService _doseService = DoseService();
  Future<Experiment> _experimentFuture;
  Experiment _experiment;
  List<Dose> _doses;

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
                      await _doseService.insert(output);
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
      child: FutureBuilder<Experiment>(
        future: _experimentFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _experiment = snapshot.data;

            var doses = <Widget>[];
            doses.add(
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add dose'),
                onTap: _addDose,
              ),
            );

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
                padding: EdgeInsets.fromLTRB(0, 0, 0, 49),
                child: TabBarView(
                  children: [
                    Container(),
                    FutureBuilder<List<Dose>>(
                      future:
                          DoseService().getAllFromExperiment(_experiment.id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          _doses = snapshot.data;

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
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: Text('Continue'),
                                          ),
                                          FlatButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
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
                                  trailing:
                                      Text(_experiment.unit.stringValue()),
                                )));
                          }

                          return ListView(
                            children: output,
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
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
                                _experimentFuture = _experimentService
                                    .getSingle(_experiment.id);
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
