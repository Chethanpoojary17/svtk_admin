import 'package:flutter/material.dart';

class AddSevaCard extends StatelessWidget {
  const AddSevaCard({
    Key key,
    @required Size mediaQuery,
    @required TextEditingController nameAdd,
    @required TextEditingController costAdd,
    @required this.formLoad,
    @required this.addSeva,
  })  : _mediaQuery = mediaQuery,
        _nameAdd = nameAdd,
        _costAdd = costAdd,
        super(key: key);

  final Size _mediaQuery;
  final TextEditingController _nameAdd;
  final TextEditingController _costAdd;
  final bool formLoad;
  final Function addSeva;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      height: _mediaQuery.height * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameAdd,
                decoration: InputDecoration(
                  hintText: "Enter the Name",
                  labelText: "Seva Name",
                  hintStyle: TextStyle(fontSize: 20),
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _costAdd,
                decoration: InputDecoration(
                  hintText: "Enter the Cost",
                  labelText: "Seva Cost",
                  hintStyle: TextStyle(fontSize: 20),
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Do you want to save?'),
                      actions: <Widget>[
                        FlatButton(
                            child: Text('Yes'),
                            onPressed: () {
                              addSeva(_nameAdd.text, _costAdd.text);
                            }),
                        FlatButton(
                          child: Text('No'),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                      ],
                    ),
                  );
                },
                child: formLoad
                    ? Center(child: CircularProgressIndicator())
                    : Text(
                        "Submit",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
