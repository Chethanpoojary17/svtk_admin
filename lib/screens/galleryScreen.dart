import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skvt_admin/utils/gallery.dart';
import 'package:http/http.dart' as http;
import 'package:skvt_admin/widgets/galleryCard.dart';

class GalleryScreen extends StatefulWidget {
  GalleryScreen({Key key}) : super(key: key);
  static const routeName = "/gallery";

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoad = true;
  bool _isCheck = true;
  Gallery _gallery = Gallery();
  TextEditingController _name = new TextEditingController();
  TextEditingController _folderName = new TextEditingController();
  TextEditingController _prevImg = new TextEditingController();
  bool formLoad = false;
  DateTime _currentDate = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  String date = "";

  Future<void> _datePicker() async {
    _selectedDate = await showDatePicker(
      context: context,
      initialDate: _currentDate,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (_selectedDate != null) {
      date = DateFormat('dd/MM/yyyy').format(_selectedDate);
    }
    return;
  }

  addFolder(
      String name, String foldername, String previmage, String date) async {
    if (name.isEmpty ||
        foldername.isEmpty ||
        previmage.isEmpty ||
        date.isEmpty) {
      _scaffoldKey.currentState
          .showSnackBar(snackBar("Please fill all the fields"));
    } else {
      formLoad = true;
      setState(() {});
      final response = await http.post(
          "http://svtkallianpur.com/wp-content/php/addGallery.php",
          body: {
            "name": name,
            "folder_name": foldername,
            "prev_image": previmage,
            "date": date,
          });
      if (response.body == "yes") {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(snackBar("Successfull!!"));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).popAndPushNamed(GalleryScreen.routeName);
          setState(() {});
        });
      } else {
        _scaffoldKey.currentState
            .showSnackBar(snackBar("Something went wrong"));
      }
      formLoad = false;
      setState(() {});
    }
  }

  updateFolder(String id, String name, String foldername, String previmage,
      String date) async {
    if (name.isEmpty ||
        foldername.isEmpty ||
        previmage.isEmpty ||
        date.isEmpty) {
      _scaffoldKey.currentState
          .showSnackBar(snackBar("Please fill all the fields"));
    } else {
      formLoad = true;
      setState(() {});
      final response = await http.post(
          "http://svtkallianpur.com/wp-content/php/editGallery.php",
          body: {
            "id": id,
            "name": name,
            "folder_name": foldername,
            "prev_image": previmage,
            "date": date,
          });
      if (response.body == "yes") {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(snackBar("Successfull!!"));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).popAndPushNamed(GalleryScreen.routeName);
          setState(() {});
        });
      } else {
        _scaffoldKey.currentState
            .showSnackBar(snackBar("Something went wrong"));
      }
      formLoad = false;
      setState(() {});
    }
  }

  buildAlertDialog(Size _mediaQuery, BuildContext context,
      [String id = "",
      String name,
      String foldername,
      String previmg,
      DateTime updatedate]) {
    if (id.isNotEmpty) {
      _name.text = name;
      _folderName.text = foldername;
      _prevImg.text = previmg;
      date = DateFormat('dd/MM/yyyy').format(updatedate);
    }
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: Container(
              height: _mediaQuery.height * 0.4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _name,
                    decoration: InputDecoration(
                      hintText: "Enter the Title",
                      labelText: "Folder Title",
                      hintStyle: TextStyle(fontSize: 20),
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    controller: _folderName,
                    decoration: InputDecoration(
                      hintText: "Enter the Folder Name",
                      labelText: "Folder Name",
                      hintStyle: TextStyle(fontSize: 20),
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    controller: _prevImg,
                    decoration: InputDecoration(
                      hintText: "Enter the Image Name",
                      labelText: "Preview Image",
                      hintStyle: TextStyle(fontSize: 20),
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(date.isEmpty ? "Not selected" : date),
                      FlatButton(
                          onPressed: () async {
                            await _datePicker();
                            setState(() {});
                          },
                          child: Text(
                            "Change Date",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (id.isEmpty) {
                        addFolder(
                          _name.text,
                          _folderName.text,
                          _prevImg.text,
                          _selectedDate.toString(),
                        );
                      } else {
                        updateFolder(
                          id,
                          _name.text,
                          _folderName.text,
                          _prevImg.text,
                          _selectedDate.toString(),
                        );
                      }
                    },
                    child: formLoad
                        ? Center(child: CircularProgressIndicator())
                        : Text(
                            "Submit",
                            style: TextStyle(color: Colors.white),
                          ),
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  SnackBar snackBar(String responseNotify) {
    return SnackBar(
      backgroundColor: Theme.of(context).primaryColor,
      content: Text(
        responseNotify,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      duration: Duration(seconds: 2),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQuery = MediaQuery.of(context).size;
    if (_isCheck) {
      _gallery.getData().whenComplete(() {
        _isLoad = false;
        setState(() {});
      });
      _isCheck = false;
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Gallery"),
      ),
      body: _isLoad
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GalleryCard(
              gallery: _gallery,
              mediaQuery: _mediaQuery,
              buildDialog: buildAlertDialog,
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          buildAlertDialog(_mediaQuery, context);
        },
      ),
    );
  }
}
