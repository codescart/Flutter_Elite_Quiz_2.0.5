import 'package:flutter/material.dart';
import 'package:flutterquiz/app/appLocalization.dart';
import 'package:flutterquiz/app/routes.dart';
import 'package:flutterquiz/utils/stringLabels.dart';

class TermsAndCondition extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Text(
        AppLocalization.of(context)!.getTranslatedValues('termAgreement')!,
        style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.secondary.withOpacity(0.8), fontWeight: FontWeight.bold),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.appSettings, arguments: termsAndConditions);
              },
              child: Text(
                AppLocalization.of(context)!.getTranslatedValues('termOfService')!,
                style: TextStyle(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 10),
              )),
          SizedBox(
            width: 5.0,
          ),
          Text(AppLocalization.of(context)!.getTranslatedValues('andLbl')!, style: Theme.of(context).textTheme.caption!.copyWith(color: Theme.of(context).colorScheme.secondary.withOpacity(0.8), fontWeight: FontWeight.bold,fontSize: 10)),
          SizedBox(
            width: 5.0,
          ),
          InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(Routes.appSettings, arguments: privacyPolicy);
              },
              child: Text(
                AppLocalization.of(context)!.getTranslatedValues('privacyPolicy')!,
                style: TextStyle(color: Theme.of(context).primaryColor, decoration: TextDecoration.underline, fontWeight: FontWeight.bold, fontSize: 10),
              )),
        ],
      ),
    ]));
  }
}
