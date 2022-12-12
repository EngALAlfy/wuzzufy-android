import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:wuzzufy/models/Category.dart';
import 'package:wuzzufy/providers/CategoriesProvider.dart';
import 'package:wuzzufy/providers/DatabaseProvider.dart';
import 'package:wuzzufy/providers/JobsProvider.dart';
import 'package:wuzzufy/utils/Config.dart';
import 'package:wuzzufy/widgets/AdsWidget.dart';
import 'package:wuzzufy/widgets/IsEmptyWidget.dart';
import 'package:wuzzufy/widgets/IsErrorWidget.dart';
import 'package:wuzzufy/widgets/IsLoadingWidget.dart';
import 'package:wuzzufy/widgets/JobWidget.dart';
import 'package:provider/provider.dart';
class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    JobsProvider provider = Provider.of<JobsProvider>(context , listen: false);

    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    databaseProvider.getSavedJobsIds(context);

    provider.getCategory(context , category.id);
    return Scaffold(
      appBar: AppBar(title: Text(category.name),centerTitle: true,),
      body: Consumer<JobsProvider>(
        builder: (context, value, child) {
          print(value.isError);
          if (value.isError) {
            return IsErrorWidget(
              error: value.error,
              onRetry: (){
                //refresh(context, provider);
              },
            );
          }

          if (value.categoryJobs == null) {
            return IsLoadingWidget();
          }

          if (value.categoryJobs.isEmpty) {
            return IsEmptyWidget();
          }

          return LazyLoadScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == value.categoryJobs.length &&
                    value.categoryJobs.length - value.adsCount < value.categoryCount) {
                  return IsLoadingWidget();
                }

                if (value.categoryJobs.elementAt(index).isAds) {
                  return AdsWidget();
                }
                return JobWidget(
                  job: value.categoryJobs.elementAt(index),
                );
              },
              itemCount:  value.categoryJobs.length - value.adsCount < value.categoryCount
                  ? value.categoryJobs.length + 1
                  : value.categoryJobs.length,
            ),
            onEndOfPage: () {
              if (value.categoryJobs.length - value.adsCount < value.categoryCount) {
                value.categoryFrom = value.categoryFrom + Config.LIST_LIMIT;
                value.getCategory(context , category.id);
              }
            },
          );
        },
      ),
    );
  }
}
