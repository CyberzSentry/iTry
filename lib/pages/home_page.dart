import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:itry/ads/ads.dart';
import 'package:itry/fragments/drawer_fragment.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  static const String title = "Home";
  static const IconData icon = Icons.home;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  BannerAd _bannerAd;

  @override
  void initState() {
    _bannerAd = Ads.createBannerAd()
      ..load()
      ..show();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HomePage.title),
      ),
      drawer: DrawerFragment(),
      body: Container(
        margin: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'What is iTry?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: const Text(
                    'This application is created for people who aim to improve themselves. It gives you the posibility to check how your new workout routine or different supplements impact your everyday performance.',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'How it works?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: const Text(
                    'Through regular participation in series of questionnaires and cognitive tests you will be able to monitor your results in the fields of cognitive functions such as; visual and hearing abilities, hand coordination, working of short memory, information processing, as well as in the psychological areas of overall well being, creativity and productivity.',
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
