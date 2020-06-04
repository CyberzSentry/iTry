import 'package:flutter/material.dart';
import 'package:itry/database/models/experiments/experiment.dart';
import 'package:itry/fragments/drawer_fragment.dart';
import 'package:itry/pages/experiments/add_experiment_page.dart';
import 'package:itry/pages/experiments/experiment_page.dart';
import 'package:itry/pages/results/baseline_results_page.dart';
import 'package:itry/services/ads_service.dart';
import 'package:itry/services/experiments/experiment_service.dart';

class ResultsPage extends StatefulWidget {
  static final String routeName = '/results';
  static const String title = "Results";
  static const IconData icon = Icons.pie_chart;

  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ResultsPage.title),
      ),
      drawer: DrawerFragment(),
      body: FutureBuilder<List<Experiment>>(
          future: ExperimentService().getAll(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var experiments = snapshot.data;
              var output = <Widget>[
                ListTile(
                  title: Text("Baseline results"),
                  onTap: () => Navigator.of(context).pushNamed(
                      BaselineResultsPage.routeName), //add results presentation
                ),
                ListTile(
                  title: Text('New experiment'),
                  trailing: Icon(Icons.add),
                  onTap: () => Navigator.of(context)
                      .pushNamed(AddExperimentPage.routeName)
                      .then((value) => setState(() {})),
                ),
              ];

              for (var exp in experiments) {
                output.add(
                  ListTile(
                    title: Text(exp.name),
                    onTap: () => Navigator.of(context)
                        .push(
                          MaterialPageRoute(
                            builder: (context) => ExperimentPage(exp.id),
                          ),
                        )
                        .then((value) => setState(() {})),
                  ),
                );
              }
              output.add(ListTile());

              return ListView(
                children: output,
              );
            } else {
              return ListView(
                children: <Widget>[
                  ListTile(
                    title: Text("Baseline results"),
                    onTap: () => Navigator.of(context).pushNamed(
                        BaselineResultsPage
                            .routeName), //add results presentation
                  ),
                  ListTile(
                    title: Text('New experiment'),
                    trailing: Icon(Icons.add),
                    onTap: () => Navigator.of(context)
                        .pushNamed(AddExperimentPage.routeName)
                        .then((value) => setState(() {})),
                  ),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              );
            }
          }),
    );
  }

  @override
  void initState() {
    AdsService().showBanner();
    super.initState();
  }
}
