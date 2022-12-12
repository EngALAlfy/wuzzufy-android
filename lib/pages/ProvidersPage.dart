import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:wuzzufy/providers/ProvidersProvider.dart';
import 'package:wuzzufy/screens/search/SearchProvidersScreen.dart';
import 'package:wuzzufy/utils/Config.dart';
import 'package:wuzzufy/widgets/AdsWidget.dart';
import 'package:wuzzufy/widgets/IsEmptyWidget.dart';
import 'package:wuzzufy/widgets/IsErrorWidget.dart';
import 'package:wuzzufy/widgets/IsLoadingWidget.dart';
import 'package:wuzzufy/widgets/ProviderWidget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class ProvidersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProvidersProvider provider = Provider.of<ProvidersProvider>(context, listen: false);
    provider.getAll(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('المصادر'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(FontAwesome.refresh),
              onPressed: () {
                refresh(context , provider);
              }),
          IconButton(icon: Icon(FontAwesome.search), onPressed: () {
            Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: SearchProvidersScreen()));
          }),
        ],
      ),
      body: Consumer<ProvidersProvider>(
        builder: (context, value, child) {
          if (value.isError) {
            return IsErrorWidget(
              error: value.error,
              onRetry: (){
                refresh(context, value);
              },
            );
          }

          if (value.providers == null) {
            return IsLoadingWidget();
          }

          if (value.providers.isEmpty) {
            return IsEmptyWidget();
          }

          return LazyLoadScrollView(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == value.providers.length &&
                    value.providers.length - value.adsCount < value.count) {
                  return IsLoadingWidget();
                }

                if (value.providers.elementAt(index).isAds) {
                  return AdsWidget();
                }
                return ProviderWidget(
                  provider: value.providers.elementAt(index),
                );
              },
              itemCount:  value.providers.length - value.adsCount < value.count
                  ? value.providers.length + 1
                  : value.providers.length,
            ),
            onEndOfPage: () {
              if (value.providers.length - value.adsCount < value.count) {
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
