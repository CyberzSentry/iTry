import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itry/database/models/pavsat_test.dart';
import 'package:itry/fragments/icon_text_fragment.dart';
import 'package:itry/pages/tests/base_test_page.dart';
import 'dart:math';

import 'package:itry/services/tests/pavsat_test_service.dart';

class PavsatTestPage extends BaseTestPage {
  static final String routeName = '/pavsatTest';
  static final String title = "PAVSAT";

  @override
  _PavsatTestPageState createState() => _PavsatTestPageState();
}

class _PavsatTestPageState
    extends BaseTestState<PavsatTestPage, PavsatTestService, PavsatTest> {
  static const int time = 183;
  static const int changeTime = 2;
  static const int maxAddition = 17;
  final Random random = Random();
  PavsatTestService service = PavsatTestService();

  bool _finished = false;
  bool _started = false;
  int _time = time;
  int _changeTime = changeTime;
  bool _answered = true;
  int _score = 0;
  int _prev = 0;
  int _curr;
  Timer _timer;

  void _start() {
    _curr = random.nextInt(8) + 1;
    setState(() {
      _started = true;
    });
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) => setState(
        () {
          if (_time < 1) {
            _answered = true;
            _finished = true;
            timer.cancel();
          } else {
            _time -= 1;
          }

          if (_changeTime < 1 && _time > 0) {
            _changeTime = changeTime;
            _answered = false;
            _prev = _curr;

            var foundNew = false;
            var tempRand = 0;
            while (!foundNew) {
              if (_prev > maxAddition - 9) {
                tempRand = random.nextInt(maxAddition - _prev) + 1;
              } else {
                tempRand = random.nextInt(9) + 1;
              }
              if (tempRand != _prev) {
                foundNew = true;
              }
            }
            _curr = tempRand;
            print("Curr sum: " + (_curr + _prev).toString());
            print('a');
          } else {
            _changeTime--;
          }
        },
      ),
    );
  }

  void _gridTap(int value) {
    if (_answered == false) {
      if (_curr + _prev == value) {
        _score++;
        print(_curr + _prev);
      }
    }
    _answered = true;
    print(value);
  }

  Widget _testBody() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
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
              Text('$_time'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _started
                  ? Text(
                      '$_curr',
                      style: TextStyle(fontSize: 40),
                    )
                  : MaterialButton(
                      color: Colors.green,
                      onPressed: _start,
                      child: Text('Start'),
                    )
            ],
          ),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            children: List.generate(
              15,
              (index) {
                return Container(
                  margin: EdgeInsets.all(1),
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.grey,
                          blurRadius: 3.0,
                          offset: new Offset(1.0, 1.0))
                    ],
                  ),
                  child: Material(
                    child: InkWell(
                      splashColor: Colors.green[100],
                      onTap: () => _gridTap(index + 3),
                      child: Center(
                        child: Text(
                          (index + 3).toString(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _accept() async {
    var test = PavsatTest();
    test.score = _score;
    test.date = DateTime.now();
    await commitResult(test);
    Navigator.of(context).pop();
  }

  void _retake() {
    setState(() {
      _time = time;
      _changeTime = changeTime;
      _score = 0;
      _prev = 0;
      _answered = true;
      _finished = false;
      _started = false;
    });
  }

  Widget _confirmBody() {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
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
            children: <Widget>[Text('Score:')],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '$_score/$maxScore',
                style: TextStyle(fontSize: 40),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                MaterialButton(
                  color: Colors.green,
                  onPressed: _accept,
                  child: Text('Accept'),
                ),
                MaterialButton(
                  color: Colors.green,
                  onPressed: _retake,
                  child: Text('Retake'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget body() {
    if (_finished == false) {
      return _testBody();
    } else {
      return _confirmBody();
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
            "Paced Auditory Serial Addition Test measures the cognitive function by assessing speed and flexibility of information processing, simultaneously with calculation ability.",
            textAlign: TextAlign.justify),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Text(
            "Single digits will be presented every 3 seconds and your goal is to add each new digit to the one directly prior to it. You are not being asked to give a total sum of numbers, but the sum of the last two numbers you have seen.",
            textAlign: TextAlign.justify),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Text("The interval of the test: once every two weeks.",
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
    return PavsatTestPage.title;
  }

  @override
  String route() {
    return PavsatTestPage.routeName;
  }

  @override
  String title() {
    return PavsatTestPage.title;
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _timer?.cancel();
    super.dispose();
  }
}
