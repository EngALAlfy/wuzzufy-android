import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:wuzzufy/providers/CategoriesProvider.dart';
import 'package:wuzzufy/screens/search/SearchCategoriesScreen.dart';
import 'package:wuzzufy/utils/Config.dart';
import 'package:wuzzufy/widgets/AdsWidget.dart';
import 'package:wuzzufy/widgets/CategoryWidget.dart';
import 'package:wuzzufy/widgets/IsEmptyWidget.dart';
import 'package:wuzzufy/widgets/IsErrorWidget.dart';
import 'package:wuzzufy/widgets/IsLoadingWidget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CategoriesProvider provider = Provider.of<CategoriesProvider>(context, listen: false);
    provider.getAll(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('الاقسام'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(FontAwesome.refresh),
              onPressed: () {
                refresh(context , provider);
              }),
          IconButton(icon: Icon(FontAwesome.search), onPressed: () {
            Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: SearchCategoriesScreen()));
          }),
        ],
      ),
      body: Consumer<CategoriesProvider>(
        builder: (context, value, child) {
          print("is Erro : ${value.isError}");
          if (value.isError) {
            return IsErrorWidget(
              error: value.error,
              onRetry: (){
                refresh(context, value);
              },
            );
          }

          if (value.categories == null) {
            return IsLoadingWidget();
          }

          if (value.categories.isEmpty) {
            return IsEmptyWidget();
          }

          return LazyLoadScrollView(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == value.categories.length &&
                    value.categories.length - value.adsCount < value.count) {
                  return IsLoadingWidget();
                }

                if (value.categories.elementAt(index).isAds) {
                  return AdsWidget();
                }
                return CategoryWidget(
                  category: value.categories.elementAt(index),
                );
              },
              itemCount:  value.categories.length - value.adsCount < value.count
                  ? value.categories.length + 1
                  : value.categories.length,
            ),
            onEndOfPage: () {
              if (value.categories.length - value.adsCount < value.count) {
                value.from = value.from + Config.LIST_LIMIT;
                value.getAll(context);
              }
            },
          );
        },
      ),
    );
  }

  refresh(context , provider) {
    provider.clear();
    provider.getAll(context);
  }
}
