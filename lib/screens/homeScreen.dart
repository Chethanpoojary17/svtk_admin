import 'package:flutter/material.dart';
import 'package:skvt_admin/screens/circularScreen.dart';
import 'package:skvt_admin/screens/eventScreen.dart';
import 'package:skvt_admin/screens/galleryScreen.dart';
import 'package:skvt_admin/screens/sevaScreen.dart';
import 'package:skvt_admin/widgets/homeButtons.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = "/home";
  String title = "Sevas";

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "SVTK ADMIN PANEL",
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        body: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              HomeButtons(
                mediaQuery: _mediaQuery,
                title: "SEVA LIST",
                route: SevaScreen.routeName,
              ),
              HomeButtons(
                  mediaQuery: _mediaQuery,
                  title: "GALLERY",
                  route: GalleryScreen.routeName),
              HomeButtons(
                  mediaQuery: _mediaQuery,
                  title: "EVENTS",
                  route: EventScreen.routeName),
              HomeButtons(
                  mediaQuery: _mediaQuery,
                  title: "CIRCULARS",
                  route: CircularScreen.routeName),
            ],
          ),
        ));
  }
}
