import 'package:flutter/material.dart';
import 'package:itry/database/models/test_interface.dart';
import 'package:itry/fragments/test_description_fragment.dart';
import 'package:itry/services/ads_service.dart';
import 'package:itry/services/notifications_service.dart';
import 'package:itry/services/settings_service.dart';
import 'package:itry/services/test_service_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class BaseTestPage extends StatefulWidget {
  BaseTestPage({Key key}) : super(key: key);
}

abstract class BaseTestState<
    Page extends BaseTestPage,
    TestService extends TestServiceInterface,
    Test extends TestInterface> extends State<Page> {
  @required
  TestService service;

  bool _saving = false;

  Future<void> commitResult(Test result) async {
    setState(() {
      _saving = true;
    });
    await AdsService().showInterstitial(() => Navigator.of(context).pop());
    if (await SettingsService().getTestTimeBlocking()) {
      if (await service.isActive(result.date)) {
        await service.insert(result);
        NotificationsService()
            .scheduleTestNotification(result.getTestInterval());
      }
    } else {
      await service.insert(result);
    }
  }

  void showDescription() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => TestDescriptionFragment(
          title: descriptionTitle(),
          children: descriptionBody(),
        ),
      ),
    );
  }

  Future _checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool(route()) ?? false);

    if (_seen == false) {
      await prefs.setBool(route(), true);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) => TestDescriptionFragment(
            title: descriptionTitle(),
            children: descriptionBody(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title()),
        ),
        body: Container(
          child: _saving
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : body(),
        ));
  }

  @override
  void initState() {
    AdsService().hideBanner();
    _checkFirstSeen();
    super.initState();
  }

  @override
  void dispose() {
    AdsService().showBanner();
    super.dispose();
  }

  String title();
  String route();
  Widget body();
  String descriptionTitle();
  List<Widget> descriptionBody();
}
