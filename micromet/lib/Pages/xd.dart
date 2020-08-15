import 'package:firebase_database/firebase_database.dart';
import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Pruebas extends StatefulWidget {
  @override
  _PruebasState createState() => _PruebasState();
}

class _PruebasState extends State<Pruebas> {
  String data = "ah";
  LineChart chart;
  List<Map> arregloGrafico = [];
  String dropVal;
  bool someStations = false;
  List stations = [];
  List keysData = [];
  @override
  void initState() {
    super.initState();
    newMethod();
  }

  Map<DateTime, double> createLineForTemperature() {
    Map<DateTime, double> data = {};
    for (var i = 0; i < arregloGrafico.length; i++) {
      data[DateTime.parse(arregloGrafico[i]["hour"])] =
          double.parse(arregloGrafico[i]["temp"].toString().substring(0, 3));
    }
    return data;
  }

  Widget build(BuildContext context) {
    chart = LineChart.fromDateTimeMaps(
        [createLineForTemperature()], [Colors.orange], ['Temperatura']);
    return Scaffold(
      appBar: AppBar(title: Text("Pruebas")),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            //FlatButton(onPressed: () {}, child: Text("Traer datos")),
            // someStations == true ? drop() : Text(""),
            RaisedButton(
                onPressed: () {
                  newMethod();
                },
                child: Text("Traer nueva data")),
            Text(data),
            grafi()
          ],
        ),
      ),
    );
  }

  Widget drop() {
    return DropdownButton(
        hint: Text('Please choose a location'), // Not necessary for Option 1
        value: dropVal,
        onChanged: (newValue) {
          setState(() {
            dropVal = newValue;
          });
        },
        items: stations.map((location) {
          return DropdownMenuItem(
            child: new Text(location),
            value: location,
          );
        }).toList());
  }

  newMethod() async {
    arregloGrafico.clear();
    List keysNew = [];
    var prefs = await SharedPreferences.getInstance();
    var mail = prefs.getString("mail");
    var dbRef = FirebaseDatabase.instance.reference().orderByKey();
    dbRef.once().then((DataSnapshot dataSnapshot) {
      setState(() {
        data = "";
        var datos =
            dataSnapshot.value[mail.replaceAll("@", "").replaceAll(".", "")];
        var station = datos.keys;
        stations.clear();
        for (var i in station) {
          stations.add(i);
        }
        if (stations.length > 1) {
          someStations = true;
        }
        for (var i in datos[stations.first].keys) {
          keysNew.add(i);
        }
        var max = 0;
        for (var i = 0; i < keysNew.length; i++) {
          if (int.parse(keysNew[i]) > max) {
            setState(() {
              max = int.parse(keysNew[i]);
            });
          }
        }
        int dateNow = int.parse(
            DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10));

        int timestamHour = dateNow - 600;
        List array = [];
        data = "";

        for (var i = 0; i < keysNew.length; i++) {
          if (int.parse("${keysNew[i]}") <= dateNow &&
              int.parse("${keysNew[i]}") >= timestamHour) {
            array.add(int.parse("${keysNew[i]}"));
          }
        }
        data = array.toString();
        print(array);

        array.sort();

        for (var i = 0; i < array.length; i++) {
          Map<String, dynamic> itemMap = {
            "hour":
                "${DateTime.now().toString().substring(0, 10) + " " + datos[station.first]["${array[i]}"]["hora"].toString()}",
            "temp":
                datos[station.first]["${array[i]}"]["temperatura"].toString()
          };
          arregloGrafico.add(itemMap);
        }
        setState(() {
          data = arregloGrafico.toString();
        });
      });
    });
  }

  Widget grafi() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.all(10),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width * 0.9,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnimatedLineChart(
                chart,
                key: UniqueKey(),
              ), //Unique key to force animations
            )),
          ]),
        ),
      ),
    );
  }
}
