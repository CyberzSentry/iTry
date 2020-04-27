import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdsService {
  AdsService._() {
    FirebaseAdMob.instance.initialize(appId: getAppId());
    _bannerUnitId = getBannerAdUnitId();
    
  }

  static final AdsService _instance = AdsService._();

  String _bannerUnitId;

  BannerAd _banner;

  factory AdsService() {
    return _instance;
  }

  void showBanner() {
    if(_banner == null){
      _banner = BannerAd(
          adUnitId: _bannerUnitId,
          size: AdSize.banner,
          listener: (MobileAdEvent event) {
            print("BannerAd $event");
          });
      _banner
        ..load()
        ..show();
    }
  }

  void hideBanner() async {
    await _banner?.dispose();
    _banner = null;
  }

  static String getAppId() {
    if (Platform.isIOS) {
      return "ca-app-pub-2917376840034915~5362920708";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-2917376840034915~7011044292";
    }
    return null;
  }

  static String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return "ca-app-pub-2917376840034915/2454574389";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-2917376840034915/7944852012";
    }
    return null;
  }
}
