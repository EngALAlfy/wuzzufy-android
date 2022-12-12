import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:wuzzufy/models/Provider.dart' as model;
import 'package:wuzzufy/providers/DatabaseProvider.dart';
import 'package:wuzzufy/providers/JobsProvider.dart';
import 'package:wuzzufy/utils/Config.dart';
import 'package:wuzzufy/widgets/AdsWidget.dart';
import 'package:wuzzufy/widgets/IsEmptyWidget.dart';
import 'package:wuzzufy/widgets/IsErrorWidget.dart';
import 'package:wuzzufy/widgets/IsLoadingWidget.dart';
import 'package:wuzzufy/widgets/JobWidget.dart';
import 'package:provider/provider.dart';

class ProviderScreen extends StatelessWidget {
  final model.Provider provider;

  const ProviderScreen({Key key, this.provider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    JobsProvider jobsProvider =
        Provider.of<JobsProvider>(context, listen: false);
    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    databaseProvider.getSavedJobsIds(context);

    jobsProvider.getProvider(context, provider.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(provider.name),
        centerTitle: true,
      ),
      body: Consumer<JobsProvider>(
        builder: (context, value, child) {
          if (value.isError) {
            return IsErrorWidget(
              error: value.error,
              onRetry: () {
                //refresh(context, provider);
              },
            );
          }

          if (value.providerJobs == null) {
            return IsLoadingWidget();
          }

          if (value.providerJobs.isEmpty) {
            return IsEmptyWidget();
          }

          return LazyLoadScrollView(
            child:  ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == value.providerJobs.length &&
                    value.providerJobs.length - value.adsCount <
                        value.providerCount) {
                  return IsLoadingWidget();
                }

                if (value.providerJobs.elementAt(index).isAds) {
                  return AdsWidget();
                }
                return JobWidget(
                  job: value.providerJobs.elementAt(index),
                );
              },
              itemCount:  value.providerJobs.length - value.adsCount < value.providerCount
                  ? value.providerJobs.length + 1
                  : value.providerJobs.length,
            ),
            onEndOfPage: () {
              if (value.providerJobs.length - value.adsCount < value.providerCount) {
                value.providerFrom = value.providerFrom + Config.LIST_LIMIT;
                value.getProvider(context , provider.id);
              }
            },
          );
        },
      ),
    );
  }
}
