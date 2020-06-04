import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:itry/database/models/experiments/experiment.dart';
import 'package:itry/services/experiments/experiment_service.dart';

class ModifyExperimentPage extends StatefulWidget {
  static const String routeName = '/modifyExperiment';
  static const String title = "Modify experiment";

  @override
  _ModifyExperimentPageState createState() => _ModifyExperimentPageState();
}

class _ModifyExperimentPageState extends State<ModifyExperimentPage> {
  ExperimentService _service = ExperimentService();

  ExperimentType _selectedExperiment;
  String _experimentName;
  String _experimentDescription;

  final _formKey = GlobalKey<FormState>();

  static const List<ExperimentType> _experimentUnits = <ExperimentType>[
    const ExperimentType(ExperimentUnits.count, 'Count'),
    const ExperimentType(ExperimentUnits.days, 'Days'),
    const ExperimentType(ExperimentUnits.hours, 'Hours'),
    const ExperimentType(ExperimentUnits.minutes, 'Minutes'),
    const ExperimentType(ExperimentUnits.mgrams, 'Miligrams'),
    const ExperimentType(ExperimentUnits.grams, 'Grams'),
    const ExperimentType(ExperimentUnits.kgrams, 'Kilograms'),
    const ExperimentType(ExperimentUnits.ounces, 'Ounces'),
    const ExperimentType(ExperimentUnits.pounds, 'Pounds'),
    const ExperimentType(ExperimentUnits.kmeters, 'Kilometers'),
    const ExperimentType(ExperimentUnits.miles, 'Miles'),
  ];

  void _submit() async {
    if (_formKey.currentState.validate()) {
      var exp = Experiment();
      exp.name = _experimentName;
      exp.description = _experimentDescription ?? '';
      exp.unit = _selectedExperiment.id;
      await _service.insert(exp);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ModifyExperimentPage.title),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.content_paste),
              title: TextFormField(
                onChanged: (value) {
                  _experimentName = value;
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
              title: DropdownButtonFormField<ExperimentType>(
                  validator: (value) {
                    if (value == null) {
                      return 'Unit can not be empty';
                    } else {
                      return null;
                    }
                  },
                  isExpanded: true,
                  hint: Text('Experiment unit'),
                  value: _selectedExperiment,
                  items: _experimentUnits.map((e) {
                    return DropdownMenuItem<ExperimentType>(
                      value: e,
                      child: Row(
                        children: <Widget>[Text(e.name)],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedExperiment = value;
                    });
                  }),
            ),
            ListTile(
              title: TextFormField(
                onChanged: (value) {
                  _experimentDescription = value;
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
      ),
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
