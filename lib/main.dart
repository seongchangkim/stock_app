import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_app/global/user_global.dart';
import 'package:stock_app/pages/menu_select.dart';
import 'package:stock_app/pages/stock/stock_porfolio_detail_view.dart';
import 'package:stock_app/pages/stock/stock_portfolio_create_or_edit_page.dart';
import 'package:stock_app/pages/user/sign_up_view.dart';
import 'package:stock_app/pages/user/login_view.dart';
import 'package:stock_app/api/user_api.dart';
import 'package:stock_app/pages/user/user_profile_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stock_app/firebase_options.dart';
import 'package:stock_app/pages/splash_page.dart';

final List<String> stockList = [];
final DateTime now = DateTime.now();

void main() async {
  WidgetsBinding widgetBinding = WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: _navigatorKey,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      onGenerateRoute: (settings) {
        print("argument : ${settings.arguments.toString()}");
        Map params = (settings.arguments ?? {}) as Map;
        // print("params type: ${params.runtimeType}");

        var routes = {
          '/appMenu': const AppMenu(),
          '/loginPage': const LoginView(),
          '/signUpPage': const SignUpPage(),
          '/myProfilePage': MyProfileView(user: params['user']),
          '/stockPortfolioCreatePage': const StockPortfolioCreateOrEditPage(),
          '/stockPortfolioDetailPage' : StockPorfolioDetailView(portIndex: params['portIndex'] ?? 0),
          '/stockPortfolioEditPage': StockPortfolioCreateOrEditPage(symbolRatioList: params['symbolRatioList'] ?? [], info: params['info'] ?? {}, isEditPortfolio: true,)
        };

        var getMoveRouteName = settings.name;

        print("routes : ${routes[getMoveRouteName]!}");

        return MaterialPageRoute(
            settings: settings,
            builder: (context) => routes[getMoveRouteName]!);
      },
    );  
  }
}