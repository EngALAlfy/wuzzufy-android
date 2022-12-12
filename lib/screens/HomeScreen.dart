import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:wuzzufy/pages/CategoriesPage.dart';
import 'package:wuzzufy/pages/JobsPage.dart';
import 'package:wuzzufy/pages/ProvidersPage.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _index = 0;

  Widget body = JobsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: onTap,
        selectedItemColor: Theme.of(context).accentColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline), label: "الوظايف"),
          BottomNavigationBarItem(icon: Icon(Icons.format_list_numbered_rtl), label: "الاقسام"),
          BottomNavigationBarItem(icon: Icon(Icons.language), label: "المصادر"),
        ],),
    );
  }

  void onTap(int value) {
    setState(() {
      switch (value) {
        case 0:
          body = JobsPage();
          break;
        case 1:
          body = CategoriesPage();
          break;
        case 2:
          body = ProvidersPage();
          break;
      }
      _index = value;
    });
  }
}
