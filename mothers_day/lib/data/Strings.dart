import 'dart:io';
import 'package:launch_review/launch_review.dart';

class Strings {
  Strings._();

  static const accountName = "GJOneStudio";

  static const accountEmail = "gj1studio@gmail.com";

  static const appName = "Happy Mother's Day Wishes Quotes";

  static const mailAppName = "Happpy Mothers%20Day%20Wishes%20Quotes";

  static const iosAppId = "1235378448";

  static const iosAdmobAppId = "ca-app-pub-8179797674906935~3542931805";

  static const iosAdmobBannerId = "ca-app-pub-8179797674906935/5019665004";

  static const iosAdmobInterstitialId =
      "ca-app-pub-8179797674906935/6496398206"; //8452635043

  static const iosAdmobNativeId = "ca-app-pub-8179797674906935/5719781606";

  static const iosAdmobRewardedId = "ca-app-pub-8179797674906935/9147906635";

  static const iosFBInterstitialId = "266846741590142_266846904923459";

  static const iosFBBannerId = "266846741590142_270405771234239";

  static const androidAppPackageName = "mothers.day.images.messages";

  static const androidAdmobAppId = "ca-app-pub-8179797674906935~2159826451";

  static const androidAdmobBannerId = "ca-app-pub-8179797674906935/5799634660";

  static const androidAdmobInterstitialId =
      "ca-app-pub-8179797674906935/5560015413";

  static const androidAdmobNativeId = "ca-app-pub-8179797674906935/4246933742";

  static const androidAdmobRewardedId =
      "ca-app-pub-8179797674906935/5256763087";

  static const testDevice = 'c835aea0489176f272e2d174b8d921ca';

  static String appUrl = Platform.isAndroid
      ? "https://play.google.com/store/apps/details?id=${Strings.androidAppPackageName}"
      : "https://apps.apple.com/us/app/-/id${Strings.iosAppId}";

  static String accountUrl = Platform.isAndroid
      ? "https://play.google.com/store/apps/developer?id=Festival+Messages+SMS"
      : "https://apps.apple.com/us/developer/sonam-jain/id1440118616";

  static const String mailContent =
      'mailto:sonamjain2810@yahoo.com?subject=feedback%20from%20${Strings.mailAppName}&body=Your%20Apps%20Rocks!!';

  static String shareAppText =
      "Hey I have found this amazing app for you.\nHave a look on\n${Strings.appName}\n${Strings.appUrl}";

  static void RateNReview() {
    LaunchReview.launch(iOSAppId: Strings.iosAppId);
  }
}
