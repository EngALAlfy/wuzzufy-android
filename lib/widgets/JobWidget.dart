import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:wuzzufy/models/Job.dart';
import 'package:wuzzufy/providers/AdsProvider.dart';
import 'package:wuzzufy/providers/DatabaseProvider.dart';
import 'package:wuzzufy/screens/WebViewScreen.dart';
import 'package:wuzzufy/utils/timeAgo.dart' as timeAgo;
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wuzzufy/widgets/AdsWidget.dart';
import 'package:wuzzufy/widgets/ProfileImageWidget.dart';

class JobWidget extends StatefulWidget {
  final Job job;
  final DatabaseProvider databaseProvider;

  const JobWidget({Key key, this.job, this.databaseProvider}) : super(key: key);

  @override
  _JobWidgetState createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      color: Colors.grey.shade100,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          providerInfo(),
          SizedBox(
            height: 20,
          ),
          jobInfo(),
          SizedBox(
            height: 10,
          ),
          Divider(),
          SizedBox(
            height: 10,
          ),
          timeAndUserInfo(),
          SizedBox(
            height: 20,
          ),
          buttons(),
        ],
      ),
    );
  }

  providerInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ProfileImageWidget(
          radius: 30.0,
          url: widget.job.provider.photo,
          errorIcon: Icons.work_outline,
        ),
        SizedBox(
          width: 10,
        ),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.job.provider.name,
                style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              InkWell(
                child: Text(
                    widget.job.provider.url
                        .replaceAll("https://", "")
                        .replaceAll("http://", ""),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.blueAccent,
                        decoration: TextDecoration.underline)),
                onTap: () {
                  Provider.of<AdsProvider>(context, listen: false)
                      .getFullScreen(() {
                    open(widget.job.provider.url);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  jobInfo() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: Text(
              widget.job.title,
              style: TextStyle(
                  color: Colors.green,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
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
          jobDesc(),
        ],
      ),
    );
  }

  timeAndUserInfo() {
    return Row(
      children: [
        Text(
          timeAgo.format(DateTime.parse(widget.job.createdAt)),
          style: TextStyle(color: Colors.grey),
        ),
        Spacer(),
        Text(
          " بواسطة ${widget.job.added_admin.name}",
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }

  buttons() {
    return Wrap(
      direction: Axis.horizontal,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        TextButton.icon(
          icon: Icon(Icons.open_in_browser_outlined),
          onPressed: () {
            Provider.of<AdsProvider>(context, listen: false).getFullScreen(() {
              Navigator.push(
                context,
                PageTransition(
                    child: WebViewScreen(
                      job: widget.job,
                    ),
                    type: PageTransitionType.leftToRight),
              );
              //open(widget.job.url);
            });
          },
          label: Text("فتح"),
        ),
        TextButton.icon(
          icon: Icon(Icons.email_outlined),
          onPressed: () {
            Provider.of<AdsProvider>(context, listen: false).getFullScreen(() {
              mailto();
            });
          },
          label: Text("ارسال"),
        ),
        TextButton.icon(
          icon: Icon(Icons.share),
          onPressed: () {
            Provider.of<AdsProvider>(context, listen: false).getFullScreen(() {
              share();
            });
          },
          label: Text("شارك"),
        ),
        savedButton(),
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

  mailto() async {
    String url = "mailto:?subject=${widget.job.title}" +
        "&body=" +
        widget.job.title +
        "\n" +
        "https://wuzzufy.me/${widget.job.id}";
    await launch(Uri.encodeFull(url));
  }

  share() async {
    String shareBody =
        widget.job.title + "\n" + "https://wuzzufy.me/${widget.job.id}";

    await Share.share(shareBody);
  }

  savedButton() {
    if (widget.databaseProvider != null) {
      bool isSaved = widget.databaseProvider.ids == null
          ? false
          : widget.databaseProvider.ids.contains(widget.job.id);
      return TextButton.icon(
        icon: Icon(isSaved ? Icons.star_rate : Icons.star_rate_outlined),
        onPressed: () async {
          if (isSaved) {
            await widget.databaseProvider
                .removeJobFromSaved(context, widget.job);
          } else {
            await widget.databaseProvider.addJobToSaved(context, widget.job);
          }
        },
        label: Text(isSaved ? "حذف المفضلة" : "المفضلة"),
      );
    } else {
      return Consumer<DatabaseProvider>(
        builder: (context, value, child) {
          bool isSaved =
              value.ids == null ? false : value.ids.contains(widget.job.id);
          return TextButton.icon(
            icon: Icon(isSaved ? Icons.star_rate : Icons.star_rate_outlined),
            onPressed: () async {
              if (isSaved) {
                await value.removeJobFromSaved(context, widget.job);
              } else {
                await value.addJobToSaved(context, widget.job);
              }
            },
            label: Text(isSaved ? "حذف المفضلة" : "المفضلة"),
          );
        },
      );
    }
  }

  jobDesc() {
    if (widget.job.desc.split(" ").length > 12) {
      var line = widget.job.desc.split(" ").getRange(0, 12).join(" ");
      return Text.rich(
             TextSpan(
               text: line, // default text style
               children: <TextSpan>[
                 TextSpan(text: '.....', style: TextStyle(color: Colors.grey)),
                 TextSpan(text: 'المزيد', style: TextStyle(fontWeight: FontWeight.bold , color: Colors.blue , decoration: TextDecoration.underline)),
               ],
             ),
           );
    } else {
      return Text(widget.job.desc);
    }
  }
}
