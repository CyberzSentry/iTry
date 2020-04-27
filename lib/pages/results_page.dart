import 'package:flutter/material.dart';
import 'package:itry/fragments/drawer_fragment.dart';
import 'package:itry/pages/results/baseline_results_page.dart';
import 'package:itry/services/ads_service.dart';

class ResultsPage extends StatefulWidget {
  static final String routeName = '/results';
  static const String title = "Results";
  static const IconData icon = Icons.insert_chart;

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

  @override
  void initState() {
    AdsService().showBanner();
    super.initState();
  }
}
