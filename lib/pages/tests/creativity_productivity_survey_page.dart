import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:itry/database/models/creativity_productivity_survey.dart';
import 'package:itry/pages/tests/base_test_page.dart';
import 'package:itry/services/creativity_productivity_survey_service.dart';

class CreativityProductivitySurveyPage extends BaseTestPage {
  static final String routeName = '/creativityProductivitySurvey';
  static final String title = "Creativity and productivity survey";

  @override
  _CreativityProductivitySurveyPageState createState() =>
      _CreativityProductivitySurveyPageState();
}

class _CreativityProductivitySurveyPageState extends BaseTestState<
    CreativityProductivitySurveyPage,
    CreativityProductivitySurveyService,
    CreativityProductivitySurvey> {
  static final _questionsMultiAns = questionsMultiAns;
  static final _possibleAnswers = possibleAnswers;

  CreativityProductivitySurveyService service =
      CreativityProductivitySurveyService();

  var _answers = List<int>.filled(_questionsMultiAns.length, -1);
  int _questionIndex = 0;
  int _currAnsw = -1;

  void _previous() {
    setState(() {
      _answers[_questionIndex] = _currAnsw;
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

  void _confirm() async {
    var score = calculateScore(_answers);

    var result = CreativityProductivitySurvey();
    var date = DateTime.now();
    result.date = date;
    result.score = score;
    await commitResult(result);
    Navigator.of(context).pop();
  }

  Widget _questionScreen() {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child: Icon(
                    Icons.info_outline,
                    color: Colors.grey,
                  ),
                  onTap: () => showDescription(),

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
                color: Colors.green,
                onPressed: _questionIndex > 0 ? _previous : null,
                child: Text('Previous'),
              ),
              MaterialButton(
                color: Colors.green,
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
      margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('Are you happy with your answers?')],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('Score:')],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                calculateScore(_answers).toString() + "/$maxScore",
                style: TextStyle(fontSize: 40),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                color: Colors.green,
                onPressed: _questionIndex > 0 ? _previous : null,
                child: Text('Go back'),
              ),
              MaterialButton(
                color: Colors.green,
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
  Widget body() {
    if (_questionIndex < _questionsMultiAns.length) {
      return _questionScreen();
    } else {
      return _confirmScreen();
    }
  }

  @override
  String title() {
    return CreativityProductivitySurveyPage.title;
  }

  @override
  List<Widget> descriptionBody() {
    return <Widget>[
      Text(
          "In creative and productivity test you can determine changes in your ability to produce new ideas and challenge tasks.",
          textAlign: TextAlign.justify),
      Text(
          "Using 4-point scale;\n0 - Not at all\n1 - From time to time\n2 - Most of the time\n3 - Nearly all the time",
          textAlign: TextAlign.justify),
    ];
  }

  @override
  String descriptionTitle() {
    return CreativityProductivitySurveyPage.title;
  }

  @override
  String route() {
    return CreativityProductivitySurveyPage.routeName;
  }
}