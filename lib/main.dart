// import 'package:firebase_core/firebase_core.dart';

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hiptech_app/detail.dart';
import 'package:hiptech_app/home.dart';
import 'package:hiptech_app/login.dart';
import 'package:hiptech_app/provider/userProfile_Provider.dart';
import 'package:hiptech_app/sent.dart';
import 'package:hiptech_app/store.dart';

import 'package:hiptech_app/timing.dart';
import 'package:hiptech_app/welcome.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'provider/fetchNotification_Provider.dart';

// import 'api/firebase.dart';

void main() async {
  // SystemChrome.setSystemUIOverlayStyle(
  //     const SystemUiOverlayStyle(statusBarColor: Colors.transparent)); //ẩn viền màu nâu ở top đth
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => UserProfileProvider()),
    ChangeNotifierProvider(create: (_) => FetchNotifiCationProvider()),
  ], child: const MyApp())
      // ChangeNotifierProvider(
      //     create: (context) => UserProfileProvider(), child: const MyApp()),
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // scrollBehavior: NoThumbScrollBehavior().copyWith(scrollbars: false),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginPage(),
        '/': (context) => const WelcomePage(),
        '/home': (context) => const HomePage(),
        '/detail': (context) => const DetailPage(),
        '/sent': (context) => const SentPage(),
        '/timing': (context) => const TimingPage(),
        '/store': (context) => const StorePage(),
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
