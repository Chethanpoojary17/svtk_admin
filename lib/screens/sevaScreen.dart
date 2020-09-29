import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:skvt_admin/widgets/addSevaCard.dart';
import 'package:skvt_admin/widgets/sevaListCard.dart';

class SevaScreen extends StatefulWidget {
  SevaScreen({Key key}) : super(key: key);
  static const routeName = "/sevas";

  @override
  _SevaScreenState createState() => _SevaScreenState();
}

class _SevaScreenState extends State<SevaScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoad = true;
  bool check = true;
  List _sevaList = [];
  TextEditingController _name = new TextEditingController();
  TextEditingController _cost = new TextEditingController();
  TextEditingController _nameAdd = new TextEditingController();
  TextEditingController _costAdd = new TextEditingController();
  bool formLoad = false;
  bool addLoad = false;

  getData() async {
    final response =
        await http.get("http://svtkallianpur.com/wp-content/php/getSevas.php");
    final data = json.decode(response.body);
    _sevaList = data["sevas"];
    setState(() {
      isLoad = false;
    });
  }

  deleteSeva(String id) async {
    final response = await http
        .post("http://svtkallianpur.com/wp-content/php/deleteSeva.php", body: {
      "id": id,
    });
    if (response.body == "yes") {
      Navigator.pop(context);
      _scaffoldKey.currentState.showSnackBar(snackBar("Successfull!!"));
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.of(context).popAndPushNamed(SevaScreen.routeName);
        setState(() {});
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(snackBar("Something went wrong"));
    }
  }

  updateSeva(String id, String name, String cost) async {
    if (name.isEmpty || cost.isEmpty || id.isEmpty) {
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
      final response = await http
          .post("http://svtkallianpur.com/wp-content/php/editSeva.php", body: {
        "id": id,
        "name": name,
        "cost": cost,
      });
      if (response.body == "yes") {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(snackBar("Successfull!!"));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).popAndPushNamed(SevaScreen.routeName);
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

  _addSeva(String name, String cost) async {
    if (name.isEmpty || cost.isEmpty) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).primaryColor,
        content: Text(
          'Please fill all the fields',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ));
    } else {
      addLoad = true;
      setState(() {});
      final response = await http
          .post("http://svtkallianpur.com/wp-content/php/addSeva.php", body: {
        "name": name,
        "cost": cost,
      });
      if (response.body == "yes") {
        Navigator.pop(context);
        _scaffoldKey.currentState.showSnackBar(snackBar("Successfull!!"));
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.of(context).popAndPushNamed(SevaScreen.routeName);
          setState(() {});
        });
      } else {
        _scaffoldKey.currentState
            .showSnackBar(snackBar("Something went wrong"));
      }
      addLoad = false;
      setState(() {});
    }
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
    if (check) {
      getData();
      check = false;
    }

    final _mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Seva List"),
      ),
      body: Column(
        children: [
          AddSevaCard(
            mediaQuery: _mediaQuery,
            nameAdd: _nameAdd,
            costAdd: _costAdd,
            formLoad: addLoad,
            addSeva: _addSeva,
          ),
          SevaListCard(
            mediaQuery: _mediaQuery,
            isLoad: isLoad,
            sevaList: _sevaList,
            name: _name,
            cost: _cost,
            formLoad: formLoad,
            deleteSeva: deleteSeva,
            updateSeva: updateSeva,
          ),
        ],
      ),
    );
  }
}
