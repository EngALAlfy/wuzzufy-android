import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wuzzufy/providers/BaseProvider.dart';
import 'package:wuzzufy/utils/Config.dart';

class AdsProvider extends BaseProvider {
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;
  bool isDebug = false; // todo - change that

  getFullScreen(callback) {
    EasyLoading.show(status: "جار تحميل اعلان");
    interstitialAd = AdmobInterstitial(
      adUnitId: isDebug ? AdmobInterstitial.testAdUnitId : Config.AD_FULL_ID,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        handleEvent(event, callback, interstitialAd);
      },
    );

    interstitialAd.load();
    return interstitialAd;
  }

  AdmobReward getReward(callback) {
    EasyLoading.show(status: "جار تحميل اعلان");
    rewardAd = AdmobReward(
      adUnitId: isDebug ? AdmobReward.testAdUnitId : Config.AD_REWARD_ID,
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        handleEvent(event, callback, rewardAd);
      },
    );

    rewardAd.load();
    return rewardAd;
  }

  void handleEvent(AdmobAdEvent event, callback, ad) {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }

    if (event == AdmobAdEvent.loaded) {
      ad.show();
    } else {
      if (event != AdmobAdEvent.started &&
          event != AdmobAdEvent.impression &&
          event != AdmobAdEvent.opened &&
          event != AdmobAdEvent.clicked) {
        ad.dispose();
        callback();
      }
    }
  }

  Widget getBanner({size: AdmobBannerSize.BANNER}) {
    return AdmobBanner(
        adUnitId: isDebug ? AdmobBanner.testAdUnitId : Config.AD_BANNER_ID,
        adSize: size,
    );
  }
}
