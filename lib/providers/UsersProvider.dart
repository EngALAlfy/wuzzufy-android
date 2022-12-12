import 'package:dio/dio.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:wuzzufy/models/User.dart';
import 'package:wuzzufy/providers/BaseProvider.dart';
import 'package:wuzzufy/utils/Config.dart';

class UsersProvider extends BaseProvider {
  String email;
  String phone;
  String name;
  String username;

  String loginId;
  String password;

  loginWithUsername(context) async {
    try {
      Response response = await Dio().post(Config.LOGIN_URL,
          data: {"loginId": loginId, "password": password});

      if (response.data['success'] == true) {
        User user = User.fromJson(response.data["data"]["user"]);
        await setUserToken(user.token);
        goToHome(context);
      } else {
        catchError(context, response.data['error']);
      }
    } catch (err) {
      catchError(context, err);
    }
  }

  loginWithFacebook(context) {
    EasyLoading.showInfo("قريبا");
  }

  loginWithGoogle(context) {
    EasyLoading.showInfo("قريبا");
  }

  signUpWithUsername(context) async {
    try {
      Response response = await Dio().post(Config.REGISTER_URL, data: {
        "username": username,
        "name": name,
        "email": email,
        "password": password,
      });
      if (response.data['success'] == true) {
        await setUserToken(response.data['data']['user']['token']);
        addFcmToken();
        goToHome(context);
      } else {
        catchError(context, response.data['error']);
      }
    } catch (err) {
      catchError(context, err);
    }
  }

  signUpWithFacebook(context) {
    EasyLoading.showInfo("قريبا");
  }

  signUpWithGoogle(context) {
    EasyLoading.showInfo("قريبا");
  }
}
