import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:wuzzufy/models/Provider.dart' as model;
import 'package:wuzzufy/providers/AdsProvider.dart';
import 'package:wuzzufy/screens/ProviderScreen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wuzzufy/widgets/ProfileImageWidget.dart';

class ProviderWidget extends StatefulWidget {
  final model.Provider provider;

  const ProviderWidget({Key key, this.provider}) : super(key: key);

  @override
  _ProviderWidgetState createState() => _ProviderWidgetState();
}

class _ProviderWidgetState extends State<ProviderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: () {
          Navigator.push(
              context,
              PageTransition(
                  child: ProviderScreen(
                    provider: widget.provider,
                  ),
                  type: PageTransitionType.bottomToTop));
        },
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ProfileImageWidget(
              url: widget.provider.photo,
              errorIcon: Icons.work_outline,
              radius: 30.0,
            ),
            SizedBox(
              width: 10,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.provider.name,
                    style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    child: Text(
                        widget.provider.url
                            .replaceAll("https://", "")
                            .replaceAll("http://", ""),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.blueAccent,
                            decoration: TextDecoration.underline)),
                    onTap: () {
                      Provider.of<AdsProvider>(context , listen: false).getFullScreen((){
                        open();
                      });
                    },
                  ),
                  Text(widget.provider.desc),
                ],
              ),
            ),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios_outlined),
      ),
    );
  }

  open() async {
    String url = widget.provider.url;
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
}
