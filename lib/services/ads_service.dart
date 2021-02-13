import 'dart:async';
import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class AdsService {
  AdsService._() {
    FirebaseAdMob.instance.initialize(appId: getAppId());
    _bannerUnitId = getBannerAdUnitId();
    _interstitialUnitId = getInterstitialAdUnitId();
    configCheck();
  }

  static final AdsService _instance = AdsService._();

  String _bannerUnitId;

  String _interstitialUnitId;

  BannerAd _banner;

  bool _bannerHidden;

  Future<void> _loadingBanner;

  InterstitialAd _interstitialAd;

  bool _showBannerConfig = true;

  bool _showInterstitialConfig = false;

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
    if (_showBannerConfig) {
      if (_banner != null) {
        return;
      }
      var completer = new Completer<void>();
      _loadingBanner = completer.future;
      _bannerHidden = false;
      _banner = BannerAd(
          adUnitId: _bannerUnitId,
          size: AdSize.banner,
          targetingInfo: _targetingInfo,
          listener: (MobileAdEvent event) {
            print("BannerAd $event");
            if (event == MobileAdEvent.loaded ||
                event == MobileAdEvent.failedToLoad) {
              completer.complete();
              if (_bannerHidden) {
                // hideBanner();
              }
            }
          });
      _banner
        ..load().then((loaded) {
          if (loaded) {
            _banner..show();
          }
        });
    }
  }

  void hideBanner() async {
    _bannerHidden = true;
    if (_loadingBanner != null) {
      await _loadingBanner;
    }
    // Future.delayed(const Duration(milliseconds: 500), () {
    _banner?.dispose();
    _banner = null;
    // });
  }

  Future<void> showInterstitial(Function() onComplete) async {
    if (_showInterstitialConfig) {
      _interstitialAd = InterstitialAd(
          adUnitId: _interstitialUnitId,
          targetingInfo: _targetingInfo,
          listener: (MobileAdEvent event) {
            print("InterstitialAd $event");
            if (event == MobileAdEvent.opened ||
                event == MobileAdEvent.failedToLoad) {
              onComplete();
            }
          });
      await _interstitialAd.load();
      await _interstitialAd.show();
    }else{
      onComplete();
    }
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

  configCheck() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    try {
      // Using default duration to force fetching from remote server.
      await remoteConfig.fetch(expiration: const Duration(seconds: 0));
      await remoteConfig.activateFetched();
      _showBannerConfig = remoteConfig.getBool('ad_show_baner');
      _showInterstitialConfig =
          remoteConfig.getBool('ad_show_interstitial');

      print("Show Banner Config: $_showBannerConfig");
      print("Show Interstitial Config: $_showInterstitialConfig");
    } on FetchThrottledException catch (exception) {
      // Fetch throttled.
      print(exception);
    } catch (exception) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }
}
