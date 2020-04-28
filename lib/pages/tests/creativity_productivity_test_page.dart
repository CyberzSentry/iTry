import 'dart:async';
import 'package:flutter/material.dart';
import 'package:itry/database/models/creativity_productivity_test.dart';
import 'package:itry/fragments/test_description_fragment.dart';
import 'package:itry/pages/tests/base_test_page.dart';
import 'package:itry/services/ads_service.dart';
import 'package:itry/services/creativity_productivity_test_service.dart';
import 'package:random_words/random_words.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreativityProductivityTestPage extends StatefulWidget {
  static final String routeName = '/creativityProductivityTest';
  static final String title = "Creativity and productivity test";

  @override
  _CreativityProductivityTestPageState createState() =>
      _CreativityProductivityTestPageState();
}

class _CreativityProductivityTestPageState
    extends State<CreativityProductivityTestPage> {
  static final int _testTime = 60;
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = new TextEditingController();
  CreativityProductivityTestService service =
      CreativityProductivityTestService();

  int _time = _testTime;
  bool _timeOut = false;
  Timer _timer;
  bool _started = false;
  String _randomWord = "The word will appear here.";
  int _score = 0;

  BaseTestPage<CreativityProductivityTestService, CreativityProductivityTest> _testBase;

  _CreativityProductivityTestPageState(){
    _testBase = BaseTestPage<CreativityProductivityTestService, CreativityProductivityTest>(service);
  }

  void _start() {
    if (_started == false) {
      setState(() {
        _started = true;
        _randomWord = generateNoun(top: 1000).take(1).toList().first.toString();
      });
      _startTimer();
    }
  }

  void _next(String value) {
    _focusNode.requestFocus();
    _controller.clear();
    _score += 1;
  }

  void _startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (Timer timer) {
      setState(() {
        _time -= 1;
      });
      if (_time <= 0) {
        _timeOut = true;
        timer.cancel();
      }
    });
  }

  void _acceptResult() async{
    print('$_score');
    var result = CreativityProductivityTest();
    var date = DateTime.now();
    result.score = _score;
    result.date = date;
    await _testBase.commitResult(result);
    Navigator.of(context).pop();
  }

  void _retakeTest() {
    setState(() {
      _randomWord = "The word will appear here.";
      _time = _testTime;
      _started = false;
      _timeOut = false;
      _score = 0;
    });
  }

  Future _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seenCreativityProductivityTestPage') ?? false);

    if (_seen == false) {
      await prefs.setBool('seenCreativityProductivityTestPage', true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) =>
              CreativityProductivityTestDescriptionPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(CreativityProductivityTestPage.title),
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 40, 20, 40),
        child: _timeOut ? _confirmationColumn() : _testColumn(),
      ),
    );
  }

  Widget _testColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              child: Icon(
                Icons.info_outline,
                color: Colors.grey,
              ),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        CreativityProductivityTestDescriptionPage()),
              ),
            ),
            Text('$_time')
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "$_randomWord",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
                child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: _started ? '' : 'Tap here to start'),
              onTap: _start,
              onChanged: (text) {
                print("First text field: $text");
              },
              onSubmitted: _next,
            ))
          ],
        ),
      ],
    );
  }

  Widget _confirmationColumn() {
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
                        CreativityProductivityTestDescriptionPage()),
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
              '$_score',
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
    _timer?.cancel();
    super.dispose();
  }
}

class CreativityProductivityTestDescriptionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TestDescriptionFragment(
      children: <Widget>[Text("This is the test for ability to produce new ideas. During the test you will see a random word, a noun, and your task is to look for words that you associate with the given one. After every word, confirm the answer, and start writing the next one.")],
      title: CreativityProductivityTestPage.title,
    );
  }
}
