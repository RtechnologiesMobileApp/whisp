import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:get/get.dart';

class AdService extends GetxService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  /// Production Ad Unit IDs
  static const String interstitialAdUnitId = 'ca-app-pub-9148185035281718/4854906272';
  static const String bannerAdUnitId = 'ca-app-pub-9148185035281718/8459109362';
  static const String rewardedAdUnitId = 'ca-app-pub-9148185035281718/2851559464';

  /// Initialize the Mobile Ads SDK
  Future<void> init() async {
    await MobileAds.instance.initialize();
  }

  /// Load an interstitial ad
  Future<void> loadInterstitialAd() async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isAdLoaded = true;
          _setFullScreenCallbacks(ad);
          debugPrint("✅ Interstitial ad loaded successfully.");
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint("❌ Failed to load interstitial ad: $error");
          _isAdLoaded = false;
        },
      ),
    );
  }

  /// Show interstitial ad if loaded
  void showInterstitialAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
      _interstitialAd = null;
      _isAdLoaded = false;
      loadInterstitialAd(); // Preload next ad
    } else {
      debugPrint("⚠️ Interstitial ad not ready yet.");
    }
  }
 
  void _setFullScreenCallbacks(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        debugPrint("ℹ️ Interstitial ad dismissed.");
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint("⚠️ Failed to show interstitial ad: $error");
        ad.dispose();
      },
    );
  }
}
