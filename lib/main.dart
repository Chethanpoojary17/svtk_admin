import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skvt_admin/screens/circularScreen.dart';
import 'package:skvt_admin/screens/eventScreen.dart';
import 'package:skvt_admin/screens/galleryScreen.dart';
import 'package:skvt_admin/screens/homeScreen.dart';
import 'package:skvt_admin/screens/sevaScreen.dart';

void main() async {
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SVTK Admin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff650D01),
        accentColor: Color(0xffECB840),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: HomeScreen(),
      routes: {
        HomeScreen.routeName: (ctx) => HomeScreen(),
        SevaScreen.routeName: (ctx) => SevaScreen(),
        EventScreen.routeName: (ctx) => EventScreen(),
        GalleryScreen.routeName: (ctx) => GalleryScreen(),
        CircularScreen.routeName: (ctx) => CircularScreen(),
      },
    );
  }
}
