import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class Ads {
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

  static BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: Ads.getBannerAdUnitId(),
        size: AdSize.banner,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }
}
