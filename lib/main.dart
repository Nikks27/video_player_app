import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player_app/provider/video_provider.dart';
import 'package:video_player_app/view/screens/home_page.dart';
import 'package:video_player_app/view/screens/splashscreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => VideoProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/' : (context)=> SplashScreen(),
          '/home' : (context)=> AhaHomePage(),
        },
      ),
    );
  }
}