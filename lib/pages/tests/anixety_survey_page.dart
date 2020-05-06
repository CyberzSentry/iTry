import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:itry/database/models/anxiety_survey.dart';
import 'package:itry/fragments/icon_text_fragment.dart';
import 'package:itry/pages/tests/base_test_page.dart';
import 'package:itry/services/anxiety_survey_service.dart';

class AnxietySurveyPage extends BaseTestPage {
  static final String routeName = '/anxietySurvey';
  static final String title = "Anxiety survey";

  @override
  _AnxietySurveyPageState createState() => _AnxietySurveyPageState();
}

class _AnxietySurveyPageState extends BaseTestState<AnxietySurveyPage,
    AnxietySurveyService, AnxietySurvey> {
  _AnxietySurveyPageState() {
    for (int i = 0; i < _questionsMulti.length; i++) {
      _answersMulti.add(List<int>.filled(_questionsMulti[i].length, -1));
    }
    for (int i = 0; i < _questionsCheck.length; i++) {
      _answersCheck
          .add(List<bool>.filled(_possibleAnswersCheck[i].length, false));
    }
    for (int i = 0; i < _additionalToCheck.length; i++) {
      _answersAdditionalToCheck
          .add(List<int>.filled(_additionalToCheck[i].length, -1));
    }
    for (var questionType in _questionsMulti) {
      _sumAllQuestions += questionType.length;
    }
    for (var questionType in _additionalToCheck) {
      _sumAllQuestions += questionType.length;
    }
    _sumAllQuestions += _questionsCheck.length;
  }

  static final _questionsMulti = questionsMulti;
  static final _questionsCheck = questionsCheck;
  static final _additionalToCheck = additionalToCheck;
  static final _possibleAnswersMulti = possibleAnswersMulti;
  static final _possibleAnswersCheck = possibleAnswersCheck;
  static final _additionaToCheckAnswers = additionalToCheckAns;

  AnxietySurveyService service = AnxietySurveyService();

  int _questionGroupIndex = 0;
  int _questionIndex = 0;

  List<List<int>> _answersMulti = List<List<int>>();
  List<List<bool>> _answersCheck = List<List<bool>>();
  List<List<int>> _answersAdditionalToCheck = List<List<int>>();

  int _sumAllQuestions = 0;
  int _sumGlobalCurrQuestion = 0;
  int _currAnsw = -1;

  bool _finished = false;
  bool _questionType = false; //false - multi, true - check
  bool _additional = false;

  void _confirm() async {
    var score = calculateScore(_answersMulti, _answersCheck, _answersAdditionalToCheck);

    var result = AnxietySurvey();
    var date = DateTime.now();
    result.date = date;
    result.score = score;
    await commitResult(result);
    Navigator.of(context).pop();
  }

  void _retake() {
    setState(() {
      _finished = false;
      //_prevCheck();
    });
  }

  Widget _multipleAnswerQuestion() {
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
                  _questionsMulti[_questionGroupIndex][_questionIndex],
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
                onPressed: _currAnsw != -1 ? _nextMulti : null,
                child: Text('Next'),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _additionalQuestion() {
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
                  _additionalToCheck[0][0],
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
                children: _buildRadioButtonsAdditional(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _buildAnswersRowAdditional(),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                color: Colors.green,
                onPressed: () {
                  _additional = false;
                  _prevCheck();
                },
                child: Text('Previous'),
              ),
              MaterialButton(
                color: Colors.green,
                onPressed: (){
                  setState(() {
                    _finished = true;
                  });
                },
                child: Text('Next'),
              )
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _buildAnswersRow() {
    var output = <Widget>[];

    for (var ans in _possibleAnswersMulti[_questionGroupIndex]) {
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

  List<Widget> _buildAnswersRowAdditional() {
    var output = <Widget>[];

    for (var ans in _additionaToCheckAnswers[0]) {
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

  List<Widget> _buildRadioButtons() {
    var output = <Widget>[];

    for (int i = 0;
        i < _possibleAnswersMulti[_questionGroupIndex].length;
        i++) {
      output.add(Expanded(
          child: Radio(value: i, groupValue: _currAnsw, onChanged: _setRadio)));
    }

    return output;
  }

  List<Widget> _buildRadioButtonsAdditional() {
    var output = <Widget>[];

    for (int i = 0; i < _additionaToCheckAnswers[0].length; i++) {
      output.add(
        Expanded(
          child: Radio(
            value: i,
            groupValue: _answersAdditionalToCheck[0][0],
            onChanged: (value) {
              setState(() {
                _answersAdditionalToCheck[0][0] = value;
              });
            },
          ),
        ),
      );
    }

    return output;
  }

  _setRadio(int value) {
    setState(() {
      _currAnsw = value;
    });
  }

  void _nextMulti() {
    setState(() {
      _answersMulti[_questionGroupIndex][_questionIndex] = _currAnsw;
      _sumGlobalCurrQuestion++;
      _questionIndex++;
      if (_questionIndex == _questionsMulti[_questionGroupIndex].length) {
        _questionIndex = 0;
        _questionGroupIndex++;
        if (_questionGroupIndex == _questionsMulti.length) {
          _questionType = true;
        } else {
          _currAnsw = _answersMulti[_questionGroupIndex][_questionIndex];
        }
      } else {
        _currAnsw = _answersMulti[_questionGroupIndex][_questionIndex];
      }
    });
  }

  void _prevMulti() {
    setState(() {
      _answersMulti[_questionGroupIndex][_questionIndex] = _currAnsw;
      _sumGlobalCurrQuestion--;
      _questionIndex--;
      if (_questionIndex < 0) {
        _questionGroupIndex--;
        _questionIndex = _questionsMulti[_questionGroupIndex].length - 1;
      }
      _currAnsw = _answersMulti[_questionGroupIndex][_questionIndex];
    });
  }

  Widget _confirmScreen() {
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
                calculateScore(_answersMulti, _answersCheck, _answersAdditionalToCheck).toString() + "/$maxScore",
                // calculateScore(_answers).toString() + "/$maxScore",
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
                onPressed: _confirm,
                child: Text('Confirm'),
              )
            ],
          )
        ],
      ),
    );
  }

  void _prevCheck() {
    _sumGlobalCurrQuestion--;
    setState(() {
      _questionIndex--;
      if (_questionIndex < 0) {
        _questionGroupIndex = _questionsMulti.length - 1;
        _questionIndex = _questionsMulti[_questionGroupIndex].length - 1;
        _questionType = false;
      }
    });
  }

  void _nextCheck() {
    _sumGlobalCurrQuestion++;
    setState(() {
      _questionIndex++;
      if (_questionIndex == _questionsCheck.length) {
        _additional = true;
      }
    });
  }

  Widget _checkQuestion() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
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
                  questionsCheck[_questionIndex],
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, count) {
                return CheckboxListTile(
                    title: Text(_possibleAnswersCheck[_questionIndex][count]),
                    value: _answersCheck[_questionIndex][count],
                    onChanged: (value) {
                      setState(() {
                        _answersCheck[_questionIndex][count] = value;
                      });
                    });
              },
              itemCount: _possibleAnswersCheck[_questionIndex].length,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                color: Colors.green,
                onPressed: _prevCheck,
                child: Text('Previous'),
              ),
              MaterialButton(
                color: Colors.green,
                onPressed: _nextCheck,
                child: Text('Next'),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget body() {
    if (_finished) {
      return _confirmScreen();
    } else {
      if (_questionType) {
        if (_additional) {
          return _additionalQuestion();
        } else {
          return _checkQuestion();
        }
      } else {
        return _multipleAnswerQuestion();
      }
    }
  }

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
        child: Text(
            "answer the following questions using your best beliefs.",
            textAlign: TextAlign.justify),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Text(
            "The interval of the survey: once a week.",
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
    return AnxietySurveyPage.title;
  }

  @override
  String route() {
    return AnxietySurveyPage.routeName;
  }

  @override
  String title() {
    return AnxietySurveyPage.title;
  }
}
