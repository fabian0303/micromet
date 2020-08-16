import 'package:flutter/material.dart';
import 'package:micromet/Pages/Graphics.dart';
import 'package:micromet/Pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Stations extends StatefulWidget {
  final String value;
  final List values;
  final bool graphics;
  Stations({this.values, this.graphics, this.value});
  @override
  _StationsState createState() => _StationsState();
}

class _StationsState extends State<Stations> {
  String dropVal;
  @override
  void initState() { 
    super.initState();
    dropVal = widget.value;
  }
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
                child: new Text(
                    station.toString().replaceAll("_", " ").toUpperCase(),
                    style: TextStyle(fontSize: 20)),
                value: station,
              );
            }).toList()),
        Text(""),
        RaisedButton(
            onPressed: () async {
              if (widget.graphics) {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, a1, a2) => Graphics(
                        isNew: true,
                        station: dropVal,
                      ),
                    ));
              } else {
                var prefs = await SharedPreferences.getInstance();
                bool google = prefs.getBool("loginWithGoogle");
                Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, a1, a2) => HomePage(
                        isNew: true,
                        newStation: dropVal,
                        isGoogle: google,
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
