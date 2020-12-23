import 'package:firebase_database/firebase_database.dart';
import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:fl_animated_linechart/chart/area_line_chart.dart';
import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:fl_animated_linechart/common/pair.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache_builder.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _GraphicsState extends State<Graphics> with WidgetsBindingObserver {
  int connectionStatus = 2;
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
  bool isLoggedGoogle;
  String _animationName = "Untitled";
  final asset = AssetFlare(bundle: rootBundle, name: "assets/nodata.flr");
  // Map _source = {ConnectivityResult.none: false};
  // MyConnectivity _connectivity = MyConnectivity.instance;

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
    // _connectivity.initialise();
    // _connectivity.myStream.listen((source) {
    //   setState(() => _source = source);
    // });
    widget.isNew ? newStation() : newMethod();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        print("Paused");
        break;
      case AppLifecycleState.resumed:
        setState(() {
          loaded = false;
        });
        widget.isNew ? newStation() : newMethod();
        break;
      case AppLifecycleState.inactive:
        print("inactive");
        break;
      case AppLifecycleState.detached:
        print("detached");
        break;
    }
  }

  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    if (chartIndex == 1) {
      //Se puede traer la fecha y hora de la api y formatearla para usarla en data
      chart = AreaLineChart.fromDateTimeMaps(
          [createLineForHumidity()], [Colors.blue[100]], ['% de Humedad'],
          gradients: [Pair(Colors.blue.shade200, Colors.blueAccent.shade100)]);
    } else if (chartIndex == 2) {
      chart = AreaLineChart.fromDateTimeMaps(
          [createLineForTemperature()], [Colors.red], ['Temperatura'],
          gradients: [Pair(Colors.yellow.shade400, Colors.red.shade700)]);
    } else if (chartIndex == 3) {
      chart = AreaLineChart.fromDateTimeMaps(
          [createLineForPression()], [Colors.green], ['Presión'],
          gradients: [Pair(Colors.green.shade400, Colors.lightGreen.shade700)]);
    } else if (chartIndex == 4) {
      chart = AreaLineChart.fromDateTimeMaps(
          [createLineForMm()], [Colors.blueAccent], ['Milímetros'],
          gradients: [Pair(Colors.blue.shade400, Colors.lightBlue.shade700)]);
    } else {
      chart = AreaLineChart.fromDateTimeMaps(
          [createLineForWind()], [Colors.grey], ['Velocidad de viento'],
          gradients: [Pair(Colors.grey.shade400, Colors.blueGrey.shade700)]);
    }

    // int connection;
    // switch (_source.keys.toList()[0]) {
    //   case ConnectivityResult.none:
    //     setState(() {
    //       connection = 0;
    //       connectionStatus = connection;
    //     });
    //     break;
    //   case ConnectivityResult.mobile:
    //     setState(() {
    //       connection = 1;
    //       connectionStatus = connection;
    //     });
    //     break;
    //   case ConnectivityResult.wifi:
    //     setState(() {
    //       connection = 2;
    //       connectionStatus = connection;
    //     });
    // }
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        floatingActionButton:
            // connectionStatus == 0? null :
            loaded
                ? FloatingActionButton.extended(
                    onPressed: () {
                      setState(() {
                        loaded = false;
                      });
                      widget.isNew ? newStation() : newMethod();
                    },
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                    label: Text(
                      "Actualizar datos",
                      style: TextStyle(color: Colors.white),
                    ))
                : null,
        body:
            // connectionStatus == 0
            //     ? Container(
            //         height: h,
            //         width: w,
            //         decoration: BoxDecoration(
            //             color: Colors.white,
            //             image: DecorationImage(
            //                 image: AssetImage("Assets/default.jpg"),
            //                 fit: BoxFit.cover)),
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Image.asset(
            //               "Assets/noInternet.png",
            //               width: w * 0.5,
            //             ),
            //             Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Container(
            //                 decoration: BoxDecoration(
            //                     color: Colors.black54,
            //                     borderRadius:
            //                         BorderRadius.all(Radius.circular(20))),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(8.0),
            //                   child: Text(
            //                     "Actualmente no está conectado a internet.\nVerifique su conexión por favor.",
            //                     style: TextStyle(
            //                         color: Colors.white, fontSize: w * 0.09),
            //                     textAlign: TextAlign.start,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       )
            //     :
            loaded && dataExist
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
                                stations.length > 1
                                    ? IconButton(
                                        icon: Icon(
                                          FontAwesomeIcons.satellite,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          changeStation();
                                        })
                                    : SizedBox.shrink()
                              ],
                              brightness: Brightness.dark,
                              leading: IconButton(
                                  icon: Icon(Icons.arrow_back_ios,
                                      color: Colors.white),
                                  onPressed: _willPopCallback),
                              centerTitle: true,
                              title: Text(
                                "$actualStation",
                                style: TextStyle(color: Colors.white),
                              )),
                          data(),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics:
                                ScrollPhysics(parent: BouncingScrollPhysics()),
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
                                          Column(
                                            children: [
                                              Image.asset('assets/agua.png',
                                                  width: chartIndex == 1
                                                      ? 70
                                                      : 30),
                                              Text("Humedad",
                                                  style: TextStyle(
                                                      fontSize: chartIndex == 1
                                                          ? w * 0.05
                                                          : w * 0.02))
                                            ],
                                          )
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
                                          Column(
                                            children: [
                                              Image.asset('assets/luz.png',
                                                  width: chartIndex == 2
                                                      ? 70
                                                      : 30),
                                              Text("Temperatura",
                                                  style: TextStyle(
                                                      fontSize: chartIndex == 2
                                                          ? w * 0.05
                                                          : w * 0.02))
                                            ],
                                          )
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
                                          Column(
                                            children: [
                                              Image.asset(
                                                  'assets/barometro.png',
                                                  width: chartIndex == 3
                                                      ? 70
                                                      : 30),
                                              Text("Presión",
                                                  style: TextStyle(
                                                      fontSize: chartIndex == 3
                                                          ? w * 0.05
                                                          : w * 0.02))
                                            ],
                                          )
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
                                          Column(
                                            children: [
                                              Image.asset('assets/pluvi.png',
                                                  width: chartIndex == 4
                                                      ? 70
                                                      : 30),
                                              Text("Lluvia",
                                                  style: TextStyle(
                                                      fontSize: chartIndex == 4
                                                          ? w * 0.05
                                                          : w * 0.02))
                                            ],
                                          )
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
                                          Column(
                                            children: [
                                              Image.asset('assets/wind.png',
                                                  width: chartIndex == 5
                                                      ? 70
                                                      : 30),
                                              Text("Viento",
                                                  style: TextStyle(
                                                      fontSize: chartIndex == 5
                                                          ? w * 0.05
                                                          : w * 0.02))
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //       color: Colors.black54,
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(20))),
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(8.0),
                          //     child: Text(
                          //       chartIndex == 1
                          //           ? "Humedad/Hora"
                          //           : chartIndex == 2
                          //               ? "Temperatura/Hora"
                          //               : chartIndex == 3
                          //                   ? "Presión/Hora"
                          //                   : chartIndex == 4
                          //                       ? "Milímetros/Hora"
                          //                       : "Velocidad de viento/Hora",
                          //       style: TextStyle(
                          //           fontSize: w * 0.07,
                          //           fontWeight: FontWeight.bold,
                          //           color: Colors.white),
                          //     ),
                          //   ),
                          // )
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
                                      stations.length > 1
                                          ? IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.satellite,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                changeStation();
                                              })
                                          : SizedBox.shrink()
                                    ],
                                    brightness: Brightness.dark,
                                    leading: IconButton(
                                        icon: Icon(Icons.arrow_back_ios,
                                            color: Colors.white),
                                        onPressed: _willPopCallback),
                                    centerTitle: true,
                                    title: Text(
                                      "$actualStation",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black54,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        widget.isNew
                                            ? "No hay datos recientes en ${widget.station.replaceAll("_", " ").toUpperCase()}."
                                                ""
                                            : "No hay datos recientes en ${stations.first.replaceAll("_", " ").toUpperCase()}."
                                                "",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: w * 0.1,
                                            fontWeight: FontWeight.w900),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: FlareCacheBuilder(
                                    [asset],
                                    builder:
                                        (BuildContext context, bool isWarm) {
                                      return !isWarm
                                          ? Container(child: Text(""))
                                          : FlareActor.asset(
                                              asset,
                                              alignment: Alignment.topCenter,
                                              fit: BoxFit.contain,
                                              animation: _animationName,
                                            );
                                    },
                                  ),
                                )
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
        keysNew.sort();
        max = int.parse(keysNew[keysNew.length - 2]);
        print("MAAX" + max.toString());
        int dateNow = 1602273743;
        // int.parse(DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10));

        int timestamHour = dateNow - 3600;
        List array = [];

        for (var i = 0; i < keysNew.length - 1; i++) {
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
          actualStation =
              station.first.toString().replaceAll("_", " ").toUpperCase();
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
                      ["velocidad_viento"] == null ? 0 : datos[station.first]["${array[i]}"]
                      ["velocidad_viento"]
                  .toString(),
            };
            print('AAAAAAAAAAAA ' + itemMap.toString());
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
        keysNew.sort();
        max = int.parse(keysNew[keysNew.length - 2]);
        print(max);
        print(
            "DATEEEEEEEEEEEEE ${int.parse(DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10))}");
        int dateNow = 1602273743;
        // int.parse(DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10));
        int timestamHour = dateNow - 3600;
        List array = [];

        for (var i = 0; i < keysNew.length - 1; i++) {
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
                      ["velocidad_viento"] == null ? 0 : datos[widget.station]["${array[i]}"]
                      ["velocidad_viento"]
                  .toString(),
            };
            print('AAAAAAAAAAAA ' + itemMap.toString());
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
          value: widget.isNew ? widget.station : stations.first,
          values: stations,
          graphics: true,
        )).show();
  }

  Future initGetData() async {
    var prefs = await SharedPreferences.getInstance();
    bool googleSaved = prefs.getBool("loginWithGoogle");
    setState(() {
      isLoggedGoogle = googleSaved;
    });
    print("LOOOOOOOOOOOOOOOOL " + isLoggedGoogle.toString());
    return null;
  }

  Future<bool> _willPopCallback() async {
    await initGetData();
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, a1, a2) =>
            HomePage(isNew: false, isGoogle: isLoggedGoogle),
      ),
    );

    return false;
  }
}
