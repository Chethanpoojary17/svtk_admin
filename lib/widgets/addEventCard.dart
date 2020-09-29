import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEvent extends StatelessWidget {
  const AddEvent({
    Key key,
    @required Size mediaQuery,
    @required TextEditingController nameAdd,
    @required DateTime dateAdd,
    @required this.addLoad,
    @required this.datePicker,
    @required this.setDate,
    @required this.addEvents,
  })  : _mediaQuery = mediaQuery,
        _nameAdd = nameAdd,
        _dateAdd = dateAdd,
        super(key: key);

  final Size _mediaQuery;
  final TextEditingController _nameAdd;
  final DateTime _dateAdd;
  final bool addLoad;
  final Function datePicker;
  final Function setDate;
  final Function addEvents;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      height: _mediaQuery.height * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameAdd,
                decoration: InputDecoration(
                  hintText: "Enter the Name",
                  labelText: "Event Name",
                  hintStyle: TextStyle(fontSize: 20),
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _dateAdd == null
                    ? "Date Not Selected"
                    : DateFormat('dd/MM/yyyy').format(_dateAdd),
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: FlatButton(
              onPressed: () async {
                final temp = await datePicker();
                setDate(temp, 1);
              },
              child: Text(
                "Choose Date",
                style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: addLoad
                  ? Center(child: CircularProgressIndicator())
                  : RaisedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Do you want to save?'),
                            actions: <Widget>[
                              FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    addEvents(
                                        _nameAdd.text, _dateAdd.toString());
                                  }),
                              FlatButton(
                                child: Text('No'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
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
