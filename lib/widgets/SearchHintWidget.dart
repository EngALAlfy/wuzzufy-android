import 'package:flutter/material.dart';

class SearchHintWidget extends StatefulWidget {
  @override
  _SearchHintWidgetState createState() => _SearchHintWidgetState();
}

class _SearchHintWidgetState extends State<SearchHintWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text("ادخل الكلمة المراد البحث عنها ثم اضغط علي بحث."),),);
  }
}
