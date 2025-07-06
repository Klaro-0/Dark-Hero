import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsManager {
  static InterstitialAd? _interstitialAd;

  static void initialize() {
    MobileAds.instance.initialize();
    loadInterstitialAd();
  }

  static void loadInterstitialAd() {
    if (_interstitialAd != null) return;

    InterstitialAd.load(
      adUnitId: 'ca-app-pub-1846542284809231/1605424775', // ✅ your ad unit
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _interstitialAd!.setImmersiveMode(true);
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('❌ Failed to load interstitial ad: $error');
          _interstitialAd = null;
        },
      ),
    );
  }

  static bool get isAdReady => _interstitialAd != null;

  static void showInterstitialAd({Function()? onAdClosed}) {
    if (_interstitialAd == null) {
      print('⚠️ Ad not ready, skipping.');
      onAdClosed?.call();
      loadInterstitialAd(); // Try loading for next time
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd(); // Preload next ad
        if (onAdClosed != null) onAdClosed();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitialAd();
        if (onAdClosed != null) onAdClosed();
      },
    );

    _interstitialAd!.show();
    _interstitialAd = null;
  }
}
