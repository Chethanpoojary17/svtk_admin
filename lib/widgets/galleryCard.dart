import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:skvt_admin/utils/gallery.dart';

class GalleryCard extends StatelessWidget {
  const GalleryCard({
    Key key,
    @required Gallery gallery,
    @required Size mediaQuery,
    @required this.buildDialog,
  })  : _gallery = gallery,
        _mediaQuery = mediaQuery,
        super(key: key);

  final Gallery _gallery;
  final Size _mediaQuery;
  final Function buildDialog;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(20),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 8,
      children: List.generate(_gallery.getGalleryFolders().length, (index) {
        return Card(
          child: Stack(
            children: [
              Center(
                child: AutoSizeText(
                  _gallery.getGalleryFolders()[index]["name"],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      final parsedDate = DateTime.parse(
                          _gallery.getGalleryFolders()[index]["date"]);
                      final id = _gallery.getGalleryFolders()[index]["id"];
                      final name = _gallery.getGalleryFolders()[index]["name"];
                      final foldername =
                          _gallery.getGalleryFolders()[index]["folder_name"];
                      final previmage =
                          _gallery.getGalleryFolders()[index]["prev_image"];
                      buildDialog(_mediaQuery, context, id, name, foldername,
                          previmage, parsedDate);
                    }),
              )
            ],
          ),
        );
      }),
    );
  }
}
