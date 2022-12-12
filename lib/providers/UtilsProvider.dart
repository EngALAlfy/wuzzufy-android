import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:share/share.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wuzzufy/providers/BaseProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wuzzufy/utils/Config.dart';
import 'package:wuzzufy/widgets/IsLoadingWidget.dart';

class UtilsProvider extends BaseProvider {
  bool isReviewed = false;
  bool isLoaded = false;
  bool isFirstOpen = true;
  bool noInternet = false;

  bool isAuth = false;

  UtilsProvider(context) {
    init(context);
    addInternetListener();
  }

  init(context) async {
    await checkFirstOpen();
    noInternet = !await checkInternet();
    await checkReviewed();
    isAuth = await checkAuth();
    isLoaded = true;
    notifyListeners();
  }

  checkFirstOpen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isFirstOpen = preferences.getBool("isFirstOpen22") ?? true;
  }

  setFirstOpen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isFirstOpen22", false);
    await checkFirstOpen();
    notifyListeners();
  }

  addInternetListener() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        noInternet = true;
        EasyLoading.showError('لا يوجد انترنت');
      } else {
        noInternet = false;
      }

      notifyListeners();
    });
  }

  checkReviewed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    isReviewed = preferences.getBool("isReviewed1") ?? false;
  }

  setReviewed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool("isReviewed1", true);
    await checkReviewed();
    notifyListeners();
  }

  checkAuth() async {
    String token = await getUserToken();
    if (token == null) {
      return false;
    }
    return true;
  }

  logoutAndExist(context) async {
    await clearUserToken();
    SystemNavigator.pop(animated: true);
  }

  rateApp(context) async {
    if (await InAppReview.instance.isAvailable()) {
      await InAppReview.instance.requestReview();
    } else {
      await InAppReview.instance.openStoreListing();
    }
  }

  shareApp(context) {
    String body =
        "حمل تطبيق وظايفي ودور علي الزظيفة المناسبة ليك بين الاف الوظايف المتجددة يوميا\n"
        "حملة دلوقتي\n"
        "https://play.google.com/store/apps/details?id=com.alalfy.wuzzufy";
    Share.share(body);
  }

  unAuth() {
    // unauth user
    isAuth = false;
    clearUserToken();
    notifyListeners();
  }

  privacy(context) {
    Alert(
        context: context,
        title: "سياسة الخصوصية",
        content: Container(child: WebView(
          initialUrl: Config.PRIVACY_URL,
        ),
        height: 400,),
        buttons: [
          DialogButton(
              child: Text("موافق"),
              onPressed: () {
                Navigator.pop(context);
              }),
        ]).show();
  }
}
