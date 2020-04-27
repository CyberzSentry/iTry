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
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 20, 20, 60),
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
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: const Text(
                        'This application is created for people who aim to improve themselves. It gives you the posibility to check how your new workout routine or different supplements impact your everyday performance.',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
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
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: const Text(
                        'Through regular participation in the series of questionnaires and cognitive tests you will be able to monitor your results in the field of cognitive functions, as well as in the psychological area.',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: const Text(
                        'If you are ready to begin your journey through development go to the tab “Tests”. There you can find different challenges aimed to assess your visual and hearing abilities, hand coordination, working of short memory, information processing, overall well being, creativity and productivity. To ensure the trustworthy results, complete the tests providing honest answers in compliance with your best beliefs.',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: const Text(
                        'To see the descriptions click on each test and begin whenever you will be ready. For the surveys you can correct the answers by going to previous questions or retaking the test after finishing. The tests needed to be repeated as shown below, but don’t worry! You will get a notification every time the test will be ready to do again. ',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: const Text(
                        'Frequency of the tests:\n\nFinger tapping performance test - once every two weeks,\nSpatial memory span test - once every two weeks,\nCreativity and productivity survey - once a week,\nCreativity test - once a week,\nDepression, anxiety and stress survey - once a week.',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 8, bottom: 8),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: const Text(
                        'Once you accomplish the first tests you can go to the “Results” tab. In there you can change the date range, you are interested to evaluate, as well as mark tests from which you want to see the results. All the data is stored only on your device. \n\nAny thoughts or questions? \n\nDo not hesitate to contact us via:\nconnectitry@gmail.com',
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
