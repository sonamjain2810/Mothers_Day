import 'dart:async';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'api/NotificationManager.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'data/Quotes.dart';
import 'data/Shayari.dart';
import 'widgets/AppStoreAppsItemWidget1.dart';
import 'widgets/CustomBannerWidget.dart';
import 'widgets/CustomFeatureCard.dart';
import 'widgets/CustomFullCard.dart';
import 'widgets/DesignerContainer.dart';
import 'widgets/MessageWidget1.dart';
import 'widgets/MessageWidget3.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/AdService.dart';
import 'data/Gifs.dart';
import 'data/Images.dart';
import 'data/Messages.dart';
import 'data/Strings.dart';
import 'widgets/AppStoreItemWidget2.dart';
import 'utils/SizeConfig.dart';
import 'MyDrawer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:timezone/timezone.dart' as tz;

// Height = 8.96
// Width = 4.14

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final facebookAppEvents = FacebookAppEvents();
  String interstitialTag = "";

  late BannerAd bannerAd1, bannerAd2, bannerAd3;
  bool isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) => initPlugin());
    AdService.createInterstialAd();

    bannerAd1 = GetBannerAd();
    bannerAd2 = GetBannerAd();
  }

  BannerAd GetBannerAd() {
    return BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: Platform.isAndroid
            ? Strings.androidAdmobBannerId
            : Strings.iosAdmobBannerId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            isBannerAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          isBannerAdLoaded = true;
          ad.dispose();
        }),
        request: const AdRequest())
      ..load();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd1.dispose();
    bannerAd2.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();

      switch (status) {
        case TrackingStatus.authorized:
          debugPrint("Tracking Status Authorized");
          break;
        case TrackingStatus.denied:
          debugPrint("Tracking Status Denied");
          break;
        case TrackingStatus.notDetermined:
          debugPrint("Tracking Status not Determined");
          break;
        case TrackingStatus.notSupported:
          debugPrint("Tracking Status not Supported");
          break;
        case TrackingStatus.restricted:
          debugPrint("Tracking Status Restricted");
          break;
        default:
      }
    } on PlatformException {
      //setState(() => authStatus = 'PlatformException was thrown');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    debugPrint("UUID: $uuid");

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Alert",
                    style: Theme.of(context).textTheme.labelLarge),
                content: Text("Do you want to Exit",
                    style: Theme.of(context).textTheme.labelLarge),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      launchUrlString(Strings.accountUrl);
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('More Apps'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Strings.RateNReview();
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Rate 5 ⭐'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            });
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Home",
            style: Theme.of(context).appBarTheme.toolbarTextStyle,
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    DesignerContainer(
                      isLeft: false,
                      child: Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: Center(
                          child: Text(
                            "Choose Wishes From Below",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                      ),
                    ),

                    const Divider(),

                    // Wishes Start
                    DesignerContainer(
                      isLeft: true,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: Center(
                              child: Text(
                                "Select Wishes Type",
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                            ),
                          ),
                          // Honey
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: SizeConfig.height(6.0)),
                                child: Row(
                                  children: [
                                    //English
                                    InkWell(
                                      child: MessageWidget3(
                                        headLine: "English",
                                        subTitle: Messages.english_data[2],
                                        imagePath: Gifs.gifs_path[3],
                                        color: Colors.orange,
                                      ),
                                      onTap: () {
                                        //debugPrint("${format.parse(date.toString())} is English Message Clicked");
                                        interstitialTag = "lang_english";
                                        facebookAppEvents.logEvent(
                                          name: "Message List",
                                          parameters: {
                                            'button_id': 'lang_english_button',
                                          },
                                        );
                                        AdService.context = context;
                                        AdService.interstitialTag =
                                            "lang_english";
                                        AdService.showInterstitialAd();
                                      },
                                    ),

                                    Column(
                                      children: [
                                        InkWell(
                                          child: MessageWidget1(
                                            headLine: "हिंदी",
                                            subTitle: Messages.hindi_data[0],
                                            imagePath: Gifs.gifs_path[5],
                                            color: Colors.brown,
                                          ),
                                          onTap: () {
                                            debugPrint("Hindi Clicked");
                                            interstitialTag = "lang_hindi";
                                            facebookAppEvents.logEvent(
                                              name: "Message List",
                                              parameters: {
                                                'button_id':
                                                    'lang_hindi_button',
                                              },
                                            );
                                            AdService.context = context;
                                            AdService.interstitialTag =
                                                "lang_hindi";
                                            AdService.showInterstitialAd();
                                          },
                                        ),
                                        SizedBox(
                                          height: SizeConfig.height(8.0),
                                        ),

                                        //Spainsh
                                        InkWell(
                                          child: MessageWidget1(
                                            headLine: "español",
                                            subTitle: Messages.spanish_data[1],
                                            imagePath: Gifs.gifs_path[14],
                                            color: Colors.blueGrey.shade400,
                                          ),
                                          onTap: () {
                                            debugPrint("For All Clicked");
                                            interstitialTag = "lang_spanish";
                                            facebookAppEvents.logEvent(
                                              name: "Message List",
                                              parameters: {
                                                'button_id':
                                                    'lang_spanish_button',
                                              },
                                            );
                                            AdService.context = context;
                                            AdService.interstitialTag =
                                                "lang_spanish";
                                            AdService.showInterstitialAd();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // rikhil

                          // Abdul

                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(
                                    bottom: SizeConfig.height(6.0)),
                                child: Row(
                                  children: [
                                    Column(
                                      children: [
                                        // German
                                        InkWell(
                                          child: MessageWidget1(
                                            headLine: "Deutsch",
                                            subTitle: Messages.german_data[0],
                                            imagePath: Gifs.gifs_path[19],
                                            color: Colors.pink.shade300,
                                          ),
                                          onTap: () {
                                            debugPrint("German Clicked");
                                            interstitialTag = "lang_german";
                                            facebookAppEvents.logEvent(
                                              name: "Message List",
                                              parameters: {
                                                'button_id':
                                                    'lang_german_button',
                                              },
                                            );
                                            AdService.context = context;
                                            AdService.interstitialTag =
                                                "lang_german";
                                            AdService.showInterstitialAd();
                                          },
                                        ),
                                        SizedBox(
                                          height: SizeConfig.height(8.0),
                                        ),

                                        // French
                                        InkWell(
                                            child: MessageWidget1(
                                              headLine: "Français",
                                              subTitle: Messages.french_data[0],
                                              imagePath: Gifs.gifs_path[21],
                                              color: Colors.blue[300]!,
                                            ),
                                            onTap: () {
                                              debugPrint("français Clicked");
                                              interstitialTag = "lang_french";
                                              facebookAppEvents.logEvent(
                                                name: "Message List",
                                                parameters: {
                                                  'button_id':
                                                      'lang_french_button',
                                                },
                                              );
                                              AdService.context = context;
                                              AdService.interstitialTag =
                                                  "lang_french";
                                              AdService.showInterstitialAd();
                                            }),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        // Italy
                                        InkWell(
                                          child: MessageWidget1(
                                            headLine: "Italiano",
                                            subTitle: Messages.italy_data[6],
                                            imagePath: Gifs.gifs_path[22],
                                            color: Colors.green.shade400,
                                          ),
                                          onTap: () {
                                            debugPrint("Italian Clicked");
                                            interstitialTag = "lang_italian";
                                            facebookAppEvents.logEvent(
                                              name: "Message List",
                                              parameters: {
                                                'button_id':
                                                    'lang_italian_button',
                                              },
                                            );
                                            AdService.context = context;
                                            AdService.interstitialTag =
                                                "lang_italian";
                                            AdService.showInterstitialAd();
                                          },
                                        ),

                                        SizedBox(
                                          height: SizeConfig.height(8.0),
                                        ),

                                        //Portugal
                                        InkWell(
                                          child: MessageWidget1(
                                            headLine: "Português",
                                            subTitle: Messages.portugal_data[3],
                                            imagePath: Gifs.gifs_path[31],
                                            color: Colors.deepPurpleAccent,
                                          ),
                                          onTap: () {
                                            debugPrint("Portuguese Clicked");
                                            interstitialTag = "lang_portuguese";
                                            facebookAppEvents.logEvent(
                                              name: "Message List",
                                              parameters: {
                                                'button_id':
                                                    'lang_portuguese_button',
                                              },
                                            );
                                            AdService.context = context;
                                            AdService.interstitialTag =
                                                "lang_portuguese";
                                            AdService.showInterstitialAd();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          //Kalam
                        ],
                      ),
                    ),
                    // Wishes end

                    const Divider(),

                    // Wish Creator Start
                    DesignerContainer(
                      isLeft: false,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: Text("Generate Mother's Day Cards",
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ),
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: InkWell(
                              child: CustomBannerWidget(
                                size: MediaQuery.of(context).size,
                                imagePath: Images.images_path[1],
                                buttonText: "Create Cards",
                                topText: "Send ",
                                middleText: "Cards & Greetings",
                                bottomText: "Share it With Your Loved Ones",
                              ),
                              onTap: () {
                                debugPrint("Meme Clicked");
                                interstitialTag = "meme";
                                facebookAppEvents.logEvent(
                                  name: "Meme Generator",
                                  parameters: {
                                    'button_id': 'meme_button',
                                  },
                                );

                                AdService.context = context;
                                AdService.interstitialTag = "meme";
                                AdService.showInterstitialAd();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Wish Creator End

                    const Divider(),

                    // Quotes Start
                    DesignerContainer(
                      isLeft: true,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: Text("Mother's Day Quotes",
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ),
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: InkWell(
                              child: Container(
                                width: size.width - SizeConfig.width(16),
                                height: size.width / 2,
                                decoration: BoxDecoration(
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                      ? Theme.of(context).primaryColorDark
                                      : Colors.pink[300],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft:
                                        Radius.circular(SizeConfig.height(20)),
                                    topRight:
                                        Radius.circular(SizeConfig.height(20)),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 4,
                                        color: Colors.grey),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Icon(Icons.format_quote,
                                        color: Theme.of(context)
                                            .primaryIconTheme
                                            .color),
                                    Positioned(
                                      top: 20,
                                      width: size.width - SizeConfig.width(16),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              SizeConfig.width(8)),
                                          child: Text(
                                            Quotes.quotes_data[4],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              SizeConfig.width(8)),
                                          child: Text(
                                            "Tap Here to Continue",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                    color: Colors.cyan[400]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                debugPrint("Quotes Clicked");
                                interstitialTag = "quotes";
                                facebookAppEvents.logEvent(
                                  name: "Quotes List",
                                  parameters: {
                                    'button_id': 'Quotes_button',
                                  },
                                );
                                AdService.context = context;
                                AdService.interstitialTag = "quotes";
                                AdService.showInterstitialAd();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Quotes End

                    const Divider(),

                    // Game Download
                    DesignerContainer(
                      isLeft: false,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: Text(
                                "👋,Games For You | 👗 🆙 | 🫣 🔍 | 🧩🤔",
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ),
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: const [
                                  AppStoreItemWidget2(
                                    appTitle: "",
                                    imageUrl:
                                        "https://is5-ssl.mzstatic.com/image/thumb/Purple112/v4/4a/8c/62/4a8c6201-b787-d4fa-e1d0-4b585454c47c/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/460x0w.png",
                                    appUrl:
                                        "https://apps.apple.com/us/app/puzzle-games-jigsaw-puzzles/id1660034531",
                                  ),
                                  AppStoreItemWidget2(
                                    appTitle: "",
                                    imageUrl:
                                        "https://is3-ssl.mzstatic.com/image/thumb/Purple112/v4/88/77/c6/8877c63f-7403-9b49-d575-578d80075271/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/460x0w.png",
                                    appUrl:
                                        "https://apps.apple.com/us/app/christmas-game-dressup-girl-hd/id6443515715",
                                  ),
                                  AppStoreItemWidget2(
                                    appTitle: "",
                                    imageUrl:
                                        "https://is1-ssl.mzstatic.com/image/thumb/Purple112/v4/a2/4c/bf/a24cbfec-774f-8ef4-7901-95857d34e6a1/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/460x0w.png",
                                    appUrl:
                                        "https://apps.apple.com/us/app/christmas-hidden-objects-brain/id1542868606",
                                  ),
                                  AppStoreItemWidget2(
                                    appTitle: "",
                                    imageUrl:
                                        "https://is1-ssl.mzstatic.com/image/thumb/Purple122/v4/ff/3b/6e/ff3b6e42-cd15-99ef-e566-18250123f049/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/460x0w.png",
                                    appUrl:
                                        "https://apps.apple.com/us/app/christmas-decoration-makeover/id1660383621",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      //banner
                    ),

                    // Game Download
                    const Divider(),

                    //Gifs Start
                    DesignerContainer(
                      isLeft: true,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: Text(" Gifs ",
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ),
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: InkWell(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomFeatureCard(
                                        size: size,
                                        imageUrl: Gifs.gifs_path[5],
                                        ontap: null),
                                    CustomFeatureCard(
                                        size: size,
                                        imageUrl: Gifs.gifs_path[6],
                                        ontap: null),
                                    CustomFeatureCard(
                                        size: size,
                                        imageUrl: Gifs.gifs_path[3],
                                        ontap: null),
                                    CustomFeatureCard(
                                        size: size,
                                        imageUrl: Gifs.gifs_path[11],
                                        ontap: null),
                                  ],
                                ),
                                onTap: () {
                                  debugPrint("Gifs Clicked");
                                  interstitialTag = "gif";
                                  facebookAppEvents.logEvent(
                                    name: "GIF List",
                                    parameters: {
                                      'button_id': 'gif_button',
                                    },
                                  );
                                  AdService.context = context;
                                  AdService.interstitialTag = "gif";
                                  AdService.showInterstitialAd();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Gifs End

                    const Divider(),

                    DesignerContainer(
                        isLeft: false,
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: Text("✋ Need Your HELP? 😊",
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ),
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: Text(
                                "Your suggestions are very important to improve your experience in next APP Update. Let me know how our team can improve. Thanks! and click the BUTTON Below 👇🏻 to RATE this app.",
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Strings.RateNReview();
                              },
                              child: const Text("⬇️ Rate & Review ⬇️"))
                        ])),

                    const Divider(),
                    //Native Ad
                    DesignerContainer(
                      isLeft: true,
                      child: Center(
                        child: SizedBox(
                          height: bannerAd2.size.height.toDouble(),
                          width: bannerAd2.size.width.toDouble(),
                          child: AdWidget(ad: bannerAd2),
                        ),
                      ),
                    ),

                    const Divider(),

                    // Shayari start
                    DesignerContainer(
                      isLeft: false,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: Text("Mother's Day Shayari",
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ),
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: InkWell(
                              child: Container(
                                width: size.width - SizeConfig.width(16),
                                height: size.width / 2,
                                decoration: BoxDecoration(
                                  color: MediaQuery.of(context)
                                              .platformBrightness ==
                                          Brightness.dark
                                      ? Theme.of(context).primaryColorDark
                                      : Colors.pink[300],
                                  borderRadius: BorderRadius.only(
                                    bottomLeft:
                                        Radius.circular(SizeConfig.height(20)),
                                    topRight:
                                        Radius.circular(SizeConfig.height(20)),
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 4,
                                        color: Colors.grey),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Icon(Icons.format_quote,
                                        color: Theme.of(context)
                                            .primaryIconTheme
                                            .color),
                                    Positioned(
                                      top: 20,
                                      width: size.width - SizeConfig.width(16),
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              SizeConfig.width(8)),
                                          child: Text(
                                            Shayari.shayari_data[29],
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      right: 0,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(
                                              SizeConfig.width(8)),
                                          child: Text(
                                            "Tap Here to Continue",
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge
                                                ?.copyWith(
                                                    color: Colors.cyan[400]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onTap: () {
                                debugPrint("Shayari Clicked");
                                interstitialTag = "shayari";
                                facebookAppEvents.logEvent(
                                  name: "Shayari List",
                                  parameters: {
                                    'button_id': 'Shayari_button',
                                  },
                                );
                                AdService.context = context;
                                AdService.interstitialTag = "shayari";
                                AdService.showInterstitialAd();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Shayari end

                    const Divider(),

                    //Image Start
                    DesignerContainer(
                      isLeft: true,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: Text(" Mother's Day Images ",
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                          ),
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: InkWell(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomFeatureCard(
                                        size: size,
                                        imageUrl: Images.images_path[13],
                                        ontap: null),
                                    CustomFeatureCard(
                                        size: size,
                                        imageUrl: Images.images_path[12],
                                        ontap: null),
                                    CustomFeatureCard(
                                        size: size,
                                        imageUrl: Images.images_path[8],
                                        ontap: null),
                                    CustomFeatureCard(
                                        size: size,
                                        imageUrl: Images.images_path[9],
                                        ontap: null),
                                  ],
                                ),
                                onTap: () {
                                  debugPrint("Images Clicked");
                                  interstitialTag = "image";
                                  facebookAppEvents.logEvent(
                                    name: "Image List",
                                    parameters: {
                                      'button_id': 'Image_button',
                                    },
                                  );
                                  AdService.context = context;
                                  AdService.interstitialTag = "image";
                                  AdService.showInterstitialAd();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Image End

                    const Divider(),

                    // Status Start
                    /*DesignerContainer(
                      isLeft: false,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: Text("New Born Baby Poems",
                                style: Theme.of(context).textTheme.headlineSmall),
                          ),
                          Padding(
                            padding: EdgeInsets.all(SizeConfig.width(8)),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: InkWell(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    CustomFBTextWidget(
                                      size: size,
                                      text: Status.status_data[2],
                                      color: Colors.pink.shade300,
                                      url:
                                          "http://andiwiniosapps.in/baby_shower_wishes/images/9.jpeg",
                                      isLeft: false,
                                    ),
                                    SizedBox(width: SizeConfig.width(8)),
                                    CustomFBTextWidget(
                                      size: size,
                                      text: Status.status_data[3],
                                      color: Colors.pink.shade300,
                                      url:
                                          "http://andiwiniosapps.in/baby_shower_wishes/images/9.jpeg",
                                      isLeft: false,
                                    ),
                                    SizedBox(width: SizeConfig.width(8)),
                                    CustomFBTextWidget(
                                      size: size,
                                      text: Status.status_data[4],
                                      color: Colors.pink.shade300,
                                      url:
                                          "http://andiwiniosapps.in/baby_shower_wishes/images/9.jpeg",
                                      isLeft: false,
                                    ),
                                    SizedBox(width: SizeConfig.width(8)),
                                    CustomFBTextWidget(
                                      size: size,
                                      text: Status.status_data[7],
                                      color: Colors.pink.shade300,
                                      url:
                                          "http://andiwiniosapps.in/baby_shower_wishes/images/9.jpeg",
                                      isLeft: false,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  debugPrint("Status Clicked");
                                  interstitialTag = "status";
                                  facebookAppEvents.logEvent(
                                    name: "Status List",
                                    parameters: {
                                      'button_id': 'Status_button',
                                    },
                                  );
                                  AdService.context = context;
                                  AdService.interstitialTag = "status";
                                  AdService.showInterstitialAd();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    //Status End
    
                    const Divider(),*/

                    //Native Ad
                    DesignerContainer(
                      isLeft: false,
                      child: Center(
                        child: SizedBox(
                          height: bannerAd1.size.height.toDouble(),
                          width: bannerAd1.size.width.toDouble(),
                          child: AdWidget(ad: bannerAd1),
                        ),
                      ),
                    ),

                    const Divider(),

                    Padding(
                      padding: EdgeInsets.all(SizeConfig.width(8)),
                      child: Text("Play Game \"Sell Rakhi\"",
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),

                    InkWell(
                      child: CustomFullCard(
                        size: MediaQuery.of(context).size,
                        imageUrl: "lib/assets/rakhi_game.jpeg",
                      ),
                      onTap: () {
                        if (Platform.isAndroid) {
                          // Android-specific code
                          debugPrint("More Button Clicked");
                          launchUrl(Uri.parse(
                              "https://play.google.com/store/apps/developer?id=Festival+Messages+SMS"));
                        } else if (Platform.isIOS) {
                          // iOS-specific code
                          debugPrint("More Button Clicked");
                          launchUrl(Uri.parse(
                              "https://apps.apple.com/us/app/-/id1434054710"));

                          facebookAppEvents.logEvent(
                            name: "Play Rakshabandhan Game",
                            parameters: {
                              'clicked_on_play_rakshabandhan_game': 'Yes',
                            },
                          );
                        }
                      },
                    ),

                    const Divider(),

                    Padding(
                      padding: EdgeInsets.all(SizeConfig.width(8)),
                      child: Text("Apps From Developer",
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.all(SizeConfig.width(8)),
                        child: Row(
                          children: <Widget>[
                            //Column1
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is1-ssl.mzstatic.com/image/thumb/Purple117/v4/8f/e7/b5/8fe7b5bc-03eb-808c-2b9e-fc2c12112a45/mzl.jivuavtz.png/292x0w.jpg",
                                    appTitle: "Mother's Day Images & Messages",
                                    appUrl:
                                        "https://apps.apple.com/us/app/good-morning-images-messages-to-wish-greet-gm/id1232993917"),
                                Divider(),
                                AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/44/e0/fd/44e0fdb5-667b-5468-7b2f-53638cba539e/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/292x0w.jpg",
                                    appTitle: "Birthday Status Wishes Quotes",
                                    appUrl:
                                        "https://apps.apple.com/us/app/birthday-status-wishes-quotes/id1522542709"),
                                Divider(),
                                AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is3-ssl.mzstatic.com/image/thumb/Purple124/v4/9c/17/e3/9c17e319-fadf-d92a-b586-bacda2d699bd/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                    appTitle: "Good Night Gif Image Quote Sm‪s",
                                    appUrl:
                                        "https://apps.apple.com/us/app/good-night-gif-image-quote-sms/id1527002426"),
                              ],
                            ),
                            SizedBox(width: SizeConfig.width(3)),
                            //Column2
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is2-ssl.mzstatic.com/image/thumb/Purple124/v4/e9/96/64/e99664d3-1083-5fac-6a0c-61718ee209fd/AppIcon-0-1x_U007emarketing-0-0-GLES2_U002c0-512MB-sRGB-0-0-0-85-220-0-0-0-7.png/292x0w.jpg",
                                    appTitle: "Weight Loss My Diet Coach Tips",
                                    appUrl:
                                        "https://apps.apple.com/us/app/weight-loss-my-diet-coach-tips/id1448343218"),
                                Divider(),
                                AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is2-ssl.mzstatic.com/image/thumb/Purple127/v4/5f/7c/45/5f7c45c7-fb75-ea39-feaa-a698b0e4b09e/pr_source.jpg/292x0w.jpg",
                                    appTitle: "English Speaking Course Grammar",
                                    appUrl:
                                        "https://apps.apple.com/us/app/english-speaking-course-learn-grammar-vocabulary/id1233093288"),
                                Divider(),
                                AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/50/ad/82/50ad82d9-0d82-5007-fcdd-cc47c439bfd0/AppIcon-0-1x_U007emarketing-0-85-220-10.png/292x0w.jpg",
                                    appTitle: "English Hindi Language Diction",
                                    appUrl:
                                        "https://apps.apple.com/us/app/english-hindi-language-diction/id1441243874"),
                              ],
                            ),
                            SizedBox(width: SizeConfig.width(3)),
                            //Column3

                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is1-ssl.mzstatic.com/image/thumb/Purple124/v4/89/1b/44/891b44e5-bbb3-a530-0f97-011c226d79e1/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                    appTitle: "Thank You Greetings Card Make‪r",
                                    appUrl:
                                        "https://apps.apple.com/us/app/thank-you-greetings-card-maker/id1552601152"),
                                Divider(),
                                AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is3-ssl.mzstatic.com/image/thumb/Purple114/v4/b6/3d/cd/b63dcde0-b4db-d05b-7025-e879a338049a/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                    appTitle:
                                        "Sorry Forgive Card Status Gif‪s‬",
                                    appUrl:
                                        "https://apps.apple.com/us/app/sorry-forgive-card-status-gifs/id1549696526"),
                                Divider(),
                                AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is1-ssl.mzstatic.com/image/thumb/Purple114/v4/9a/52/7a/9a527a0e-ca83-ecba-5f1b-336057d7a48b/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                    appTitle: "Anniversary Wishes Gif Image‪s‬",
                                    appUrl:
                                        "https://apps.apple.com/us/app/anniversary-wishes-gif-images/id1527002955"),
                              ],
                            ),
                            SizedBox(width: SizeConfig.width(3)),

                            //Column4
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const <Widget>[
                                AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is1-ssl.mzstatic.com/image/thumb/Purple114/v4/cd/fa/5f/cdfa5f06-68b0-c6ff-eb35-e4b5cd5ac890/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                    appTitle: "Get Well Soon Gif Image eCard‪s",
                                    appUrl:
                                        "https://apps.apple.com/us/app/get-well-soon-gif-image-ecards/id1526953576"),
                                Divider(),
                                /*AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is4-ssl.mzstatic.com/image/thumb/Purple91/v4/f0/84/d7/f084d764-79a8-f6d1-3778-1cb27fabb8bd/pr_source.png/292x0w.jpg",
                                    appTitle: "Egg Recipes 100+ Recipes",
                                    appUrl:
                                        "https://apps.apple.com/us/app/egg-recipes-100-recipes-collection-for-eggetarian/id1232736881"),
                                Divider(),*/
                                AppStoreAppsItemWidget1(
                                    imageUrl:
                                        "https://is1-ssl.mzstatic.com/image/thumb/Purple114/v4/0f/d6/f4/0fd6f410-9664-94a5-123f-38d787bf28c6/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/292x0w.jpg",
                                    appTitle: "Rakshabandhan Images Greetings",
                                    appUrl:
                                        "https://apps.apple.com/us/app/rakshabandhan-images-greetings/id1523619788"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: MyDrawer(),
      ),
    );
  }
}
