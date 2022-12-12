import 'package:flutter/material.dart';
import 'package:wuzzufy/models/Category.dart';
import 'package:wuzzufy/screens/CategoryScreen.dart';
import 'package:page_transition/page_transition.dart';

class CategoryWidget extends StatefulWidget {
  final Category category;

  const CategoryWidget({Key key, this.category}) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        onTap: (){
          Navigator.push(context, PageTransition(child: CategoryScreen(category: widget.category,), type: PageTransitionType.bottomToTop));
        },
        leading: CircleAvatar(
          child: Icon(Icons.work_outline),
          radius: 25,
        ),
        title: Text(widget.category.name),
        subtitle: Text(widget.category.desc),
        trailing: Icon(Icons.arrow_forward_ios_outlined),
      ),
    );
  }
}
