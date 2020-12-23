
import 'dart:convert';
import 'package:pdf/widgets.dart' as pdfLib;
import 'package:attendance/Widget/liquidtext.dart';
import 'package:attendance/models/attendance.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/screens/homepage.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
class AdminAttendanceScreen extends StatefulWidget {
  List<User> userdetails;
  AdminAttendanceScreen({this.userdetails});
  @override
  _AdminAttendanceScreenState createState() => _AdminAttendanceScreenState(userdetails: userdetails);
}

class _AdminAttendanceScreenState extends State<AdminAttendanceScreen> {
  List<User> userdetails;
  _AdminAttendanceScreenState({this.userdetails});
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  int _currentIndex = 0;


  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      Stack(
        children: <Widget>[
          DrawerScreen(userdetails: userdetails),
          AdminAttendanceList(),
        ],
      ),
      Stack(
        children: <Widget>[
          DrawerScreen(userdetails: userdetails),
          AdminAbsentList(),
        ],
      ),
     // HomeScreenmain(),

 //  Stack(
 //   children: <Widget>[DrawerScreen(), AdminLeaveRequests()],
  // ),
    //Report()
    ];

    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        backgroundColor: Color(0xFF1976d2),
        selectedItemColor: Colors.white,
        selectedIconTheme: IconThemeData(color: Colors.white),
        items: [
          BottomNavigationBarItem(
            icon: new Image.asset(
              "assets/images/present.png",
              height: 20,
              width: 20,
            ),
            title: new Text('Present'),
          ),
         BottomNavigationBarItem(
            icon: new Image.asset(
              "assets/images/appsent.jpg",
              height: 20,
              width: 20,
            ),
            title: new Text('Absent'),
          ),
        /*  BottomNavigationBarItem(
            icon: new Icon(Icons.leak_add),
            title: new Text('Leave Requests'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.report),
            title: new Text('Reports'),
          ),*/
        ],
      ),
    );
  }
}

class AdminAttendanceList extends StatefulWidget {
  @override
  _AdminAttendanceListState createState() => _AdminAttendanceListState();
}

class _AdminAttendanceListState extends State<AdminAttendanceList>
    with SingleTickerProviderStateMixin {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  AnimationController progresscontroller;
  Animation<double> animation;
  bool isDrawerOpen = false;
  //List<bool> isSelected;
  DateFormat df;
  DateTime _selectedDate;
  String firedate = "";
  String datee = "";
  var _list;

  @override
  void initState() {
    df = DateFormat("dd-MM-yyyy");

    super.initState();
    progresscontroller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    animation = Tween<double>(begin: 0, end: 80).animate(progresscontroller)
      ..addListener(() {
        setState(() {});
      });
    setState(() {
      _selectedDate = DateTime.now();
      firedate = df.format(_selectedDate);
      _list = getdata();
    });
  }
  List<Attendance> users;
  Future getdata() async {
    var url = 'https://thermogenetic-membr.000webhostapp.com/adminattendancelistone.php';

    var data = {'date': firedate};

    var response = await http.post(url, body: json.encode(data));
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<Attendance>((json) =>Attendance.fromJson(json)).toList();
   // return users;

  }

  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;

    return GestureDetector(
        onTap: () {
          setState(() {
            xOffset = 0;
            yOffset = 0;
            scaleFactor = 1;
            isDrawerOpen = false;
          });
        },
        child: AnimatedContainer(
          height: MediaQuery.of(context).size.height,
          transform: Matrix4.translationValues(xOffset, yOffset, 0)
            ..scale(scaleFactor)
            ..rotateY(isDrawerOpen ? 0 : 0),
          duration: Duration(milliseconds: 250),
          decoration: BoxDecoration(
              //   color: Theme.of(context).backgroundColor,
              color: Color(0xFF3d70f5)
              //  borderRadius: BorderRadius.circular(isDrawerOpen?40:0.0)

              ),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  child: Container(
                    color: Colors.white,
                  ),
                  height: hei * 0.05,
                ),
                Container(
                  width: wid,
                  color: Colors.white,
                  // margin: EdgeInsets.symmetric(horizontal: 20),
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
                        "Attendance List",
                        style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: hei * 0.01,
                ),
                CalendarTimeline(
                  initialDate: _selectedDate,
                  firstDate: DateTime(2019, 1, 15),
                  lastDate: DateTime.now().add(Duration(days: 365)),
                  onDateSelected: (date) {
                    setState(() {
                      _selectedDate = date;
                      firedate = df.format(date);
                      _list = getdata();
                    });
                  },
                  monthColor: Colors.white,
                  dayColor: Colors.teal[200],
                  dayNameColor: Color(0xFF333A47),
                  activeDayColor: Colors.white,
                  activeBackgroundDayColor: Colors.redAccent[100],
                  dotsColor: Color(0xFF333A47),
                  // selectableDayPredicate: (date) => date.day != 23,
                  locale: 'en',
                ),
                GestureDetector(
                    child: Container(
                        padding: EdgeInsets.only(top: 20),
                        height: hei * 0.6,
                        child: FutureBuilder(
                            future: _list,
                            builder: (_, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                  child: Image.asset(
                                      "assets/images/adminleave-loader.gif"),
                                );
                              } else if (snapshot.data.length == 0) {
                                return Center(
                                  child: TextLiquidFill(
                                    text: "No DaTa",
                                    boxHeight: hei * 0.3,
                                    boxWidth: wid,
                                    textStyle: GoogleFonts.roboto(
                                        fontSize: 80,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic),
                                    waveColor: Colors.white,
                                    //  boxBackgroundColor: Colors.blue[700],
                                  ),
                                );
                              } else {
                                return new PresentCardSql(users: snapshot.data,);
                              }
                            }
                            )
                    )
                )
              ],
            ),
          ),
        ));
  }
}


class PresentCardSql extends StatelessWidget {
  List<Attendance> users;
  PresentCardSql({this.users});
  @override
  Widget build(BuildContext context) {
    double hei = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: users.length,
      itemBuilder: (_, index) {
        return Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: Color(0xFF3d70f5),
              ),
              height: hei * 0.18,
              child: Card(
                shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    //   Container(
                    //    color: Colors.red,
                    //    height: hei*0.12,
                    //    child:
                    Padding(
                      padding: EdgeInsets.only(top: hei * 0.015),
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: wid * 0.04,
                          ),
                          CircleAvatar(
                            // radius: 40,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: new SizedBox(
                                  height: 40,
                                  width: 40,
                                //  child:Utility.imageFromBase64String(users[0].propic)
                                  child:FadeInImage.assetNetwork(
                                    placeholder: 'assets/images/placeholder.gif',
                                    image: 'assets/images/placeholder.gif',
                                    fit: BoxFit.cover,
                                  )
                                // child: Image.network(url,fit: BoxFit.fill,),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: wid * 0.05,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                users[index].name,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800),
                              ),
                              SizedBox(
                                height: hei * 0.002,
                              ),
                              Text(users[index].designation)
                            ],
                          ),
                          Spacer(),
                          Padding(
                              padding: EdgeInsets.only(right: 30),
                              child: Icon(
                                Icons.check,
                                color: Color(0xFF1152FC),
                              ))
                        ],
                      ),
                      //   ),
                    ),

                    Container(
                      height: hei * 0.08,
                      decoration: BoxDecoration(
                          color: Color(0xFFf0f0f0),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          SizedBox(
                            width: wid * 0.04,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "Arrival\n",
                                  style: TextStyle(
                                      color: Color(0xFFb1b1b1),
                                      fontWeight: FontWeight.bold,
                                      height: 1.5),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "${DateFormat.jm().format(DateTime.parse("2020-01-01 ${users[index].cintime}"))}",
                                       // "${users[index].cintime}",
                                        style: TextStyle(
                                            color: Color(0xFF225EFB),
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal))
                                  ])),
                          SizedBox(
                            width: wid * 0.07,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "Departure\n",
                                  style: TextStyle(
                                      color: Color(0xFFb1b1b1),
                                      fontWeight: FontWeight.bold,
                                      height: 1.5),
                                  children: <TextSpan>[
                                    users[index].couttime.isNotEmpty
                                        ? TextSpan(
                                        text:"${DateFormat.jm().format(DateTime.parse("2020-01-01 ${users[index].couttime}"))}",
                                       // "${users[index].couttime}",
                                        style: TextStyle(
                                            color: Color(0xFF225EFB),
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal))
                                        : TextSpan(
                                        text: "0.00 h",
                                        style: TextStyle(
                                            color: Color(0xFF225EFB),
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal))
                                  ])),
                          SizedBox(
                            width: wid * 0.07,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "Extras\n",
                                  style: TextStyle(
                                      color: Color(0xFFb1b1b1),
                                      fontWeight: FontWeight.bold,
                                      height: 1.5),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "0.00 h",
                                        style: TextStyle(
                                            color: Color(0xFF225EFB),
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal))
                                  ])),
                          SizedBox(
                            width: wid * 0.07,
                          ),
                          RichText(
                              text: TextSpan(
                                  text: "Late\n",
                                  style: TextStyle(
                                      color: Color(0xFFb1b1b1),
                                      fontWeight: FontWeight.bold,
                                      height: 1.5),
                                  children: <TextSpan>[
                                    users[index].late.isNotEmpty
                                        ? users[index].late.toString().startsWith("-", 0)
                                        ? TextSpan(
                                        text: "0.00 h",
                                        style: TextStyle(
                                            color: Color(0xFF225EFB),
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal))
                                        : TextSpan(
                                        text: "${users[index].late} h",
                                        //  text: "${DateTime.parse(widget.cintime).difference(DateTime.parse(DateFormat("yyyy-MM-dd 09:00:00").format(DateTime.now()))).toString().substring(0,4)}",
                                        style: TextStyle(
                                            color: Color(0xFF225EFB),
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal))
                                        : TextSpan(
                                        text: "0.00 h",
                                        style: TextStyle(
                                            color: Color(0xFF225EFB),
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal))
                                  ])),
                          SizedBox(
                            width: wid * 0.04,
                          ),

                          //   Text('Arrival: ${DateFormat.jm().format(DateTime.parse(widget.cintime))}'),
                          //   widget.couttime!=null?Text('Dept: ${DateFormat.jm().format(DateTime.parse(widget.couttime))}'):Text('Dept: 0.00 h'),
                          // Text(DateFormat("yyyy-MM-dd 09:00:00").format(DateTime.now())),
                          // Text(new DateFormat.jm().format(DateTime.now()), style: TextStyle(fontSize: 18.0)),
                          // Text('Late: ${DateTime.parse(widget.cintime).difference(DateTime.parse(DateFormat("yyyy-MM-dd 09:00:00").format(DateTime.now()))).toString().substring(0,4)} h')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}



/*class AdminLeaveRequests extends StatefulWidget {
  @override
  _AdminLeaveRequestsState createState() => _AdminLeaveRequestsState();
}

class _AdminLeaveRequestsState extends State<AdminLeaveRequests>
    with SingleTickerProviderStateMixin {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  AnimationController progresscontroller;
  Animation<double> animation;
  bool isDrawerOpen = false;
  var _future;
  @override
  void initState() {
    super.initState();
    progresscontroller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000));
    animation = Tween<double>(begin: 0, end: 80).animate(progresscontroller)
      ..addListener(() {
        setState(() {});
      });
    _future = getdata();
  }

  Future getdata() async {
    QuerySnapshot qn = await Firestore.instance
        .collection("adminleaverequests")
        .orderBy("applieddate", descending: false)
        .getDocuments();
    return qn.documents;
  }

  @override
  Widget build(BuildContext context) {
    double hei = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;
    return GestureDetector(
        onTap: () {
          setState(() {
            xOffset = 0;
            yOffset = 0;
            scaleFactor = 1;
            isDrawerOpen = false;
          });
        },
        child: AnimatedContainer(
            height: MediaQuery.of(context).size.height,
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor)
              ..rotateY(isDrawerOpen ? 0 : 0),
            duration: Duration(milliseconds: 250),
            decoration: BoxDecoration(
                //   color: Theme.of(context).backgroundColor,
                color: Hexcolor('3d70f5')
                //  borderRadius: BorderRadius.circular(isDrawerOpen?40:0.0)

                ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 25),
                  width: wid,
                  color: Colors.blue,
                  // margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      isDrawerOpen
                          ? IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              ),
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
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
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
                        "Leave Requests",
                        style: TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      width: wid,
                      height: hei * 0.816,
                      color: Colors.blue,
                      //  child: Padding(padding: EdgeInsets.only(left: 20,top:30,bottom: 30),

                      //Text("Leave Requests",style: GoogleFonts.roboto(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white)),
                      //  ),
                    ),
                    Positioned(
                        top: hei * 0.1,
                        child: Container(
                            width: wid,
                            height: hei * 0.715,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30)),
                                color: Hexcolor("F9F8FB")),
                            child: Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: FutureBuilder(
                                    future: _future,
                                    builder: (_, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: Image.asset(
                                              "assets/images/adminleave-loader.gif"),
                                        );
                                      } else if (snapshot.data.length == 0) {
                                        return Center(
                                          child: Text('No data'),
                                        );
                                      } else {
                                        return new ListView.builder(
                                          scrollDirection: Axis.vertical,
                                          itemCount: snapshot.data.length,
                                          itemBuilder: (_, index) {
                                            return Padding(
                                                padding: EdgeInsets.only(
                                                    left: 15,
                                                    right: 10,
                                                    bottom: 10),
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        " ${snapshot.data[index].data['applieddate']}",
                                                        style:
                                                            GoogleFonts.roboto(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 18),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Card(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 20,
                                                                    left: 10,
                                                                    bottom: 20),
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "${snapshot.data[index].data['name']}",
                                                                  style: GoogleFonts.roboto(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          17),
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          "Applied Duration",
                                                                          style:
                                                                              GoogleFonts.roboto(fontSize: 14),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          snapshot
                                                                              .data[index]
                                                                              .data['duration'],
                                                                          style: GoogleFonts.roboto(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 16),
                                                                        )
                                                                      ],
                                                                    ),
                                                                    Spacer(),
                                                                    Container(
                                                                      width: 70,
                                                                      height:
                                                                          30,
                                                                      decoration: BoxDecoration(
                                                                          color: snapshot.data[index].data['status'] == "Pending"
                                                                              ? Colors.orange
                                                                              : snapshot.data[index].data['status'] == 'Accepted' ? Colors.green : Colors.red,
                                                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), bottomLeft: Radius.circular(30))),
                                                                      child: Center(
                                                                          child: Text(
                                                                        snapshot
                                                                            .data[index]
                                                                            .data['status'],
                                                                        style: GoogleFonts.roboto(
                                                                            color:
                                                                                Colors.white),
                                                                      )),
                                                                    )
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          "Reason",
                                                                          style:
                                                                              GoogleFonts.roboto(fontSize: 14),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          snapshot
                                                                              .data[index]
                                                                              .data['reason'],
                                                                          style: GoogleFonts.roboto(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 16),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 20,
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          "Type of Leave",
                                                                          style:
                                                                              GoogleFonts.roboto(fontSize: 14),
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          snapshot
                                                                              .data[index]
                                                                              .data['type'],
                                                                          style: GoogleFonts.roboto(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontSize: 16),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    RaisedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Firestore
                                                                            .instance
                                                                            .collection(
                                                                                "leaves")
                                                                            .document(snapshot.data[index].data[
                                                                                'userid'])
                                                                            .collection(
                                                                                "list")
                                                                            .document(snapshot.data[index].data[
                                                                                'docid'])
                                                                            .updateData({
                                                                          "status":
                                                                              "Accepted"
                                                                        });
                                                                        Firestore
                                                                            .instance
                                                                            .collection("adminleaverequests")
                                                                            .document(snapshot.data[index].data['docid'])
                                                                            .delete();
                                                                        Toast.show(
                                                                            "Accepted",
                                                                            context,
                                                                            gravity:
                                                                                Toast.CENTER);
                                                                        setState(
                                                                            () {
                                                                          _future =
                                                                              getdata();
                                                                        });
                                                                      },
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30)),
                                                                      color: Colors
                                                                          .green,
                                                                      child:
                                                                          Text(
                                                                        "Accept",
                                                                        style: GoogleFonts.roboto(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    ),
                                                                    RaisedButton(
                                                                      onPressed:
                                                                          () {
                                                                        Firestore
                                                                            .instance
                                                                            .collection(
                                                                                "leaves")
                                                                            .document(snapshot.data[index].data[
                                                                                'userid'])
                                                                            .collection(
                                                                                "list")
                                                                            .document(snapshot.data[index].data[
                                                                                'docid'])
                                                                            .updateData({
                                                                          "status":
                                                                              "Rejected"
                                                                        });
                                                                        Firestore
                                                                            .instance
                                                                            .collection("adminleaverequests")
                                                                            .document(snapshot.data[index].data['docid'])
                                                                            .delete();
                                                                        Toast.show(
                                                                            "Rejected",
                                                                            context,
                                                                            gravity:
                                                                                Toast.CENTER);
                                                                        setState(
                                                                            () {
                                                                          _future =
                                                                              getdata();
                                                                        });
                                                                      },
                                                                      shape: RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(30)),
                                                                      color: Colors
                                                                          .red,
                                                                      child:
                                                                          Text(
                                                                        "Reject",
                                                                        style: GoogleFonts.roboto(
                                                                            color:
                                                                                Colors.white),
                                                                      ),
                                                                    )
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ))
                                                    ],
                                                  ),
                                                ));
                                          },
                                        );
                                      }
                                    }))))
                  ],
                )
              ],
            )));
  }
}

class AdminLeaveCard extends StatefulWidget {
  String applieddate;
  String docid;
  String duration;
  String name;
  String reason;
  String status;
  String type;
  String userid;
  AdminLeaveCard(
      {@required this.applieddate,
      this.docid,
      this.duration,
      this.name,
      this.reason,
      this.status,
      this.type,
      this.userid});
  @override
  _AdminLeaveCardState createState() => _AdminLeaveCardState();
}

class _AdminLeaveCardState extends State<AdminLeaveCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 15, right: 10, bottom: 10),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                " ${widget.applieddate}",
                style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600, fontSize: 18),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20, left: 10, bottom: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Applied Duration",
                                  style: GoogleFonts.roboto(fontSize: 14),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.duration,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                )
                              ],
                            ),
                            Spacer(),
                            Container(
                              width: 70,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: widget.status == "Pending"
                                      ? Colors.orange
                                      : widget.status == 'Accepted'
                                          ? Colors.green
                                          : Colors.red,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(30),
                                      bottomLeft: Radius.circular(30))),
                              child: Center(
                                  child: Text(
                                widget.status,
                                style: GoogleFonts.roboto(color: Colors.white),
                              )),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Reason",
                                  style: GoogleFonts.roboto(fontSize: 14),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.reason,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Type of Leave",
                                  style: GoogleFonts.roboto(fontSize: 14),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  widget.type,
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                Firestore.instance
                                    .collection("leaves")
                                    .document(widget.userid)
                                    .collection("list")
                                    .document(widget.docid)
                                    .updateData({"status": "Accepted"});
                                Firestore.instance
                                    .collection("adminleaverequests")
                                    .document(widget.docid)
                                    .delete();
                                Toast.show("Accepted", context,
                                    gravity: Toast.CENTER);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              color: Colors.green,
                              child: Text(
                                "Accept",
                                style: GoogleFonts.roboto(color: Colors.white),
                              ),
                            ),
                            RaisedButton(
                              onPressed: () {
                                Firestore.instance
                                    .collection("leaves")
                                    .document(widget.userid)
                                    .collection("list")
                                    .document(widget.docid)
                                    .updateData({"status": "Rejected"});
                                Firestore.instance
                                    .collection("adminleaverequests")
                                    .document(widget.docid)
                                    .delete();
                                Toast.show("Rejected", context,
                                    gravity: Toast.CENTER);
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              color: Colors.red,
                              child: Text(
                                "Reject",
                                style: GoogleFonts.roboto(color: Colors.white),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ))
            ],
          ),
        ));
  }
}*/

class AdminAbsentList extends StatefulWidget {
  @override
  _AdminAbsentListState createState() => _AdminAbsentListState();
}

class _AdminAbsentListState extends State<AdminAbsentList>
    with SingleTickerProviderStateMixin {



  Animation<double> animation;
  AnimationController progresscontroller;
  DateFormat df;
  DateFormat day;
  DateTime _selectedDate;
  String firedate = "";
  String checksun;
  String sunday = "";
  bool sun;
  var list;
  List<Attendance> absentees;
  Future getdata() async {
    var url = 'https://thermogenetic-membr.000webhostapp.com/adminattendanceabsent.php';

    var data = {'date': firedate};

    var response = await http.post(url, body: json.encode(data));
    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    return parsed.map<Attendance>((json) =>Attendance.fromJson(json)).toList();
    // return users;

  }
  @override
  void initState() {
    df = DateFormat("dd-MM-yyyy");
    day = DateFormat('EEEE');

    super.initState();
    setState(() {
      progresscontroller = AnimationController(
          duration: const Duration(seconds: 3), vsync: this);

      sun = false;

      _selectedDate = DateTime.now();
      firedate = df.format(_selectedDate);
      checksun = day.format(_selectedDate);
      list=getdata();

      // _absentees=getabsentees();
    });
    progresscontroller.forward();
  }

  @override
  Widget build(BuildContext context) {
    double hei = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          body: Container(
        //   margin: EdgeInsets.only(top: 50),
        color: Color(0xFF3d70f5),
        child: Column(
          children: <Widget>[
            CalendarTimeline(
              initialDate: _selectedDate,
              firstDate: DateTime(2019, 1, 15),
              lastDate: DateTime.now().add(Duration(days: 365)),
              onDateSelected: (date) {
                setState(() {
                  _selectedDate = date;
                  firedate = df.format(date);
                  checksun = day.format(_selectedDate);
                  list=getdata();


                });
              },
              monthColor: Colors.white,
              dayColor: Colors.teal[200],
              dayNameColor: Color(0xFF333A47),
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Colors.redAccent[100],
              dotsColor: Color(0xFF333A47),
              // selectableDayPredicate: (date) => date.day != 23,
              locale: 'en',
            ),
           Container(
                    height: hei * 0.7,
                    child:  FutureBuilder(
                        future: list,
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                              child: Image.asset(
                                  "assets/images/adminleave-loader.gif"),
                            );
                          } else if (snapshot.data.length == 0) {
                            return Center(
                              child: TextLiquidFill(
                                text: "No DaTa",
                                boxHeight: hei * 0.3,
                                boxWidth: wid,
                                textStyle: GoogleFonts.roboto(
                                    fontSize: 80,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic),
                                waveColor: Colors.white,
                                //  boxBackgroundColor: Colors.blue[700],
                              ),
                            );
                          } else {
                            return new AbsentCard(users: snapshot.data,);
                          }
                        }
                    )
            )
                // : checksun == "Sunday"
                //     ? ScaleTransition(
                //         scale: Tween<double>(
                //           begin: 0.0,
                //           end: 3,
                //         ).animate(CurvedAnimation(
                //           parent: progresscontroller,
                //           curve: Curves.fastOutSlowIn,
                //         )),
                //         child: Padding(
                //           padding: const EdgeInsets.only(top: 20.0),
                //           child: Text(
                //             "Its Sunday",
                //             style: GoogleFonts.roboto(color: Colors.white),
                //           ),
                //         ))
                //     : Center(
                //         child: Container(
                //         child: Text(sunday),
                //       )
          //  ),
          ],
        ),
      )),
    );
  }
}

class AbsentCard extends StatefulWidget {
  List<Attendance> users;
  AbsentCard({this.users});
  @override
  _AbsentCardState createState() => _AbsentCardState();
}

class _AbsentCardState extends State<AbsentCard> {
  String name = "";
  String url = "";
  String designation = "";
  @override
  void initState() {
    super.initState();
    // Firestore.instance.collection(widget.uid).snapshots().listen((res) {
    //   res.documents.forEach((re) {
    //     setState(() {
    //       name = re.data['name'];
    //       url = re.data['url'];
    //       designation = re.data['designation'];
    //     });
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    double hei = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;

    return Padding(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
        child: ListView.builder(itemBuilder: (context,index){
          return Container(
            height: hei * 0.1,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xFF3d70f5),
            ),
            //  height: hei * 0.3,
            child: Card(
              shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  //   Container(
                  //    color: Colors.red,
                  //    height: hei*0.12,
                  //    child:
                  SizedBox(
                    height: hei * 0.015,
                  ),
                  Row(
                    children: <Widget>[
                      SizedBox(
                        width: wid * 0.04,
                      ),
                      CircleAvatar(
                        // radius: 40,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: new SizedBox(
                              height: 40,
                              width: 40,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/placeholder.gif',
                                image: url,
                                fit: BoxFit.cover,
                              )
                            // child: Image.network(url,fit: BoxFit.fill,),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: wid * 0.05,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            widget.users[index].name,
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                                fontWeight: FontWeight.w800),
                          ),
                          SizedBox(
                            height: hei * 0.002,
                          ),
                          Text(widget.users[index].designation)
                        ],
                      ),
                      Spacer(),
                      Padding(
                          padding: EdgeInsets.only(right: 30),
                          child: Icon(
                            Icons.cancel,
                            color: Color(0xFF1152FC),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: hei * 0.015,
                  )
                  //   ),
                ],
              ),
            ),
          );
        },
        itemCount: widget.users.length,

        )
    );
  }
}

/*class presentreport {
  String date;
  String uid;
  String attend;
  presentreport({this.date, this.uid, this.attend});
}

class Userr {
  String name;


  Userr(this.name);


}


class Tutorial {

  Userr user;
  List<Tag> tags;
  Tutorial( [this.user,this.tags]);


}

class Tag {
  String date;
  String attend;

  Tag(this.date,this.attend);

}




class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {

  List<Tutorial> tutorials=new List<Tutorial>();
  List<Tag> tags;
  DateFormat sd;

  DateTime selectedfromDate=DateTime.now();

  _selectfromDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedfromDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2052),
    );
    if (picked != null && picked != selectedfromDate)
      setState(() {
        selectedfromDate = picked;
      });
  }

  DateTime selectedtoDate=DateTime.now().add(new Duration(days: 1)) ;
  _selecttoDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedtoDate.add(new Duration(days: 1)), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2052),
    );
    if (picked != null && picked != selectedtoDate)
      setState(() async {
      selectedtoDate = picked;
      if(_value=="Present"){

     getdata(sd.format(selectedfromDate), sd.format(selectedtoDate));
      } else  if(_value=="Absent"){

        getpresentees(sd.format(selectedfromDate), sd.format(selectedtoDate));
      }
     // getdata(sd.format(selectedfromDate), sd.format(selectedtoDate));
 //  getpresentees(sd.format(selectedfromDate), sd.format(selectedtoDate));
 // getusers();
   // getusers();

    });
  }

  List<presentreport> pr = new List<presentreport>();
  var newmap;

   getdata(String fromdate,String todate) async {
    pr.clear();
    Firestore.instance
        .collection("dates")
    .where("date",isGreaterThanOrEqualTo: fromdate)
    .where("date",isLessThanOrEqualTo: todate)
        .snapshots()
        .forEach((res) {
      res.documents.forEach((re) {
         Firestore.instance.collection("adminattendance").document(re.documentID).collection("users").snapshots()
         .forEach((element) {
           element.documents.forEach((element) {
           
             setState(() {
               pr.add(new presentreport(
                 uid: element.data['name'],
                 date: re.documentID,
                 attend: element.data['attendance']
               ));
             });
           });
         });


      });
    });
  }



  Map<String,String> mappresentess=new Map();
   Map<String,String> mapusers=new Map();

  List<String> users=new List();
  List<String> presentees=new List();
  List<presentreport> ab = new List<presentreport>();

   getusers() async {
      Firestore.instance.collection("users").snapshots().listen((res) {
      res.documents.forEach((re) {
        setState(() {
          print("${re.documentID} g");
          mapusers[re.documentID]=re.data['name'];
          users.add(re.documentID);
        });
      });
    });
  }

   getpresentees(String fromdate,String todate) async {

     pr.clear();
    mappresentess.clear();
    ab.clear();


    Firestore.instance
        .collection("dates")
        .where("date",isGreaterThanOrEqualTo: fromdate)
        .where("date",isLessThanOrEqualTo: todate)
        .snapshots()
        .forEach((res) {

      res.documents.
      forEach((re) {
     mappresentess.clear();
     presentees.clear();
    print(re.documentID);
        Firestore.instance.collection("adminattendance").document(re.documentID).collection("users").snapshots()
            .forEach((element) {
          element.documents.forEach((element) {

            setState(() {
             // presentees.add(element.documentID);
            //  print(" ${re.documentID} ${element.documentID}");
              mappresentess[element.documentID]=element.data['name'];
             // print("P ${re.documentID}  ${mappresentess[element.documentID]}");


            });
          });



       mapusers.forEach((key, value) {
            if(!mappresentess.containsKey(key)){
              print("A ${re.documentID} ${mapusers[key]}");
              pr.add(new presentreport(
                  date: re.documentID,
                  uid: mapusers[key],
                  attend: "Absent"
              ));

            }
          });

        });


      });
    });

  }

  String _value;






  List<String> dates=new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getusers();
    dates.add("30092020");
    dates.add("31092020");
    dates.add("11092020");
    User user3 = User('muthu');
    List<Tag> tags = [Tag('30092020','Present'), Tag('31092020','Absent'), Tag('1102020','Absent')];
    tutorials.add(new Tutorial(user3,tags));
    User user4 = User('mutu');
    List<Tag> tags4 = [Tag('30092020','Present'), Tag('31092020','Absent'), Tag('1102020','Absent')];
    tutorials.add(new Tutorial(user4,tags4));
  // _list = getdata();
  }


 

  @override
  Widget build(BuildContext context) {
    double hei = MediaQuery.of(context).size.height;
    double wid = MediaQuery.of(context).size.width;
    sd = DateFormat("ddMMyyyy");

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "REPORTS",
            style: GoogleFonts.roboto(),
          ),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () {
                  _generatePdfAndView(context);
                }
                //_generatePdfAndView(context)
                )
          ],
        ),
        body: Column(
          children: <Widget>[
         /*   Container(
                height: hei * 0.15,
                color: Colors.blue,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: wid * 0.01,
                    ),
                    Container(
                      height: 70,
                      width: wid * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "   From",
                                style: GoogleFonts.roboto(),
                              ),
                              IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () {
                                    _selectfromDate(context);
                                  })
                            ],
                          ),
                          Text(
                            "   ${sd.format(selectedfromDate)}",
                            style: GoogleFonts.roboto(),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 70,
                      width: wid * 0.4,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "   To",
                                style: GoogleFonts.roboto(),
                              ),
                              IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () {
                                    _selecttoDate(context);
                                  })
                            ],
                          ),
                          Text(
                            "   ${sd.format(selectedtoDate)}",
                            style: GoogleFonts.roboto(),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: wid * 0.01,
                    ),
                  ],
                )),*/

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:<Widget> [
                Column(
                  children: [
                    RaisedButton(onPressed: (){
                      _selectfromDate(context);
                     },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.blue,
                      child: Text("Start Date",style: GoogleFonts.roboto(color: Colors.white),),
                    ),
                    Text(
                      "   ${sd.format(selectedfromDate)}",
                      style: GoogleFonts.roboto(),
                    )
                  ],
                ),
                Column(
                  children: [
                    RaisedButton(onPressed: (){
                      _selecttoDate(context);
                    },
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      color: Colors.blue,
                      child: Text("End Date",style: GoogleFonts.roboto(color: Colors.white),),
                    ),
                    Text(
                      "   ${sd.format(selectedtoDate)}",
                      style: GoogleFonts.roboto(),
                    )
                  ],
                )

              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
                padding: EdgeInsets.only(left: 10, right: 10),
                //  width: 60,
                height: 50,
                width: wid*0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  //   border: Border.all(color: Colors.grey[400]),
                  color: Colors.grey[200],

                ),
                child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      //elevation: 10,
                      // dropdownColor: Colors.blueGrey,
                      // style: TextStyle(color: Colors.red),
                      iconEnabledColor: Colors.grey[400],
                      hint: Text(
                          "Choose ",
                          style: GoogleFonts.roboto(color: Colors.black)
                      ),
                      value: _value,

                      items: [
                        DropdownMenuItem(
                            child: Text( "Present",
                                style: GoogleFonts.roboto(color: Colors.green,fontWeight: FontWeight.w600)),
                            value: "Present",


                        ),
                        DropdownMenuItem(
                            child: Text("Absent",
                                style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600)),
                            value: "Absent",

                        ),

                      ],
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                          if(value=="Present"){

              getdata(sd.format(selectedfromDate), sd.format(selectedtoDate));
                          } else  if(value=="Absent"){
                            getpresentees(sd.format(selectedfromDate), sd.format(selectedtoDate));
                          }
                        });
                      },
                    ))),

            Container(
                height: hei * 0.6,
                child:SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(

                      columns: [

                        DataColumn(
                          label: Text("Date",style: GoogleFonts.roboto(fontWeight: FontWeight.bold,fontSize: 16),),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Name",style: GoogleFonts.roboto(fontWeight: FontWeight.bold,fontSize: 16)),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("Attendance",style: GoogleFonts.roboto(fontWeight: FontWeight.bold,fontSize: 16)),
                          numeric: false,
                        ),
                      ],
                      rows: pr
                          .map(
                            (pr) => DataRow(
                                //     selected: selectedAvengers.contains(avenger),
                                cells: [
                                  DataCell(
                                    Text(pr.date,style: GoogleFonts.roboto(color: Colors.grey[500]),),
                                    onTap: () {
                                      // write your code..
                                    },
                                  ),
                                  DataCell(
                                    Text(pr.uid,style: GoogleFonts.roboto(color: Colors.grey[500]),),
                                  ),
                                  DataCell(
                                    Text(pr.attend,style: GoogleFonts.roboto(color: Colors.grey[500]),),
                                  ),
                                ]),
                          )
                          .toList(),
                    )
                  ),
                )

                /* FutureBuilder(
              future: _list,
              builder: (_,snapshot){
                if(snapshot.connectionState ==ConnectionState.waiting){
                  return Center(
                    child: Image.asset("assets/images/adminleave-loader.gif"),
                  );
                }
                else if (snapshot.data.length==0) {
                  return Center(
                    child: TextLiquidFill(
                      text: "No DaTa",
                      boxHeight: hei*0.3,
                      boxWidth: wid,
                      textStyle: GoogleFonts.roboto(fontSize: 80,color: Colors.white,fontStyle: FontStyle.italic),
                      waveColor: Colors.white,
                      //  boxBackgroundColor: Colors.blue[700],
                    ),
                  );
                }

                else{
                  return new DataTable(
                      columns:[
                        DataColumn(
                          label: Text("date"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("uid"),
                          numeric: false,
                        ),
                        DataColumn(
                          label: Text("attendance"),
                          numeric: false,
                        ),
                      ],
                      rows:pr
                          .map(
                            (pr) => DataRow(
                       //     selected: selectedAvengers.contains(avenger),
                            cells: [
                              DataCell(
                                Text(pr.date),
                                onTap: () {
                                  // write your code..
                                },
                              ),
                              DataCell(
                                Text(pr.uid),
                              ),
                              DataCell(
                                Text(pr.attend),
                              ),
                            ]),
                      )
                          .toList(),

                  );
                }
              }),*/
                )
          ],
        ));
  }

  _generatePdfAndView(context) async {

    final pdfLib.Document pdf = pdfLib.Document(deflate: zlib.encode);

    pdf.addPage(
      pdfLib.MultiPage(
        build: (context) => [
          pdfLib.Header(child: pdfLib.Text(_value)),
          pdfLib.Table.fromTextArray(context: context, data: <List<String>>[
          //  tags.map((e) => e.date),
           <String>['Date', 'Name','Attendance'],
            ...pr.map((item) => [item.date, item.uid, item.attend.toString()])

          ]
          ),
        ],
      ),
    );

    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/report.pdf';
    final File file = File(path);
    await file.writeAsBytes(pdf.save());
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(path: path),
      ),
    );
  }
}*/


