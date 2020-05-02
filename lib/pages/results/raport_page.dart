import 'package:flutter/material.dart';
import 'package:itry/database/models/test_interface.dart';
import 'package:itry/services/test_service_interface.dart';

class ReportPage extends StatefulWidget {
  final TestServiceInterface testService;

  static const String routeName = '/report';
  static const String title = "Report";

  final DateTime dateFrom;
  final DateTime dateTo;
  final String raportName;

  ReportPage(
      {Key key,
      @required this.testService,
      this.dateFrom,
      this.dateTo,
      this.raportName = ''})
      : super(key: key);

  @override
  _ReportPageState createState() => _ReportPageState(dateFrom, dateTo);
}

class _ReportPageState extends State<ReportPage> {
  DateTime _from;
  DateTime _to;

  _ReportPageState(DateTime dateFrom, DateTime dateTo) {
    _from = dateFrom ?? DateTime.now().subtract(Duration(days: 30));
    _to = dateTo ?? DateTime.now();
  }

  Future _selectFromDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _from,
        firstDate: DateTime(2000),
        lastDate: _to);
    if (picked != null) setState(() => _from = picked);
  }

  Future _selectToDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _to,
        firstDate: _from,
        lastDate: DateTime.now());
    if (picked != null) setState(() => _to = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.raportName + ' ' + ReportPage.title),
      ),
      body: FutureBuilder<List<TestInterface>>(
          future: widget.testService.getBetweenDates(_from, _to),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var tiles = <Widget>[];
              snapshot.data.forEach(
                (value) {
                  tiles.add(
                    Dismissible(
                      key: Key(value.id.toString()),
                      child: ListTile(
                        title: Text(value.toString()),
                        subtitle: Text(value.date.toString()),
                      ),
                      onDismissed: (direction) {
                        // widget.testService.delete(value.id);
                        setState(() {
                          widget.testService.delete(value.id);
                        });
                      },
                      confirmDismiss: (direction) {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Delete'),
                                content: Text(
                                    'Are you sure you want to delete this value? You will not be albe to '),
                                actions: <Widget>[
                                  FlatButton(
                                    color: Colors.red,
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: Text('Continue'),
                                  ),
                                  FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: Text('Abort'),
                                  )
                                ],
                              );
                            });
                      },
                      background: Container(
                        color: Colors.red,
                      ),
                    ),
                  );
                },
              );

              double percentageImprovement;
              if (snapshot.data.length != 0) {
                percentageImprovement =
                    snapshot.data.last.compareResults(snapshot.data.first);
              } else {
                percentageImprovement = 0;
              }

              return Column(
                children: <Widget>[
                  Flexible(
                    child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text('Improvement:'),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            percentageImprovement.toStringAsFixed(1) + "%",
                            style: TextStyle(
                              fontSize: 40,
                              color: percentageImprovement >= 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ListTile(
                        title: Text('Date from:'),
                        trailing: Text(_from.toString().substring(0, 10)),
                        onTap: _selectFromDate,
                      ),
                      ListTile(
                        title: Text('Date to:'),
                        trailing: Text(_to.toString().substring(0, 10)),
                        onTap: _selectToDate,
                      ),
                    ],
                  ),
                  Flexible(
                    child: ListView(
                      children: tiles,
                    ),
                  ),
                ],
              );
            } else {
              return Column(
                children: <Widget>[
                  Flexible(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      ListTile(
                        title: Text('Date from:'),
                        trailing: Text(_from.toString().substring(0, 10)),
                        onTap: _selectFromDate,
                      ),
                      ListTile(
                        title: Text('Date to:'),
                        trailing: Text(_to.toString().substring(0, 10)),
                        onTap: _selectToDate,
                      ),
                    ],
                  ),
                  Flexible(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                ],
              );
            }
          }),
    );
  }
}
