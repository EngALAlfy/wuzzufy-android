import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:wuzzufy/models/Job.dart';
import 'package:wuzzufy/models/User.dart';
import 'package:wuzzufy/providers/BaseProvider.dart';
import 'package:wuzzufy/utils/Config.dart';

class JobsProvider extends BaseProvider {
  List jobs;
  Job job;

  User user;

  List categoryJobs;
  List providerJobs;

  List searchResult;
  bool isSearching = false;

  int count = 0;
  int searchCount = 0;
  int categoryCount = 0;
  int providerCount = 0;

  int adsCount = 5;

  int from = 0;
  int searchFrom = 0;
  int categoryFrom = 0;
  int providerFrom = 0;

  String searchQuery = '';

  getAll(context) async {
    try {
      var token = await getUserToken();
      Response response =
          await Dio().get(Config.API_URL + "/jobs/$from?user_token=$token");
      if (response.data['success'] == true) {
        if (jobs != null && jobs.isNotEmpty && from != 0) {
          jobs.addAll((response.data["data"]["jobs"] as List)
              ?.map((e) =>
                  e == null ? null : Job.fromJson(e as Map<String, dynamic>))
              ?.toList());
        } else {
          jobs = (response.data["data"]["jobs"] as List)
              ?.map((e) =>
                  e == null ? null : Job.fromJson(e as Map<String, dynamic>))
              ?.toList();

          if (jobs != null && jobs.isNotEmpty) {
            int index = jobs.length ~/ adsCount;

            for (int i = 1; i <= adsCount; i++) {
              jobs.insert(i * index + i - 1, Job(isAds: true));
            }
          }
        }

        count = response.data["data"]["count"];
        user = User.fromJson(response.data["data"]["user"]);
      } else {
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }

  get(context , id) async {
    try {
      var token = await getUserToken();
      Response response =
          await Dio().get(Config.API_URL + "/jobs/job/$id?user_token=$token");
      if (response.data['success'] == true) {
        job = Job.fromJson(response.data["data"]["job"]);
        user = User.fromJson(response.data["data"]["user"]);
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
    jobs = null;
    user = null;
    isError = false;
    error = null;
    notifyListeners();
  }

  void searchClear() {
    searchCount = 0;
    searchFrom = 0;
    searchQuery = '';
    searchResult = null;
    isError = false;
    error = null;
    notifyListeners();
  }

  void search(BuildContext context) async {
    isSearching = true;
    var token = await getUserToken();
    Response response = await Dio()
        .get(Config.API_URL + "/jobs/search/$searchQuery/$from?user_token=$token");
    if (response.data['success'] == true) {
      if (searchResult != null && searchResult.isNotEmpty && searchFrom != 0) {
        searchResult.addAll((response.data["data"]["jobs"] as List)
            ?.map((e) =>
                e == null ? null : Job.fromJson(e as Map<String, dynamic>))
            ?.toList());
      } else {
        searchResult = (response.data["data"]["jobs"] as List)
            ?.map((e) =>
                e == null ? null : Job.fromJson(e as Map<String, dynamic>))
            ?.toList();

        if (searchResult != null && searchResult.isNotEmpty) {
          int index = searchResult.length ~/ adsCount;

          for (int i = 1; i <= adsCount; i++) {
            searchResult.insert(i * index + i - 1, Job(isAds: true));
          }
        }

      }
      searchCount = response.data["data"]["count"];
    } else {
      catchError(context, response.data["error"]);
    }
    isSearching = false;
    notifyListeners();
  }

  logoutAndLogin(BuildContext context) async {
    await clearUserToken();
    goToLogin(context);
  }

  void getCategory(BuildContext context, int id) async {
    try {
      var token = await getUserToken();
      Response response = await Dio()
          .get(Config.API_URL + "/jobs/category/$id/$from?user_token=$token");
      if (response.data['success'] == true) {
        if (categoryJobs != null &&
            categoryJobs.isNotEmpty &&
            categoryFrom != 0) {
          categoryJobs.addAll((response.data["data"]["jobs"] as List)
              ?.map((e) =>
                  e == null ? null : Job.fromJson(e as Map<String, dynamic>))
              ?.toList());
        } else {
          categoryJobs = (response.data["data"]["jobs"] as List)
              ?.map((e) =>
                  e == null ? null : Job.fromJson(e as Map<String, dynamic>))
              ?.toList();

          if (categoryJobs != null && categoryJobs.isNotEmpty) {
            int index = categoryJobs.length ~/ adsCount;

            for (int i = 1; i <= adsCount; i++) {
              categoryJobs.insert(i * index + i - 1, Job(isAds: true));
            }
          }
        }
        categoryCount = response.data["data"]["count"];
      } else {
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }

  void getProvider(BuildContext context, int id) async {
    try {
      var token = await getUserToken();
      Response response = await Dio()
          .get(Config.API_URL + "/jobs/provider/$id/$from?user_token=$token");
      if (response.data['success'] == true) {
        if (providerJobs != null &&
            providerJobs.isNotEmpty &&
            providerFrom != 0) {
          providerJobs.addAll((response.data["data"]["jobs"] as List)
              ?.map((e) =>
                  e == null ? null : Job.fromJson(e as Map<String, dynamic>))
              ?.toList());
        } else {
          print(response.data);
          providerJobs = (response.data["data"]["jobs"] as List)
              ?.map((e) =>
                  e == null ? null : Job.fromJson(e as Map<String, dynamic>))
              ?.toList();

          if (providerJobs != null && providerJobs.isNotEmpty) {
            int index = providerJobs.length ~/ adsCount;

            for (int i = 1; i <= adsCount; i++) {
              providerJobs.insert(i * index + i - 1, Job(isAds: true));
            }
          }
        }
        providerCount = response.data["data"]["count"];
      } else {
        catchError(context, response.data["error"]);
      }
    } catch (err) {
      catchError(context, err);
    }
    notifyListeners();
  }

  void clearJob() {
    job = null;
    user = null;
    isError = false;
    error = null;
    notifyListeners();
  }
}
