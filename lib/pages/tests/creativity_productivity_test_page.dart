import 'package:flutter/material.dart';

class CreativityProductivityPage extends StatefulWidget {
  static final String routeName = '/creativityProductivityTest';
  static final String title = "Creativity and productivity test";

  @override
  _CreativityProductivityPageState createState() =>
      _CreativityProductivityPageState();
}

class _CreativityProductivityPageState
    extends State<CreativityProductivityPage> {
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
  var _answers = List<int>.filled(_questionsMultiAns.length, -1);
  int _questionIndex = 0;
  int _currAnsw = -1;

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
    print('confirmed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CreativityProductivityPage.title),
      ),
      body: _questionIndex < _questionsMultiAns.length
          ? Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 20, 10),
                        child: Text((_questionIndex + 1).toString() +
                            '/' +
                            (_questionsMultiAns.length).toString()),
                      )
                    ],
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
                          Radio(
                              value: 0,
                              groupValue: _currAnsw,
                              onChanged: _setRadio),
                          Text('0')
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Radio(
                              value: 1,
                              groupValue: _currAnsw,
                              onChanged: _setRadio),
                          Text('1')
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Radio(
                              value: 2,
                              groupValue: _currAnsw,
                              onChanged: _setRadio),
                          Text('2')
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Radio(
                              value: 3,
                              groupValue: _currAnsw,
                              onChanged: _setRadio),
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
                      RaisedButton(
                        onPressed: _questionIndex > 0 ? _previous : null,
                        child: Text('Previous'),
                      ),
                      RaisedButton(
                        onPressed: _currAnsw != -1 ? _next : null,
                        child: Text('Next'),
                      )
                    ],
                  )
                ],
              ),
            )
          : Container(
              margin: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Are you happy with your answers?')
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: _questionIndex > 0 ? _previous : null,
                        child: Text('Go back'),
                      ),
                      RaisedButton(
                        onPressed: _confirm,
                        child: Text('Confirm'),
                      )
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
