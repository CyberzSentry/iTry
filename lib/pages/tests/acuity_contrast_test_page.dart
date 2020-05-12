import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itry/database/models/acuity_contrast_test.dart';
import 'package:itry/fragments/icon_text_fragment.dart';
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
    'assets/images/acuity_contrast/visual15.png',
    'assets/images/acuity_contrast/visual10.png'
  ];
  static const List<double> _scalesOrder = [
    1,
    1,
    1,
    1,
    1,
    1,
    0.6,
    0.5,
    0.5,
    0.5,
    0.5,
    0.5,
    0.5,
    0.4,
    0.3,
    0.2
  ];
  static const List<int> _imagesOrder = [
    0,
    1,
    2,
    3,
    4,
    5,
    0,
    0,
    1,
    2,
    3,
    4,
    5,
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

  bool _started = false;

  bool _side = false; //false - left, true - right
  int _scoreLeft = 0;

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
          Text(_side ? "Cover left eye" : "Cover right eye", style: TextStyle(fontSize: 20),),
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
                      width: 62.99 * _scalesOrder[_currImage],
                      height: 62.99 * _scalesOrder[_currImage],
                      child: Transform.rotate(
                        angle: _rotations[_rotationsOrder[_currImage]],
                        child: _started
                            ? Image.asset(
                                _images[_imagesOrder[_currImage]],
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
    if(_side){
      var result = AcuityContrastTest();
      result.scoreLeft = _scoreLeft;
      result.scoreRight = _score;
      result.date = DateTime.now();
      await super.commitResult(result);
    }else{
      _scoreLeft = _score;
      _side = true;
      _retake();
    }
    
    // Navigator.of(context).pop();
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
              )
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
    return <Widget>[
      Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Text(
            "Tests for visual acuity and contrast sensitivity are aimed to determine changes in your vision ability. They have no diagnostic values.",
            textAlign: TextAlign.justify),
      ),
      Padding(
        padding: EdgeInsets.only(
          top: 5,
          bottom: 5,
        ),
        child: Text(
            "You have to place yourself about 0,5 meter from the screen. If you have any glasses that you are using everyday, keep them on. When asked, without pressing on the eyelid, cover the left or right eye with your hand. Indicate with the cursor the way that symbols’ open side is facing.",
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
    super.dispose();
  }
}
