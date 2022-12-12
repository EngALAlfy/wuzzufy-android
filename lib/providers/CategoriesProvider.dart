import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:wuzzufy/models/Category.dart';
import 'package:wuzzufy/models/User.dart';
import 'package:wuzzufy/providers/BaseProvider.dart';
import 'package:wuzzufy/utils/Config.dart';

class CategoriesProvider extends BaseProvider {
  List categories;
  User user;

  List searchResult;
  bool isSearching = false;

  int count = 0;
  int searchCount = 0;

  int adsCount = 3;

  int from = 0;
  int searchFrom = 0;

  String searchQuery = '';

  getAll(context) async {
    try {
      var token = await getUserToken();
      Response response = await Dio()
          .get(Config.API_URL + "/categories/$from?user_token=$token");
      if (response.data['success'] == true) {
        if (categories != null && categories.isNotEmpty && from != 0) {
          categories.addAll((response.data["data"]["categories"] as List)
              ?.map((e) => e == null
                  ? null
                  : Category.fromJson(e as Map<String, dynamic>))
              ?.toList());
        } else {
          categories = (response.data["data"]["categories"] as List)
              ?.map((e) => e == null
                  ? null
                  : Category.fromJson(e as Map<String, dynamic>))
              ?.toList();

          if (categories != null && categories.isNotEmpty) {
            int index = categories.length ~/ adsCount;

            for (int i = 1; i <= adsCount; i++) {
              categories.insert(i * index + i - 1, Category(isAds: true));
            }
          }
        }

        user = User.fromJson(response.data["data"]["user"]);
        count = response.data["data"]["count"];
      } else {
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }

  void clear() {
    count = 0;
    from = 0;
    categories = null;
    user = null;
    isError = false;
    error = null;
    notifyListeners();
  }

  void searchClear() {
    searchFrom = 0;
    searchCount = 0;
    searchQuery = '';
    searchResult = null;
    isError = false;
    error = null;
    notifyListeners();
  }

  void search(BuildContext context) async {
    isSearching = true;
    try {
      var token = await getUserToken();
      Response response = await Dio().get(Config.API_URL +
          "/categories/search/$searchQuery/$searchFrom?user_token=$token");
      if (response.data['success'] == true) {
        if (searchResult != null &&
            searchResult.isNotEmpty &&
            searchFrom != 0) {
          searchResult.addAll((response.data["data"]["categories"] as List)
              ?.map((e) => e == null
                  ? null
                  : Category.fromJson(e as Map<String, dynamic>))
              ?.toList());
        } else {
          searchResult = (response.data["data"]["categories"] as List)
              ?.map((e) => e == null
                  ? null
                  : Category.fromJson(e as Map<String, dynamic>))
              ?.toList();

          if (searchResult != null && searchResult.isNotEmpty) {
            int index = searchResult.length ~/ adsCount;

            for (int i = 1; i <= adsCount; i++) {
              searchResult.insert(i * index + i - 1, Category(isAds: true));
            }
          }
        }

        searchCount = response.data["data"]["count"];
      } else {
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    isSearching = false;
    notifyListeners();
  }
}
