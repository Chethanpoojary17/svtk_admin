import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CircularCard extends StatelessWidget {
  const CircularCard({
    Key key,
    @required List circularList,
    @required Size mediaQuery,
    @required this.deleteCircular,
    @required this.buildDialog,
  })  : _circularList = circularList,
        _mediaQuery = mediaQuery,
        super(key: key);

  final List _circularList;
  final Size _mediaQuery;
  final Function deleteCircular;
  final Function buildDialog;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _circularList.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              title: Text(
                "${_circularList[index]["title"]}",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              subtitle: Text(
                "Date: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(_circularList[index]["date"]))}",
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
                onSelected: (value) {
                  if (value == 2) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Are you sure you want to delete?'),
                        actions: <Widget>[
                          FlatButton(
                              child: Text('Yes'),
                              onPressed: () {
                                deleteCircular(
                                    _circularList[index]["id"].toString());
                              }),
                          FlatButton(
                            child: Text('No'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                        ],
                      ),
                    );
                  } else {
                    final id = _circularList[index]["id"].toString();
                    final title = _circularList[index]["title"];
                    final description = _circularList[index]["description"];
                    final url = _circularList[index]["url"];
                    final date = DateTime.parse(_circularList[index]["date"]);
                    buildDialog(_mediaQuery, context, id, title, description,
                        url, date);
                  }
                },
              ),
            ),
          );
        });
  }
}
