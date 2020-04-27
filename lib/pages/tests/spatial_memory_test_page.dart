import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:itry/fragments/test_description_fragment.dart';
import 'package:itry/services/ads_service.dart';
import 'package:itry/services/settings_service.dart';
import 'package:itry/services/spatial_memory_test_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:itry/database/models/spatial_memory_test.dart';

class SpatialMemoryTestPage extends StatefulWidget {
  static final String routeName = '/spatialMemoryTest';
  static final String title = "Spatial memory test";

  @override
  _SpatialMemoryTestPageState createState() => _SpatialMemoryTestPageState();
}

class _SpatialMemoryTestPageState extends State<SpatialMemoryTestPage> {
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

  Future _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seenSpatialMemoryPage') ?? false);

    if (_seen == false) {
      await prefs.setBool('seenSpatialMemoryPage', true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => SpatialMemoryTestDescriptionPage(),
        ),
      );
    }
  }

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

  void _acceptResult() {
    var test = SpatialMemoryTest();
    var date = DateTime.now();
    test.date = date;
    test.score = calculateScore(_seriesScore);
    SettingsService().getTestTimeBlocking().then((value) {
      if (value) {
        service.insertIfActive(test, date);
      } else {
        service.insert(test);
      }
    });

    Navigator.of(context).pop();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(SpatialMemoryTestPage.title),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 40, 20, 40),
        child: _finished ? _connfirmationColumn() : _testColumn(),
      ),
    );
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
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          SpatialMemoryTestDescriptionPage()),
                ),
              ),
            ),
          ],
        ),
        GridView.count(
          shrinkWrap: true,
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 4,
          // Generate 100 widgets that display their index in the List.
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
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        SpatialMemoryTestDescriptionPage()),
              ),
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
  void initState() {
    AdsService().hideBanner();
    _checkFirstSeen();
    super.initState();
  }

  @override
  void dispose() {
    _displayTimer?.cancel();
    _displayOffsetTimer?.cancel();
    super.dispose();
  }
}

class SpatialMemoryTestDescriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TestDescriptionFragment(
      children: <Widget>[
        Text(
          "Test for spatial visual memory is based on the Corsi Block Test. Its aimed to assess work of the short term memory. ",
          textAlign: TextAlign.justify,
        ),
        Text(
          "Remember the sequence of objects shown in the grid below and repeat the sequence. ",
          textAlign: TextAlign.justify,
        ),
        Text(
          "You can access this info during the test by tapping info icon in the upper left corner. ",
          textAlign: TextAlign.justify,
        ),
      ],
      title: SpatialMemoryTestPage.title,
    );
  }
}
