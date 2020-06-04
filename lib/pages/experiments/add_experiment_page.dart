import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itry/database/models/experiments/experiment.dart';
import 'package:itry/services/experiments/experiment_service.dart';

class AddExperimentPage extends StatefulWidget {
  static const String routeName = '/addExperiment';
  static const String title = "New experiment";

  final int id;

  AddExperimentPage({this.id});

  @override
  _AddExperimentPageState createState() => _AddExperimentPageState(id);
}

class _AddExperimentPageState extends State<AddExperimentPage> {
  _AddExperimentPageState(id) {
    if (id == null) {
      _experimentFuture = Future<Experiment>(() {
        return Experiment();
      });
    } else {
      _experimentFuture = _service.getSingle(id);
    }
  }

  ExperimentService _service = ExperimentService();

  Future<Experiment> _experimentFuture;

  Experiment _experiment;

  final _formKey = GlobalKey<FormState>();

  void _submit() async {
    if (_formKey.currentState.validate()) {
      if (_experiment.id == null) {
        await _service.insert(_experiment);
        Navigator.of(context).pop();
      } else {
        await _service.updateExperiment(_experiment);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AddExperimentPage.title),
      ),
      body: FutureBuilder<Experiment>(
          future: _experimentFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _experiment = snapshot.data;
              return Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.content_paste),
                      title: TextFormField(
                        initialValue: _experiment.name,
                        onChanged: (value) {
                          _experiment.name = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Name can not be empty';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Experiment name",
                        ),
                      ),
                    ),
                    ListTile(
                      title: DropdownButtonFormField<ExperimentUnits>(
                          validator: (value) {
                            if (value == null) {
                              return 'Unit can not be empty';
                            } else {
                              return null;
                            }
                          },
                          isExpanded: true,
                          hint: Text('Experiment unit'),
                          value: _experiment.unit,
                          items: ExperimentUnits.values.map((e) {
                            return DropdownMenuItem<ExperimentUnits>(
                              value: e,
                              child: Row(
                                children: <Widget>[Text(e.stringValue())],
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _experiment.unit = value;
                            });
                          }),
                    ),
                    ListTile(
                      title: TextFormField(
                        initialValue: _experiment.description,
                        onChanged: (value) {
                          _experiment.description = value;
                        },
                        minLines: 5,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "Notes/Description",
                        ),
                      ),
                    ),
                    ListTile(
                      title: MaterialButton(
                        onPressed: _submit,
                        child: Text('Save'),
                        color: Theme.of(context).buttonColor,
                      ),
                    ),
                    ListTile(),
                  ],
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class ExperimentType {
  final ExperimentUnits id;

  final String name;

  const ExperimentType(
    this.id,
    this.name,
  );
}
