import 'package:flutter/material.dart';
import 'dart:async';

import 'package:itry/database/accessors/finger_tapping_test_accesor.dart';
import 'package:itry/database/models/finger_tapping_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          if (_time < 0) {
            _activeButtons = true;
            timer.cancel();
          } else {
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

  Future _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seenFingerTappingPage') ?? false);

    if (_seen == false) {
      await prefs.setBool('seenFingerTappingPage', true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              FingerTappingTestDescriptionPage(),
        ),
      );
    }
  }

  List<Widget> _testColumn() {
    return <Widget>[
      Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.info_outline,
                color: Colors.grey,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        FingerTappingTestDescriptionPage()),
              ),
            ),
          ],
        ),
      ),
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
          MaterialButton(
            onPressed: _activeButtons ? _acceptResult : null,
            child: Text('Accept'),
          ),
          MaterialButton(
            onPressed: _activeButtons ? _retakeTest : null,
            child: Text('Retake'),
          ),
        ],
      )
    ];
  }

  List<Widget> _confirmColumn() {
    return <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            child: Icon(
              Icons.info_outline,
              color: Colors.grey,
            ),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      FingerTappingTestDescriptionPage()),
            ),
          ),
        ],
      ),
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FingerTappingTestPage.title),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _timeOut ? _testColumn() : _confirmColumn(),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 200), () {
        _checkFirstSeen();
        });
  }

  @override
  void dispose() {
    _timer?.cancel() ;
    super.dispose();
  }
}

class FingerTappingTestDescriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FingerTappingTestPage.title),
      ),
      body: Center(
        child: Text('description'),
      ),
    );
  }
}
