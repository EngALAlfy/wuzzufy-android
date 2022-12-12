import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wuzzufy/providers/DatabaseProvider.dart';
import 'package:wuzzufy/widgets/AdsWidget.dart';
import 'package:wuzzufy/widgets/IsEmptyWidget.dart';
import 'package:wuzzufy/widgets/IsErrorWidget.dart';
import 'package:wuzzufy/widgets/IsLoadingWidget.dart';
import 'package:wuzzufy/widgets/JobWidget.dart';

class SavedJobsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseProvider provider = Provider.of<DatabaseProvider>(context , listen: false);
    provider.getSavedJobs(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("المفضلة"),
      ),
      body: Consumer<DatabaseProvider>(
        builder: (context, value, child) {
          if (value.isError) {
            return IsErrorWidget(
              onRetry: () {
                // todo
              },
              error: value.error,
            );
          }
          if (value.savedJobs == null) {
            return IsLoadingWidget();
          }

          if (value.savedJobs.isEmpty) {
            return IsEmptyWidget();
          }

          return ListView.builder(
            itemBuilder: (context, index) {
              if(value.savedJobs.elementAt(index).isAds){
                return AdsWidget();
              }
              return JobWidget(
                job: value.savedJobs.elementAt(index),
                databaseProvider: value,
              );
            },
            itemCount: value.savedJobs.length,
          );
        },
      ),
    );
  }
}
