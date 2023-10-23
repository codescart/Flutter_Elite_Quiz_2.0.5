import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterquiz/app/appLocalization.dart';
import 'package:flutterquiz/app/routes.dart';
import 'package:flutterquiz/features/profileManagement/cubits/updateScoreAndCoinsCubit.dart';
import 'package:flutterquiz/features/profileManagement/cubits/userDetailsCubit.dart';
import 'package:flutterquiz/features/profileManagement/profileManagementRepository.dart';
import 'package:flutterquiz/features/quiz/cubits/contestCubit.dart';
import 'package:flutterquiz/features/quiz/models/contest.dart';
import 'package:flutterquiz/features/quiz/models/quizType.dart';
import 'package:flutterquiz/features/quiz/quizRepository.dart';
import 'package:flutterquiz/ui/styles/colors.dart';
import 'package:flutterquiz/ui/widgets/circularProgressContainner.dart';
import 'package:flutterquiz/ui/widgets/customBackButton.dart';
import 'package:flutterquiz/ui/widgets/errorContainer.dart';
import 'package:flutterquiz/utils/errorMessageKeys.dart';
import 'package:flutterquiz/utils/stringLabels.dart';
import 'package:flutterquiz/utils/uiUtils.dart';

class ContestScreen extends StatefulWidget {
  @override
  _ContestScreen createState() => _ContestScreen();
  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (_) => MultiBlocProvider(providers: [
              BlocProvider<ContestCubit>(
                create: (_) => ContestCubit(QuizRepository()),
              ),
              BlocProvider<UpdateScoreAndCoinsCubit>(
                create: (_) =>
                    UpdateScoreAndCoinsCubit(ProfileManagementRepository()),
              ),
            ], child: ContestScreen()));
  }
}

class _ContestScreen extends State<ContestScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    context
        .read<ContestCubit>()
        .getContest(context.read<UserDetailsCubit>().getUserId());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: Builder(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
                backgroundColor: Theme.of(context).backgroundColor,
                leading: CustomBackButton(
                  iconColor: Theme.of(context).primaryColor,
                ),
                centerTitle: true,
                title: Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    AppLocalization.of(context)!
                        .getTranslatedValues("contestLbl")!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22.0),
                  ),
                ),
                bottom: TabBar(
                    labelPadding: EdgeInsetsDirectional.only(
                        top: MediaQuery.of(context).size.height * .03),
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.7),
                    labelStyle: Theme.of(context).textTheme.subtitle1,
                    indicatorColor: Theme.of(context).primaryColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 5,
                    tabs: [
                      Tab(
                          text: AppLocalization.of(context)!
                              .getTranslatedValues("pastLbl")),
                      Tab(
                          text: AppLocalization.of(context)!
                              .getTranslatedValues("liveLbl")),
                      Tab(
                          text: AppLocalization.of(context)!
                              .getTranslatedValues("upcomingLbl")),
                    ])),
            body: Stack(
              children: [
                BlocConsumer<ContestCubit, ContestState>(
                    bloc: context.read<ContestCubit>(),
                    listener: (context, state) {
                      if (state is ContestFailure) {
                        if (state.errorMessage == unauthorizedAccessCode) {
                          //
                          UiUtils.showAlreadyLoggedInDialog(
                            context: context,
                          );
                        }
                      }
                    },
                    builder: (context, state) {
                      if (state is ContestProgress || state is ContestInitial) {
                        return Center(
                            child: CircularProgressContainer(
                          useWhiteLoader: false,
                        ));
                      }
                      if (state is ContestFailure) {
                        print(state.errorMessage);
                        return ErrorContainer(
                          errorMessage: AppLocalization.of(context)!
                              .getTranslatedValues(
                                  convertErrorCodeToLanguageKey(
                                      state.errorMessage)),
                          onTapRetry: () {
                            context.read<ContestCubit>().getContest(
                                context.read<UserDetailsCubit>().getUserId());
                          },
                          showErrorImage: true,
                          errorMessageColor: Theme.of(context).primaryColor,
                        );
                      }
                      final contestList = (state as ContestSuccess).contestList;
                      return TabBarView(children: [
                        past(contestList.past),
                        live(contestList.live),
                        future(contestList.upcoming)
                      ]);
                    })
              ],
            ),
          );
        }));
  }

  Widget past(Contest data) {
    return data.errorMessage.isNotEmpty
        ? ErrorContainer(
            showBackButton: false,
            errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                convertErrorCodeToLanguageKey(data.errorMessage))!,
            errorMessageColor: Theme.of(context).primaryColor,
            onTapRetry: () {
              context
                  .read<ContestCubit>()
                  .getContest(context.read<UserDetailsCubit>().getUserId());
            },
            showErrorImage: true)
        : ListView.builder(
            shrinkWrap: false,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: data.contestDetails.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: data.contestDetails[index].showDescription == false
                      ? MediaQuery.of(context).size.height * .3
                      : MediaQuery.of(context).size.height * .4,
                  margin: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      boxShadow: [
                        UiUtils.buildBoxShadow(
                            offset: Offset(5, 5), blurRadius: 10.0),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: contestDesign(data, index, 0));
            });
  }

  Widget live(Contest data) {
    return data.errorMessage.isNotEmpty
        ? ErrorContainer(
            showBackButton: false,
            errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                convertErrorCodeToLanguageKey(data.errorMessage))!,
            errorMessageColor: Theme.of(context).primaryColor,
            onTapRetry: () {
              context
                  .read<ContestCubit>()
                  .getContest(context.read<UserDetailsCubit>().getUserId());
            },
            showErrorImage: true)
        : ListView.builder(
            shrinkWrap: false,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: data.contestDetails.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: data.contestDetails[index].showDescription == false
                      ? MediaQuery.of(context).size.height * .3
                      : MediaQuery.of(context).size.height * .4,
                  margin: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      boxShadow: [
                        UiUtils.buildBoxShadow(
                            offset: Offset(5, 5), blurRadius: 10.0),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: contestDesign(data, index, 1));
            });
  }

  Widget future(Contest data) {
    return data.errorMessage.isNotEmpty
        ? ErrorContainer(
            showBackButton: false,
            errorMessage: AppLocalization.of(context)!.getTranslatedValues(
                convertErrorCodeToLanguageKey(data.errorMessage))!,
            errorMessageColor: Theme.of(context).primaryColor,
            onTapRetry: () {
              context
                  .read<ContestCubit>()
                  .getContest(context.read<UserDetailsCubit>().getUserId());
            },
            showErrorImage: true)
        : ListView.builder(
            shrinkWrap: false,
            physics: AlwaysScrollableScrollPhysics(),
            itemCount: data.contestDetails.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: data.contestDetails[index].showDescription == false
                      ? MediaQuery.of(context).size.height * .3
                      : MediaQuery.of(context).size.height * .4,
                  margin: EdgeInsets.all(15),
                  width: MediaQuery.of(context).size.width * .9,
                  decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      boxShadow: [
                        UiUtils.buildBoxShadow(
                            offset: Offset(5, 5), blurRadius: 10.0),
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: contestDesign(data, index, 2));
            });
  }

  Widget contestDesign(dynamic data, int index, int type) {
    return Column(
      children: [
        Expanded(
            flex: 5,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
              ),
              child: CachedNetworkImage(
                placeholder: (context, _) {
                  return Center(
                    child: CircularProgressContainer(
                      useWhiteLoader: false,
                    ),
                  );
                },
                imageBuilder: (context, imageProvider) {
                  return Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                    ),
                  );
                },
                errorWidget: (context, image, error) {
                  print(error.toString());
                  return Center(
                    child: Icon(
                      Icons.error,
                      color: Theme.of(context).primaryColor,
                    ),
                  );
                },
                fit: BoxFit.cover,
                width: double.infinity,
                height: MediaQuery.of(context).size.height * .15,
                imageUrl: data.contestDetails[index].image.toString(),
              ),
            )),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 3),
            color: Theme.of(context).backgroundColor,
            //height: MediaQuery.of(context).size.height*.05,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: Text(
                    data.contestDetails[index].name.toString(),
                    style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        data.contestDetails[index].showDescription =
                            !data.contestDetails[index].showDescription!;
                      });
                    },
                    child: Icon(
                      data.contestDetails[index].showDescription!
                          ? Icons.keyboard_arrow_up_sharp
                          : Icons.keyboard_arrow_down_sharp,
                      color: Theme.of(context).primaryColor,
                      size: 30,
                    )),
              ],
            ),
          ),
        ),
        data.contestDetails[index].showDescription!
            ? Container(
                padding: EdgeInsets.only(left: 10, bottom: 5),
                color: Theme.of(context).backgroundColor,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                    //scrollDirection: Axis.horizontal,
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Text(
                      data.contestDetails[index].description!,
                      style: TextStyle(
                        color: Theme.of(context).canvasColor.withOpacity(0.5),
                      ),
                    )))
            : Container(),
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          child: Divider(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            height: 0.1,
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.only(left: 10, top: 10),
            decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        AppLocalization.of(context)!
                            .getTranslatedValues("entryFeesLbl")!,
                        style: TextStyle(
                            color:
                            Theme.of(context).canvasColor.withOpacity(0.5),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        data.contestDetails[index].entry.toString(),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        AppLocalization.of(context)!
                            .getTranslatedValues("endsOnLbl")!,
                        style: TextStyle(
                          color:
                          Theme.of(context).canvasColor.withOpacity(0.5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        data.contestDetails[index].endDate.toString(),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        AppLocalization.of(context)!
                            .getTranslatedValues("playersLbl")!,
                        style: TextStyle(
                            color:
                            Theme.of(context).canvasColor.withOpacity(0.5),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        data.contestDetails[index].participants.toString(),
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    SizedBox(
                      height: 1.0,
                    ),
                    type == 0
                        ? Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).backgroundColor,
                                maximumSize: Size(
                                    MediaQuery.of(context).size.width * .5,
                                    MediaQuery.of(context).size.height * .05),
                                backgroundColor: Theme.of(context).primaryColor,
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: 1),
                                minimumSize: Size(
                                    MediaQuery.of(context).size.width * .1,
                                    MediaQuery.of(context).size.height * .05),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(10.0),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                    Routes.contestLeaderboard,
                                    arguments: {
                                      "contestId": data.contestDetails[index].id
                                    });
                              },
                              child: Text(
                                AppLocalization.of(context)!
                                    .getTranslatedValues("leaderboardLbl")!,
                              ),
                            ),
                          )
                        : type == 1
                            ? Padding(
                                padding:
                                    const EdgeInsetsDirectional.only(end: 10.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor:
                                        Theme.of(context).backgroundColor,
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    side: BorderSide(
                                        color: primaryColor, width: 1),
                                    minimumSize: Size(
                                        MediaQuery.of(context).size.width * .2,
                                        MediaQuery.of(context).size.height *
                                            .05),
                                    shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (int.parse(context
                                            .read<UserDetailsCubit>()
                                            .getCoins()!) >=
                                        int.parse(data
                                            .contestDetails[index].entry!)) {
                                      context
                                          .read<UpdateScoreAndCoinsCubit>()
                                          .updateCoins(
                                            context
                                                .read<UserDetailsCubit>()
                                                .getUserId(),
                                            int.parse(data
                                                .contestDetails[index].entry!),
                                            false,
                                            AppLocalization.of(context)!
                                                    .getTranslatedValues(
                                                        playedContestKey) ??
                                                "-",
                                          );

                                      context
                                          .read<UserDetailsCubit>()
                                          .updateCoins(
                                              addCoin: false,
                                              coins: int.parse(data
                                                  .contestDetails[index]
                                                  .entry!));
                                      Navigator.of(context)
                                          .pushReplacementNamed(Routes.quiz,
                                              arguments: {
                                            "numberOfPlayer": 1,
                                            "quizType": QuizTypes.contest,
                                            "contestId":
                                                data.contestDetails[index].id,
                                            "quizName": "Contest"
                                          });
                                    } else {
                                      UiUtils.setSnackbar(
                                          AppLocalization.of(context)!
                                              .getTranslatedValues(
                                                  "noCoinsMsg")!,
                                          context,
                                          false);
                                    }
                                  },
                                  child: Text(
                                    AppLocalization.of(context)!
                                        .getTranslatedValues("playLbl")!,
                                    style: TextStyle(
                                        color:
                                            Theme.of(context).backgroundColor),
                                  ),
                                ),
                              )
                            : Container()
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
