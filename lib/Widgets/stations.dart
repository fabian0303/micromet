import 'package:flutter/material.dart';
import 'package:micromet/Pages/Graphics.dart';
import 'package:micromet/Pages/HomePage.dart';

class Stations extends StatefulWidget {
  final List values;
  final bool graphics;
  Stations({this.values, this.graphics});
  @override
  _StationsState createState() => _StationsState();
}

class _StationsState extends State<Stations> {
  String dropVal;
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        DropdownButton(
            hint: Text(
              'Seleccione estación',
              style: TextStyle(fontSize: 20),
            ), // Not necessary for Option 1
            value: dropVal,
            onChanged: (newValue) {
              setState(() {
                dropVal = newValue;
              });
            },
            items: widget.values.map((station) {
              return DropdownMenuItem(
                child: new Text(station.toString().replaceAll("_", " ").toUpperCase(), style: TextStyle(fontSize: 20)),
                value: station,
              );
            }).toList()),
        Text(""),
        RaisedButton(
            onPressed: () {
              Navigator.pop(context);
              if (widget.graphics) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Graphics(
                      isNew: true,
                      station: dropVal,
                    ),
                  ));
              }else{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      isNew: true,
                      newStation: dropVal,
                    ),
                  ));
              }
            },
            color: Colors.green,
            child: Text(
              "Cambiar",
              style: TextStyle(color: Colors.white, fontSize: 30),
            ))
      ],
    ));
  }
}
