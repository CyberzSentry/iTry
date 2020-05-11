import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdsService {
  AdsService._() {
    FirebaseAdMob.instance.initialize(appId: getAppId());
    _bannerUnitId = getBannerAdUnitId();
    _interstitialUnitId = getInterstitialAdUnitId();
    _awaitingDisplayBanner = false;
    _awaitingDisplayInterstitial = false;
  }

  static final AdsService _instance = AdsService._();

  String _bannerUnitId;

  String _interstitialUnitId;

  BannerAd _banner;

  bool _awaitingDisplayBanner;

  bool _awaitingDisplayInterstitial;

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

  void showBanner() async {
    _awaitingDisplayBanner = true;
    if (_banner == null) {
      _awaitingDisplayBanner = true;
      _banner = BannerAd(
          adUnitId: _bannerUnitId,
          size: AdSize.banner,
          targetingInfo: _targetingInfo,
          listener: (MobileAdEvent event) {
            print("BannerAd $event");
            if (event == MobileAdEvent.loaded ||
                event == MobileAdEvent.opened ||
                event == MobileAdEvent.failedToLoad) {
              this._awaitingDisplayBanner = false;
            }
          });
      await _banner.load();
      await _banner.show();
    }
  }

  void hideBanner() async {
    if (_banner != null) {
      await _banner.dispose();
      _banner = null;
    }
  }

  Future<void> showInterstitial(Function() onComplete) async {
    // if (_interstitialAd == null) {
    _awaitingDisplayInterstitial = true;
    _interstitialAd = InterstitialAd(
        adUnitId: _interstitialUnitId,
        targetingInfo: _targetingInfo,
        listener: (MobileAdEvent event) {
          print("InterstitialAd $event");
          if (event == MobileAdEvent.opened ||
              event == MobileAdEvent.failedToLoad) {
            _awaitingDisplayInterstitial = false;
            onComplete();
          }
        });
    // }
    await _interstitialAd.load();
    await _interstitialAd.show();
  }

  // void hideInterstitial() async {
  //   await _interstitialAd?.dispose();
  //   _banner = null;
  // }

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
