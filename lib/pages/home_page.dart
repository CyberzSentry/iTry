import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:itry/fragments/drawer_fragment.dart';
import 'package:itry/services/ads_service.dart';
import 'package:itry/services/update_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  static const String title = "Home";
  static const IconData icon = Icons.home;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    AdsService().showBanner();
    UpdateService().versionCheck(context);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HomePage.title),
      ),
      drawer: DrawerFragment(),
      body: Padding(
        padding: EdgeInsets.only(bottom: 51),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 100),
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
                Padding(
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
                Padding(
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
                Padding(
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
                Padding(
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
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: const Text(
                          'To see the descriptions click on each test and begin whenever you will be ready. For the surveys you can correct the answers by going to previous questions or retake the tests after finishing if something interrupted you. The tests needed to be repeated in intervals, but don’t worry! You will get a notification every time the test will be ready to do again. You can also do the tests more often and add scores to your result table by switching off the option “Apply test intervals” in the “Settings” tab.',
                          textAlign: TextAlign.justify,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Row(
                    children: <Widget>[
                      Flexible(
                        child: const Text(
                          'Once you accomplish the first tests you can go to the “Results” tab. In there you can change the date range, you are interested to evaluate, as well as mark tests from which you want to see the results. All the data is stored only on your device.',
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
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                                style: Theme.of(context).textTheme.bodyText1,
                                text:
                                    "\nAny thoughts or questions? \n\nDo not hesitate to contact us via:\n"),
                            TextSpan(
                              text: "connectitry@gmail.com",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => launch(
                                    'mailto:connectitry@gmail.com?subject=iTry+app+feedback'),
                            ),
                            TextSpan(
                                style: Theme.of(context).textTheme.bodyText1,
                                text: "\nor\n"),
                            TextSpan(
                              text: "facebook",
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => launch(
                                    'https://www.facebook.com/itry.app.test.and.track.your.improvement'),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
