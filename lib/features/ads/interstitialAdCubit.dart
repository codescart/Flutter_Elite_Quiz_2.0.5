import 'dart:io';

import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterquiz/features/systemConfig/cubits/systemConfigCubit.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:unity_ads_plugin/unity_ads_plugin.dart';

abstract class InterstitialAdState {}

class InterstitialAdInitial extends InterstitialAdState {}

class InterstitialAdLoaded extends InterstitialAdState {}

class InterstitialAdLoadInProgress extends InterstitialAdState {}

class InterstitialAdFailToLoad extends InterstitialAdState {}

class InterstitialAdCubit extends Cubit<InterstitialAdState> {
  InterstitialAdCubit() : super(InterstitialAdInitial());

  InterstitialAd? _interstitialAd;

  InterstitialAd? get interstitialAd => _interstitialAd;

  void _createGoogleInterstitialAd(BuildContext context) {
    InterstitialAd.load(
        adUnitId: context.read<SystemConfigCubit>().googleInterstitialAdId(),
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print("InterstitialAd Ad loaded successfully");
            _interstitialAd = ad;
            emit(InterstitialAdLoaded());
          },
          onAdFailedToLoad: (LoadAdError error) {
            print(error);
            emit(InterstitialAdFailToLoad());
          },
        ));
  }

  void _createFacebookInterstitialAd(BuildContext context) async {
    await FacebookInterstitialAd.destroyInterstitialAd();
    FacebookInterstitialAd.loadInterstitialAd(
        placementId: context.read<SystemConfigCubit>().faceBookInterstitialAdId(),
        listener: (result, value) {
          if (result == InterstitialAdResult.LOADED) {
            print("Facebook ad loaded");
            emit(InterstitialAdLoaded());
          }
          if (result == InterstitialAdResult.ERROR) {
            print("Facebook ad error : $value");
            print("---------------------");
            emit(InterstitialAdFailToLoad());
          }
          //if ad dismissed and becomes invalidate
          if (result == InterstitialAdResult.DISMISSED && value["invalidated"] == true) {
            createInterstitialAd(context);
          }
        });



  }


  void _createUnityAds(){
    // UnityAds.load(
    //     placementId: unityInterstitialPlacement(),
    //     onComplete: (placementId) {
    //       emit(InterstitialAdLoaded());
    //     },
    //     onFailed: (placementId, error, message) =>
    //         emit(InterstitialAdFailToLoad())
    // );
  }

  void createInterstitialAd(BuildContext context) {
    if (context.read<SystemConfigCubit>().isAdsEnable()) {
      emit(InterstitialAdLoadInProgress());
      if (context.read<SystemConfigCubit>().adsType()==1) {
        _createGoogleInterstitialAd(context);
      } else if(context.read<SystemConfigCubit>().adsType()==2){
        _createFacebookInterstitialAd(context);
      }else{
        _createUnityAds();
      }
    }
  }

  void showAd(BuildContext context) {
    //if ad is enable
    if (context.read<SystemConfigCubit>().isAdsEnable()) {
      //if ad loaded succesfully
      if (state is InterstitialAdLoaded) {
        //show google interstitial ad

        if (context.read<SystemConfigCubit>().adsType()==1) {
          interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (InterstitialAd ad) {},
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              ad.dispose();
              createInterstitialAd(context);
            },
            onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
              print('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
              createInterstitialAd(context);
            },
          );
          interstitialAd?.show();
        } else if(context.read<SystemConfigCubit>().adsType()==2){
          //show facebook interstitial ad
          FacebookInterstitialAd.showInterstitialAd();

        }else{
          //show Unity interstitial ad
          // UnityAds.showVideoAd(
          //   placementId: unityInterstitialPlacement(),
          //   onComplete: (placementId) =>
          //       createInterstitialAd(context),
          //   onFailed: (placementId, error, message) =>
          //       print('Video Ad $placementId failed: $error $message'),
          //   onStart: (placementId) =>
          //       print('Video Ad $placementId started'),
          //   onClick: (placementId) => print('Video Ad $placementId click'),
          //   onSkipped: (placementId) =>
          //       createInterstitialAd(context),
          // );
        }
      } else if (state is InterstitialAdFailToLoad) {
        createInterstitialAd(context);
      }
    }
  }


  String unityInterstitialPlacement() {
    if (Platform.isAndroid) {
      return "Interstitial_Android";
    }
    if (Platform.isIOS) {
      return "Interstitial_iOS";
    }
    return "";
  }


  @override
  Future<void> close() async {
    _interstitialAd?.dispose();
    return super.close();
  }
}
