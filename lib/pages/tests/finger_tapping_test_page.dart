import 'package:flutter/material.dart';
import 'dart:async';
import 'package:itry/database/models/finger_tapping_test.dart';
import 'package:itry/services/finger_tapping_test_service.dart';
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
  int _scoreDominant = 0;
  int _scoreNonDominant = 0;
  bool _started = false;
  bool _side; //false-left;true-right;
  bool _timeOut = false;
  bool _activeButtons = false;
  bool _dominant = true;
  FingerTappingTestService service = FingerTappingTestService();

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
    if (_dominant) {
      if (_timeOut != true) {
        if (_started == false) {
          _startTimer();
          _started = true;
          _side = false;
          _scoreDominant++;
        }
        if (_side == true) {
          _side = false;
          _scoreDominant++;
        }
      }
    } else {
      if (_timeOut != true) {
        if (_started == false) {
          _startTimer();
          _started = true;
          _side = false;
          _scoreNonDominant++;
        }
        if (_side == true) {
          _side = false;
          _scoreNonDominant++;
        }
      }
    }
  }

  void _tapRight() {
    if (_dominant) {
      if (_timeOut != true) {
        if (_started == false) {
          _startTimer();
          _started = true;
          _side = true;
          _scoreDominant++;
        }
        if (_side == false) {
          _side = true;
          _scoreDominant++;
        }
      }
    } else {
      if (_timeOut != true) {
        if (_started == false) {
          _startTimer();
          _started = true;
          _side = true;
          _scoreNonDominant++;
        }
        if (_side == false) {
          _side = true;
          _scoreNonDominant++;
        }
      }
    }
  }

  void _acceptResult() {
    if (_dominant) {
      setState(() {
        _dominant = false;
        _started = false;
        _timeOut = false;
        _activeButtons = false;
        _time = _testTime;
      });
    } else {
      print('$_scoreDominant');
      print('$_scoreNonDominant');
      print(DateTime.now().toString());
      var testResult = FingerTappingTest();
      testResult.date = DateTime.now();
      testResult.scoreDominant = _scoreDominant;
      testResult.scoreNonDominant = _scoreNonDominant;
      service.insert(testResult);
      Navigator.of(context).pop();
    }
  }

  void _retakeTest() {
    setState(() {
      if (_dominant) {
        _scoreDominant = 0;
        _started = false;
        _time = _testTime;
        _timeOut = false;
        _activeButtons = false;
      } else {
        _scoreNonDominant = 0;
        _started = false;
        _time = _testTime;
        _timeOut = false;
        _activeButtons = false;
      }
    });
  }

  Future _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seenFingerTappingPage') ?? false);

    if (_seen == false) {
      await prefs.setBool('seenFingerTappingPage', true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => FingerTappingTestDescriptionPage(),
        ),
      );
    }
  }

  List<Widget> _testColumn() {
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
            _dominant ? "Dominant hand" : "Nondominant hand",
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text('Score:')],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            _dominant ? '$_scoreDominant' : '$_scoreNonDominant',
            style: TextStyle(fontSize: 40),
          )
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          MaterialButton(
            color: Colors.green,
            onPressed: _activeButtons ? _acceptResult : null,
            child: Text('Accept'),
          ),
          MaterialButton(
            color: Colors.green,
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
            _dominant ? "Dominant hand" : "Nondominant hand",
            style: TextStyle(fontSize: 20),
          )
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
    _timer?.cancel();
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
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              "Finger tapping performance test is a quantitative assessment tool used to evaluate hand skill and coordination. Hand performance can depend on many variables including our emotional and physical health and any factors that impact our nervous system.",
              textAlign: TextAlign.justify,
            ),
            Text(
              "In this test you are asked to determine your dominant hand and use your index and middle finger to tap alternately two buttons in the period of 15 seconds. For both hands you will receive results in average intertap - interval, tapping speed and overall number of taps.",
              textAlign: TextAlign.justify,
            ),
            Text(
              "By completing this test regularly you can measure and evaluate changes in your motor system. ",
              textAlign: TextAlign.justify,
            ),
            MaterialButton(
              color: Colors.green,
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Continue'),
            )
          ],
        ),
      ),
    );
  }
}
