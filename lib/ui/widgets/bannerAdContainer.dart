import 'dart:io';

import 'package:facebook_audience_network/ad/ad_banner.dart' as facebook;
import 'package:flutter/material.dart';
import 'package:flutterquiz/features/systemConfig/cubits/systemConfigCubit.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:unity_ads_plugin/unity_ads_plugin.dart';

class BannerAdContainer extends StatefulWidget {
  @override
  _BannerAdContainer createState() => _BannerAdContainer();
}

class _BannerAdContainer extends State<BannerAdContainer> {
  BannerAd? _googleBannerAd;
  facebook.FacebookBannerAd? _facebookBannerAd;
  // UnityBannerAd? _unityBannerAd;

  @override
  void initState() {
    super.initState();
    _initBannerAd();
  }

  @override
  void dispose() {
    _googleBannerAd?.dispose();

    super.dispose();
  }

  void _initBannerAd() {
    Future.delayed(Duration.zero, () {
      final systemConfigCubit = context.read<SystemConfigCubit>();
      if (systemConfigCubit.isAdsEnable()) {
        //is google ad enable or not
        if (systemConfigCubit.adsType() == 1) {
          _createGoogleBannerAd();
        } else if (systemConfigCubit.adsType() == 2) {
          _createFacebookBannerAd();
        } else {
          _createUnityBannerAd();
        }
      }
    });
  }

  void _createFacebookBannerAd() async {
    print("Create facebook ad");
    _facebookBannerAd = facebook.FacebookBannerAd(
      bannerSize: facebook.BannerSize.STANDARD,
      placementId: context.read<SystemConfigCubit>().faceBookBannerId(),
      listener: (result, value) {
        print("$result -> $value");
      },
    );
    setState(() {});
  }

  void _createUnityBannerAd() async {
    // _unityBannerAd = UnityBannerAd(
    //   placementId: unityBannerAdsPlacement(),
    //   onLoad: (placementId) => print('Banner loaded: $placementId'),
    //   onClick: (placementId) => print('Banner clicked: $placementId'),
    //   onFailed: (placementId, error, message) =>
    //       print('Banner Ad $placementId failed: $error $message'),
    // );
    setState(() {});
  }

  Future<void> _createGoogleBannerAd() async {
    final BannerAd banner = BannerAd(
      request: AdRequest(),
      adUnitId: context.read<SystemConfigCubit>().googleBannerId(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded');
          setState(() {
            _googleBannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failedToLoad: $error');
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed'),
      ),
      size: AdSize.banner,
    );
    banner.load();
  }

  @override
  Widget build(BuildContext context) {
    final systemConfigCubit = context.read<SystemConfigCubit>();
    if (systemConfigCubit.isAdsEnable()) {
      if (systemConfigCubit.adsType() == 1) {
        return _googleBannerAd != null
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: _googleBannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _googleBannerAd!),
              )
            : Container();
      } else if (systemConfigCubit.adsType() == 2) {
        return _facebookBannerAd == null ? Container() : _facebookBannerAd!;
      } else {
       // return _unityBannerAd == null ? Container() : _unityBannerAd!;
      }
    }
    return Container();
  }
}

String unityBannerAdsPlacement() {
  if (Platform.isAndroid) {
    return "Banner_Android";
  }
  if (Platform.isIOS) {
    return "Banner_iOS";
  }
  return "";
}
