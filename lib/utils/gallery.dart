import 'dart:convert';

import 'package:http/http.dart' as http;

class Gallery {
  List _folders = [];
  List _images = [];

  Future<void> getData() async {
    final response = await http
        .get("http://svtkallianpur.com/wp-content/getGalleryFolders.php");
    final data = json.decode(response.body);
    _folders = data["gallery"];
  }

  List getGalleryFolders() {
    return _folders;
  }

  Future<void> addFolder(
      String name, String foldername, String previmage, String date) async {
    final response = await http
        .post("http://svtkallianpur.com/wp-content/php/addGallery.php", body: {
      "name": name,
      "folder_name": foldername,
      "prev_image": previmage,
      "date": date,
    });
  }
}
