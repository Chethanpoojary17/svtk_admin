import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:skvt_admin/widgets/addEventCard.dart';

class EventScreen extends StatefulWidget {
  EventScreen({Key key}) : super(key: key);
  static const routeName = "/event";

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoad = true;
  bool check = true;
  List _eventList = [];
  TextEditingController _name = new TextEditingController();
  TextEditingController _nameAdd = new TextEditingController();
  DateTime _date;
  DateTime _dateAdd;
  bool formLoad = false;
  bool addLoad = false;

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
    _eventList.clear();
    final response =
        await http.get("http://svtkallianpur.com/wp-content/php/getEvents.php");
    final data = json.decode(response.body);
    _eventList = data["events"];
    setState(() {
      isLoad = false;
    });
  }

  deleteEvent(String id) async {
    final response = await http.post(
        "http://svtkallianpur.com/wp-content/php/deleteEvents.php",
        body: {
          "eventId": id,
        }).whenComplete(() {
      Navigator.of(context).popAndPushNamed(EventScreen.routeName);
    });
    if (response.body == "yes") {
      formLoad = false;
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(snackBar("Successfull!!"));
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).popAndPushNamed(EventScreen.routeName);
        setState(() {});
      });
    } else {
      formLoad = false;
      _scaffoldKey.currentState.showSnackBar(snackBar("Something went wrong"));
    }
  }

  updateEvent(String id, String name, String date) async {
    if (name.isEmpty || date.isEmpty || id.isEmpty) {
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
          "http://svtkallianpur.com/wp-content/php/editEvents.php",
          body: {
            "id": id,
            "name": name,
            "date": date,
          });
      if (response.body == "yes") {
        formLoad = false;
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(snackBar("Successfull!!"));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).pushReplacementNamed(EventScreen.routeName);
          setState(() {});
        });
      } else {
        formLoad = false;
        _scaffoldKey.currentState
            .showSnackBar(snackBar("Something went wrong"));
      }
      setState(() {});
    }
  }

  _addEvents(String name, String date) async {
    if (name.isEmpty || date.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(
          'Please fill all the fields',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ));
      Navigator.pop(context);
    } else {
      addLoad = true;
      setState(() {});
      final response = await http
          .post("http://svtkallianpur.com/wp-content/php/addEvents.php", body: {
        "name": name,
        "date": date,
      });
      CollectionReference notification =
          FirebaseFirestore.instance.collection('notification');
      await notification.add({
        'title': name.toUpperCase(),
        'body': name.toUpperCase() +
            " On " +
            DateFormat('dd/MM/yyyy').format(DateTime.parse(date)),
        'to': "notify",
      });
      if (response.body == "yes") {
        addLoad = false;
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(snackBar("Successfull!!"));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).popAndPushNamed(EventScreen.routeName);
          setState(() {});
        });
      } else {
        addLoad = false;
        _scaffoldKey.currentState
            .showSnackBar(snackBar("Something went wrong"));
      }
      setState(() {});
    }
  }

  _datePicker() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
      helpText: "Choose the date",
    );
  }

  setDate(DateTime date, int i) {
    i == 1 ? _dateAdd = date : _date = date;
    setState(() {});
  }

  buildShowDialog(BuildContext context, Size _mediaQuery, int index) async {
    showDialog(
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
                      hintText: "Enter the Name",
                      labelText: "Event Name",
                      hintStyle: TextStyle(fontSize: 20),
                      labelStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                  Text(
                    _date == null
                        ? "Not Selected"
                        : DateFormat('dd/MM/yyyy').format(_date),
                  ),
                  FlatButton(
                    onPressed: () async {
                      final temp = await _datePicker();
                      setDate(temp, 0);
                      setState(() {});
                    },
                    child: Text(
                      "Choose Date",
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  formLoad
                      ? Center(child: CircularProgressIndicator())
                      : RaisedButton(
                          onPressed: () {
                            updateEvent(
                              _eventList[index]["id"].toString(),
                              _name.text,
                              _date.toString(),
                            );
                          },
                          child: Text(
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
    if (check || _eventList.isEmpty) {
      getData();
      check = false;
      isLoad = false;
    }

    final _mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Events"),
      ),
      body: Column(
        children: [
          AddEvent(
            mediaQuery: _mediaQuery,
            nameAdd: _nameAdd,
            dateAdd: _dateAdd,
            addLoad: addLoad,
            datePicker: _datePicker,
            setDate: setDate,
            addEvents: _addEvents,
          ),
          Container(
            height: _mediaQuery.height * 0.75,
            child: isLoad == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: _eventList.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                            "${_eventList[index]["name"]}",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(_eventList[index]["date"]))}",
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          trailing: PopupMenuButton<int>(
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 1,
                                child: Text("Edit"),
                              ),
                              PopupMenuItem(
                                value: 2,
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                            onSelected: (value) async {
                              if (value == 2) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                        'Are you sure you want to delete?'),
                                    actions: <Widget>[
                                      FlatButton(
                                          child: Text('Yes'),
                                          onPressed: () {
                                            deleteEvent(_eventList[index]["id"]
                                                .toString());
                                          }),
                                      FlatButton(
                                        child: Text('No'),
                                        onPressed: () =>
                                            Navigator.of(context).pop(false),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                _name.text = _eventList[index]["name"];
                                _date =
                                    DateTime.parse(_eventList[index]["date"]);
                                await buildShowDialog(
                                    context, _mediaQuery, index);
                              }
                            },
                          ),
                        ),
                      );
                    }),
          ),
        ],
      ),
    );
  }
}
