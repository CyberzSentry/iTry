import 'package:flutter/material.dart';
import 'package:itry/database/accessors/first_test_accessor.dart';
import 'package:itry/database/models/first_test.dart';
import 'package:itry/fragments/drawer_fragment.dart';
import 'package:itry/pages/results/baseline_results_page.dart';

class ResultsPage extends StatefulWidget {
  static final String routeName = '/results';
  static const String title = "Results";
  static const IconData icon = Icons.insert_chart;

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  FirstTestAccessor fta = FirstTestAccessor();

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(ResultsPage.title),
  //     ),
  //     drawer: DrawerFragment(),
  //     body: FutureBuilder<List<FirstTest>>(
  //       future: fta.getAll(),
  //       builder:
  //         (BuildContext context, AsyncSnapshot<List<FirstTest>> snapshot) {
  //         if (snapshot.hasData) {
  //           return ListView.builder(
  //             physics: BouncingScrollPhysics(),
  //             itemCount: snapshot.data.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               FirstTest item = snapshot.data[index];
  //               return Dismissible(
  //                 key: UniqueKey(),
  //                 background: Container(color: Colors.red),
  //                 onDismissed: (direction) {
  //                   fta.delete(item.id);
  //                 },
  //                 child: ListTile(
  //                   title: Text(item.score.toString()),
  //                   subtitle: Text(item.date.toString()),
  //                   leading: CircleAvatar(child: Text(item.id.toString())),
  //                 ),
  //               );
  //             },
  //           );
  //         } else {
  //           return Center(child: CircularProgressIndicator());
  //         }
  //       },
  //     ),
  //   );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ResultsPage.title),
      ),
      drawer: DrawerFragment(),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text("Baseline results"),
            onTap: () => Navigator.of(context).pushNamed(BaselineResultsPage.routeName), //add results presentation
          )
        ],
      ),
    );
  }
}
