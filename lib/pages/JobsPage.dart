import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:wuzzufy/providers/DatabaseProvider.dart';
import 'package:wuzzufy/providers/JobsProvider.dart';
import 'package:wuzzufy/providers/UtilsProvider.dart';
import 'package:wuzzufy/screens/search/SearchJobsScreen.dart';
import 'package:wuzzufy/utils/Config.dart';
import 'package:wuzzufy/widgets/AdsWidget.dart';
import 'package:wuzzufy/widgets/IsEmptyWidget.dart';
import 'package:wuzzufy/widgets/IsErrorWidget.dart';
import 'package:wuzzufy/widgets/IsLoadingWidget.dart';
import 'package:wuzzufy/widgets/JobWidget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

class JobsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    JobsProvider provider = Provider.of<JobsProvider>(context, listen: false);
    UtilsProvider utilsProvider = Provider.of<UtilsProvider>(context, listen: false);

    DatabaseProvider databaseProvider = Provider.of<DatabaseProvider>(context, listen: false);
    databaseProvider.getSavedJobsIds(context);

    provider.from = 0;
    provider.count = 0;
    provider.getAll(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          shrinkWrap: true,
          children: [
            DrawerHeader(child: Consumer<JobsProvider>(
              builder: (context, value, child) {
                if (value.isError) {
                  return IsErrorWidget(
                    error: value.error,
                  );
                }

                if (value.user == null) {
                  return IsLoadingWidget();
                }

                return ListTile(
                  leading: CircleAvatar(
                    child: Icon(Icons.person),
                    radius: 30,
                  ),
                  title: Text(value.user.name),
                  subtitle: Text(value.user.email),
                  trailing: IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () => value.logoutAndLogin(context),
                  ),
                );
              },
            ),),
            ListTile(
              leading: Icon(Icons.refresh),
              title: Text("تحديث"),
              onTap: () => refresh(context, provider),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.search),
              title: Text("بحث"),
              onTap: () => Navigator.push(
                  context,
                  PageTransition(
                      child: SearchJobsScreen(),
                      type: PageTransitionType.bottomToTop)),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.save_outlined),
              title: Text("المفضلة"),
              onTap: () => utilsProvider.goToSaved(context),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text("الخصوصية"),
              onTap: () => utilsProvider.privacy(context),
            ), Divider(),
            ListTile(
              leading: Icon(Icons.share),
              title: Text("شارك"),
              onTap: () => utilsProvider.shareApp(context),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.star_rate_outlined),
              title: Text("تقييم"),
              onTap: () => utilsProvider.rateApp(context),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("خروج"),
              onTap: () => utilsProvider.logoutAndExist(context),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('الوظايف'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(FontAwesome.refresh),
              onPressed: () {
                refresh(context, provider);
              }),
          IconButton(
              icon: Icon(FontAwesome.search),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: SearchJobsScreen()));
              }),
        ],
      ),
      body: Consumer<JobsProvider>(
        builder: (context, value, child) {
          if (value.isError) {
            return IsErrorWidget(
              error: value.error,
              onRetry: () {
                refresh(context, provider);
              },
            );
          }

          if (value.jobs == null) {
            return IsLoadingWidget();
          }

          if (value.jobs.isEmpty) {
            return IsEmptyWidget();
          }

          return LazyLoadScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index == value.jobs.length &&
                    value.jobs.length - value.adsCount < value.count) {
                  return IsLoadingWidget();
                }

                if (value.jobs.elementAt(index).isAds) {
                  return AdsWidget(
                    bannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
                  );
                }

                return InkWell(
                  child: JobWidget(
                    job: value.jobs.elementAt(index),
                  ),
                  onTap: (){
                    value.goToJob(context, value.jobs.elementAt(index).id);
                  },
                );
              },
              itemCount: value.jobs.length - value.adsCount < value.count
                  ? value.jobs.length + 1
                  : value.jobs.length,
            ),
            onEndOfPage: () {
              if (value.jobs.length - value.adsCount < value.count) {
                value.from = value.from + Config.LIST_LIMIT;
                value.getAll(context);
              }
            },
          );
        },
      ),
    );
  }

  refresh(context, JobsProvider provider) {
    provider.clear();
    provider.getAll(context);
  }
}
