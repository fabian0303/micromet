import 'package:flutter/material.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: h,
            width: w,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.green, Colors.blue])),
          ),
          Container(
            width: w,
            height: h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    brightness: Brightness.dark,
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pop(context)),
                    centerTitle: true,
                    title: Text(
                      "Información de app".toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    )),
                Text(""),
                Container(
                  width: w * 0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    color: Colors.black54,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "MICROMET",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.07,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                        endIndent: 16,
                        indent: 16,
                      ),
                      Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Versión 1.0.0",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: w * 0.06,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Image.asset(
                                "assets/logo.png",
                                width: w * 0.45,
                              )),
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                        endIndent: 16,
                        indent: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "contacto@micromet.cl",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: w * 0.07,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: h * 0.1,
                ),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0)),
                    color: Colors.green,
                    child: Text(
                      'Comprobar actualizaciones'.toUpperCase(),
                      style: TextStyle(color: Colors.white, fontSize: w * 0.05),
                    ),
                    onPressed: () async {}),
                SizedBox(
                  height: h * 0.2,
                ),
                FlatButton.icon(
                  onPressed: () {},
                  label: Text(
                    "Ver términos y condiciones",
                    style: TextStyle(color: Colors.white, fontSize: w * 0.05),
                  ),
                  icon: Icon(
                    Icons.info,
                    color: Colors.white,
                    size: w * 0.08,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
