import 'package:animate_do/animate_do.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:micromet/Pages/Graphics.dart';
import 'package:micromet/Pages/Login.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Widgets/stations.dart';

class HomePage extends StatefulWidget {
  final String mail;
  final bool isNew;
  final String newStation;
  HomePage({this.mail, this.isNew, this.newStation});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    widget.isNew == false ? readData() : readNewData();
  }

  bool existsStations = true;
  bool loaded = false;
  String actualStation = "";
  int lumenes = 0;
  double mm = 0;
  int hPa = 0;
  String data = "";
  String dropVal;
  int humedad = 0;
  bool someStations;
  List stations = [];
  String dateAct = "";
  String grados = "";
  String windSpeed = "0";
  String windDirection = "";

  Future<bool> _willPopCallback() async {
    Alert(
            style: AlertStyle(
                animationType: AnimationType.shrink,
                animationDuration: Duration(milliseconds: 300),
                isOverlayTapDismiss: false),
            title: "¿Está seguro(a) que desea cerrar la aplicación?",
            buttons: [
              DialogButton(
                color: Colors.green,
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text(
                  "Cerrar app",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
              DialogButton(
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancelar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              )
            ],
            context: context,
            type: AlertType.warning)
        .show();
    return false;
  }

  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        key: _scaffoldKey,
        drawer: existsStations ? _drawer() : null,
        floatingActionButton: loaded ? _floating() : SizedBox.shrink(),
        body: loaded
            ? Stack(
                children: [
                  Container(
                    height: h,
                    width: w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: lumenes > 51 && lumenes < 1075 && mm <= 1
                              ? AssetImage("assets/cloudy.jpg")
                              : lumenes < 51 && mm <= 1
                                  ? AssetImage("assets/night.jpg")
                                  : lumenes > 1075 && mm <= 1
                                      ? AssetImage("assets/sunny.jpg")
                                      : mm > 1
                                          ? AssetImage("assets/rainy.jpg")
                                          : AssetImage("assets/default.jpg"),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Container(
                    height: h,
                    width: w,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                      child: Column(
                        children: <Widget>[
                          AppBar(
                            actions: <Widget>[
                              stations.length > 1
                                  ? IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.satellite,
                                        color: Colors.white,
                                        size: w * 0.09,
                                      ),
                                      onPressed: () {
                                        changeStation();
                                      })
                                  : SizedBox.shrink()
                            ],
                            leading: IconButton(
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                  size: w * 0.09,
                                ),
                                onPressed: () {
                                  _scaffoldKey.currentState.openDrawer();
                                }),
                            brightness: Brightness.dark,
                            centerTitle: true,
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            title: Text(
                              "${actualStation.replaceAll("_", " ").toUpperCase()}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          body()
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : existsStations == false
                ? Stack(
                    children: [
                      Container(
                        height: h,
                        width: w,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/default.jpg"),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Container(
                        width: w,
                        height: h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text("Estimado/a\n \nActualmente usted no cuenta con ninguna estación vinculada a su cuenta, por favor selecione una de las siguientes alternativas: ",style: TextStyle(color:Colors.white,fontSize: w*0.07,fontWeight: FontWeight.bold),textAlign: TextAlign.start),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  FadeInLeft(
                                    duration: Duration(milliseconds: 300),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          height: h * 0.3,
                                          width: w * 0.4,
                                          child: Column(
                                            children: <Widget>[
                                              Text(""),
                                              Icon(
                                                Icons.monetization_on,
                                                color: Colors.white,
                                                size: w * 0.3,
                                              ),
                                              Text(
                                                "Comprar",
                                                style: TextStyle(
                                                    fontSize: w * 0.07,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  FadeInRight(
                                    duration: Duration(milliseconds: 300),
                                    child: InkWell(
                                      onTap: () {},
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.blue.shade300,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                          height: h * 0.3,
                                          width: w * 0.4,
                                          child: Column(
                                            children: <Widget>[
                                              Text(""),
                                              Icon(
                                                Icons.link,
                                                color: Colors.white,
                                                size: w * 0.3,
                                              ),
                                              Text(
                                                "Vincular",
                                                style: TextStyle(
                                                    fontSize: w * 0.07,
                                                    color: Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FadeInUp(
                                  duration: Duration(milliseconds: 300),
                                  child: InkWell(
                                    onTap: () async {
                                      var prefs =
                                          await SharedPreferences.getInstance();

                                      Alert(
                                              style: AlertStyle(
                                                  animationType:
                                                      AnimationType.shrink,
                                                  animationDuration: Duration(
                                                      milliseconds: 300),
                                                  isOverlayTapDismiss: false),
                                              title:
                                                  "¿Está seguro(a) que desea cerrar su sesión?",
                                              buttons: [
                                                DialogButton(
                                                  color: Colors.green,
                                                  onPressed: () {
                                                    prefs.setBool(
                                                        "login", false);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              Login(),
                                                        ));
                                                  },
                                                  child: Text(
                                                    "Cerrar",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                ),
                                                DialogButton(
                                                  color: Colors.red,
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    "Cancelar",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20),
                                                  ),
                                                )
                                              ],
                                              context: context,
                                              type: AlertType.warning)
                                          .show();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        height: h * 0.1,
                                        width: w * 0.6,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Text(""),
                                            Text(
                                              "Cerrar sesión",
                                              style: TextStyle(
                                                  fontSize: w * 0.07,
                                                  color: Colors.white),
                                            ),
                                            Icon(Icons.exit_to_app,
                                                size: w * 0.1,
                                                color: Colors.white),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(
                    width: w,
                    height: h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Cargando datos...",
                          style: TextStyle(color: Colors.black, fontSize: 20),
                        ),
                        CircularProgressIndicator(),
                      ],
                    ),
                  ),
      ),
    );
  }

//botón flotante
  Widget _floating() {
    return FloatingActionButton.extended(
      onPressed: () {
        print(DateTime.now().toString());
        setState(() {
          loaded = false;
        });
        widget.isNew == true && widget.newStation != null
            ? readNewData()
            : readData();
      },
      label: Text(
        "Actualizar datos",
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(
        Icons.refresh,
        color: Colors.white,
      ),
    );
  }

//El menú lateral
  Widget _drawer() {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), bottomRight: Radius.circular(30))),
      height: h,
      width: w * 0.8,
      child: Column(
        children: <Widget>[
          Container(
              height: h * 0.28,
              width: w,
              decoration: BoxDecoration(
                  color: Colors.green,
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/country.jpg",
                      ),
                      fit: BoxFit.cover)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: h * 0.05),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage("assets/logo.png"),
                    ),
                    Text(""),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "contacto@micromet.cl",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    )
                  ],
                ),
              )),
          FadeInLeft(
            duration: Duration(milliseconds: 400),
            child: ListTile(
              title: Text("Gráficos"),
              leading: Image.asset(
                "assets/grafico.png",
                width: w * 0.15,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Graphics(
                        isNew: false,
                      ),
                    ));
              },
            ),
          ),
          Divider(),
          FadeInLeft(
            duration: Duration(milliseconds: 600),
            child: ListTile(
              title: Text("Datos historicos"),
              leading: Image.asset(
                "assets/planta.png",
                width: w * 0.15,
              ),
            ),
          ),
          Divider(),
          SizedBox(
            height: h * 0.3,
          ),
          Divider(),
          FadeInLeft(
            duration: Duration(milliseconds: 800),
            child: ListTile(
              onTap: () async {
                var prefs = await SharedPreferences.getInstance();

                Alert(
                        style: AlertStyle(
                            animationType: AnimationType.shrink,
                            animationDuration: Duration(milliseconds: 300),
                            isOverlayTapDismiss: false),
                        title: "¿Está seguro(a) que desea cerrar su sesión?",
                        buttons: [
                          DialogButton(
                            color: Colors.green,
                            onPressed: () {
                              prefs.setBool("login", false);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ));
                            },
                            child: Text(
                              "Cerrar",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                          DialogButton(
                            color: Colors.red,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Cancelar",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ],
                        context: context,
                        type: AlertType.warning)
                    .show();
              },
              title: Text("Cerrar sesión"),
              leading: Icon(LineAwesomeIcons.sign_out),
            ),
          ),
          Divider(),
          SizedBox(
            height: h * 0.04,
          ),
          Text("Micromet 2020")
        ],
      ),
    );
  }

//Cuerpo de app
  Widget body() {
    var w = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(""),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.black54),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  lumenes > 51 && lumenes < 1075 && mm <= 1
                      ? Icon(
                          FontAwesomeIcons.cloud,
                          size: w * 0.15,
                          color: Colors.white,
                        )
                      : lumenes < 51 && mm <= 1
                          ? Icon(
                              FontAwesomeIcons.moon,
                              size: w * 0.15,
                              color: Colors.white,
                            )
                          : lumenes > 1075 && mm <= 1
                              ? Icon(
                                  FontAwesomeIcons.sun,
                                  size: w * 0.15,
                                  color: Colors.white,
                                )
                              : mm > 1
                                  ? Icon(
                                      FontAwesomeIcons.cloudRain,
                                      size: w * 0.15,
                                      color: Colors.white,
                                    )
                                  : Icon(
                                      FontAwesomeIcons.question,
                                      size: w * 0.15,
                                      color: Colors.white,
                                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FadeInDown(
                        duration: Duration(milliseconds: 300),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "${grados.length >= 4 ? grados.substring(0, 4) : grados}° Celsius",
                              style: TextStyle(
                                  fontSize: w * 0.1,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      FadeInDown(
                        duration: Duration(milliseconds: 300),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                lumenes > 51 && lumenes < 1075 && mm <= 1
                                    ? "Nublado"
                                    : lumenes < 51 && mm <= 1
                                        ? " "
                                        : lumenes > 1075 && mm <= 1
                                            ? "Soleado"
                                            : mm > 1 ? "Lluvioso" : "",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.07,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Text(""),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: <Widget>[
                  Text(""),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Image.asset(
                              "assets/wind.png",
                              width: w * 0.09,
                              color: Colors.white,
                            ),
                            Text(
                              " $windSpeed km/h",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: w * 0.07,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        FadeInRight(
                          duration: Duration(milliseconds: 400),
                          child: Row(
                            children: <Widget>[
                              // Icon(
                              //   FontAwesomeIcons.compass,
                              //   color: Colors.white,
                              //   size: w * 0.09,
                              // ),
                              Text(
                                "${windDirection == "O" ? "OESTE" : windDirection == "E" ? "ESTE" : windDirection == "N" ? "NORTE" : windDirection == "S" ? "SUR" : windDirection == "SE" ? "SURESTE" : windDirection == "NO" ? "NOROESTE" : windDirection == "NE" ? "NORESTE" : windDirection == "SO" ? "SUROESTE" : "?"}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: w * 0.06,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                    endIndent: 16,
                    indent: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: FadeInLeft(
                      duration: Duration(milliseconds: 500),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            color: Colors.transparent,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.tint,
                                    color: Colors.white,
                                    size: w * 0.15,
                                  ),
                                  Text(""),
                                  Text(
                                    "$humedad% \n Humedad",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: w * 0.07,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            color: Colors.transparent,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.cloudRain,
                                    color: Colors.white,
                                    size: w * 0.15,
                                  ),
                                  Text(""),
                                  Text(
                                    "$mm \n mm",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: w * 0.07,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                    endIndent: 16,
                    indent: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: FadeInUp(
                      duration: Duration(milliseconds: 600),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            color: Colors.transparent,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.lightbulb,
                                    color: Colors.white,
                                    size: w * 0.15,
                                  ),
                                  Text(""),
                                  Text(
                                    "$lumenes \n Lúmenes",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: w * 0.07,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            color: Colors.transparent,
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.weight,
                                    color: Colors.white,
                                    size: w * 0.15,
                                  ),
                                  Text(""),
                                  Text(
                                    "$hPa \n hPa",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: w * 0.07,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                    endIndent: 16,
                    indent: 16,
                  ),
                  FadeInUp(
                    duration: Duration(milliseconds: 700),
                    child: Text(
                      "Actualizado " + dateAct,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: w * 0.04,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text("")
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

//Leer data cuando es sólo una estación
  void readData() async {
    var key = [];
    var prefs = await SharedPreferences.getInstance();
    var mail = prefs.getString("mail");
    var dbRef = FirebaseDatabase.instance.reference();
    dbRef.once().then((DataSnapshot dataSnapshot) {
      var datos =
          dataSnapshot.value[mail.replaceAll("@", "").replaceAll(".", "")];
      var station = datos;
      print("STATION " + station.toString());
      if (station.toString() == "null") {
        setState(() {
          existsStations = false;
        });
      } else {
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
          for (var i in datos[station.first].keys) {
            key.add(i);
          }
          var max = 0;
          for (var i = 0; i < key.length; i++) {
            if (int.parse(key[i]) > max) {
              setState(() {
                max = int.parse(key[i]);
              });
            }
          }
          actualStation = station.first;
          print("MAAAAX $max");
          print(datos[station.first]["$max"]);
          print(datos[station.first]["$max"]["fecha"]);

          dateAct = datos[station.first]["$max"]["fecha"].toString() +
              " a las " +
              datos[station.first]["$max"]["hora"].toString();
          grados = datos[station.first]["$max"]["temperatura"].toString();
          windDirection =
              datos[station.first]["$max"]["direccion_viento"].toString();
          windSpeed =
              datos[station.first]["$max"]["velocidad_viento"].toString();
          lumenes = datos[station.first]["$max"]["luminosidad"].toInt();
          mm = double.parse(datos[station.first]["$max"]["lluvia"].toString());
          humedad = datos[station.first]["$max"]["humedad"].toInt();
          hPa = datos[station.first]["$max"]["presion"].toInt();
          setState(() {
            loaded = true;
            existsStations = true;
          });
        });
      }
    });
  }

//Leer data cuando es más de una
  void readNewData() async {
    List key = [];
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
        for (var i in datos[widget.newStation].keys) {
          key.add(i);
        }
        var max = 0;
        for (var i = 0; i < key.length; i++) {
          if (int.parse(key[i]) > max) {
            setState(() {
              max = int.parse(key[i]);
            });
          }
        }
        actualStation = widget.newStation;
        print(datos[widget.newStation]);
        dateAct = datos[widget.newStation]["$max"]["fecha"].toString() +
            " a las " +
            datos[widget.newStation]["$max"]["hora"].toString();
        grados = datos[widget.newStation]["$max"]["temperatura"].toString();
        windDirection =
            datos[widget.newStation]["$max"]["direccion_viento"].toString();
        windSpeed = datos[widget.newStation]["$max"]["velocidad_viento"]
            .toString();
        lumenes = datos[widget.newStation]["$max"]["luminosidad"].toInt();
        mm =
            double.parse(datos[widget.newStation]["$max"]["lluvia"].toString());
        humedad = datos[widget.newStation]["$max"]["humedad"].toInt();
        hPa = datos[widget.newStation]["$max"]["presion"].toInt();
        setState(() {
          loaded = true;
        });
      });
    });
    print(grados);
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
          graphics: false,
        )).show();
  }
}
