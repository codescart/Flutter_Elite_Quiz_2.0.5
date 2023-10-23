import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterquiz/app/appLocalization.dart';
import 'package:flutterquiz/app/routes.dart';
import 'package:flutterquiz/features/ads/interstitialAdCubit.dart';
import 'package:flutterquiz/features/notificatiion/cubit/notificationCubit.dart';
import 'package:flutterquiz/features/quiz/models/quizType.dart';
import 'package:flutterquiz/ui/widgets/circularProgressContainner.dart';
import 'package:flutterquiz/ui/widgets/customListTile.dart';
import 'package:flutterquiz/ui/widgets/errorContainer.dart';
import 'package:flutterquiz/ui/widgets/roundedAppbar.dart';
import 'package:flutterquiz/utils/errorMessageKeys.dart';
import 'package:flutterquiz/utils/uiUtils.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreen createState() => _NotificationScreen();

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => BlocProvider<NotificationCubit>(
              create: (_) => NotificationCubit(),
              child: NotificationScreen(),
            ));
  }
}

class _NotificationScreen extends State<NotificationScreen> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    controller.addListener(scrollListener);
    Future.delayed(Duration.zero, () {
      context.read<NotificationCubit>().fetchNotification("20");
    });

    Future.delayed(Duration.zero, () {
      context.read<InterstitialAdCubit>().showAd(context);
    });
    super.initState();
  }

  scrollListener() {
    if (controller.position.maxScrollExtent == controller.offset) {
      if (context.read<NotificationCubit>().hasMoreData()) {
        context.read<NotificationCubit>().fetchMoreNotificationData("20");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(children: [
          Align(
            alignment: Alignment.topCenter,
            child: RoundedAppbar(
              title: AppLocalization.of(context)!
                  .getTranslatedValues("notificationLbl")!,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .84,
            alignment: Alignment.topCenter,
            child: BlocConsumer<NotificationCubit, NotificationState>(
                bloc: context.read<NotificationCubit>(),
                listener: (context, state) {
                  if (state is NotificationFailure) {
                    if (state.errorMessageCode == unauthorizedAccessCode) {
                      UiUtils.showAlreadyLoggedInDialog(context: context);
                    }
                  }
                },
                builder: (context, state) {
                  if (state is NotificationProgress ||
                      state is NotificationInitial) {
                    return Center(
                        child:
                            CircularProgressContainer(useWhiteLoader: false));
                  }
                  if (state is NotificationFailure) {
                    return ErrorContainer(
                      showBackButton: false,
                      errorMessageColor: Theme.of(context).primaryColor,
                      showErrorImage: true,
                      errorMessage: AppLocalization.of(context)!
                          .getTranslatedValues(convertErrorCodeToLanguageKey(
                              state.errorMessageCode)),
                      onTapRetry: () {
                        context
                            .read<NotificationCubit>()
                            .fetchNotification("20");
                      },
                    );
                  }
                  final notificationList =
                      (state as NotificationSuccess).notificationList;
                  final hasMore = state.hasMore;
                  return ListView.builder(
                      controller: controller,
                      itemCount: notificationList.length,
                      padding: EdgeInsets.only(
                          top: 25.0,
                          left: MediaQuery.of(context).size.width * (0.075),
                          right: MediaQuery.of(context).size.width * (0.075),
                          bottom: 100),
                      itemBuilder: (context, index) {
                        return hasMore && index == (notificationList.length - 1)
                            ? Center(
                                child: CircularProgressContainer(
                                useWhiteLoader: false,
                              ))
                            : GestureDetector(
                                onTap: () {
                                  if (notificationList[index]["type"] ==
                                      "category") {
                                    Navigator.of(context)
                                        .pushNamed(Routes.category, arguments: {
                                      "quizType": QuizTypes.quizZone,
                                      "type": notificationList[index]["type"],
                                      "typeId": notificationList[index]
                                          ["type_id"]
                                    });
                                  }
                                },
                                child: CustomListTile(
                                  trailingButtonOnTap: null,
                                  title: notificationList[index]["title"],
                                  subtitle: notificationList[index]["message"],
                                  leadingChild: notificationList[index]
                                              ["image"]!
                                          .isNotEmpty
                                      ? CachedNetworkImage(
                                          imageUrl: notificationList[index]
                                              ["image"]!,
                                        )
                                      : Container(),
                                  opacity: 1,
                                ),
                              );
                      });
                }),
          )
        ]),
      ],
    ));
  }
}
