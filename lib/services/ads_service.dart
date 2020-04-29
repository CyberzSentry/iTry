import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdsService {
  AdsService._() {
    FirebaseAdMob.instance.initialize(appId: getAppId());
    _bannerUnitId = getBannerAdUnitId();
    _interstitialUnitId = getInterstitialAdUnitId();
  }

  static final AdsService _instance = AdsService._();

  String _bannerUnitId;
  String _interstitialUnitId;

  BannerAd _banner;

  InterstitialAd _interstitialAd;

  static const MobileAdTargetingInfo _targetingInfo = MobileAdTargetingInfo(
      keywords: <String>[
        'self improvement',
        'improvement',
        'gym',
        'suplements'
      ]);

  factory AdsService() {
    return _instance;
  }

  void showBanner() {
    if (_banner == null) {
      _banner = BannerAd(
          adUnitId: _bannerUnitId,
          size: AdSize.banner,
          targetingInfo: _targetingInfo,
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

  void showInterstitial() {
    if (_interstitialAd == null) {
      _interstitialAd = InterstitialAd(
          adUnitId: _interstitialUnitId,
          targetingInfo: _targetingInfo,
          listener: (MobileAdEvent event) {
            print("BannerAd $event");
          });
      _banner
        ..load()
        ..show();
    }
  }

  void hideInterstitial() async {
    await _interstitialAd?.dispose();
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

  static String getInterstitialAdUnitId() {
    if (Platform.isIOS) {
      return "ca-app-pub-2917376840034915/5945051233";
    } else if (Platform.isAndroid) {
      return "ca-app-pub-2917376840034915/9939657632";
    }
    return null;
  }
}
