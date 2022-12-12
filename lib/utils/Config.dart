import 'package:flutter/material.dart';

class Config {
  static const PRIMARY_COLOR = Colors.deepPurple;
  static const ACCENT_COLOR = Colors.deepOrangeAccent;

  static const String BASE_URL = /*"http://192.168.43.78:5000";*/"http://wuzzufy.me";
  static const String API_URL = BASE_URL + "/api/user";
  static const String LOGIN_URL = BASE_URL + "/auth/api/user/login";
  static const String REGISTER_URL = BASE_URL + "/auth/api/user/register";
  static const String PROVIDERS_PHOTO_URL = BASE_URL + "/uploads/images/providers";

  static const String PRIVACY_URL = "https://wuzzufy.me/plain-privacy";

  static const int LIST_LIMIT = 20;

  static const String AD_APP_ID = "ca-app-pub-8532116945853033~1532933088";
  static const String AD_FULL_ID = "ca-app-pub-8532116945853033/8366864350";
  static const String AD_REWARD_ID = "ca-app-pub-8532116945853033/5932272704";
  static const String AD_BANNER_ID = "ca-app-pub-8532116945853033/8293782555";

}
