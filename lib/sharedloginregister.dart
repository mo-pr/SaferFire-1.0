import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'adr.dart';
import 'api.dart';
import 'cam.dart';
import 'charts.dart';
import 'map.dart';
import 'notImplemeneted.dart';
import 'oxygenPage.dart';
import 'protocol.dart';
import 'stylesLoginRegister.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

Timer timer;
enum LoginStatus { notSignIn, signIn }
enum Title { Info, Karte, Foto, Protokoll, Atemschutz, Abschluss }

class _LoginPageState extends State<LoginPage> {
  int _pageState = 1;

  var _backgroundColor = Colors.white;
  var _headingColor = Color(0xFFB40284A);

  double _headingTop = 100;

  double _loginWidth = 0;
  double _loginHeight = 0;
  double _loginOpacity = 1;

  double _loginYOffset = 0;
  double _loginXOffset = 0;
  double _registerYOffset = 0;
  double _registerHeight = 0;

  double windowWidth = 0;
  double windowHeight = 0;

  bool _keyboardVisible = false;

  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String email = "", password = "", feuerwehr = "";
  final _key = new GlobalKey<FormState>(),
      _keyT = new GlobalKey<FormState>(),
      _keyV = new GlobalKey<FormState>();

  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  checkPass() {
    final form = _keyV.currentState;
    if (form.validate()) {
      form.save();
      mailCheck();
    }
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    }
  }

  checkReg() {
    final form = _keyT.currentState;
    if (form.validate()) {
      form.save();
      save();
    }
  }

  mailCheck() async {
    final response = await http
        .post(Uri.parse("http://IP/api_verification.php"), body: {
      "flag": 3.toString(),
      "email": email
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String emailAPI = data['email'];
    String id = data['id'];
    String ff = data['ff'];
    if (value == 1) {
      setState(() {
        final form = _keyV.currentState;
        form.reset();
      });
      print(message);
      loginToast(message);
    } else {
      print(message);
      loginToast(message);
    }
  }

  login() async {
    final response = await http
        .post(Uri.parse("http://IP/api_verification.php"), body: {
      "flag": 1.toString(),
      "email": email,
      "password": password
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    String emailAPI = data['email'];
    String id = data['id'];
    String ff = data['ff'];
    if (value == 1) {
      setState(() {
        _loginStatus = LoginStatus.signIn;
        savePref(value, emailAPI, id, ff);
      });
      print(message);
      loginToast(message);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainMenu(signOut)));
    } else {
      print("fail");
      print(message);
      loginToast(message);
    }
  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  savePref(int value, String email, String id, String ff) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("email", email);
      preferences.setString("id", id);
      preferences.setString('ff', ff);
      preferences.commit();
    });
  }

  save() async {
    final response = await http
        .post(Uri.parse("http://IP/api_verification.php"), body: {
      "flag": 2.toString(),
      "email": email,
      "feuerwehr": feuerwehr,
      "password": password
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if (value == 1) {
      setState(() {
        info();
        _pageState = 1;
        final form = _keyT.currentState;
        form.reset();
      });
      print(message);
      registerToast(message);
    } else if (value == 2) {
      print(message);
      registerToast(message);
    } else {
      print(message);
      registerToast(message);
    }
  }

  registerToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");
      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  signOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.clear();
      preferences.commit();
      _loginStatus = LoginStatus.notSignIn;
    });
    Navigator.pop(context);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    timer = Timer.periodic(
        Duration(seconds: 10), (Timer t) => infoState().getAPI());
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    if (_loginStatus.toString() != 'LoginStatus.signIn') {
      windowHeight = MediaQuery.of(context).size.height;
      windowWidth = MediaQuery.of(context).size.width;

      _loginHeight = windowHeight - 270;
      _registerHeight = windowHeight - 270;

      switch (_pageState) {
        case 0:
          _backgroundColor = Colors.white;
          _headingColor = Color(0xFFB40284A);

          _headingTop = 100;

          _loginWidth = windowWidth;
          _loginOpacity = 1;

          _loginYOffset = windowHeight;
          _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

          _loginXOffset = 0;
          _registerYOffset = windowHeight;
          break;
        case 1:
          _backgroundColor = Color(0xFFB020030);
          _headingColor = Colors.white;

          _headingTop = 90;

          _loginWidth = windowWidth;
          _loginOpacity = 1;

          _loginYOffset = _keyboardVisible ? 40 : 270;
          _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 270;

          _loginXOffset = 0;
          _registerYOffset = windowHeight;
          break;
        case 2:
          _backgroundColor = Color(0xFFB020030);
          _headingColor = Colors.white;

          _headingTop = 80;

          _loginWidth = windowWidth - 40;
          _loginOpacity = 0.7;

          _loginYOffset = _keyboardVisible ? 30 : 240;
          _loginHeight = _keyboardVisible ? windowHeight : windowHeight - 240;

          _loginXOffset = 20;
          _registerYOffset = _keyboardVisible ? 55 : 270;
          _registerHeight =
              _keyboardVisible ? windowHeight : windowHeight - 270;
          break;
      }

      bool validateFeuerwehr(String exp) {
        RegExp reg = new RegExp("FF [A-Z][a-z]*");
        return reg.hasMatch(exp);
      }

      return MaterialApp(
        home: Scaffold(
            body: Stack(
          children: <Widget>[
            AnimatedContainer(
                curve: Curves.fastLinearToSlowEaseIn,
                duration: Duration(milliseconds: 1000),
                color: _backgroundColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      height: 280,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/firewatch.png'),
                              fit: BoxFit.fill)),
                    ),
                    Container(
                      width: windowWidth - 40,
                      child: Form(
                        key: _keyV,
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text(
                                "Forgot Password",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Card(
                              elevation: 6.0,
                              child: TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Please Insert Email";
                                  } else if (EmailValidator.validate(e) ==
                                      false) {
                                    return "E-Mail muss dem Format (abc@def.ghi) entsprechen";
                                  }
                                },
                                onSaved: (e) => email = e,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(Icons.email,
                                          color: Colors.black),
                                    ),
                                    contentPadding: EdgeInsets.all(18),
                                    labelText: "Email"),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          checkPass();
                          setState(() {
                            _pageState = 1;
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.all(32),
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(50)),
                          child: Center(
                            child: Text(
                              "Send New Password",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
            AnimatedContainer(
              padding: EdgeInsets.all(30),
              width: _loginWidth,
              height: _loginHeight,
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 1000),
              transform:
                  Matrix4.translationValues(_loginXOffset, _loginYOffset, 1),
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(_loginOpacity),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Form(
                    key: _key,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Text(
                            "Login To Continue",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please Insert Email";
                              } else if (EmailValidator.validate(e) == false) {
                                return "E-Mail muss dem Format (abc@def.ghi) entsprechen";
                              }
                            },
                            onSaved: (e) => email = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.email, color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(18),
                                labelText: "Email"),
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Password can't be Empty";
                              }
                            },
                            obscureText: _secureText,
                            onSaved: (e) => password = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                              labelText: "Password",
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.phonelink_lock,
                                    color: Colors.black),
                              ),
                              suffixIcon: IconButton(
                                onPressed: showHide,
                                icon: Icon(_secureText
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                              ),
                              contentPadding: EdgeInsets.all(18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          check();
                        },
                        child: PrimaryButton(
                          btnText: "Login",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pageState = 2;
                          });
                        },
                        child: OutlineBtn(
                          btnText: "Create New Account",
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: Text(
                          "Passwort vergessen?",
                          style: TextStyle(fontSize: 15),
                        ),
                        onTap: () {
                          setState(() {
                            _pageState = 0;
                          });
                          //loginToast("Passwort vergessen");
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              height: _registerHeight,
              padding: EdgeInsets.all(30),
              curve: Curves.fastLinearToSlowEaseIn,
              duration: Duration(milliseconds: 1000),
              transform: Matrix4.translationValues(0, _registerYOffset, 1),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Form(
                    key: _keyT,
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 8),
                          child: Text(
                            "Create a New Account",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Feuerwehr darf nicht leer sein";
                              } else if (validateFeuerwehr(e) == false) {
                                return "Feuerwehr muss dem Format (FF Xyz) entsprechen";
                              }
                            },
                            onSaved: (e) => feuerwehr = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.local_fire_department,
                                      color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(18),
                                labelText: "Firestation"),
                          ),
                        ),

                        //card for Email TextFormField
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert Email";
                              } else if (EmailValidator.validate(e) == false) {
                                return "E-Mail muss dem Format (abc@def.ghi) entsprechen";
                              }
                            },
                            onSaved: (e) => email = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.email, color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(18),
                                labelText: "Email"),
                          ),
                        ),
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            obscureText: _secureText,
                            onSaved: (e) => password = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: showHide,
                                  icon: Icon(_secureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.phonelink_lock,
                                      color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(18),
                                labelText: "Password"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          checkReg();
                        },
                        child: PrimaryButton(
                          btnText: "Create Account",
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _pageState = 1;
                          });
                        },
                        child: OutlineBtn(
                          btnText: "Back To Login",
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        )),
      );
    } else {
      return Container(
        child: MainMenu(signOut),
      );
    }
  }
}

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;

  MainMenu(this.signOut);

  @override
  MainMenuState createState() => MainMenuState();
}

class MainMenuState extends State<MainMenu> {
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  Timer _timer;
  String email = "", id = "", ff = "";
  TabController tabController;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      email = preferences.getString("email");
      ff = preferences.getString('ff');
    });
    print("ID: " + id);
    print("USER: " + email);
    print("Feuerwehr: " + ff);
  }

  @override
  void initState() {
    super.initState();
    getPref();
    new Timer.periodic(new Duration(seconds: 3), (timer) {
      setState(() {
        infoState().getAPI();
      });
    });
  }

  String _title = "Dashboard";
  int pageIndex = 0;
  int initialIndex = 0;
  final info _info = info();
  final camera _cam = camera();
  final Protocol _protocol = Protocol();
  final Oxygen _oxygen = Oxygen();
  final map _map = map();
  final adr _adr = adr();
  final ChartsPage _chart = ChartsPage();
  final noImpl _nimpl = noImpl();

  bool isExpanded = false;
  double lat = 0, lng = 0;

  void _setTitle(int index) {
    setState(() {
      lat = infoState().getlat();
      lng = infoState().getlng();
      _title = pageNames[index];
    });
  }

  List<Widget> pages = <Widget>[
    info(),
    map(),
    camera(),
    Protocol(),
    Oxygen(),
    noImpl(),
    adr(),
    noImpl(),
    ChartsPage()
  ];

  List<String> pageNames = <String>[
    "Dashboard",
    "Karte",
    "Kamera",
    "Protokoll",
    "Atemschutz",
    "Rettungskarte",
    "Gefahrgut",
    "Wasserkarte",
    "Statistik"
  ];

  List<IconData> pageIcons = <IconData>[
    Icons.info_rounded,
    Icons.map_rounded,
    Icons.local_see,
    Icons.format_list_bulleted_rounded,
    Icons.alarm_rounded,
    Icons.directions_car,
    Icons.warning_rounded,
    Icons.waves_rounded,
    Icons.poll_rounded
  ];

  void toggleDrawer(){
    setState(() {
      isExpanded = !isExpanded;
    });
  }
  void changeIndex(int index){
    setState(() {
      _setTitle(index);
      _index = index;
    });
  }
  
  int _index = 0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => {
                toggleDrawer()
              },
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    signOut();
                  }),
            ],
            title: Text(
              _title,
              style: TextStyle(fontSize: 20),
            ),
            backgroundColor: Color(0xffb32b19),
          ),
          body: Row(
            children: [
              isExpanded ?
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width*0.45,
                child: Column(children: [
                  Flexible(
                    child:
                    ListView(padding: EdgeInsets.zero, children: <Widget>[
                      Container(
                        color: _index == 0? Colors.black12:Colors.white,
                        child: ListTile(
                            leading:
                            Icon(Icons.dashboard_rounded, color: Colors.black87),
                            title: Text("Dashboard",
                                style: TextStyle(color: Colors.black87,fontSize: 15)),
                            onTap: () {
                              changeIndex(0);
                              toggleDrawer();
                            }),
                      ),
                      Container(
                        color: _index == 1? Colors.black12:Colors.white,
                        child: ListTile(
                            leading:
                            Icon(Icons.map_rounded, color: Colors.black87),
                            title: Text("Karte",
                                style: TextStyle(color: Colors.black87,fontSize: 15)),
                            onTap: () {
                              changeIndex(1);
                              toggleDrawer();
                            }),
                      ),
                      Container(
                        color: _index == 2? Colors.black12:Colors.white,
                        child: ListTile(
                            leading:
                            Icon(Icons.local_see, color: Colors.black87),
                            title: Text("Kamera",
                                style: TextStyle(color: Colors.black87,fontSize: 15)),
                            onTap: () {
                              changeIndex(2);
                              toggleDrawer();
                            }),
                      ),
                      Container(
                        color: _index == 3? Colors.black12:Colors.white,
                        child: ListTile(
                            leading:
                            Icon(Icons.format_list_bulleted_rounded, color: Colors.black87),
                            title: Text("Protokoll",
                                style: TextStyle(color: Colors.black87,fontSize: 15)),
                            onTap: () {
                              changeIndex(3);
                              toggleDrawer();
                            }),
                      ),
                      Container(
                        color: _index == 4? Colors.black12:Colors.white,
                        child: ListTile(
                            leading:
                            Icon(Icons.alarm_rounded, color: Colors.black87),
                            title: Text("Atemschutz",
                                style: TextStyle(color: Colors.black87,fontSize: 15)),
                            onTap: () {
                              changeIndex(4);
                              toggleDrawer();
                            }),
                      ),
                      Container(
                        color: _index == 5? Colors.black12:Colors.white,
                        child: ListTile(
                            leading:
                            Icon(Icons.directions_car, color: Colors.black87),
                            title: Text("Rettungskarte",
                                style: TextStyle(color: Colors.black87,fontSize: 15)),
                            onTap: () {
                              changeIndex(5);
                              toggleDrawer();
                            }),
                      ),
                      Container(
                        color: _index == 6? Colors.black12:Colors.white,
                        child: ListTile(
                            leading:
                            Icon(Icons.warning_rounded, color: Colors.black87),
                            title: Text("Gefahrgut",
                                style: TextStyle(color: Colors.black87,fontSize: 15)),
                            onTap: () {
                              changeIndex(6);
                              toggleDrawer();
                            }),
                      ),
                      Container(
                        color: _index == 7? Colors.black12:Colors.white,
                        child: ListTile(
                            leading: Icon(Icons.waves_rounded, color: Colors.black87),
                            title: Text("Wasserkarte",
                                style: TextStyle(color: Colors.black87,fontSize: 15)),
                            onTap: () {
                              changeIndex(7);
                              toggleDrawer();
                            }),
                      ),
                      Container(
                        color: _index == 8? Colors.black12:Colors.white,
                        child: ListTile(
                            leading: Icon(Icons.poll_rounded, color: Colors.black87),
                            title: Text("Statistik",
                                style: TextStyle(color: Colors.black87,fontSize: 15)),
                            onTap: () {
                              changeIndex(8);
                              toggleDrawer();
                            }),
                      ),
                    ]),
                  ),
                ]),
              )
              :Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width*0.15,
                child: Column(children: [
                  Flexible(
                    child:
                        ListView(padding: EdgeInsets.zero, children: <Widget>[
                          Container(
                            color: _index == 0? Colors.black12:Colors.white,
                            child: ListTile(
                                leading:
                                Icon(Icons.dashboard_rounded, color: Colors.black87),
                                onTap: () {
                                  changeIndex(0);
                                }),
                          ),
                          Container(
                            color: _index == 1? Colors.black12:Colors.white,
                            child: ListTile(
                                leading:
                                Icon(Icons.map_rounded, color: Colors.black87),
                                onTap: () {
                                  changeIndex(1);
                                }),
                          ),
                          Container(
                            color: _index == 2? Colors.black12:Colors.white,
                            child: ListTile(
                                leading:
                                Icon(Icons.local_see, color: Colors.black87),
                                onTap: () {
                                  changeIndex(2);
                                }),
                          ),
                          Container(
                            color: _index == 3? Colors.black12:Colors.white,
                            child: ListTile(
                                leading:
                                Icon(Icons.format_list_bulleted_rounded, color: Colors.black87),
                                onTap: () {
                                  changeIndex(3);
                                }),
                          ),
                          Container(
                            color: _index == 4? Colors.black12:Colors.white,
                            child: ListTile(
                                leading:
                                Icon(Icons.alarm_rounded, color: Colors.black87),
                                onTap: () {
                                  changeIndex(4);
                                }),
                          ),
                          Container(
                            color: _index == 5? Colors.black12:Colors.white,
                            child: ListTile(
                                leading:
                                Icon(Icons.directions_car, color: Colors.black87),
                                onTap: () {
                                  changeIndex(5);
                                }),
                          ),
                          Container(
                            color: _index == 6? Colors.black12:Colors.white,
                            child: ListTile(
                                leading:
                                Icon(Icons.warning_rounded, color: Colors.black87),
                                onTap: () {
                                  changeIndex(6);
                                }),
                          ),
                          Container(
                            color: _index == 7? Colors.black12:Colors.white,
                            child: ListTile(
                                leading: Icon(Icons.waves_rounded, color: Colors.black87),
                                onTap: () {
                                  changeIndex(7);
                                }),
                          ),
                          Container(
                            color: _index == 8? Colors.black12:Colors.white,
                            child: ListTile(
                                leading: Icon(Icons.poll_rounded, color: Colors.black87),
                                onTap: () {
                                  changeIndex(8);
                                }),
                          ),
                    ]),
                  ),
                ]),
              ),
              Container(
                width: isExpanded ? MediaQuery.of(context).size.width*0.55:MediaQuery.of(context).size.width*0.85,
                child: Column(
                  children: [
                    _index == 0?
                    Flexible(
                      child: StaggeredGridView.countBuilder(
                        itemCount: pages.length,
                        crossAxisCount: 4,
                        itemBuilder: (BuildContext context, int index) =>
                            index == 0
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 2,
                                          color: Color(0xffb32b19)),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.6),
                                          spreadRadius: 2,
                                          blurRadius: 2,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                    ),
                                    margin: EdgeInsets.all(5),
                                    height:
                                        MediaQuery.of(context).size.height / 2,
                                    child: DrawerHeader(child: _info),
                                  )
                                : new GestureDetector(
                                    child: Card(
                                      margin: EdgeInsets.all(5),
                                      color: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10),
                                              topRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10)),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              spreadRadius: 2,
                                              blurRadius: 2,
                                              offset: Offset(0,
                                                  3), // changes position of shadow
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              pageIcons[index],
                                              color: Colors.black87,
                                            ),
                                            Text(
                                              pageNames[index].toUpperCase(),
                                              style: TextStyle(fontSize: isExpanded? 11:15,
                                                  color: Colors.black87),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    onTap: () => {
                                      changeIndex(index)
                                    },
                                  ),
                        staggeredTileBuilder: (int index) => index == 0
                            ? new StaggeredTile.count(4, 4)
                            : new StaggeredTile.count(2, 1),
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 1.0,
                      ),
                    ):Container(),
                    _index == 1?
                    Flexible(child: _map):Container(),
                    _index == 2?
                    Flexible(child: _cam):Container(),
                    _index == 3?
                    Flexible(child: _protocol):Container(),
                    _index == 4?
                    Flexible(child: _oxygen):Container(),
                    _index == 5?
                    Flexible(child: _nimpl):Container(),
                    _index == 6?
                    Flexible(child: _adr):Container(),
                    _index == 7?
                    Flexible(child: _nimpl):Container(),
                    _index == 8?
                    Flexible(child: _chart):Container(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
