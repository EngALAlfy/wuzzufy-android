import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wuzzufy/models/Job.dart';
import 'package:wuzzufy/providers/AdsProvider.dart';
import 'package:wuzzufy/providers/DatabaseProvider.dart';
import 'package:wuzzufy/providers/JobsProvider.dart';
import 'package:wuzzufy/screens/WebViewScreen.dart';
import 'package:wuzzufy/utils/Config.dart';
import 'package:wuzzufy/widgets/AdsWidget.dart';
import 'package:wuzzufy/widgets/IsErrorWidget.dart';
import 'package:wuzzufy/widgets/IsLoadingWidget.dart';
import 'package:wuzzufy/utils/timeAgo.dart' as timeAgo;

class JobScreen extends StatelessWidget {
  final int id;

  const JobScreen({Key key, this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    JobsProvider provider = Provider.of<JobsProvider>(context, listen: false);

    DatabaseProvider databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);
    databaseProvider.getSavedJobsIds(context);

    provider.get(context, id);

    return Consumer<JobsProvider>(
      builder: (context, value, child) {
        if (value.isError) {
          return IsErrorWidget(
            error: value.error,
            onRetry: () {
              refresh(context);
            },
          );
        }

        if (value.job == null) {
          return IsLoadingWidget();
        }

        return jobBody(context, value);
      },
    );
  }

  Widget jobBody(BuildContext context, JobsProvider value) {
    return Scaffold(
      floatingActionButton: Consumer<DatabaseProvider>(
        builder: (context, databaseProvider, child) {
          bool isSaved = databaseProvider.ids == null
              ? false
              : databaseProvider.ids.contains(value.job.id);

          return FloatingActionButton(
            onPressed: () async {
              if (isSaved) {
                await databaseProvider.removeJobFromSaved(context, value.job);
              } else {
                await databaseProvider.addJobToSaved(context, value.job);
              }
            },
            child: Icon(isSaved ? Icons.star_rate : Icons.star_rate_outlined),
          );
        },
      ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 350.0,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                title: Text(value.job.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
                background: (value.job.provider.photo != null &&
                        value.job.provider.photo.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: Config.PROVIDERS_PHOTO_URL +
                            "/" +
                            value.job.provider.photo,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              alignment: Alignment.center,
                              fit: BoxFit.contain,
                              image: imageProvider,
                            ),
                            shape: BoxShape.rectangle,
                          ),
                        ),
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Icon(
                            Icons.work_outline,
                            size: 150,
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.work_outline,
                          size: 150,
                        ),
                      ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: jobDetails(context, value),
        ),
      ),
    );
  }

  void refresh(BuildContext context) {
    JobsProvider provider = Provider.of<JobsProvider>(context, listen: false);
    provider.clearJob();
    provider.get(context, id);
  }

  jobDetails(BuildContext context, JobsProvider value) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AdsWidget(
              bannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          jobInfo(value.job),
          SizedBox(
            height: 20,
          ),
          timeAndUserInfo(value.job),
          SizedBox(
            height: 20,
          ),
          buttons(context, value.job),
          SizedBox(
            height: 10,
          ),
          Center(
            child: AdsWidget(
              bannerSize: AdmobBannerSize.MEDIUM_RECTANGLE,
            ),
          ),
        ],
      ),
    );
  }

  jobInfo(job) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: Text(
              job.title,
              style: TextStyle(
                  color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Center(
            child: AdsWidget(
              bannerSize: AdmobBannerSize.BANNER,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          jobDesc(job),
        ],
      ),
    );
  }

  timeAndUserInfo(job) {
    return Row(
      children: [
        Text(timeAgo.format(DateTime.parse(job.createdAt))),
        Spacer(),
        Text(" بواسطة ${job.added_admin.name}"),
      ],
    );
  }

  buttons(context, job) {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        TextButton.icon(
          icon: Icon(Icons.open_in_browser_outlined),
          onPressed: () {
            Provider.of<AdsProvider>(context, listen: false).getReward(() {
              Navigator.push(context, PageTransition(
                  child: WebViewScreen(
                    job: job,
                  ),
                  type: PageTransitionType.leftToRight),);
              //open(job.url);
            });
          },
          label: Text("فتح"),
        ),
        TextButton.icon(
          icon: Icon(Icons.email_outlined),
          onPressed: () {
            Provider.of<AdsProvider>(context, listen: false).getFullScreen(() {
              mailto(job);
            });
          },
          label: Text("ارسال"),
        ),
        TextButton.icon(
          icon: Icon(Icons.share),
          onPressed: () {
            Provider.of<AdsProvider>(context, listen: false).getFullScreen(() {
              share(job);
            });
          },
          label: Text("شارك"),
        ),
      ],
    );
  }

  open(url) async {
    if (url != null && url.isNotEmpty) {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        if (!url.startsWith("http")) {
          url = "http://$url";
        }

        if (await canLaunch(url)) {
          await launch(url);
        } else {
          // error
          EasyLoading.showError("لا يمكن فتح الرابط");
        }
      }
    } else {
      EasyLoading.showError("الرابط فارغ");
    }
  }

  mailto(job) async {
    String url = "mailto:?subject=${job.title}" +
        "&body=" +
        job.title +
        "\n" +
        "https://wuzzufy.me/${job.id}";
    await launch(Uri.encodeFull(url));
  }

  share(job) async {
    String shareBody = job.title + "\n" + "https://wuzzufy.me/${job.id}";

    await Share.share(shareBody);
  }

  jobDesc(Job job) {
    var adEveryLines = 5;
    var lines = job.desc.split("\n");
    var adsCount = lines.length ~/ adEveryLines;

    for (var i = 1; i <= adsCount; i++) {
      lines.insert((i * adEveryLines) + (i - 1), "ad");
    }

    return ListView.builder(
      itemBuilder: (context, i) {
        if (lines.elementAt(i) != "ad") {
          return Text(lines.elementAt(i));
        } else {
          return AdsWidget(
            bannerSize: AdmobBannerSize.BANNER,
          );
        }
      },
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: lines.length,
    );
  }
}
