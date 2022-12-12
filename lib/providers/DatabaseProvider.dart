import 'dart:io';

import 'package:ext_storage/ext_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:wuzzufy/models/Job.dart';
import 'package:wuzzufy/providers/BaseProvider.dart';

class DatabaseProvider extends BaseProvider{
  String dbName = 'Jobs1.db';
  String savedStoreName = "saved_Jobs";
  Database db;

  List<dynamic> ids;

  List<Job> savedJobs;

  bool isError = false;

  int adsCount = 2;

  init(context) async {
    Directory folder;
    if (await checkPermissions()) {
      folder = await checkFolder();
    }

    if (folder == null) {
      return;
    }

    try {
      // File path to a file in the current directory
      String dbPath = folder.path + "/" + dbName;
      DatabaseFactory dbFactory = databaseFactoryIo;

      // We use the database factory to open the database
      db = await dbFactory.openDatabase(dbPath);
    } catch (e) {
      catchError(context, e);
    }
  }

  addJobToSaved(context, Job job) async {
    await init(context);
    if (db != null) {
      StoreRef savedStore = StoreRef(savedStoreName);
      await savedStore.record(job.id).put(db, job.toJson());
      EasyLoading.showSuccess("تم اضافه للمحفوظات");
     // getSavedJobsIds(context);
      getSavedJobs(context);
    } else {
      EasyLoading.showError("حدث خطأ ما!");
    }
  }

  removeJobFromSaved(context, Job job) async {
    await init(context);
    if (db != null) {
      StoreRef savedStore = StoreRef(savedStoreName);
      await savedStore.record(job.id).delete(db);
      EasyLoading.showSuccess("تم الحذف من المحفوظات");
     // getSavedJobsIds(context);
      getSavedJobs(context);
    } else {
      EasyLoading.showError("حدث خطأ ما!");
    }
  }

  getSavedJobs(context) async {
    await init(context);

    if (db != null) {
      StoreRef savedStore = StoreRef(savedStoreName);
      var _ids = await savedStore.findKeys(db);
      ids = _ids.toList();
      var jobs = await savedStore.records(_ids).get(db);
      savedJobs = jobs
          ?.map((e) =>
      e == null ? null : Job.fromJson(e as Map<String, dynamic>))
          ?.toList();


      if (savedJobs != null && savedJobs.isNotEmpty) {
        int index = savedJobs.length ~/ adsCount;

        for (int i = 1; i <= adsCount; i++) {
          savedJobs.insert(i * index + i - 1, Job(isAds: true));
        }
      }

      notifyListeners();
    } else {
      EasyLoading.showError("حدث خطأ ما!");
    }
  }

  getSavedJobsIds(context) async {
    await init(context);
    if (db != null) {
      StoreRef savedStore = StoreRef(savedStoreName);
      ids = (await savedStore.findKeys(db)).toList();
      notifyListeners();
    } else {
      EasyLoading.showError("حدث خطأ ما!");
    }
  }

  checkFolder() async {
    String path = await ExtStorage.getExternalStorageDirectory();
    Directory folder = Directory(path + "/wuzzufy/.database");

    if (!folder.existsSync()) {
      await folder.create(recursive: true);
    }

    return folder;
  }
}