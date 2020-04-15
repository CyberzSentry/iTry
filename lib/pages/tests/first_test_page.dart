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
  String _testDate;
  String _testScore;

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
                onChanged: (val) => setState(() => _testScore = val),
              ),
              TextFormField(
                keyboardType: TextInputType.datetime,
                initialValue: '2020',
                decoration: InputDecoration(hintText: 'Date'),
                onChanged: (val) => setState(() =>_testDate = val),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: MaterialButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      var firstTest = FirstTest();
                      firstTest.score = int.parse(_testScore);
                      try{
                        firstTest.date = DateTime.parse(_testDate);
                      }on ArgumentError{

                      }     
                      if(firstTest.date == null){
                        firstTest.date = DateTime.now();
                      }
                      print(firstTest.toMap());
                      fta.insert(firstTest);
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
