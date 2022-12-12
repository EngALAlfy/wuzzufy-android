import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:wuzzufy/providers/DatabaseProvider.dart';
import 'package:wuzzufy/providers/JobsProvider.dart';
import 'package:wuzzufy/utils/Config.dart';
import 'package:wuzzufy/widgets/IsEmptyWidget.dart';
import 'package:wuzzufy/widgets/IsErrorWidget.dart';
import 'package:wuzzufy/widgets/IsLoadingWidget.dart';
import 'package:wuzzufy/widgets/JobWidget.dart';
import 'package:wuzzufy/widgets/SearchHintWidget.dart';
import 'package:provider/provider.dart';

class SearchJobsScreen extends StatefulWidget {
  @override
  _SearchJobsScreenState createState() => _SearchJobsScreenState();
}

class _SearchJobsScreenState extends State<SearchJobsScreen> {
  TextEditingController searchController = TextEditingController();
  ValueNotifier notifier = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    JobsProvider provider = Provider.of<JobsProvider>(context, listen: false);

    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    databaseProvider.getSavedJobsIds(context);

    return Scaffold(
      appBar: AppBar(
        title: searchText(provider),
        titleSpacing: 0.0,
        centerTitle: true,
        actions: [
          ValueListenableBuilder(
            valueListenable: notifier,
            builder: (context, value, child) => IconButton(
                icon: const Icon(
                  Icons.search,
                ),
                onPressed: value
                    ? () {
                        provider.searchQuery = searchController.text;
                        provider.search(context);
                      }
                    : null),
          ),
        ],
      ),
      body: Consumer<JobsProvider>(
        builder: (context, value, child) {
          if (value.isError) {
            return IsErrorWidget(
              error: value.error,
            );
          }

          if (value.searchResult == null && !value.isSearching) {
            return SearchHintWidget();
          }

          if (value.searchResult == null && value.isSearching) {
            return IsLoadingWidget();
          }

          if (value.searchResult.isEmpty) {
            return IsEmptyWidget();
          }

          return LazyLoadScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == value.searchResult.length &&
                    value.searchResult.length - value.adsCount < value.searchCount) {
                  return IsLoadingWidget();
                }

                return JobWidget(
                  job: value.searchResult.elementAt(index),
                );
              },
              itemCount: value.searchResult.length - value.adsCount < value.searchCount
                  ? value.searchResult.length + 1
                  : value.searchResult.length,
            ),
            onEndOfPage: () {
              if (value.searchResult.length - value.adsCount <
                  value.searchCount) {
                value.searchFrom = value.searchFrom + Config.LIST_LIMIT;
                value.search(context);
              }
            },
          );
        },
      ),
    );
  }

  searchText(provider) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Padding(
        padding: EdgeInsets.only(right: 20, left: 20, bottom: 10),
        child: TextField(
          autofocus: true,
          controller: searchController,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            provider.searchQuery = searchController.text;
            provider.search(context);
          },
          onChanged: (value) =>
              value.isNotEmpty ? notifier.value = true : notifier.value = false,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10),
            hintText: "ادخل كلمة البحث",
            hintStyle: TextStyle(fontSize: 14, color: Colors.white),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    Provider.of<JobsProvider>(context, listen: false).searchClear();
    searchController.dispose();
    super.dispose();
  }
}
