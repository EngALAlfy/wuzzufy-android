import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wuzzufy/providers/AdsProvider.dart';
class AdsWidget extends StatelessWidget {
  final AdmobBannerSize bannerSize ;

  const AdsWidget({Key key, this.bannerSize = AdmobBannerSize.MEDIUM_RECTANGLE}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AdsProvider>(
      builder: (context, value, child) {
        return value.getBanner(size: bannerSize);
      },
    );
  }
}
