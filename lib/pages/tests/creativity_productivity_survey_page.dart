import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:itry/database/accessors/creativity_productivity_survey_accesor.dart';
import 'package:itry/database/models/creativity_productivity_survey.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class CreativityProductivitySurveyPage extends StatefulWidget {
  static final String routeName = '/creativityProductivityTest';
  static final String title = "Creativity and productivity survey";

  @override
  _CreativityProductivitySurveyPageState createState() =>
      _CreativityProductivitySurveyPageState();
}

class _CreativityProductivitySurveyPageState
    extends State<CreativityProductivitySurveyPage> {
  static final _questionsMultiAns = <String>[
    'Have you been creative this past week?',
    'Have you been contemplative this past week?',
    'Have you been focused this past week?',
    'Have you been productive this past week?',
    'Have you experienced fatigue due to lack of sleep this past week?',
    'Have you been distracted due to some unusual event this past week?',
  ];

  static final _possibleAnswers = <String>[
    'Not at all',
    'From time to time',
    'Most of the time',
    'Nearly all the time'
  ];

  CreativityProductivitySurveyAccesor cpsa = CreativityProductivitySurveyAccesor();
  var _answers = List<int>.filled(_questionsMultiAns.length, -1);
  int _questionIndex = 0;
  int _currAnsw = -1;

  Future _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seenCreativityProductivitySurveyPage') ?? false);

    if (_seen == false) {
      await prefs.setBool('seenCreativityProductivitySurveyPage', true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              CreativityProductivitySurveyDescriptionPage(),
        ),
      );
    }
  }

  void _previous() {
    setState(() {
      _questionIndex--;
      _currAnsw = _answers[_questionIndex];
    });
  }

  void _next() {
    setState(() {
      _answers[_questionIndex] = _currAnsw;
      _questionIndex++;
      if (_questionIndex < _questionsMultiAns.length)
        _currAnsw = _answers[_questionIndex];
    });
  }

  void _setRadio(int val) {
    setState(() {
      _currAnsw = val;
    });
  }

  void _confirm() {
    _answers[4] = _answers[4] *-1;
    _answers[5] = _answers[5] *-1; 
    var sum = 0;
    for(var val in _answers){
      sum = sum + val;
    }

    var  result = CreativityProductivitySurvey();
    result.date = DateTime.now();
    result.score = sum;

    print(result.toMap());
    cpsa.insert(result);
    Navigator.of(context).pop();
  }

  Widget _questionScreen() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.grey,
                  ),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CreativityProductivitySurveyDescriptionPage()),
                  ),
                ),
                Text((_questionIndex + 1).toString() +
                    '/' +
                    (_questionsMultiAns.length).toString()),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  _questionsMultiAns[_questionIndex],
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Radio(value: 0, groupValue: _currAnsw, onChanged: _setRadio),
                  Text('0')
                ],
              ),
              Column(
                children: <Widget>[
                  Radio(value: 1, groupValue: _currAnsw, onChanged: _setRadio),
                  Text('1')
                ],
              ),
              Column(
                children: <Widget>[
                  Radio(value: 2, groupValue: _currAnsw, onChanged: _setRadio),
                  Text('2')
                ],
              ),
              Column(
                children: <Widget>[
                  Radio(value: 3, groupValue: _currAnsw, onChanged: _setRadio),
                  Text('3')
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _currAnsw != -1
                  ? Text(_possibleAnswers[_currAnsw].toString())
                  : Text('')
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                onPressed: _questionIndex > 0 ? _previous : null,
                child: Text('Previous'),
              ),
              MaterialButton(
                onPressed: _currAnsw != -1 ? _next : null,
                child: Text('Next'),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _confirmScreen() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('Are you happy with your answers?')],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                onPressed: _questionIndex > 0 ? _previous : null,
                child: Text('Go back'),
              ),
              MaterialButton(
                onPressed: _confirm,
                child: Text('Confirm'),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CreativityProductivitySurveyPage.title),
      ),
      body: _questionIndex < _questionsMultiAns.length
          ? _questionScreen()
          : _confirmScreen(),
    );
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 200), () {
        _checkFirstSeen();
        });
  }
}

class CreativityProductivitySurveyDescriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CreativityProductivitySurveyPage.title),
      ),
      body: Center(
        child: Text('description'),
      ),
    );
  }
}
