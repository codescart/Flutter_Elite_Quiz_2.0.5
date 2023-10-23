import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutterquiz/app/appLocalization.dart';
import 'package:flutterquiz/app/routes.dart';
import 'package:flutterquiz/features/auth/authRepository.dart';
import 'package:flutterquiz/features/auth/cubits/authCubit.dart';
import 'package:flutterquiz/features/badges/cubits/badgesCubit.dart';
import 'package:flutterquiz/features/bookmark/cubits/audioQuestionBookmarkCubit.dart';
import 'package:flutterquiz/features/bookmark/cubits/bookmarkCubit.dart';
import 'package:flutterquiz/features/bookmark/cubits/guessTheWordBookmarkCubit.dart';
import 'package:flutterquiz/features/deposit.dart';
import 'package:flutterquiz/features/profileManagement/cubits/deleteAccountCubit.dart';
import 'package:flutterquiz/features/profileManagement/cubits/updateUserDetailsCubit.dart';
import 'package:flutterquiz/features/profileManagement/cubits/uploadProfileCubit.dart';
import 'package:flutterquiz/features/profileManagement/cubits/userDetailsCubit.dart';
import 'package:flutterquiz/features/profileManagement/profileManagementRepository.dart';
import 'package:flutterquiz/features/systemConfig/cubits/systemConfigCubit.dart';
import 'package:flutterquiz/ui/screens/home/widgets/languageBottomSheetContainer.dart';
import 'package:flutterquiz/ui/screens/profile/widgets/editProfileFieldBottomSheetContainer.dart';
import 'package:flutterquiz/ui/screens/profile/widgets/themeDialog.dart';
import 'package:flutterquiz/ui/styles/colors.dart';
import 'package:flutterquiz/ui/widgets/circularProgressContainner.dart';
import 'package:flutterquiz/utils/constants.dart';
import 'package:flutterquiz/utils/errorMessageKeys.dart';
import 'package:flutterquiz/utils/stringLabels.dart';
import 'package:flutterquiz/utils/uiUtils.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share_plus/share_plus.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();

  static Route<dynamic> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
        builder: (context) => MultiBlocProvider(providers: [
              BlocProvider<DeleteAccountCubit>(
                  create: (_) =>
                      DeleteAccountCubit(ProfileManagementRepository())),
              BlocProvider<UploadProfileCubit>(
                  create: (context) => UploadProfileCubit(
                        ProfileManagementRepository(),
                      )),
              BlocProvider<UpdateUserDetailCubit>(
                  create: (context) => UpdateUserDetailCubit(
                        ProfileManagementRepository(),
                      )),
            ], child: MenuScreen()));
  }
}

class _MenuScreenState extends State<MenuScreen> {

  List menuName = [
    "notificationLbl",
    "coinHistory",
    "wallet",
    "bookmarkLbl",
    "inviteFriendsLbl",
    "badges",
    "coinStore",
    "theme",
    "rewardsLbl",
    "statisticsLabel",
    "language",
    "aboutQuizApp",
    "howToPlayLbl",
    "shareAppLbl",
    "rateUsLbl",
    "logoutLbl",
  "AddCoins",
    // "Deposit Money"
    "deleteAccount"
  ];

  List menuIcon = [
    "notification_icon.svg",
    "coin_history_icon.svg",
    "wallet_icon.svg",
    "bookmark.svg",
    "invite_friends.svg",
    "badges_icon.svg",
    "coin_icon.svg",
    "theme_icon.svg",
    "reword_icon.svg",
    "statistics_icon.svg",
    "language_icon.svg",
    "about_us_icon.svg",
    "how_to_play_icon.svg",
    "share_icon.svg",
    "rate_icon.svg",
    "logout_icon.svg",
    "wallet_icon.svg",
    "delete_account.svg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top + 30,
                      left: 20,
                      right: 20),
                  height: MediaQuery.of(context).size.height * 0.24,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).colorScheme.secondary
                        ],
                        begin: FractionalOffset.bottomLeft,
                        end: FractionalOffset.topRight,
                      )),
                  child: LayoutBuilder(builder: (context, boxConstriant) {
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.12,
                                height: MediaQuery.of(context).size.height * 0.06,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: Theme.of(context).backgroundColor,
                                        width: 0.3)),
                                child: Center(
                                    child: Icon(Icons.arrow_back_ios_rounded,
                                        color: Theme.of(context).backgroundColor)),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            Text(
                              "Profile",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).backgroundColor),
                            )
                          ],
                        ),
                        Positioned(
                          bottom: boxConstriant.maxHeight * (-0.6),
                          child: Container(
                            width: boxConstriant.maxWidth,
                            height: boxConstriant.maxHeight,
                            decoration: BoxDecoration(
                                color: Theme.of(context).backgroundColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: BlocBuilder<UserDetailsCubit, UserDetailsState>(
                              bloc: context.read<UserDetailsCubit>(),
                              builder: (context, state) {
                                if (state is UserDetailsFetchSuccess) {
                                  return Row(
                                    children: [
                                      SizedBox(
                                        width: boxConstriant.maxWidth * (0.25),
                                        height: boxConstriant.maxHeight * (0.8),
                                        child: Center(
                                          child: Stack(
                                            clipBehavior: Clip.none,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(left: 10),
                                                padding: EdgeInsets.all(2),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.18,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.18,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  border: Border.all(
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                      width: 0.5),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    fit: BoxFit.cover,
                                                    imageUrl: state
                                                        .userProfile.profileUrl!,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: -10,
                                                right: -10,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).pushNamed(
                                                        Routes.selectProfile,
                                                        arguments: false);
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 20,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    decoration: BoxDecoration(
                                                        color: Theme.of(context)
                                                            .backgroundColor
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    (0.07))),
                                                    height: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        (0.08),
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        (0.08),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width *
                                            (0.03),
                                      ),
                                      SizedBox(
                                        width: boxConstriant.maxWidth * (0.7),
                                        height: boxConstriant.maxHeight * (0.6),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: boxConstriant.maxWidth *
                                                      (0.6),
                                                  child: Text(
                                                    state.userProfile.name!,
                                                    style: TextStyle(
                                                      fontSize: 16.0,
                                                      fontWeight: FontWeight.bold,
                                                      color: Theme.of(context)
                                                          .primaryColor,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Spacer(),
                                                GestureDetector(
                                                  onTap: () {
                                                    editProfileFieldBottomSheet(
                                                      nameLbl,
                                                      state.userProfile.name!
                                                              .isEmpty
                                                          ? ""
                                                          : state.userProfile.name!,
                                                      false,
                                                      context,
                                                      context.read<
                                                          UpdateUserDetailCubit>(),
                                                    );
                                                  },
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: DecoratedBox(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Colors
                                                                  .transparent)),
                                                      child: Icon(
                                                        Icons.edit,
                                                        size: 22,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.005,
                                            ),
                                            Text(
                                              context.read<AuthCubit>()
                                                          .getAuthProvider() ==
                                                      AuthProvider.mobile
                                                  ? state.userProfile.mobileNumber!
                                                  : state.userProfile.email!,
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color:
                                                    Theme.of(context).canvasColor,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                ),

                /*  LayoutBuilder(builder: (context, constraints) {
                  return Positioned(
                    bottom: -MediaQuery.of(context).size.height * 0.06,
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 10),
                      margin: EdgeInsets.only(
                        left: 20,
                      ),
                      width: MediaQuery.of(context).size.width * 0.89,
                      height: MediaQuery.of(context).size.height * 0.13,
                      decoration: BoxDecoration(
                          color: Theme.of(context).backgroundColor,
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        child: BlocBuilder<UserDetailsCubit, UserDetailsState>(
                          bloc: context.read<UserDetailsCubit>(),
                          builder: (context, state) {
                            if (state is UserDetailsFetchSuccess) {
                              return Row(
                                children: [
                                  Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(2),
                                        width: MediaQuery.of(context).size.width *
                                            0.18,
                                        height: MediaQuery.of(context).size.width *
                                            0.18,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                              color: Theme.of(context).primaryColor,
                                              width: 0.5),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: CachedNetworkImage(
                                            fit: BoxFit.cover,
                                            imageUrl: state.userProfile.profileUrl!,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: -10,
                                        right: -10,
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.edit,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                          decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .backgroundColor
                                                  .withOpacity(0.7),
                                              borderRadius: BorderRadius.circular(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      (0.07))),
                                          height:
                                              MediaQuery.of(context).size.width *
                                                  (0.08),
                                          width: MediaQuery.of(context).size.width *
                                              (0.08),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * (0.03),
                                  ),
                                  LayoutBuilder(
                                    builder: (context, constraints) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                state.userProfile.name!,
                                                style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  editProfileFieldBottomSheet(
                                                    nameLbl,
                                                    state.userProfile.name!.isEmpty
                                                        ? ""
                                                        : state.userProfile.name!,
                                                    false,
                                                    context,
                                                    context.read<
                                                        UpdateUserDetailCubit>(),
                                                  );
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                MediaQuery.of(context).size.height *
                                                    0.005,
                                          ),
                                          Text(
                                            context
                                                        .read<AuthCubit>()
                                                        .getAuthProvider() ==
                                                    AuthProvider.mobile
                                                ? state.userProfile.mobileNumber!
                                                : state.userProfile.email!,
                                            style: TextStyle(
                                              fontSize: 12.0,
                                              color: Theme.of(context).primaryColor,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  );
                }),*/
                _buildGridviewList()
              ],
            ),
          ),
          BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
            listener: (context, state) {
              if (state is DeleteAccountSuccess) {
                //Update state for gloabally cubits
                context.read<BadgesCubit>().updateState(BadgesInitial());
                context.read<BookmarkCubit>().updateState(BookmarkInitial());

                //set local auth details to empty
                AuthRepository().setLocalAuthDetails(
                    authStatus: false,
                    authType: "",
                    jwtToken: "",
                    firebaseId: "",
                    isNewUser: false);
                //
                UiUtils.setSnackbar(
                    AppLocalization.of(context)!
                        .getTranslatedValues(accountDeletedSuccessfullyKey)!,
                    context,
                    false);
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(Routes.login);
              } else if (state is DeleteAccountFailure) {
                UiUtils.setSnackbar(
                    AppLocalization.of(context)!.getTranslatedValues(
                        convertErrorCodeToLanguageKey(state.errorMessage))!,
                    context,
                    false);
              }
            },
            bloc: context.read<DeleteAccountCubit>(),
            builder: (context, state) {
              if (state is DeleteAccountInProgress) {
                return Container(
                  color: Theme.of(context)
                      .colorScheme
                      .secondary
                      .withOpacity(0.275),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: AlertDialog(
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressContainer(
                            useWhiteLoader: false,
                            heightAndWidth: 45.0,
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            AppLocalization.of(context)!
                                .getTranslatedValues(deletingAccountKey)!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGridviewList() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * (0.1),
            left: 20,
            right: 20,
            bottom: 20),
        child: Column(
          children: [
            GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 4,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              // Generate 100 widgets that display their index in the List.
              children: List.generate(menuName.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _onPressed(index);
                    });
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).backgroundColor),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: SvgPicture.asset(
                            UiUtils.getImagePath(menuIcon[index]),
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        SizedBox(
                          width: 12.5,
                        ),
                        Flexible(
                          child: Text(
                            AppLocalization.of(context)!
                                .getTranslatedValues(menuName[index])!,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Theme.of(context).canvasColor,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            // ElevatedButton(onPressed: (){}, child: Text("Deposit Money"))
          ],
        ),
      ),
    );
  }



  void _onPressed(int index) {
    switch (index) {
      case 0:
        {
          Navigator.of(context).pushNamed(Routes.notification);
        }
        break;

      case 1:
        {
          Navigator.of(context).pushNamed(Routes.coinHistory);
        }
        break;

      case 2:
        {
          Navigator.of(context).pushNamed(Routes.wallet);
        }
        break;

      case 3:
        {
          Navigator.of(context).pushNamed(Routes.bookmark);
        }
        break;

      case 4:
        {
          Navigator.of(context).pushNamed(Routes.referAndEarn);
        }
        break;

      case 5:
        {
          Navigator.of(context).pushNamed(Routes.badges);
        }
        break;
      case 6:
        {
          Navigator.of(context).pushNamed(Routes.coinStore);
        }
        break;
      case 7:
        {
          showDialog(context: context, builder: (_) => ThemeDialog());
        }
        break;
      case 8:
        {
          Navigator.of(context).pushNamed(Routes.rewards);
        }
        break;
      case 9:
        {
          Navigator.of(context).pushNamed(Routes.statistics);
        }
        break;
      case 10:
        {
          showDialog(
              context: context, builder: (_) => LanguageDailogContainer());
        }
        break;
      case 11:
        {
          Navigator.of(context).pushNamed(Routes.aboutApp);
        }
        break;
      case 12:
        {
          Navigator.of(context)
              .pushNamed(Routes.appSettings, arguments: howToPlayLbl);
        }
        break;
      case 13:
        {
          try {
            if (Platform.isAndroid) {
              Share.share(context.read<SystemConfigCubit>().getAppUrl() +
                  "\n" +
                  context
                      .read<SystemConfigCubit>()
                      .getSystemDetails()
                      .shareappText);
            } else {
              Share.share(context.read<SystemConfigCubit>().getAppUrl() +
                  "\n" +
                  context
                      .read<SystemConfigCubit>()
                      .getSystemDetails()
                      .shareappText);
            }
          } catch (e) {
            UiUtils.setSnackbar(e.toString(), context, false);
          }
        }
        break;
      case 14:
        {
          LaunchReview.launch(
            androidAppId: packageName,
            iOSAppId: "585027354",
          );
        }
        break;
      case 15:
        {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    content: Text(
                      AppLocalization.of(context)!
                          .getTranslatedValues("logoutDialogLbl")!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();

                            context
                                .read<BadgesCubit>()
                                .updateState(BadgesInitial());
                            context
                                .read<BookmarkCubit>()
                                .updateState(BookmarkInitial());
                            context
                                .read<GuessTheWordBookmarkCubit>()
                                .updateState(GuessTheWordBookmarkInitial());

                            context
                                .read<AudioQuestionBookmarkCubit>()
                                .updateState(AudioQuestionBookmarkInitial());

                            context.read<AuthCubit>().signOut();
                            Navigator.of(context)
                                .pushReplacementNamed(Routes.login);
                          },
                          child: Text(
                            AppLocalization.of(context)!
                                .getTranslatedValues("yesBtn")!,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            AppLocalization.of(context)!
                                .getTranslatedValues("noBtn")!,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          )),
                    ],
                  ));
        }
        break;


      case 16:
        {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>deposit_Money()));

        }
        break;

      case 17:
        {
          showDialog<bool>(
              context: context,
              builder: (_) => AlertDialog(
                content: Text(
                  AppLocalization.of(context)!
                      .getTranslatedValues(
                      deleteAccountConfirmationKey)!,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary,
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text(
                        AppLocalization.of(context)!
                            .getTranslatedValues("yesBtn")!,
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text(
                        AppLocalization.of(context)!
                            .getTranslatedValues("noBtn")!,
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryColor),
                      )),
                ],
              )).then((value) {
            if (value != null && value) {
              context
                  .read<DeleteAccountCubit>()
                  .deleteUserAccount(
                  userId: context
                      .read<UserDetailsCubit>()
                      .getUserId());
            }
          });
        }
        break;
      default:
        {
          print("Invalid choice");
        }
        break;
    }
  }

  void editProfileFieldBottomSheet(
      String fieldTitle,
      String fieldValue,
      bool isNumericKeyboardEnable,
      BuildContext context,
      UpdateUserDetailCubit updateUserDetailCubit) {
    showModalBottomSheet(
        isDismissible: false,
        enableDrag: false,
        isScrollControlled: true,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        )),
        context: context,
        builder: (context) {
          return EditProfileFieldBottomSheetContainer(
              canCloseBottomSheet: true,
              fieldTitle: fieldTitle,
              fieldValue: fieldValue,
              numericKeyboardEnable: isNumericKeyboardEnable,
              updateUserDetailCubit: updateUserDetailCubit);
        }).then((value) {
      context
          .read<UpdateUserDetailCubit>()
          .updateState(UpdateUserDetailInitial());
    });
  }
}
