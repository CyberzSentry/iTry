import 'package:flutter/material.dart';
import 'package:itry/database/accessors/first_test_accessor.dart';
import 'package:itry/database/models/first_test.dart';

class FirstTestPage extends StatefulWidget {
  static const String routeName = '/firstTest';
  static const String title = "First Test";

  @override
  _FirstTestPageState createState() => _FirstTestPageState();
}

class _FirstTestPageState extends State<FirstTestPage> {
  FirstTestAccessor fta = FirstTestAccessor();
  final _formKey = GlobalKey<FormState>();
  var _firstTest = FirstTest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FirstTestPage.title),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'Score'),
                onChanged: (val) => setState(() => {_firstTest.score = int.parse(val)}),
              ),
              TextFormField(
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(hintText: 'Score'),
                onChanged: (val) => setState(() => {_firstTest.date = DateTime.parse(val)}),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: RaisedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      if(_firstTest.date == null){
                        _firstTest.date = DateTime.now();
                      }
                      print(_firstTest.toMap());
                      fta.insert(_firstTest);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
