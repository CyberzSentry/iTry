
import 'dart:io';

class Ads{
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

// String getInterstitialAdUnitId() {
//   if (Platform.isIOS) {
//     return IOS_AD_UNIT_INTERSTITIAL;
//   } else if (Platform.isAndroid) {
//     return ANDROID_AD_UNIT_INTERSTITIAL;
//   }
//   return null;
// }BannerAd createBannerAd() {
//     return BannerAd(
//       adUnitId: getBannerAdUnitId(),
//       size: AdSize.banner,
//       targetingInfo: targetingInfo,
//       listener: (MobileAdEvent event) {
//         print("BannerAd event $event");
//       },
//     );
//   }InterstitialAd createInterstitialAd() {
//     return InterstitialAd(
//       adUnitId: getInterstitialAdUnitId(),
//       targetingInfo: targetingInfo,
//       listener: (MobileAdEvent event) {
//         print("InterstitialAd event $event");
//       },
//     );
//   }
}