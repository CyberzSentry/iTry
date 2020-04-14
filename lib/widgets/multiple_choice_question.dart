import 'package:flutter/material.dart';

class MultipleChoiceQuestion extends StatefulWidget {
  String question;
  List<String> possibleAnswers;
  int selected;
  Function(int selected) onNext;
  Function(int selected) onPrev;

  MultipleChoiceQuestion(this.question, this.possibleAnswers,
      {this.onNext = null, this.onPrev = null, this.selected = -1});

  @override
  _MultipleChoiceQuestionState createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  List<Widget> _buildRadios() {
    var radios = <Widget>[];

    var i = 0;
    for (var ans in widget.possibleAnswers) {
      radios.add(Column(
        children: <Widget>[
          Radio(value: i, groupValue: widget.selected, onChanged: _setRadio),
          Text(i.toString())
        ],
      ));
      i++;
    }
    return radios;
  }

  void _setRadio(int index) {
    setState(() {
      widget.selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(
              child: Text(
                widget.question,
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildRadios()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.selected != -1
                ? Text(widget.possibleAnswers[widget.selected].toString())
                : Text('')
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: () => widget.onPrev(widget.selected),
              child: Text('Previous'),
            ),
            RaisedButton(
              onPressed: widget.selected != -1
                  ? () => widget.onNext(widget.selected)
                  : null,
              child: Text('Next'),
            )
          ],
        )
      ],
    );
  }
}
