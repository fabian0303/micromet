import 'package:flutter/material.dart';
import 'package:micromet/Pages/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool isLogged;
  bool isLoggedGoogle;
  @override
  void initState() {
    super.initState();
    initGetData();
    timer();
    getLogin();
  }

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
              image: DecorationImage(
                  image: AssetImage("assets/wallSplash.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          Container(
            color: Colors.transparent,
            height: h,
            width: w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  "BIENVENIDO A MICROMET",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: w * 0.12,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                  "assets/logo.png",
                  width: w * 0.7,
                ),
                CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ),
                Text(""),
                Text(
                  "MICROMET 2020",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void getLogin() async {
    var prefs = await SharedPreferences.getInstance();
    var login = prefs.getBool("login");
    if (login == null || login == false) {
      setState(() {
        isLogged = false;
      });
    } else {
      isLogged = true;
    }
  }

  timer() {
    Future.delayed(Duration(seconds: 3), () async {
      if (isLogged) {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                isGoogle: isLoggedGoogle,
                isNew: false,
              ),
            ));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }

  initGetData() async {
    var prefs = await SharedPreferences.getInstance();
    bool googleSaved = prefs.getBool("loginWithGoogle");
    setState(() {
      isLoggedGoogle = googleSaved;
    });
  }
}
