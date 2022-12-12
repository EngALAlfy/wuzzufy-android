import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:wuzzufy/models/Job.dart';
import 'package:wuzzufy/widgets/AdsWidget.dart';

class WebViewScreen extends StatefulWidget {

  final Job job;

  const WebViewScreen({Key key, this.job}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  WebViewController _controller;
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.job.title),
        actions: [
          IconButton(
            icon: Icon(MaterialCommunityIcons.reload),
            onPressed: () => _controller.reload(),
          ),
          IconButton(
            icon: Icon(MaterialCommunityIcons.home),
            onPressed: () => _controller.loadUrl(widget.job.url),
          ),
        ],
      ),
      body: Column(
        children: [
          AdsWidget(
            bannerSize: AdmobBannerSize.BANNER,
          ),
          Expanded(
            child: WebView(
              allowsInlineMediaPlayback: true,
              onWebViewCreated: (controller) => _controller = controller,
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.job.url,
              onProgress: (progress) {
                if (progress > 90) {
                  EasyLoading.dismiss(animation: true);
                }
              },
              onPageStarted: (url) => EasyLoading.show(
                  dismissOnTap: false, maskType: EasyLoadingMaskType.black),
            ),
          ),
        ],
      ),
      bottomNavigationBar: AdsWidget(
        bannerSize: AdmobBannerSize.BANNER,
      ),
    );
  }
}
