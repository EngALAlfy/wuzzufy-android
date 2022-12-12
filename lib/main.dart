import 'package:admob_flutter/admob_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_deep_linking/flutter_deep_linking.dart' as deep;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:wuzzufy/providers/AdsProvider.dart';
import 'package:wuzzufy/providers/CategoriesProvider.dart';
import 'package:wuzzufy/providers/DatabaseProvider.dart';
import 'package:wuzzufy/providers/JobsProvider.dart';
import 'package:wuzzufy/providers/NotificationsProvider.dart';
import 'package:wuzzufy/providers/ProvidersProvider.dart';
import 'package:wuzzufy/providers/UsersProvider.dart';
import 'package:wuzzufy/providers/UtilsProvider.dart';
import 'package:wuzzufy/screens/HomeScreen.dart';
import 'package:wuzzufy/screens/IntroScreen.dart';
import 'package:wuzzufy/screens/JobScreen.dart';
import 'package:wuzzufy/screens/NoInternetScreen.dart';
import 'package:wuzzufy/screens/auth/LoginScreen.dart';
import 'package:wuzzufy/utils/Config.dart';
import 'package:wuzzufy/widgets/IsLoadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => NotificationsProvider(context)),
        ChangeNotifierProvider(create: (context) => UtilsProvider(context)),
        ChangeNotifierProvider(create: (context) => DatabaseProvider()),
        ChangeNotifierProvider(create: (context) => JobsProvider()),
        ChangeNotifierProvider(create: (context) => CategoriesProvider()),
        ChangeNotifierProvider(create: (context) => ProvidersProvider()),
        ChangeNotifierProvider(create: (context) => UsersProvider()),
        ChangeNotifierProvider(create: (context) => AdsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        onGenerateRoute: router.onGenerateRoute,
        supportedLocales: [
          const Locale('ar', ''),
        ],
        theme: ThemeData(
          fontFamily: "cairo",
          //scaffoldBackgroundColor: Colors.white,
          primarySwatch: Config.PRIMARY_COLOR,
          accentColor: Config.ACCENT_COLOR,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        builder: EasyLoading.init(),
        home: Consumer<NotificationsProvider>(
          builder: (context, value, child) {
            // init firebase messaging
            value.init(context);
            return child;
          },
          child: Consumer<UtilsProvider>(
            builder: (context, utils, child) {
              return WillPopScope(
                child: getScreen(utils, child),
                onWillPop: () async {
                  if (!utils.isReviewed && !utils.noInternet) {
                    //rateDialog(context, utils);
                    if (await InAppReview.instance.isAvailable()) {
                      await InAppReview.instance.requestReview();
                    } else {
                      await InAppReview.instance.openStoreListing();
                    }
                    await utils.setReviewed();
                  } else {
                    exitDialog(context);
                  }
                  return false;
                },
              );
            },
            child: IsLoadingWidget(),
          ),
        ),
      ),
    );
  }

  getScreen(UtilsProvider utils, child) {
    if (utils.isLoaded) {
      if (utils.isFirstOpen) {
        return IntroScreen();
      } else {
        if (utils.noInternet) {
          //EasyLoading.showError('لا يوجد انترنت\nيمكنك مشاهدة المحفوظات');
          //return SavedJobsScreen();
          return NoInternetScreen();
        }

        if (utils.isAuth) {
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      }
    }

    return child;
  }

  void exitDialog(context) {
    Alert(context: context, title: "هل تريد الخروج ؟", buttons: [
      DialogButton(
          color: Colors.red,
          child: Text(
            "خروج",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            SystemNavigator.pop();
          }),
      DialogButton(
          color: Colors.blue,
          child: Text(
            "لا",
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pop(context, false);
          }),
    ]).show();
  }

  rateDialog(BuildContext context, utils) {
    Alert(
        context: context,
        type: AlertType.success,
        title: "تقييم",
        desc: "هل اعجبك تطبيقنا ؟ تقييم الان ..!",
        buttons: [
          DialogButton(
              child: Text(
                "تقييم",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
              ),
              color: Colors.green,
              onPressed: () async {
                if (await InAppReview.instance.isAvailable()) {
                  await InAppReview.instance.requestReview();
                } else {
                  await InAppReview.instance.openStoreListing();
                }
                await utils.setReviewed();
                Navigator.pop(context);
              }),
          DialogButton(
              child: Text(
                "لا",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
              ),
              color: Colors.red,
              onPressed: () async {
                await utils.setReviewed();
                Navigator.pop(context);
              }),
          DialogButton(
              child: Text(
                "لاحقا",
                style:
                    TextStyle(fontWeight: FontWeight.w300, color: Colors.white),
              ),
              color: Colors.black,
              onPressed: () {
                SystemNavigator.pop(animated: true);
              }),
        ]).show();
  }

  final router = deep.Router(
    routes: [
      deep.Route(
        // This matches any HTTP or HTTPS URI pointing to schul-cloud.org.
        // Due to `isOptional`, this also matches URIs without a scheme or domain,
        // but not other domains.
        matcher: deep.Matcher.webHost('wuzzufy.me', isOptional: true),
        // These nested routes are evaluated only if the above condition matches.
        routes: [
          deep.Route(
            // {courseId} is a parameter matches a single path segment.
            matcher: deep.Matcher.path('{id}'),
            materialBuilder: (_, deep.RouteResult result) {
              // You can access the matched parameters using `result[<name>]`.
              return JobScreen(
                id: int.parse(result['id']),
              );
            },
          ),
        ],
      ),
    ],
  );
}
