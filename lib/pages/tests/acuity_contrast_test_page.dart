import 'package:flutter/material.dart';
import 'package:itry/database/models/acuity_contrast_test.dart';
import 'package:itry/pages/tests/base_test_page.dart';
import 'package:itry/services/acuity_contrast_test_service.dart';
import 'dart:math' as math;

class AcuityContrastTestPage extends BaseTestPage {
  static final String routeName = '/acuityContrastTest';
  static final String title = "Visual acuity and contrast test";

  @override
  _AcuityContrastTestPageState createState() => _AcuityContrastTestPageState();
}

class _AcuityContrastTestPageState extends BaseTestState<AcuityContrastTestPage,
    AcuityContrastTestService, AcuityContrastTest> {
  AcuityContrastTestService service = AcuityContrastTestService();

  static const double _arrowSize = 60;
  static const List<String> _images = [
    'assets/images/acuity_contrast/visual100.png',
    'assets/images/acuity_contrast/visual75.png',
    'assets/images/acuity_contrast/visual50.png',
    'assets/images/acuity_contrast/visual25.png',
    'assets/images/acuity_contrast/visual10.png'
  ];
  static const List<double> _scalesOrder = [
    1,
    1,
    1,
    1,
    1,
    0.75,
    0.5,
    0.5,
    0.5,
    0.5,
    0.5,
    0.25,
    0.15,
    0.10
  ];
  static const List<int> _imagesOrder = [
    0,
    1,
    2,
    3,
    4,
    0,
    0,
    1,
    2,
    3,
    4,
    0,
    0,
    0
  ];

  static List<int> _generateRotations() {
    var result = <int>[];
    var rand = math.Random();
    for (int i = 0; i < _scalesOrder.length; i++) {
      result.add(rand.nextInt(4));
    }
    return result;
  }

  List<int> _rotationsOrder = _generateRotations();

  static const List<double> _rotations = [
    0,
    math.pi / 2,
    math.pi,
    math.pi * 1.5
  ];

  int _currImage = 0;
  int _score = 0;

  bool _finished = false;
  bool _started = false;

  void _up() {
    if (_rotationsOrder[_currImage] == 2) {
      _score++;
    }
    setState(() {
      _currImage++;
    });
  }

  void _down() {
    if (_rotationsOrder[_currImage] == 0) {
      _score++;
    }
    setState(() {
      _currImage++;
    });
  }

  void _left() {
    if (_rotationsOrder[_currImage] == 1) {
      _score++;
    }
    setState(() {
      _currImage++;
    });
  }

  void _right() {
    if (_rotationsOrder[_currImage] == 3) {
      _score++;
    }
    setState(() {
      _currImage++;
    });
  }

  Widget _testBody() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 40),
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
              )
            ],
          ),
          Flexible(
            // widthFactor: 1,
            // heightFactor: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.keyboard_arrow_up),
                        onPressed: _up,
                        iconSize: _arrowSize)
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                        icon: Icon(Icons.keyboard_arrow_left),
                        onPressed: _left,
                        iconSize: _arrowSize),
                    SizedBox(
                      width: 53,
                      height: 53,
                      child: Transform.rotate(
                        angle: _rotations[_rotationsOrder[_currImage]],
                        child: _started
                            ? Image.asset(
                                _images[_imagesOrder[_currImage]],
                                scale: 1 / _scalesOrder[_currImage],
                              )
                            : null,
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.keyboard_arrow_right),
                        onPressed: _right,
                        iconSize: _arrowSize)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_down),
                      onPressed: _down,
                      iconSize: _arrowSize,
                    )
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                color: Colors.green,
                onPressed: !_started
                    ? () {
                        setState(() {
                          _started = true;
                        });
                      }
                    : null,
                child: Text('Start'),
              )
            ],
          )
        ],
      ),
    );
  }

  void _retake() {
    _score = 0;
    setState(() {
      _started = false;
      _currImage = 0;
      _rotationsOrder = _generateRotations();
    });
  }

  void _confirm() async {
    var result = AcuityContrastTest();
    result.score = _score;
    result.date = DateTime.now();
    await super.commitResult(result);
    Navigator.of(context).pop();
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
                "$_score/$maxScore",
                style: TextStyle(fontSize: 40),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                color: Colors.green,
                onPressed: _confirm,
                child: Text('Accept'),
              ),
              MaterialButton(
                color: Colors.green,
                onPressed: _retake,
                child: Text('Retake'),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget body() {
    if (_currImage < _imagesOrder.length) {
      return _testBody();
    } else {
      return _confirmScreen();
    }
  }

  @override
  List<Widget> descriptionBody() {
    return <Widget>[Text('description')];
  }

  @override
  String descriptionTitle() {
    return AcuityContrastTestPage.title;
  }

  @override
  String route() {
    return AcuityContrastTestPage.routeName;
  }

  @override
  String title() {
    return AcuityContrastTestPage.title;
  }
}
