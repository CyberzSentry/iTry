import 'package:flutter/material.dart';
import 'package:itry/database/models/chronic_pain_survey.dart';
import 'package:itry/fragments/icon_text_fragment.dart';
import 'package:itry/pages/tests/base_test_page.dart';
import 'package:itry/services/tests/chronic_pain_survey_service.dart';

class ChronicPainSurveyPage extends BaseTestPage {
  static final String routeName = '/chronicPainSurvey';
  static final String title = "Chronic pain survey";

  @override
  _ChronicPainSurveyPageState createState() => _ChronicPainSurveyPageState();
}

class _ChronicPainSurveyPageState extends BaseTestState<ChronicPainSurveyPage,
    ChronicPainSurveyService, ChronicPainSurvey> {
  _ChronicPainSurveyPageState() {
    _answers = <List<int>>[];
    for (var q in questionsMulti) {
      _answers.add(List.filled(q.length, -1));
      _sumAllQuestions += q.length;
    }
  }

  ChronicPainSurveyService service = ChronicPainSurveyService();

  var _questions = questionsMulti;
  var _possibleAnswers = possibleAnswersMulti;
  int _sumAllQuestions = 0;
  int _questionIndex = 0;
  int _questionGroupIndex = 0;
  int _sumGlobalCurrQuestion = 0;

  List<List<int>> _answers;

  bool _finished = false;

  Widget _test() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                child: Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                ),
                onTap: () => showDescription(),
              ),
              Text((_sumGlobalCurrQuestion + 1).toString() +
                  '/' +
                  (_sumAllQuestions).toString()),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Text(
                  _questions[_questionGroupIndex][_questionIndex],
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _buildRadioButtons(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _buildAnswersRow(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                color: Colors.green,
                onPressed: _questionIndex != 0 || _questionGroupIndex != 0
                    ? _prevMulti
                    : null,
                child: Text('Previous'),
              ),
              MaterialButton(
                color: Colors.green,
                onPressed: _answers[_questionGroupIndex][_questionIndex] != -1
                    ? _nextMulti
                    : null,
                child: Text('Next'),
              )
            ],
          )
        ],
      ),
    );
  }

  void _prevMulti() {
    _sumGlobalCurrQuestion--;
    _questionIndex--;
    if (_questionIndex == -1) {
      _questionGroupIndex--;
      _questionIndex = _questions[_questionGroupIndex].length - 1;
    }
    setState(() {});
  }

  void _nextMulti() {
    _sumGlobalCurrQuestion++;
    if (_answers[0][0] == 0) {
      setState(() {
        _questionIndex++;
        _finished = true;
        _questionGroupIndex++;
      });
    } else {
      _questionIndex++;
      if (_questionIndex == _questions[_questionGroupIndex].length) {
        _questionGroupIndex++;
        if (_questionGroupIndex == _questions.length) {
          _finished = true;
        } else {
          _questionIndex = 0;
        }
      }
      setState(() {});
    }
  }

  List<Widget> _buildRadioButtons() {
    var output = <Widget>[];

    for (int i = 0; i < _possibleAnswers[_questionGroupIndex].length; i++) {
      output.add(
        Expanded(
          child: Radio(
              value: i,
              groupValue: _answers[_questionGroupIndex][_questionIndex],
              onChanged: (x) => setState(() {
                    _answers[_questionGroupIndex][_questionIndex] = x;
                  })),
        ),
      );
    }

    return output;
  }

  List<Widget> _buildAnswersRow() {
    var output = <Widget>[];

    for (var ans in _possibleAnswers[_questionGroupIndex]) {
      output.add(
        Expanded(
          child: Text(
            ans,
            softWrap: true,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return output;
  }

  Widget _confirm() {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                child: Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                ),
                onTap: () => showDescription(),
              ),
            ],
          ),
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
                onPressed: _retake,
                child: Text('Go back'),
              ),
              MaterialButton(
                color: Colors.green,
                onPressed: _commit,
                child: Text('Confirm'),
              )
            ],
          )
        ],
      ),
    );
  }

  void _retake() {
    setState(() {
      _questionIndex--;
      _questionGroupIndex--;
      _finished = false;
      _sumGlobalCurrQuestion--;
    });
  }

  void _commit() async {
    var score = calculateScore(_answers);
    var result = ChronicPainSurvey();
    result.date = DateTime.now();
    result.score = score;

    await commitResult(result);
  }

  @override
  Widget body() {
    if (_finished) {
      return _confirm();
    } else {
      return _test();
    }
  }

  //TODO: implement description
  @override
  List<Widget> descriptionBody() {
    return <Widget>[
      Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Text(
            "Anxiety is a regular reaction of our body to constant stress, although it can limit our ability to get into new situations and perform our everyday tasks. It is useful, while appearing from time to time, but overwhelming fear could be devastating, so if your results keep high or increasing through a long period of time, you should consider getting professional help.",
            textAlign: TextAlign.justify),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Text(
            "Every question in this survey should be followed with retrospection of this past week, where the described symptoms were appearing:",
            textAlign: TextAlign.justify),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(
                  "0 - Not at all\n1 - From time to time\n2 - Most of the time\n3 - Nearly all the time",
                  textAlign: TextAlign.justify),
            ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Text("answer the following questions using your best beliefs.",
            textAlign: TextAlign.justify),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Text("The interval of the survey: once a week.",
            textAlign: TextAlign.justify),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: IconTextFragment(),
      ),
    ];
  }

  @override
  String descriptionTitle() {
    return ChronicPainSurveyPage.title;
  }

  @override
  String route() {
    return ChronicPainSurveyPage.routeName;
  }

  @override
  String title() {
    return ChronicPainSurveyPage.title;
  }
}
