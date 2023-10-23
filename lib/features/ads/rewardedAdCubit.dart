import 'package:facebook_audience_network/ad/ad_rewarded.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterquiz/features/systemConfig/cubits/systemConfigCubit.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'dart:io';

abstract class RewardedAdState {}

class RewardedAdInitial extends RewardedAdState {}

class RewardedAdLoaded extends RewardedAdState {}

class RewardedAdLoadInProgress extends RewardedAdState {}

class RewardedAdFailure extends RewardedAdState {}

class RewardedAdCubit extends Cubit<RewardedAdState> {
  RewardedAdCubit() : super(RewardedAdInitial());

  RewardedAd? _rewardedAd;

  RewardedAd? get rewardedAd => _rewardedAd;

  void _createGoogleRewardedAd(BuildContext context) {
    //dispose ad and then load
    _rewardedAd?.dispose();
    RewardedAd.load(
      adUnitId: context.read<SystemConfigCubit>().googleRewardedAdId(),
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdFailedToLoad: (error) {
        print("Rewarded ad failed to load");
        emit(RewardedAdFailure());
      }, onAdLoaded: (ad) {
        _rewardedAd = ad;
        print("Rewarded ad loaded successfully");
        emit(RewardedAdLoaded());
      }),
    );
  }

  Future<void> _createFacebookRewardedAd(BuildContext context, {required Function onFbRewardAdCompleted}) async {

    await FacebookRewardedVideoAd.destroyRewardedVideoAd();
    FacebookRewardedVideoAd.loadRewardedVideoAd(
      placementId: context.read<SystemConfigCubit>().faceBookRewardedAdId(),
      listener: (result, value) {
        print("Rewarded Ad: $result --> $value");
        if (result == RewardedVideoAdResult.LOADED) {
          emit(RewardedAdLoaded());
        }

        if (result == RewardedVideoAdResult.ERROR) {
          print(value);
          emit(RewardedAdFailure());
        }
        //if (result == RewardedVideoAdResult.VIDEO_COMPLETE)

        /// Once a Rewarded Ad has been closed and becomes invalidated,
        /// load a fresh Ad by calling this function.
        if (result == RewardedVideoAdResult.VIDEO_CLOSED && (value == true || value["invalidated"] == true)) {
          //ad callback here to
          print("Add coins here");
          onFbRewardAdCompleted();
          createRewardedAd(context, onFbRewardAdCompleted: onFbRewardAdCompleted);
        }
      },
    );







  }

  void createUnityRewardsAd(){
    // UnityAds.load(
    //     placementId: unityRewardsPlacement(),
    //     onComplete: (placementId) {
    //       emit(RewardedAdLoaded());
    //     },
    //     onFailed: (placementId, error, message) =>
    //         emit(RewardedAdFailure())
    // );
  }

  void createRewardedAd(BuildContext context, {required Function onFbRewardAdCompleted}) {
    emit(RewardedAdLoadInProgress());

    if (context.read<SystemConfigCubit>().isAdsEnable()) {
      if (context.read<SystemConfigCubit>().adsType()==1) {
        _createGoogleRewardedAd(context);
      } else if(context.read<SystemConfigCubit>().adsType()==2){
        _createFacebookRewardedAd(context, onFbRewardAdCompleted: onFbRewardAdCompleted);
      }else{
        createUnityRewardsAd();
      }
    }
  }

  void showAd({required Function onAdDismissedCallback, required BuildContext context}) {
    //if ads is enable
    if (context.read<SystemConfigCubit>().isAdsEnable()) {
      if (state is RewardedAdLoaded) {
        //if google ad is enable
        if (context.read<SystemConfigCubit>().adsType()==1) {
          _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onAdDismissedCallback();
              createRewardedAd(context, onFbRewardAdCompleted: () {});
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('$ad onAdFailedToShowFullScreenContent: $error');
              ad.dispose();
              //need to show this reason to user
              emit(RewardedAdFailure());
              createRewardedAd(context, onFbRewardAdCompleted: () {});
            },
          );
          rewardedAd?.show(onUserEarnedReward: (_, __) => {});
        } else if(context.read<SystemConfigCubit>().adsType()==2) {
          //show facebook ad
          FacebookRewardedVideoAd.showRewardedVideoAd();




        }else{
          // UnityAds.showVideoAd(
          //   placementId: unityRewardsPlacement(),
          //   onComplete: (placementId){
          //     onAdDismissedCallback();
          //     createRewardedAd(context, onFbRewardAdCompleted: () {});
          //   },
          //   onFailed: (placementId, error, message) =>
          //       print('Video Ad $placementId failed: $error $message'),
          //   onStart: (placementId) =>
          //       print('Video Ad $placementId started'),
          //   onClick: (placementId) => print('Video Ad $placementId click'),
          // );
        }
      } else if (state is RewardedAdFailure) {
        //create reward ad if ad is not loaded successfully
        createRewardedAd(context, onFbRewardAdCompleted: onAdDismissedCallback);
      }
    }
  }


  String unityRewardsPlacement() {
    if (Platform.isAndroid) {
      return "Rewarded_Android";
    }
    if (Platform.isIOS) {
      return "Rewarded_iOS";
    }
    return "";
  }


  @override
  Future<void> close() async {
    _rewardedAd?.dispose();
    return super.close();
  }
}
