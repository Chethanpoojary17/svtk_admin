import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:skvt_admin/widgets/circularCard.dart';

class CircularScreen extends StatefulWidget {
  CircularScreen({Key key}) : super(key: key);
  static const routeName = "/circular";

  @override
  _CircularScreenState createState() => _CircularScreenState();
}

class _CircularScreenState extends State<CircularScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoad = true;
  bool check = true;
  List _circularList = [];
  TextEditingController _title = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _url = new TextEditingController();
  DateTime _date;
  bool formLoad = false;
  bool addLoad = false;
  String dateText = "";

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

  getData() async {
    final response = await http
        .get("http://svtkallianpur.com/wp-content/php/getCirculars.php");
    final data = json.decode(response.body);
    _circularList = data["circulars"];
    setState(() {
      isLoad = false;
    });
  }

  deleteCircular(String id) async {
    final response = await http.post(
        "http://svtkallianpur.com/wp-content/php/deleteCirculars.php",
        body: {
          "circularId": id,
        });
    if (response.body == "yes") {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(snackBar("Successfull!!"));
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).popAndPushNamed(CircularScreen.routeName);
        setState(() {});
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(snackBar("Something went wrong"));
    }
  }

  updateCircular(String id, String title, String description, String url,
      String date) async {
    if (title.isEmpty ||
        date.isEmpty ||
        id.isEmpty ||
        description.isEmpty ||
        url.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(
          'Please fill all the fields',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ));
    } else {
      formLoad = true;
      setState(() {});
      final response = await http.post(
          "http://svtkallianpur.com/wp-content/php/editCirculars.php",
          body: {
            "id": id,
            "title": title,
            "date": date,
            "url": url,
            "description": description,
          });
      if (response.body == "yes") {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(snackBar("Successfull!!"));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).popAndPushNamed(CircularScreen.routeName);
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

  addCircular(
      String title, String description, String url, DateTime date) async {
    if (title.isEmpty || date == null || description.isEmpty || url.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(
          'Please fill all the fields',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ));
    } else {
      print(title);
      formLoad = true;
      setState(() {});
      final response = await http.post(
          "http://svtkallianpur.com/wp-content/php/addCirculars.php",
          body: {
            "title": title.trim(),
            "date": date.toString(),
            "url": url.trim(),
            "description": description.trim(),
          });
      CollectionReference notification =
          FirebaseFirestore.instance.collection('notification');
      await notification.add({
        'title': title.toUpperCase(),
        'body': description,
        'to': "notify",
      });
      if (response.body == "yes") {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(snackBar("Successfull!!"));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).popAndPushNamed(CircularScreen.routeName);
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

  _datePicker() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
    );
  }

  buildAlertDialog(Size _mediaQuery, BuildContext context,
      [String id = "",
      String title,
      String description,
      String url,
      DateTime date]) {
    if (id.isNotEmpty) {
      _title.text = title;
      _description.text = description;
      _url.text = url;
      _date = date;
      dateText = DateFormat('dd/MM/yyyy').format(date);
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
                    controller: _title,
                    decoration: InputDecoration(
                      hintText: "Enter the Title",
                      labelText: "Circular Title",
                      hintStyle: TextStyle(fontSize: 20),
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    controller: _description,
                    decoration: InputDecoration(
                      hintText: "Enter the description",
                      labelText: "Description",
                      hintStyle: TextStyle(fontSize: 20),
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                  TextField(
                    controller: _url,
                    decoration: InputDecoration(
                      hintText: "Enter the PDF URL",
                      labelText: "PDF URL",
                      hintStyle: TextStyle(fontSize: 20),
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(_date == null
                          ? "Date Not Selected"
                          : DateFormat('dd/MM/yyyy').format(_date)),
                      FlatButton(
                          onPressed: () async {
                            _date = await _datePicker();
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
                        addCircular(
                          _title.text,
                          _description.text,
                          _url.text,
                          _date,
                        );
                      } else {
                        updateCircular(
                          id,
                          _title.text,
                          _description.text,
                          _url.text,
                          _date.toString(),
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

  @override
  Widget build(BuildContext context) {
    if (check) {
      getData();
      check = false;
      isLoad = false;
    }

    final _mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Circulars"),
      ),
      body: isLoad == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CircularCard(
              circularList: _circularList,
              mediaQuery: _mediaQuery,
              deleteCircular: deleteCircular,
              buildDialog: buildAlertDialog,
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        hoverElevation: 30,
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
