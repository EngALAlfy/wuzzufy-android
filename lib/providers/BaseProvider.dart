import 'dart:collection';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wuzzufy/providers/UtilsProvider.dart';
import 'package:wuzzufy/screens/HomeScreen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wuzzufy/screens/JobScreen.dart';
import 'package:wuzzufy/screens/SavedJobsScreen.dart';
import 'package:wuzzufy/screens/auth/LoginScreen.dart';
import 'package:wuzzufy/utils/Config.dart';
import 'package:wuzzufy/utils/Errors.dart';

class BaseProvider extends ChangeNotifier {
  String error;
  bool isError = false;

  catchError(context, err) async {
    isError = true;
    EasyLoading.showError("حدث خطأ ما !");
    if (err is DioError) {
      switch (err.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.sendTimeout:
        case DioErrorType.receiveTimeout:
          error = "انتهي وقت الطلب";
          break;
        case DioErrorType.response:
          error = err.response == null
              ? "غير قادر علي الوصول للسيرفر"
              : " خطأ في السيرفر \n كود الحالة : ${err.response.statusCode} ";
          break;
        case DioErrorType.cancel:
          error = "تم الغاء الطلب";
          break;
        case DioErrorType.other:
        default:
          error = "غير قادر علي الاتصال بالسيرفر";
          break;
      }
    } else {
      if (err is LinkedHashMap<String, dynamic>) {
        if (err.containsKey("code")) {
          switch (err["code"]) {
            case Errors.not_auth:
              {
                UtilsProvider utilsProvider =
                    Provider.of<UtilsProvider>(context, listen: false);
                if (utilsProvider.isAuth) {
                  // not auth user
                  EasyLoading.showInfo("تحتاج لتسجيل الدخول");
                  utilsProvider.unAuth();
                } else {}
                break;
              }
            case Errors.wrong_password:
              {
                EasyLoading.showInfo("اسم المستخدم او كلمة السر خطأ");
                break;
              }
            case Errors.wrong_password:
              {
                EasyLoading.showInfo("اسم المستخدم او كلمة السر خطأ");
                break;
              }
            case Errors.user_exist:
              {
                EasyLoading.showInfo("البريد او اسم المستخدم موجود مسبقا");
                break;
              }
            case Errors.db_err:
              {
                EasyLoading.showInfo("خطأ في قواعد البيانات");
                break;
              }
            case Errors.no_token:
              {
                EasyLoading.showInfo("لا يوجد رمز امان");
                break;
              }
            case Errors.not_allowed:
              {
                EasyLoading.showInfo("غير مسموح");
                break;
              }
            case Errors.not_found:
              {
                EasyLoading.showInfo("غير موجود");
                break;
              }
            case Errors.unknown_err:
              {
                EasyLoading.showInfo("خطأ غير معروف");
                break;
              }
          }
        }
      }
      error = "خطا غير معروف بالسيرفر";
    }

    if (await checkShowErrors()) {
      Alert(
              context: context,
              title: "خطأ مفصل",
              desc: err.toString(),
              type: AlertType.error)
          .show();
    }

    print(err);
  }

  Future<bool> checkInternet() async {
    return await Connectivity().checkConnectivity() != ConnectivityResult.none;
  }

  Future<bool> setPermissions() async {
    return Permission.storage.request().isGranted;
  }

  Future<bool> checkPermissions() async {
    var storagePermission = await Permission.storage.request();

    if (storagePermission.isDenied) {
      EasyLoading.showError("لا يمكن تشغيل التطبيق بدون منح الاذونات");
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkShowErrors() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool("showErrors") ?? false;
  }

  Future<bool> setShowErrors(show) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setBool("showErrors", show);
  }

  Future<String> getUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString("token");
  }

  Future<bool> setUserToken(token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.setString("token", token);
  }

  Future<bool> clearUserToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.remove("token");
  }

  goToHome(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => HomeScreen()),
        (route) => false);
  }

  goToLogin(context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        (route) => false);
  }

  goToJob(context, id) {
    Navigator.push(
        context,
        PageTransition(
            child: JobScreen(
              id: id,
            ),
            type: PageTransitionType.bottomToTop));
  }

  goToSaved(context) {
    Navigator.push(
        context,
        PageTransition(
            child: SavedJobsScreen(), type: PageTransitionType.bottomToTop));
  }

  addFcmToken(){
    try {
      FirebaseMessaging.instance.getToken().then((value) async {
        var token = await getUserToken();
        if (token != null) {
          Dio().post(Config.API_URL + "/add/fcm-token?user_token=$token",
              data: {"fcmToken": value});
        }
      });

    } catch (e) {
      EasyLoading.showError("لم يتم تسجيل الرمز");
    }
  }
}
