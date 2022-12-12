import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:wuzzufy/models/Provider.dart';
import 'package:wuzzufy/models/User.dart';
import 'package:wuzzufy/providers/BaseProvider.dart';
import 'package:wuzzufy/utils/Config.dart';

class ProvidersProvider extends BaseProvider {
  List providers;
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
          .get(Config.API_URL + "/providers/$from?user_token=$token");
      if (response.data['success'] == true) {
        if (providers != null && providers.isNotEmpty && from != 0) {
          providers.addAll((response.data["data"]["providers"] as List)
              ?.map((e) => e == null
                  ? null
                  : Provider.fromJson(e as Map<String, dynamic>))
              ?.toList());
        } else {
          providers = (response.data["data"]["providers"] as List)
              ?.map((e) => e == null
                  ? null
                  : Provider.fromJson(e as Map<String, dynamic>))
              ?.toList();

          if (providers != null && providers.isNotEmpty) {
            int index = providers.length ~/ adsCount;

            for (int i = 1; i <= adsCount; i++) {
              providers.insert(i * index + i - 1, Provider(isAds: true));
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
    from = 0;
    count = 0;
    providers = null;
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
          "/providers/search/$searchQuery/$searchFrom?user_token=$token");
      if (response.data['success'] == true) {
        if (searchResult != null &&
            searchResult.isNotEmpty &&
            searchFrom != 0) {
          searchResult.addAll((response.data["data"]["providers"] as List)
              ?.map((e) => e == null
                  ? null
                  : Provider.fromJson(e as Map<String, dynamic>))
              ?.toList());
        } else {
          searchResult = (response.data["data"]["providers"] as List)
              ?.map((e) => e == null
                  ? null
                  : Provider.fromJson(e as Map<String, dynamic>))
              ?.toList();

          if (searchResult != null && searchResult.isNotEmpty) {
            int index = searchResult.length ~/ adsCount;

            for (int i = 1; i <= adsCount; i++) {
              searchResult.insert(i * index + i - 1, Provider(isAds: true));
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
