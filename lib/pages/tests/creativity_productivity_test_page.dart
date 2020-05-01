import 'dart:async';
import 'package:flutter/material.dart';
import 'package:itry/database/models/creativity_productivity_test.dart';
import 'package:itry/fragments/icon_text_fragment.dart';
import 'package:itry/pages/tests/base_test_page.dart';
import 'package:itry/services/creativity_productivity_test_service.dart';
import 'package:random_words/random_words.dart';

class CreativityProductivityTestPage extends BaseTestPage {
  static final String routeName = '/creativityProductivityTest';
  static final String title = "Creativity test";

  @override
  _CreativityProductivityTestPageState createState() =>
      _CreativityProductivityTestPageState();
}

class _CreativityProductivityTestPageState
    extends BaseTestState<CreativityProductivityTestPage, CreativityProductivityTestService, CreativityProductivityTest> {
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

  List<String> _answers = <String>[];

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
    if (value.length > 0) {
      setState(() {
        _answers.insert(0, value);
      });
      _controller.clear();
      _score += 1;
    }
    _focusNode.requestFocus();
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

  void _acceptResult() async {
    print('$_score');
    var result = CreativityProductivityTest();
    var date = DateTime.now();
    result.score = _score;
    result.date = date;
    await commitResult(result);
    Navigator.of(context).pop();
  }

  void _retakeTest() {
    setState(() {
      _randomWord = "The word will appear here.";
      _controller.clear();
      _time = _testTime;
      _started = false;
      _timeOut = false;
      _answers = <String>[];
      _score = 0;
    });
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
              onTap: () => showDescription(),
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
              ),
              onTap: _start,
              onChanged: (text) {
                print("First text field: $text");
              },
              onSubmitted: _next,
            ))
          ],
        ),
        _started
            ? Expanded(
                child: ListView.builder(
                  itemCount: _answers.length,
                  itemBuilder: (ctxt, index) {
                    return ListTile(
                      title: Text(
                        _answers[index],
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    onPressed: () {
                      _start();
                      _focusNode.requestFocus();
                    },
                    child: Text('Start'),
                    color: Colors.green,
                  )
                ],
              )
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
              '$_score',
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
                onPressed: _acceptResult,
                child: Text('Accept'),
              ),
              MaterialButton(
                color: Colors.green,
                onPressed: _retakeTest,
                child: Text('Retake'),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget body() {
    return Container(
        margin: EdgeInsets.fromLTRB(20, 40, 20, 0),
        child: _timeOut ? _confirmationColumn() : _testColumn(),
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
            "This is the test for ability to produce new ideas. During the test you will see a random word, a noun, and your task is to look for words that you associate with the given one. After every word, confirm the answer, and start writing the next one.",
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
    return CreativityProductivityTestPage.title;
  }

  @override
  String route() {
    return CreativityProductivityTestPage.routeName;
  }

  @override
  String title() {
    return CreativityProductivityTestPage.title;
  }
}