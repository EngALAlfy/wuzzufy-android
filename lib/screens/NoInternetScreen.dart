import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                MaterialIcons.network_check,
                size: 100,
              ),
              Text(
                "انقطع اتصال الانترنت",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 30),
              ),
              Text(
                "تأكد من تشغيل الواي فاي او بيانات الهاتف لاستكمال استخدام التطبيق",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                child: Text(
                  "عرض المحفوظات",
                  style: TextStyle(
                      color: Colors.blue, decoration: TextDecoration.underline),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
