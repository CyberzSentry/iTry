import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itry/database/models/tests/spatial_memory_test.dart';
import 'package:itry/fragments/icon_text_fragment.dart';
import 'package:itry/pages/tests/base_test_page.dart';
import 'package:itry/services/tests/spatial_memory_test_service.dart';

class SpatialMemoryTestPage extends BaseTestPage {
  static final String routeName = '/spatialMemoryTest';
  static final String title = "Spatial memory test";

  @override
  _SpatialMemoryTestPageState createState() => _SpatialMemoryTestPageState();
}

class _SpatialMemoryTestPageState extends BaseTestState<SpatialMemoryTestPage,
    SpatialMemoryTestService, SpatialMemoryTest> {
  static final List<int> _series = series;
  final int _lightedOnTapMs = 750;
  int _lighted = -1;
  bool _started = false;
  int _currSeries = 0;
  int _currSeriesMember = 0;
  bool _repeating = false;
  bool _finished = false;
  List<int> _currSeriesAns;
  List<int> _seriesScore = List<int>.filled(_series.length, 0);
  SpatialMemoryTestService service = SpatialMemoryTestService();
  Timer _displayTimer;
  Timer _displayOffsetTimer;

  void _buttonPressed(int count) {
    if (_repeating == true) {
      setState(() {
        _lighted = count;
      });
      Timer(Duration(milliseconds: _lightedOnTapMs), () {
        setState(() {
          if (_lighted == count) {
            _lighted = -1;
          }
        });
      });
      if (_currSeriesMember < _series[_currSeries]) {
        if (_currSeriesAns[_currSeriesMember] == count) {
          _seriesScore[_currSeries]++;
        }
        _currSeriesMember++;
      }
      if (_currSeriesMember == _series[_currSeries]) {
        _currSeries++;
        _currSeriesMember = 0;
        if (_currSeries < _series.length) {
          _start();
        } else {
          print(_seriesScore.toString());
          setState(() {
            _finished = true;
          });
        }
      }
    }
  }

  void _start() async {
    setState(() {
      _started = true;
    });
    var rand = Random();
    var series = <int>[];
    for (int i = 0; i < _series[_currSeries]; i++) {
      series.add(rand.nextInt(16));
    }
    _currSeriesAns = series;
    _display();
  }

  void _display() async {
    _repeating = false;
    _displayTimer =
        Timer.periodic(Duration(milliseconds: disabledMs + enabledMs), (timer) {
      if (_currSeriesMember < _currSeriesAns.length) {
        setState(() {
          _lighted = _currSeriesAns[_currSeriesMember];
          _currSeriesMember++;
        });
      } else {
        timer.cancel();
        setState(() {
          _repeating = true;
          _currSeriesMember = 0;
        });
      }
    });
    Future.delayed(Duration(milliseconds: enabledMs)).whenComplete(() {
      _displayOffsetTimer = Timer.periodic(
          Duration(milliseconds: disabledMs + enabledMs), (timer) {
        if (_currSeriesMember < _currSeriesAns.length) {
          setState(() {
            _lighted = -1;
          });
        } else {
          timer.cancel();
          setState(() {
            _lighted = -1;
          });
        }
      });
    });
  }

  void _acceptResult() async {
    var test = SpatialMemoryTest();
    var date = DateTime.now();
    test.date = date;
    test.score = calculateScore(_seriesScore);
    await commitResult(test);

    // Navigator.of(context).pop();
  }

  void _retakeTest() {
    setState(() {
      _lighted = -1;
      _started = false;
      _currSeries = 0;
      _currSeriesMember = 0;
      _repeating = false;
      _finished = false;
      _seriesScore = List<int>.filled(_series.length, 0);
    });
  }

  Widget _testColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: GestureDetector(
                child: Icon(
                  Icons.info_outline,
                  color: Colors.grey,
                ),
                onTap: () => showDescription(),
              ),
            ),
          ],
        ),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 4,
          children: List.generate(
            16,
            (index) {
              return Container(
                margin: EdgeInsets.all(5),
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.circular(10.0),
                  color: index == _lighted ? Colors.green : Colors.white,
                  boxShadow: [
                    new BoxShadow(
                        color: Colors.grey,
                        blurRadius: 3.0,
                        offset: new Offset(1.0, 1.0))
                  ],
                ),
                child: GestureDetector(
                  onTap: () => _buttonPressed(index),
                ),
              );
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _started
                ? Text(_repeating ? "Repeat" : "Remember")
                : MaterialButton(
                    color: Colors.green,
                    onPressed: _start,
                    child: Text('Start'),
                  ),
          ],
        )
      ],
    );
  }

  Widget _connfirmationColumn() {
    return Column(
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
              calculateScore(_seriesScore).toString() + "/$maxScore",
              style: TextStyle(fontSize: 40),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MaterialButton(
              color: Colors.green,
              onPressed: _acceptResult,
              child: Text('Accept'),
            ),
            MaterialButton(
              color: Colors.green,
              onPressed: _retakeTest,
              child: Text('Retake'),
            ),
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    _displayTimer?.cancel();
    _displayOffsetTimer?.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget body() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
      child: _finished ? _connfirmationColumn() : _testColumn(),
    );
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
            "Test for spatial visual memory is based on the Corsi Block Test. Its aimed to assess work of the short term memory.",
            textAlign: TextAlign.justify),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Text(
            "Remember the sequence of objects shown in the grid below and repeat the sequence.",
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
    return SpatialMemoryTestPage.title;
  }

  @override
  String route() {
    return SpatialMemoryTestPage.routeName;
  }

  @override
  String title() {
    return SpatialMemoryTestPage.title;
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.initState();
  }
}
