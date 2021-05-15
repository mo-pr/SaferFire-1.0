import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:ui';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:safer_fire_test/cam.dart';
import 'package:safer_fire_test/charts.dart';
import 'package:safer_fire_test/protocol.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';
import 'oxygenPage.dart';
import 'stylesLoginRegister.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

Timer timer;
Set<Marker> markers = new HashSet<Marker>();
enum LoginStatus { notSignIn, signIn }
enum Title { Info, Karte, Foto, Protokoll, Atemschutz, Abschluss }

class _LoginPageState extends State<LoginPage> {
  int _pageState = 1;

  var _backgroundColor = Colors.red;
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
  String email, password, feuerwehr;
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
    final response = await http.post(
        Uri.parse("http://192.168.0.8/api_verification.php"),
        body: {"flag": 3.toString(), "email": email});
    /*final response = await http
        .post(Uri.parse("http://86.56.241.47/api_verification.php"), body: {
      "flag": 3.toString(),
      "email": email
    });*/
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
    final response = await http.post(
        Uri.parse("http://192.168.0.8/api_verification.php"),
        body: {"flag": 1.toString(), "email": email, "password": password});
    /*final response = await http
        .post(Uri.parse("http://86.56.241.47/api_verification.php"), body: {
      "flag": 1.toString(),
      "email": email,
      "password": password
    });*/
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
        timeInSecForIos: 1,
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
        .post(Uri.parse("http://192.168.0.8/api_verification.php"), body: {
      "flag": 2.toString(),
      "email": email,
      "feuerwehr": feuerwehr,
      "password": password
    });
    /*final response = await http
        .post(Uri.parse("http://86.56.241.47/api_verification.php"), body: {
      "flag": 2.toString(),
      "email": email,
      "feuerwehr": feuerwehr,
      "password": password
    });*/
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
        timeInSecForIos: 1,
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
      preferences.setInt("value", null);
      preferences.setString("email", null);
      preferences.setString("id", null);
      preferences.setString('ff', null);
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
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardVisible = visible;
        });
      },
    );
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
          _backgroundColor = Colors.red;
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
          _backgroundColor = Colors.red;
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
                                      child: Icon(Icons.person,
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
                                  child:
                                      Icon(Icons.person, color: Colors.black),
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
                                  child:
                                      Icon(Icons.person, color: Colors.black),
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
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
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
      infoState().getAPI();
    });
  }

  String _title = "Info";
  int pageIndex = 0;
  int initialIndex = 0;
  final info _infoPage = info();
  //final ChartsPage _chartsPage = ChartsPage();
  final camera _cam = camera();
  final Protocol _protocol = Protocol();
  final Oxygen _oxygen = Oxygen();
  final ChartsPage _chart = ChartsPage();

  Widget _showPage = new ChartsPage();

  Widget _pageChooser(int page) {
    switch (page) {
      case 0:
        return _infoPage;
        break;
      case 1:
        return Container(
          child: lat != 0.0 && lng != 0.0
              ? GoogleMap(
                  markers: markers,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(lat, lng),
                    zoom: 16,
                  ),
                  mapType: MapType.hybrid,
                )
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(48.310258, 14.310297),
                    zoom: 13,
                  ),
                  mapType: MapType.hybrid,
                ),
        );
        break;
      case 2:
        return _cam;
        break;
      case 3:
        return _chart;
        break;
      case 4:
        return _oxygen;
        break;
      default:
        new Container(
          child: new Center(
            child: new Text(
              "Error: No Page found",
              style: new TextStyle(fontSize: 30),
            ),
          ),
        );
    }
  }

  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();
  double lat, lng;

  void _setTitle(int index) {
    setState(() {
      markers = new HashSet<Marker>();
      lat = infoState().getlat();
      lng = infoState().getlng();
      markers.add(new Marker(
          markerId: MarkerId('marker_id_1'),
          position: LatLng(lat, lng),
          icon: BitmapDescriptor.defaultMarker));
      var temp = Title.values[index].toString().split('.');
      _title = temp[1];
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      infoState().getAPI();
    });
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            drawer: Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.white.withOpacity(0.9),
                ),
                child: Drawer(
                    child: Stack(children: <Widget>[
                  /*BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white10))),*/
                  ListView(padding: EdgeInsets.zero, children: <Widget>[
                    DrawerHeader(child: Text('Safer.Fire',style: TextStyle(fontSize: 16),)),
                    ListTile(
                        leading: Icon(Icons.dashboard, color: Colors.white),
                        title: Text("Dashboard"),
                        onTap: () {})
                  ])
                ]))),
            backgroundColor: Colors.white10,
            appBar: AppBar(
              actions: [
                IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      signOut();
                    }),
              ],
              centerTitle: true,
              title: Text(
                _title,
                style: TextStyle(fontSize: 30),
              ),
              backgroundColor: Colors.red,
            ),
            bottomNavigationBar: CurvedNavigationBar(
              key: _bottomNavigationKey,
              index: pageIndex,
              height: 50.0,
              items: <Widget>[
                Icon(Icons.info, size: 30),
                Icon(Icons.map, size: 30),
                Icon(Icons.local_see, size: 30),
                Icon(Icons.format_list_bulleted, size: 30),
                Icon(Icons.alarm, size: 30),
              ],
              color: Colors.white,
              buttonBackgroundColor: Colors.white,
              backgroundColor: Colors.transparent,
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 300),
              onTap: (trappedIndex) {
                setState(() {
                  _setTitle(trappedIndex);
                  _showPage = _pageChooser(trappedIndex);
                });
              },
              letIndexChange: (index) => true,
            ),
            body: Container(
              child: Center(
                child: _showPage,
              ),
            )));
  }
}
