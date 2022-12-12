import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:wuzzufy/providers/UtilsProvider.dart';
import 'package:provider/provider.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
        pages: [
          PageViewModel(
            titleWidget: Text(
              "وظايفي",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
            bodyWidget: Text(
              "اكبر تجمع للوظائف بين ايديك",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
            ),
            image: Image.asset("assets/images/ic_logo.png"),
            footer: Text(
              "اكبر محرك بحث للوظائف بين ايديك",
              textAlign: TextAlign.center,
              style: TextStyle(backgroundColor: Colors.black , color: Colors.white ,fontWeight: FontWeight.w100, fontSize: 30),
            ),
            decoration: PageDecoration(
              footerPadding: EdgeInsets.only(top: 30),
            ),
          ),

          PageViewModel(
            titleWidget: Text(
              "وظايفي",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
            bodyWidget: Text(
              "اكبر تجمع للوظائف بين ايديك",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
            ),
            footer: Text(
              "اكثر من 10000 وظيفة في مختلف المجالات",
              textAlign: TextAlign.center,
              style: TextStyle(backgroundColor: Colors.black , color: Colors.white ,fontWeight: FontWeight.w100, fontSize: 30),
            ),
            decoration: PageDecoration(
              footerPadding: EdgeInsets.only(top: 30),
            ),
            image: Image.asset("assets/images/ic_logo.png"),
          ),

          PageViewModel(
            titleWidget: Text(
              "وظايفي",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
            bodyWidget: Text(
              "اكبر تجمع للوظائف بين ايديك",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
            ),
            footer: Text(
              "تقدر تبحث عن اي وظيفة من موقع معين او فئة معينه بسهوله",
              textAlign: TextAlign.center,
              style: TextStyle(backgroundColor: Colors.black , color: Colors.white ,fontWeight: FontWeight.w100, fontSize: 30),
            ),
            decoration: PageDecoration(
              footerPadding: EdgeInsets.only(top: 30),
            ),
            image: Image.asset("assets/images/job-search.png"),
          ),

          PageViewModel(
            titleWidget: Text(
              "وظايفي",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
            bodyWidget: Text(
              "اكبر تجمع للوظائف بين ايديك",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
            ),
            footer: Text(
              "يمكنك حفظ الوظائف او مشاركتها علي السوشيال",
              textAlign: TextAlign.center,
              style: TextStyle(backgroundColor: Colors.black , color: Colors.white ,fontWeight: FontWeight.w100, fontSize: 30),
            ),
            decoration: PageDecoration(
              footerPadding: EdgeInsets.only(top: 30),
            ),
            image: Icon(Icons.font_download_outlined , size: 230,),
          ),

          PageViewModel(
            titleWidget: Text(
              "وظايفي",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
            bodyWidget: Text(
              "اكبر تجمع للوظائف بين ايديك",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
            ),
            footer: Text(
              "يمكنك حفظ الوظائف وتصفحها فيما بعد بدون انترنت من المحفوظاات",
              textAlign: TextAlign.center,
              style: TextStyle(backgroundColor: Colors.black , color: Colors.white ,fontWeight: FontWeight.w100, fontSize: 20),
            ),
            decoration: PageDecoration(
              footerPadding: EdgeInsets.only(top: 30),
            ),
            image: Icon(FontAwesome.save , size: 200,),
          ),

          PageViewModel(
            titleWidget: Text(
              "وظايفي",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
            bodyWidget: Text(
              "اكبر محرك بحث للوظائف بين ايديك",
              style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
            ),
            footer: Text(
              "يجب منح الصلاحيات للتطبيق ليعمل بشكل سليم",
              textAlign: TextAlign.center,
              style: TextStyle(backgroundColor: Colors.black , color: Colors.white ,fontWeight: FontWeight.w100, fontSize: 20),
            ),
            decoration: PageDecoration(
              footerPadding: EdgeInsets.only(top: 30),
            ),
            image: Icon(FontAwesome.shield , size: 200,),
          ),
        ],
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Theme.of(context).accentColor,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)
            )
        ),
        next: Icon(Icons.arrow_forward_ios),
        onDone: () async {
          UtilsProvider utilsProvider =
          Provider.of<UtilsProvider>(context, listen: false);

          await utilsProvider.checkPermissions();

          await utilsProvider.setFirstOpen();
        },
        done: Text(
          "فهمت",
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),
        ));
  }
}
