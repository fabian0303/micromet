import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:micromet/Pages/HomePage.dart';
import 'package:micromet/Widgets/Text.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  PageController _pageController = PageController(initialPage: 1);
  bool viewPass = true;
  bool viewPass1 = true;
  bool viewPass2 = true;
  TextEditingController email = TextEditingController();
  TextEditingController emailRecup = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController emailReg = TextEditingController();
  TextEditingController passReg = TextEditingController();
  TextEditingController pass2Reg = TextEditingController();
  String mailGoogle = "";
  String imgUrlGoogle = "";
  String nameGoogle = "";
  bool emailSelected = true;

  bool errorEmailRegister = false;
  String messageErrorRegister = "";
  bool errorEmail = false;
  String messageErrorMail = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
          body: PageView(
        physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
        scrollDirection: Axis.horizontal,
        controller: _pageController,
        children: <Widget>[createUser(), login(), recoverPass()],
      )),
    );
  }

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

  Future<void> signIn() async {
    if (email.text.isEmpty || pass.text.isEmpty) {
      Alert(
          style: AlertStyle(
              isCloseButton: false,
              animationType: AnimationType.grow,
              animationDuration: Duration(milliseconds: 500)),
          context: context,
          title: "Error",
          type: AlertType.error,
          desc: "Complete todos los campos.",
          buttons: [
            DialogButton(
                child: Text(
                  "Aceptar",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () => Navigator.pop(context))
          ]).show();
    } else {
      try {
        var user = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email.text.replaceAll(" ", ""), password: pass.text);
        print(user.additionalUserInfo.username);
        var prefs = await SharedPreferences.getInstance();
        prefs.setBool("login", true);
        prefs.setBool("loginWithGoogle", false);
        prefs.setString("mail", email.text.replaceAll(" ", ""));
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                mail: email.text.replaceAll(" ", ""),
                isNew: false,
                isGoogle: false,
              ),
            ));
      } catch (e) {
        Alert(
            style: AlertStyle(
                isCloseButton: false,
                animationType: AnimationType.grow,
                animationDuration: Duration(milliseconds: 500)),
            context: context,
            title: "Error",
            type: AlertType.error,
            desc: "El usuario no ha sido encontrado",
            buttons: [
              DialogButton(
                  child: Text(
                    "Aceptar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  onPressed: () => Navigator.pop(context))
            ]).show();
      }
    }
  }

  Widget login() {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.green[900],
            Colors.green[800],
            Colors.green[400]
          ], begin: Alignment.topCenter)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: h * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: w,
                child: FadeInDown(
                    duration: Duration(milliseconds: 200),
                    child: Image.asset("assets/logo.png")),
                height: h * 0.2,
              ),
            ),
            Expanded(
              child: Container(
                width: w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextWidget().textSubtitle(
                            "INGRESE SUS DATOS", Colors.green.shade500, w),
                      ),
                      FadeInLeft(
                        duration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                            width: w,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.mail_outline,
                                        color: Colors.green.shade200),
                                    border: InputBorder.none,
                                    hintText: "Ingrese su email",
                                    hintStyle: TextStyle(
                                        color: Colors.green.shade200,
                                        fontSize: w * 0.05)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeInRight(
                        duration: Duration(milliseconds: 600),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                )),
                            width: w,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: pass,
                                obscureText: viewPass,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Ingrese su contraseña",
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          LineAwesomeIcons.eye,
                                          color: viewPass
                                              ? Colors.green.shade200
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            viewPass = !viewPass;
                                          });
                                        }),
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.green.shade200,
                                    ),
                                    hintStyle: TextStyle(
                                        color: Colors.green.shade200,
                                        fontSize: w * 0.05)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeIn(
                        duration: Duration(milliseconds: 800),
                        child: RaisedButton(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Container(
                            width: w * 0.7,
                            height: w * 0.13,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                gradient: LinearGradient(colors: [
                                  Colors.green[900],
                                  Colors.green[800],
                                  Colors.green[400]
                                ])),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Center(
                                  child: Text("INICIAR SESIÓN",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                ),
                                Icon(FontAwesomeIcons.arrowRight,
                                    color: Colors.white),
                              ],
                            ),
                          ),
                          onPressed: () {
                            signIn();
                          },
                          hoverColor: Colors.greenAccent,
                          splashColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5))),
                        ),
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 800),
                        child: FlatButton(
                            onPressed: () {
                              _pageController.nextPage(
                                  duration: Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn);
                            },
                            child: Text(
                              "¿HE OLVIDADO MI CONTRASEÑA?",
                              style: TextStyle(color: Colors.green.shade200),
                            )),
                      ),
                      SizedBox(
                        height: h * 0.02,
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 870),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Iniciar sesión con",
                              style: TextStyle(color: Colors.grey),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                FloatingActionButton(
                                    onPressed: () async {
                                      await signInWithGoogle()
                                          .catchError((onError) {
                                        setState(() {
                                          emailSelected = false;
                                        });
                                      });
                                      if (emailSelected) {
                                        var prefs = await SharedPreferences
                                            .getInstance();
                                        prefs.setBool("login", true);
                                        prefs.setBool("loginWithGoogle", true);
                                        prefs.setString("mail", mailGoogle);
                                        prefs.setString(
                                            "imageUrl", imgUrlGoogle);
                                        prefs.setString(
                                            "nameGoogle", nameGoogle);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return HomePage(
                                                mail: mailGoogle,
                                                isNew: false,
                                                isGoogle: true,
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        Alert(
                                            desc:
                                                "Debe seleccionar un email. En caso de no haber ninguno deberá crear una nueva cuenta.",
                                            type: AlertType.error,
                                            style: AlertStyle(
                                                isCloseButton: false,
                                                animationType:
                                                    AnimationType.grow,
                                                animationDuration: Duration(
                                                    milliseconds: 500)),
                                            context: context,
                                            title: "ERROR",
                                            buttons: [
                                              DialogButton(
                                                  color: Colors.red,
                                                  child: Text(
                                                    "Aceptar",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  onPressed: () {
                                                    setState(() {
                                                      emailSelected = true;
                                                    });
                                                    Navigator.pop(context);
                                                  })
                                            ]).show();
                                      }
                                    },
                                    child: Icon(FontAwesomeIcons.google,
                                        color: Colors.white),
                                    backgroundColor: Colors.red),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: h * 0.04,
                      ),
                      Text(
                        "No tienes una cuenta",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 900),
                        child: FlatButton(
                            onPressed: () {
                              _pageController.previousPage(
                                  duration: Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn);
                            },
                            child: Text(
                              "Regístrate aquí".toUpperCase(),
                              style: TextStyle(color: Colors.green.shade200),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Future<String> signInWithGoogle() async {
    print("Inicio");
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    print(_auth.currentUser());

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    print("Auth result");

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    print("Anonymus");

    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);

    print('signInWithGoogle succeeded: $user');
    print("${user.email}");
    print(user.photoUrl);
    print(user.displayName);
    setState(() {
      mailGoogle = user.email;
      imgUrlGoogle = user.photoUrl;
      nameGoogle = user.displayName;
    });

    return 'signInWithGoogle succeeded: $user';
  }

  void signOutGoogle() async {}

  Widget recoverPass() {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.green[900],
            Colors.green[800],
            Colors.green[400]
          ], begin: Alignment.topCenter)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: h * 0.05,
            ),
            FadeInDown(
              duration: Duration(milliseconds: 400),
              child: SizedBox(
                width: w,
                child: Image.asset("assets/logo.png"),
                height: h * 0.15,
              ),
            ),
            FadeIn(
              duration: Duration(milliseconds: 500),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextWidget()
                        .textTitle("RECUPERAR CONTRASEÑA", Colors.white, w),
                    TextWidget()
                        .textSubtitle("Indique su correo", Colors.white, w)
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: h * 0.07,
                      ),
                      FadeInLeft(
                        duration: Duration(milliseconds: 600),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                            width: w,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: emailRecup,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.mail_outline,
                                        color: Colors.green.shade200),
                                    border: InputBorder.none,
                                    hintText: "Ingrese su email",
                                    hintStyle: TextStyle(
                                        color: Colors.green.shade200,
                                        fontSize: w * 0.05)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 800),
                        child: RaisedButton(
                          color: Colors.green.shade700,
                          child: Text("RECUPERAR",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700)),
                          onPressed: () async {
                            if (emailRecup.text.isEmpty) {
                              Alert(
                                  style: AlertStyle(
                                      isCloseButton: false,
                                      animationType: AnimationType.grow,
                                      animationDuration:
                                          Duration(milliseconds: 500)),
                                  context: context,
                                  type: AlertType.error,
                                  title: "ERROR",
                                  desc: "Ingrese un email.",
                                  buttons: [
                                    DialogButton(
                                        child: Text("Aceptar",
                                            style:
                                                TextStyle(color: Colors.white)),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        })
                                  ]).show();
                            } else {
                              await getEmailVerification();
                              print("Two " + errorEmail.toString());
                              if (errorEmail) {
                                if (messageErrorMail.contains("formatted")) {
                                  Alert(
                                      style: AlertStyle(
                                          isCloseButton: false,
                                          animationType: AnimationType.grow,
                                          animationDuration:
                                              Duration(milliseconds: 500)),
                                      context: context,
                                      type: AlertType.error,
                                      title: "ERROR",
                                      desc:
                                          "El correo indicado no es válido. Ingrese uno correcto.",
                                      buttons: [
                                        DialogButton(
                                            color: Colors.red,
                                            child: Text("Aceptar",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: w * 0.05)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              errorEmail = false;
                                            })
                                      ]).show();
                                } else {
                                  Alert(
                                      style: AlertStyle(
                                          isCloseButton: false,
                                          animationType: AnimationType.grow,
                                          animationDuration:
                                              Duration(milliseconds: 500)),
                                      context: context,
                                      type: AlertType.error,
                                      title: "ERROR",
                                      desc:
                                          "El correo indicado no se encuentra registrado en nuestros datos.",
                                      buttons: [
                                        DialogButton(
                                            color: Colors.red,
                                            child: Text("Aceptar",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: w * 0.05)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              errorEmail = false;
                                            })
                                      ]).show();
                                }
                              } else {
                                Alert(
                                    style: AlertStyle(
                                        isCloseButton: false,
                                        animationType: AnimationType.grow,
                                        animationDuration:
                                            Duration(milliseconds: 500)),
                                    context: context,
                                    type: AlertType.success,
                                    title: "REALIZADO",
                                    desc:
                                        "Se ha enviado un correo a la dirección indicada.",
                                    buttons: [
                                      DialogButton(
                                          child: Text("Aceptar",
                                              style: TextStyle(
                                                  color: Colors.white)),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _pageController.previousPage(
                                                duration: Duration(
                                                    milliseconds: 1000),
                                                curve: Curves.fastOutSlowIn);
                                            setState(() {
                                              errorEmail = false;
                                            });
                                          })
                                    ]).show();
                              }
                            }
                          },
                          hoverColor: Colors.greenAccent,
                          splashColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.2,
                      ),
                      FadeInRight(
                        duration: Duration(milliseconds: 900),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: RaisedButton.icon(
                            color: Colors.green.shade700,
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            label: Text("VOLVER",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700)),
                            onPressed: () {
                              _pageController.previousPage(
                                  duration: Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn);
                            },
                            hoverColor: Colors.greenAccent,
                            splashColor: Colors.greenAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Future getEmailVerification() async {
    await FirebaseAuth.instance
        .sendPasswordResetEmail(email: emailRecup.text.replaceAll(" ", ""))
        .catchError((onError) {
      print(onError.message);
      setState(() {
        errorEmail = true;
        messageErrorMail = onError.message;
      });
      print("One " + errorEmail.toString());
    });

    return null;
  }

  Widget createUser() {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Stack(
      children: <Widget>[
        Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.green[900],
            Colors.green[800],
            Colors.green[400]
          ], begin: Alignment.topCenter)),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: h * 0.05,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FadeInLeft(
                    duration: Duration(milliseconds: 200),
                    child: Image.asset(
                      "assets/logo.png",
                      width: w * 0.25,
                    ),
                  ),
                  FadeInRight(
                    duration: Duration(milliseconds: 200),
                    child: RaisedButton.icon(
                      color: Colors.green.shade700,
                      icon: Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      label: Text("VOLVER",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700)),
                      onPressed: () {
                        _pageController.nextPage(
                            duration: Duration(seconds: 1),
                            curve: Curves.fastOutSlowIn);
                      },
                      hoverColor: Colors.greenAccent,
                      splashColor: Colors.greenAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20))),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeIn(
                      duration: Duration(milliseconds: 300),
                      child: TextWidget()
                          .textTitle("NUEVO USUARIO", Colors.white, w)),
                  FadeIn(
                    duration: Duration(milliseconds: 400),
                    child: TextWidget().textSubtitle(
                        "Complete los siguientes campos", Colors.white, w),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: h * 0.03,
                      ),
                      FadeInLeft(
                        duration: Duration(milliseconds: 500),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                            width: w,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: emailReg,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.mail_outline,
                                        color: Colors.green.shade200),
                                    border: InputBorder.none,
                                    hintText: "Ingrese su email",
                                    hintStyle: TextStyle(
                                        color: Colors.green.shade200,
                                        fontSize: w * 0.05)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeInLeft(
                        duration: Duration(milliseconds: 700),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                            width: w,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                obscureText: viewPass1,
                                controller: passReg,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Ingrese su contraseña",
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          LineAwesomeIcons.eye,
                                          color: viewPass
                                              ? Colors.green.shade200
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            viewPass1 = !viewPass1;
                                          });
                                        }),
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.green.shade200,
                                    ),
                                    hintStyle: TextStyle(
                                        color: Colors.green.shade200,
                                        fontSize: w * 0.05)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeInRight(
                        duration: Duration(milliseconds: 800),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                )),
                            width: w,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                obscureText: viewPass2,
                                controller: pass2Reg,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Repita su contraseña",
                                    suffixIcon: IconButton(
                                        icon: Icon(
                                          LineAwesomeIcons.eye,
                                          color: viewPass
                                              ? Colors.green.shade200
                                              : Colors.grey,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            viewPass2 = !viewPass2;
                                          });
                                        }),
                                    prefixIcon: Icon(
                                      Icons.vpn_key,
                                      color: Colors.green.shade200,
                                    ),
                                    hintStyle: TextStyle(
                                        color: Colors.green.shade200,
                                        fontSize: w * 0.05)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeInUp(
                        duration: Duration(milliseconds: 900),
                        child: RaisedButton(
                          color: Colors.green.shade700,
                          child: Text("REGISTRARME",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700)),
                          onPressed: () {
                            if (emailReg.text.isEmpty ||
                                pass2Reg.text.isEmpty ||
                                passReg.text.isEmpty) {
                              Alert(
                                  style: AlertStyle(
                                      isCloseButton: false,
                                      animationType: AnimationType.grow,
                                      animationDuration:
                                          Duration(milliseconds: 500)),
                                  context: context,
                                  title: "Error",
                                  type: AlertType.error,
                                  desc: "Complete todos los campos.",
                                  buttons: [
                                    DialogButton(
                                        child: Text(
                                          "Aceptar",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                        onPressed: () => Navigator.pop(context))
                                  ]).show();
                            } else if (passReg.text != pass2Reg.text) {
                              Alert(
                                      style: AlertStyle(
                                          isCloseButton: false,
                                          animationType: AnimationType.grow,
                                          animationDuration:
                                              Duration(milliseconds: 500)),
                                      buttons: [
                                        DialogButton(
                                            child: Text("Aceptar",
                                                style: TextStyle(
                                                    color: Colors.white)),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            })
                                      ],
                                      type: AlertType.error,
                                      context: context,
                                      title: "ERROR",
                                      desc: "Las contraseñas no coinciden.")
                                  .show();
                            } else {
                              handleSignUp(emailReg.text.replaceAll(" ", ""),
                                  passReg.text);
                            }
                          },
                          hoverColor: Colors.greenAccent,
                          splashColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                      SizedBox(
                        height: h * 0.03,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  Future getDataEmail(String email, String password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    print("Init");
    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .catchError((onError) {
      setState(() {
        errorEmailRegister = true;
        messageErrorRegister = onError.message;
        print("ERRORRRRRR ${onError.message}");
      });
    });
    return null;
  }

  handleSignUp(String email, String password) async {
    var w = MediaQuery.of(context).size.width;
    await getDataEmail(email, password);
    // final FirebaseUser user = result.user;

    if (errorEmailRegister) {
      if (messageErrorRegister.contains("already")) {
        Alert(
            style: AlertStyle(
                isCloseButton: false,
                animationType: AnimationType.grow,
                animationDuration: Duration(milliseconds: 500)),
            context: context,
            type: AlertType.error,
            title: "ERROR",
            desc: "Este correo ya está en uso por un usuario.",
            buttons: [
              DialogButton(
                  color: Colors.red,
                  child: Text("Aceptar",
                      style:
                          TextStyle(color: Colors.white, fontSize: w * 0.07)),
                  onPressed: () {
                    setState(() {
                      errorEmailRegister = false;
                    });
                    Navigator.pop(context);
                  })
            ]).show();
      } else if (messageErrorRegister.contains("formatted")) {
        Alert(
            style: AlertStyle(
                isCloseButton: false,
                animationType: AnimationType.grow,
                animationDuration: Duration(milliseconds: 500)),
            context: context,
            type: AlertType.error,
            title: "ERROR",
            desc: "El correo ingresado es inválido. Ingrese uno correcto.",
            buttons: [
              DialogButton(
                  color: Colors.red,
                  child: Text("Aceptar",
                      style:
                          TextStyle(color: Colors.white, fontSize: w * 0.07)),
                  onPressed: () {
                    setState(() {
                      errorEmailRegister = false;
                    });
                    Navigator.pop(context);
                  })
            ]).show();
      } else if (messageErrorRegister.contains("Password should")) {
        Alert(
            style: AlertStyle(
                isCloseButton: false,
                animationType: AnimationType.grow,
                animationDuration: Duration(milliseconds: 500)),
            context: context,
            type: AlertType.error,
            title: "ERROR",
            desc: "La contraseña debe tener como mínimo 6 caracteres.",
            buttons: [
              DialogButton(
                  color: Colors.red,
                  child: Text("Aceptar",
                      style:
                          TextStyle(color: Colors.white, fontSize: w * 0.07)),
                  onPressed: () {
                    setState(() {
                      errorEmailRegister = false;
                    });
                    Navigator.pop(context);
                  })
            ]).show();
      } else {
        Alert(
            style: AlertStyle(
                isCloseButton: false,
                animationType: AnimationType.grow,
                animationDuration: Duration(milliseconds: 500)),
            context: context,
            type: AlertType.error,
            title: "ERROR",
            desc: "Ha ocurrido un error al intentar registrar al usuario.",
            buttons: [
              DialogButton(
                  color: Colors.red,
                  child: Text("Aceptar",
                      style:
                          TextStyle(color: Colors.white, fontSize: w * 0.07)),
                  onPressed: () {
                    setState(() {
                      errorEmailRegister = false;
                    });
                    Navigator.pop(context);
                  })
            ]).show();
      }
    } else {
      Alert(
          style: AlertStyle(
              isCloseButton: false,
              animationType: AnimationType.grow,
              animationDuration: Duration(milliseconds: 500)),
          context: context,
          type: AlertType.success,
          title: "REALIZADO",
          desc: "Se ha registrado el nuevo usuario.",
          buttons: [
            DialogButton(
                child: Text("Aceptar", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.pop(context);
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 1000),
                      curve: Curves.fastOutSlowIn);
                })
          ]).show();
    }
  }
}
