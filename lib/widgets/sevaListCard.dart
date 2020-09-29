import 'package:flutter/material.dart';

class SevaListCard extends StatelessWidget {
  const SevaListCard({
    Key key,
    @required Size mediaQuery,
    @required this.isLoad,
    @required List sevaList,
    @required TextEditingController name,
    @required TextEditingController cost,
    @required this.formLoad,
    @required this.deleteSeva,
    @required this.updateSeva,
  })  : _mediaQuery = mediaQuery,
        _sevaList = sevaList,
        _name = name,
        _cost = cost,
        super(key: key);

  final Size _mediaQuery;
  final bool isLoad;
  final List _sevaList;
  final TextEditingController _name;
  final TextEditingController _cost;
  final bool formLoad;
  final Function deleteSeva;
  final Function updateSeva;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _mediaQuery.height * 0.75,
      child: isLoad == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _sevaList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(
                      "${_sevaList[index]["name"]}",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      "Rs. ${_sevaList[index]["cost"]}",
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
                                      deleteSeva(
                                          _sevaList[index]["id"].toString());
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
                          _name.text = _sevaList[index]["name"];
                          _cost.text = _sevaList[index]["cost"];
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Container(
                                  height: _mediaQuery.height * 0.4,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      TextField(
                                        controller: _name,
                                        decoration: InputDecoration(
                                          hintText: "Enter the Name",
                                          labelText: "Seva Name",
                                          hintStyle: TextStyle(fontSize: 20),
                                          labelStyle: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      TextField(
                                        controller: _cost,
                                        decoration: InputDecoration(
                                          hintText: "Enter the Cost",
                                          labelText: "Seva Cost",
                                          hintStyle: TextStyle(fontSize: 20),
                                          labelStyle: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      RaisedButton(
                                        onPressed: () {
                                          updateSeva(
                                            _sevaList[index]["id"].toString(),
                                            _name.text,
                                            _cost.text,
                                          );
                                        },
                                        child: formLoad
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : Text(
                                                "Submit",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                        color: Theme.of(context).primaryColor,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                );
              }),
    );
  }
}
