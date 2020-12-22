import 'dart:convert';
import 'dart:ui';
import 'package:attendance/Widget/rotatetext.dart';
import 'package:attendance/Widget/typer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:attendance/models/user.dart';
import 'package:toast/toast.dart';

class HomeScreen extends StatefulWidget {
  List<User> userdetails;
  HomeScreen({this.userdetails});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin{

  Future userLogin() async{

    String email = widget.userdetails[0].email;
    String password = widget.userdetails[0].password;

    var url = 'https://thermogenetic-membr.000webhostapp.com/login.php';

    var data = {'email': email, 'password' : password};

    var response = await http.post(url, body: json.encode(data));

    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    setState(() {
      widget.userdetails= parsed.map<User>((json) =>User.fromJson(json)).toList();

    });
    print(response.body.toString());



  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //userLogin();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[DrawerScreen( userdetails: widget.userdetails,), HomeScreenmain(userdetails: widget.userdetails,)],
      ),
    );
  }
}

class DrawerScreen extends StatefulWidget {
  List<User> userdetails;
  DrawerScreen({this.userdetails});
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool admin;
  String userid;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Container(
      color: Color(0xFF2577FD),
      //   width: wid,
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 50.0,
          ),
          ListTile(
              leading: Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: Text("Home", style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) =>new HomeScreen(userdetails: widget.userdetails,)));

           //     Navigator.pop(context);
           //     Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
              }),
          ListTile(
              leading: Icon(
                Icons.person_pin,
                color: Colors.white,
              ),
              title: Text("Profile", style: TextStyle(color: Colors.white)),
              onTap: () {
               // Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) =>new ProfileScreen(userdetails: widget.userdetails,)));

              }),
          widget.userdetails[0].level=="admin"
              ? ListTile(
              leading: Icon(
                Icons.map,
                color: Colors.white,
              ),
              title:
              Text("Admin", style: TextStyle(color: Colors.white)),
              onTap: () {
              //  Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) =>new AdminAttendanceScreen(userdetails: widget.userdetails,)));


              })
              : Container(
            width: 0,
            height: 0,
          ),
          ListTile(
              leading: Icon(
                Icons.remove_from_queue,
                color: Colors.white,
              ),
              title: Text("Leave Request", style: TextStyle(color: Colors.white)),
              onTap: () {
               // Navigator.pop(context);
               // Navigator.push(context, MaterialPageRoute(builder: (context) => LeaveRequestScreen()));
              }),
          ListTile(
              leading: Icon(
                Icons.power_settings_new,
                color: Colors.white,
              ),
              title: Text("Logout", style: TextStyle(color: Colors.white)),
              onTap: () {

              }),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class HomeScreenmain extends StatefulWidget {
  List<User> userdetails;
   HomeScreenmain({this.userdetails});
  @override
  _HomeScreenmainState createState() => _HomeScreenmainState();
}

class _HomeScreenmainState extends State<HomeScreenmain>
    with SingleTickerProviderStateMixin {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  AnimationController progresscontroller;
  Animation<double> animation;
  bool isDrawerOpen = false;
  //List<bool> isSelected;

  SharedPreferences _prefs;
  static const String statuskey = 'status_key';
  String userid;
  String _status;
  String name;

  String latitudedata = "";
  String longitudedata = "";

  double i, j;
  String rad = "";

  String cintime = "";
  String couttime = "";

  var hour = DateTime.now().hour;

  bool loginloader;
  bool logoutloader;


  getCurrentlocation(String da, String da2) async {
    final geoposition = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    setState(() async {
      i = geoposition.latitude;
      j = geoposition.longitude;
      latitudedata = geoposition.latitude.toString();
      longitudedata = geoposition.longitude.toString();
      print("LATITUDE $latitudedata        LONGITUDE  $longitudedata");
      radiuscheck(geoposition.latitude, geoposition.longitude, da, da2);

      // addcindata(da, da2);
    });
  }

  radiuscheck(double lat, double long, String da, String da2) {
    (13.0646661 <= i && i <= 13.065)
        ? setState(() async {

      var url = 'https://thermogenetic-membr.000webhostapp.com/attendance.php';
      var data = {'email': widget.userdetails[0].email, 'name':widget.userdetails[0].name,
      'date':da, 'attendance':'present', 'cintime':da2.substring(11,19),'couttime':'',
        'late':DateTime.parse(da2).difference(DateTime.parse(DateFormat("yyyy-MM-dd 09:00:00").format(DateTime.now()))).toString().substring(0,4),
        'extra':''
      };
      var response = await http.post(url, body: json.encode(data));
      print(DateTime.parse(da2).difference(DateTime.parse(DateFormat("yyyy-MM-dd 09:00:00").format(DateTime.now()))).toString().substring(0,4));
      print(response.body.toString());
      rad = "You are in Tetrosoft";
      this._setStatus("In");


    })
        : setState(() {
      rad = "You are not in Tetrosoft";
      this._setStatus("away");
      loginloader=false;
    });
  }

  addcoutdata(String email,String da, String da2) async {
    var url = 'https://thermogenetic-membr.000webhostapp.com/addcouttime.php';

    var data = {'email': email, 'date' : da, 'couttime':da2.substring(11,19), 'extra':DateTime.parse(da2).difference(DateTime.parse(DateFormat("yyyy-MM-dd 18:00:00").format(DateTime.now()))).toString().substring(0,4)};

    var response = await http.post(url, body: json.encode(data));
    print(response.body.toString());

  }


  todaydetails(String useremail, String da) async {
    var url = 'https://thermogenetic-membr.000webhostapp.com/todaydetails.php';

    var data = {'email': useremail, 'date' : da};

    var response = await http.post(url, body: json.encode(data));
   // print(response.body.toString());
    final parsed = json.decode(response.body);

  //  print(parsed[0]['cintime'].toString());
    setState(() {
      parsed!=null?cintime=parsed[0]['cintime'].toString():null;
     parsed!=null? couttime=parsed[0]['couttime'].toString():null;
    });
  //  print(parsed.toString());
    //users= parsed.map<User>((json) =>User.fromJson(json)).toList();


  }


  greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {

      return Text("Good Morning",style: GoogleFonts.roboto(fontSize: 26,fontWeight: FontWeight.w500));
    }
    if (hour < 17) {
      return Text("Good Afternoon",style: GoogleFonts.roboto(fontSize: 26,fontWeight: FontWeight.w500));
    }
    return Center(child:Container(
        height: 40,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Text(
                "Good ",
                style: GoogleFonts.roboto(fontWeight: FontWeight.w500,fontSize: 26)
            ),
            Padding(padding: EdgeInsets.only(top: 5),child:
            RotateAnimatedTextKit(
              text: ["Evening"],
              textStyle: GoogleFonts.roboto(fontSize: 26,fontWeight: FontWeight.w500),

            ),
            )
          ],
        )
    )
    );
    // return Text("Good Evening",style: GoogleFonts.roboto(fontSize: 26,fontWeight: FontWeight.w500));
  }


  Future userLogin() async{

    String email = widget.userdetails[0].email;
    String password = widget.userdetails[0].password;

    var url = 'https://thermogenetic-membr.000webhostapp.com/login.php';

    var data = {'email': email, 'password' : password};

    var response = await http.post(url, body: json.encode(data));

    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    setState(() {
      widget.userdetails= parsed.map<User>((json) =>User.fromJson(json)).toList();
    });
    print(response.body.toString());
  }
  @override
  void initState() {
    super.initState();
    progresscontroller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    animation = Tween<double>(begin: 0, end: 80).animate(progresscontroller)
      ..addListener(() {
        setState(() {});
      });
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._prefs = prefs);

        _loadStatus();
      });
    setState(() {
      loginloader=false;
      logoutloader=false;
    });
    // userLogin();
  }
  List<Color> _colors = [
    Color.fromRGBO(239, 212, 56, 1),
    Color.fromRGBO(247, 177, 66, 1),

  ];
  //List<double> _stops = [0.5, 0.6];
  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;
    DateFormat df = DateFormat("dd-MM-yyyy");
    DateFormat df2 = DateFormat("yyyy-MM-dd HH:mm:ss");
    String da = df.format(DateTime.now());
    String da2 = df2.format(DateTime.now());

    todaydetails(widget.userdetails[0].email, da);
    return GestureDetector(
        onTap: () {
          setState(() {
            xOffset = 0;
            yOffset = 0;
            scaleFactor = 1;
            isDrawerOpen = false;
          });
        },
        child: SafeArea(child: AnimatedContainer(
          height: MediaQuery.of(context).size.height,
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor)
            ..rotateY(isDrawerOpen ? 0 : 0),
          duration: Duration(milliseconds: 250),
          decoration: BoxDecoration(
            //   color: Theme.of(context).backgroundColor,
              color: Color(0xFFF9F8FB)
            //  borderRadius: BorderRadius.circular(isDrawerOpen?40:0.0)

          ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[

                Container(
                  width: wid,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      isDrawerOpen
                          ? IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          setState(() {
                            xOffset = 0;
                            yOffset = 0;
                            scaleFactor = 1;
                            isDrawerOpen = false;
                          });
                        },
                      )
                          : IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            setState(() {
                              xOffset = 250;
                              yOffset = 0;
                              scaleFactor = 1;
                              isDrawerOpen = true;
                            });
                          }),
                      SizedBox(
                        width: wid / 5,
                      ),
                      Text(
                        "Home",
                        style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                //  SizedBox(height: hei*0.1,),

                //SizedBox(height: 20,),

                Stack(
                  children: <Widget>[
                    Container(
                      height: hei*0.25,
                      width: wid,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topRight,

                              colors: _colors,
                             stops: [0.1,0.9]
                          )),

                      child: Column(
                        children: <Widget>[
                          SizedBox(height: hei*0.03,),
                          greeting(),
                          SizedBox(height: hei*0.01,),
                          //    Text("Good Morning..",softWrap: true,style: GoogleFonts.roboto(fontSize: 22)),

                          Text(widget.userdetails[0].name.toUpperCase(),softWrap: true,style: GoogleFonts.roboto(fontSize: 20,)),
                          SizedBox(height: hei*0.01,),
                          TyperAnimatedTextKit(
                              isRepeatingAnimation: false,
                              speed: Duration(milliseconds: 250),
                              text: [
                                DateFormat("dd-MM-yyyy").format(DateTime.now())
                              ],
                              textStyle:GoogleFonts.roboto(fontSize: 18)
                            // or Alignment.topLeft
                          ),
                          //  Text(DateFormat("dd-MM-yyyy").format(DateTime.now()),style: GoogleFonts.roboto(fontSize: 18),),
                          SizedBox(height: 10,),
                          Text(DateFormat.jm().format(DateTime.parse(DateTime.now().toString())),style: GoogleFonts.roboto(fontSize: 16),)
                        ],
                      ),

                    ),

                  ],
                ),
                _status == 'status' || _status == 'away'?
                !loginloader?RaisedButton(onPressed: (){
                  setState(() {
                    loginloader=true;
                  });
                  getCurrentlocation(da, da2);
                  todaydetails(userid, da);
                },
                  shape: CircleBorder(),
                  child: Image.asset("assets/images/login.png"),
                ):  Image.asset("assets/images/loader2.gif"):

                RaisedButton(onPressed: (){


                  showDialog(context: context,
                    builder: (BuildContext dcontext){
                      return  BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 100),
                           child:Container(
                             color: Colors.red.withOpacity(0.1),
                          child:  Dialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)
                            ),
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            child: _buildChild(dcontext,da,da2),
                          )
                           )
                      );
                    }
                    );

                },
                  shape: CircleBorder(),
                  child: Image.asset("assets/images/logout.png"),
                ),


                SizedBox(
                  height: hei * 0.07,
                ),
                //Text(rad)
                _status == 'In' ? Text("You are in Tetrosoft",style: GoogleFonts.openSans(),) : Container(),
                _status == 'away'
                    ? Text("You are not in Tetrosoft")
                    : Container(),
                _status == 'status' ? Text("Please Check In") : Container(),
                SizedBox(
                  height: hei * 0.03,
                ),
                cintime != null
                    ? Text('  Check In Time: $cintime',style: GoogleFonts.roboto(),)
                    : Container(),
                couttime != null
                    ? Text('Check Out Time: $couttime')
                    : Container(),

              ],
            ),
          ),
        )
        ));
  }

  _buildChild(BuildContext dialogcontext,String da,String da2) => Container(
    height: 250,
    decoration: BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(12))
    ),
    child: Column(
      children: <Widget>[
        Container(
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Image.asset('assets/images/sad.jpg', height: 150, width: 150,),
          ),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))
          ),
        ),
        SizedBox(height: 14,),
        Text('Do you want to logout?', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),),
        SizedBox(height: 8,),


        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(onPressed: (){
              Navigator.of(dialogcontext).pop();
            }, child: Text('No'),textColor: Colors.white,),
            SizedBox(width: 8,),
            RaisedButton(onPressed: (){
              this._setStatus("status");
              setState(() {
                rad = "";
                loginloader=false;
              });
              Toast.show("See You Tomorrow..Take Care", context,
                  duration: Toast.LENGTH_LONG,
                  gravity: Toast.CENTER,
                  backgroundColor: Colors.purpleAccent,
                  backgroundRadius: 20);
              addcoutdata(widget.userdetails[0].email,da, da2);
               Navigator.of(dialogcontext).pop(true);
            }, child: Text('Yes'), color: Colors.white, textColor: Colors.redAccent,)
          ],
        )
      ],
    ),
  );

  void _loadStatus() {
    setState(() {
      this._status = this._prefs.getString(statuskey) ?? "status";
    });
  }

  Future<Null> _setStatus(String val) async {
    await this._prefs.setString(statuskey, val);
    _loadStatus();
  }



}

