import 'package:firebase_database/firebase_database.dart';
import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:micromet/Pages/HomePage.dart';
import 'package:micromet/Widgets/stations.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Graphics extends StatefulWidget {
  final bool isNew;
  final String station;
  Graphics({this.isNew, this.station});
  @override
  _GraphicsState createState() => _GraphicsState();
}

class _GraphicsState extends State<Graphics> {
  LineChart chart;
  int chartIndex = 1;
  List<Map> arregloGrafico = [];
  String dropVal;
  bool someStations = false;
  List stations = [];
  List keysData = [];
  bool loaded = false;
  String actualStation = "";
  bool dataExist = true;

  Map<DateTime, double> createLineForHumidity() {
    Map<DateTime, double> data = {};
    for (var i = 0; i < arregloGrafico.length; i++) {
      data[DateTime.parse(arregloGrafico[i]["hour"])] =
          double.parse(arregloGrafico[i]["humidity"].toString());
    }
    return data;
  }

  Map<DateTime, double> createLineForTemperature() {
    Map<DateTime, double> data = {};
    for (var i = 0; i < arregloGrafico.length; i++) {
      data[DateTime.parse(arregloGrafico[i]["hour"])] =
          double.parse(arregloGrafico[i]["temp"].toString());
    }
    return data;
  }

  Map<DateTime, double> createLineForPression() {
    Map<DateTime, double> data = {};
    for (var i = 0; i < arregloGrafico.length; i++) {
      data[DateTime.parse(arregloGrafico[i]["hour"])] =
          double.parse(arregloGrafico[i]["pression"].toString());
    }
    return data;
  }

  Map<DateTime, double> createLineForMm() {
    Map<DateTime, double> data = {};
    for (var i = 0; i < arregloGrafico.length; i++) {
      data[DateTime.parse(arregloGrafico[i]["hour"])] =
          double.parse(arregloGrafico[i]["milimeters"].toString());
    }
    return data;
  }

  Map<DateTime, double> createLineForWind() {
    Map<DateTime, double> data = {};
    for (var i = 0; i < arregloGrafico.length; i++) {
      data[DateTime.parse(arregloGrafico[i]["hour"])] =
          double.parse(arregloGrafico[i]["windSpeed"].toString());
    }
    return data;
  }

  @override
  void initState() {
    super.initState();
    widget.isNew ? newStation() : newMethod();
  }

  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    if (chartIndex == 1) {
      //Se puede traer la fecha y hora de la api y formatearla para usarla en data
      chart = LineChart.fromDateTimeMaps(
          [createLineForHumidity()], [Colors.brown], ['% de Humedad']);
    } else if (chartIndex == 2) {
      chart = LineChart.fromDateTimeMaps(
          [createLineForTemperature()], [Colors.red], ['Temperatura']);
    } else if (chartIndex == 3) {
      chart = LineChart.fromDateTimeMaps(
          [createLineForPression()], [Colors.green], ['Presión']);
    } else if (chartIndex == 4) {
      chart = LineChart.fromDateTimeMaps(
          [createLineForMm()], [Colors.blueAccent], ['Mm.']);
    } else {
      chart = LineChart.fromDateTimeMaps(
          [createLineForWind()], [Colors.grey], ['Velocidad de viento']);
    }
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: loaded && dataExist
            ? Stack(
                children: [
                  Container(
                    height: h,
                    width: w,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.blue, Colors.green])),
                  ),
                  Column(
                    children: <Widget>[
                      AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          actions: <Widget>[
                            IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.satellite,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  changeStation();
                                })
                          ],
                          brightness: Brightness.dark,
                          leading: IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      isNew: false,
                                    ),
                                  ))),
                          centerTitle: true,
                          title: Text(
                            "$actualStation",
                            style: TextStyle(color: Colors.white),
                          )),
                      data(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  chartIndex = 1;
                                });
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                margin: EdgeInsets.all(10),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(''),
                                      Image.asset('assets/agua.png',
                                          width: chartIndex == 1 ? 70 : 30)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  chartIndex = 2;
                                });
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                margin: EdgeInsets.all(10),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(''),
                                      Image.asset('assets/luz.png',
                                          width: chartIndex == 2 ? 70 : 30)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  chartIndex = 3;
                                });
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                margin: EdgeInsets.all(10),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(''),
                                      Image.asset('assets/barometro.png',
                                          width: chartIndex == 3 ? 70 : 30)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  chartIndex = 4;
                                });
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                margin: EdgeInsets.all(10),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(''),
                                      Image.asset('assets/pluvi.png',
                                          width: chartIndex == 4 ? 70 : 30)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  chartIndex = 5;
                                });
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                margin: EdgeInsets.all(10),
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Text(''),
                                      Image.asset('assets/wind.png',
                                          width: chartIndex == 5 ? 70 : 30)
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        chartIndex == 1
                            ? "Humedad v/s Hora"
                            : chartIndex == 2
                                ? "Temperatura v/s Hora"
                                : chartIndex == 3
                                    ? "Presión v/s Hora"
                                    : chartIndex == 4
                                        ? "Mílimetros v/s Hora"
                                        : "Velocidad de viento v/s Hora",
                        style: TextStyle(
                            fontSize: w * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                ],
              )
            : dataExist == false && loaded
                ? Container(
                    height: h,
                    width: w,
                    child: Stack(
                      children: [
                        Container(
                          height: h,
                          width: w,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [Colors.blue, Colors.green])),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            AppBar(
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                actions: <Widget>[
                                  IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.satellite,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        changeStation();
                                      })
                                ],
                                brightness: Brightness.dark,
                                leading: IconButton(
                                    icon: Icon(Icons.arrow_back,
                                        color: Colors.white),
                                    onPressed: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomePage(
                                            isNew: false,
                                          ),
                                        ))),
                                centerTitle: true,
                                title: Text(
                                  "$actualStation",
                                  style: TextStyle(color: Colors.white),
                                )),
                            Text(
                              widget.isNew
                                  ? "No hay datos recientes en ${widget.station.replaceAll("_", " ").toUpperCase()}\n\n\n\n\n\n"
                                  : "No hay datos recientes en ${stations.first.replaceAll("_", " ").toUpperCase()}\n\n\n\n\n\n",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w * 0.1,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Container(
                    height: h,
                    width: w,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Cargando datos..."),
                        CircularProgressIndicator()
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget data() {
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

  newMethod() async {
    arregloGrafico.clear();
    List keysNew = [];
    var prefs = await SharedPreferences.getInstance();
    var mail = prefs.getString("mail");
    var dbRef = FirebaseDatabase.instance.reference().orderByKey();
    dbRef.once().then((DataSnapshot dataSnapshot) {
      setState(() {
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
        print("MAAX" + max.toString());
        int dateNow = int.parse(
            DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10));

        int timestamHour = dateNow - 600;
        List array = [];

        for (var i = 0; i < keysNew.length; i++) {
          if (int.parse("${keysNew[i]}") <= dateNow &&
              int.parse("${keysNew[i]}") >= timestamHour) {
            array.add(int.parse("${keysNew[i]}"));
          } else {
            print("No data");
          }
        }
        print("INICIAAA");
        print(array);
        print("if");
        if (array.toString() == "[]") {
          print("No hay");
          setState(() {
            dataExist = false;
            actualStation =
                station.first.toString().replaceAll("_", " ").toUpperCase();
          });
        } else {
          print(array);
          array.sort();
          actualStation = station.first.toString();
          for (var i = 0; i < array.length; i++) {
            Map<String, dynamic> itemMap = {
              "hour":
                  "${DateTime.now().toString().substring(0, 10) + " " + datos[station.first]["${array[i]}"]["hora"].toString()}",
              "temp":
                  datos[station.first]["${array[i]}"]["temperatura"].toString(),
              "humidity":
                  datos[station.first]["${array[i]}"]["humedad"].toString(),
              "milimeters":
                  datos[station.first]["${array[i]}"]["lluvia"].toString(),
              "pression":
                  datos[station.first]["${array[i]}"]["presion"].toString(),
              "windSpeed": datos[station.first]["${array[i]}"]
                      ["velocidad_viento"]
                  .toString(),
            };
            arregloGrafico.add(itemMap);
          }
        }

        loaded = true;
      });
    });
  }

  newStation() async {
    arregloGrafico.clear();
    List keysNew = [];
    var prefs = await SharedPreferences.getInstance();
    var mail = prefs.getString("mail");
    var dbRef = FirebaseDatabase.instance.reference().orderByKey();
    dbRef.once().then((DataSnapshot dataSnapshot) {
      setState(() {
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
        for (var i in datos[widget.station].keys) {
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

        for (var i = 0; i < keysNew.length; i++) {
          if (int.parse("${keysNew[i]}") <= dateNow &&
              int.parse("${keysNew[i]}") >= timestamHour) {
            array.add(int.parse("${keysNew[i]}"));
          }
        }
        if (array.toString() == "[]") {
          print("No hay");
          setState(() {
            dataExist = false;
            actualStation = widget.station.replaceAll("_", " ").toUpperCase();
          });
        } else {
          print(array);

          array.sort();
          actualStation =
              widget.station.toString().replaceAll("_", " ").toUpperCase();
          for (var i = 0; i < array.length; i++) {
            Map<String, dynamic> itemMap = {
              "hour":
                  "${DateTime.now().toString().substring(0, 10) + " " + datos[widget.station]["${array[i]}"]["hora"].toString()}",
              "temp": datos[widget.station]["${array[i]}"]["temperatura"]
                  .toString(),
              "humidity":
                  datos[widget.station]["${array[i]}"]["humedad"].toString(),
              "milimeters":
                  datos[widget.station]["${array[i]}"]["lluvia"].toString(),
              "pression":
                  datos[widget.station]["${array[i]}"]["presion"].toString(),
              "windSpeed": datos[widget.station]["${array[i]}"]
                      ["velocidad_viento"]
                  .toString(),
            };
            arregloGrafico.add(itemMap);
          }
        }
        loaded = true;
      });
    });
    print(arregloGrafico);
  }

  changeStation() {
    return Alert(
        buttons: [],
        style: AlertStyle(isCloseButton: false),
        type: AlertType.info,
        context: context,
        title: "Cambiar estación",
        desc: "Seleccione una estación para ver sus datos:",
        content: Stations(
          values: stations,
          graphics: true,
        )).show();
  }

  Future<bool> _willPopCallback() async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            isNew: false,
          ),
        ));
    return false;
  }
}
