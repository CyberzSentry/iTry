import 'package:flutter/material.dart';
import 'dart:async';

import 'package:itry/database/accessors/finger_tapping_test_accesor.dart';
import 'package:itry/database/models/finger_tapping_test.dart';

class FingerTappingTestPage extends StatefulWidget {
  static final String routeName = '/fingerTappingTest';
  static final String title = "Finger tapping test";

  @override
  _FingerTappingTestPageState createState() => _FingerTappingTestPageState();
}

class _FingerTappingTestPageState extends State<FingerTappingTestPage> {
  static final double _buttonRadius = 30;
  static final int _testTime = 15;

  Timer _timer;
  int _time = _testTime;
  int _score = 0;
  bool _started = false;
  bool _side; //false-left;true-right;
  bool _timeOut = false;
  bool _activeButtons = false;
  FingerTappingTestAccessor accessor = FingerTappingTestAccessor();

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_time < 1) {
            _timeOut = true;
          }
          if( _time < 0){
            _activeButtons = true;
            timer.cancel();
          } 
          else {
            _time = _time - 1;
          }
        },
      ),
    );
  }

  void _tapLeft() {
    if (_timeOut != true) {
      if (_started == false) {
        _startTimer();
        _started = true;
        _side = false;
        _score++;
      }
      if (_side == true) {
        _side = false;
        _score++;
      }
    }
  }

  void _tapRight() {
    if (_timeOut != true) {
      if (_started == false) {
        _startTimer();
        _started = true;
        _side = true;
        _score++;
      }
      if (_side == false) {
        _side = true;
        _score++;
      }
    }
  }

  void _acceptResult() {
    print('$_score');
    print(DateTime.now().toString());
    var testResult = FingerTappingTest();
    testResult.date = DateTime.now();
    testResult.score = _score;
    accessor.insert(testResult);
    Navigator.of(context).pop();
  }

  void _retakeTest() {
    setState(() {
      _score = 0;
      _started = false;
      _time = _testTime;
      _timeOut = false;
      _activeButtons = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FingerTappingTestPage.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _timeOut
              ? <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Text('Score:')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '$_score',
                        style: TextStyle(fontSize: 40),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: _activeButtons ? _acceptResult : null,
                        child: Text('Accept'),
                      ),
                      RaisedButton(
                        onPressed: _activeButtons ? _retakeTest : null,
                        child: Text('Retake'),
                      ),
                    ],
                  )
                ]
              : <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        _time.toString(),
                        style: TextStyle(fontSize: 40),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[Text('Tap to start the test.')],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: _tapLeft,
                        child: Text('left'),
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(_buttonRadius),
                      ),
                      RaisedButton(
                        onPressed: _tapRight,
                        child: Text('right'),
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(_buttonRadius),
                      ),
                    ],
                  ),
                ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
