import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HomeButtons extends StatelessWidget {
  const HomeButtons({
    Key key,
    @required Size mediaQuery,
    @required this.title,
    @required this.route,
  })  : _mediaQuery = mediaQuery,
        super(key: key);

  final Size _mediaQuery;
  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(10),
      child: InkWell(
        splashColor: Theme.of(context).accentColor,
        onTap: () {
          Navigator.of(context).pushNamed(route);
        },
        child: Container(
          width: _mediaQuery.width * 0.2,
          height: _mediaQuery.height * 0.3,
          alignment: Alignment.center,
          child: Row(
            children: [
              Container(
                width: 10,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(
                width: 50,
              ),
              AutoSizeText(
                title,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                minFontSize: 25,
                maxFontSize: 40,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
