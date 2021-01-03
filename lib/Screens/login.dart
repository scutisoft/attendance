//import 'package:attendance/screens/homepage.dart';
import 'dart:convert';

import 'package:attendance/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import '../size.dart';
import 'homepage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  bool passwordvisible;
  bool wronpass;
  bool wrongemail;

  String prefEmail;
  String prefPassword;

  SharedPreferences _Loginprefs;
  static const String useremail = 'email';
  static const String password = 'password';

  void _loadCredentials() {
    setState(() {
      this.prefEmail = this._Loginprefs.getString(useremail) ?? "";
      this.prefPassword = this._Loginprefs.getString(password) ?? "";
    });
    if(prefEmail.isNotEmpty&&prefPassword.isNotEmpty){
      setState(() {
        emailController.text=prefEmail;
        passwordController.text=prefPassword;
      });
    }
    print(prefEmail.isEmpty);
    print(prefPassword);

  }

  Future<Null> _setCredentials(String email,String pass) async {
    await this._Loginprefs.setString(useremail, email);
    await this._Loginprefs.setString(password, pass);
    // _loadCredentials();
  }

  List<User> users;
  _launchURL() async {
    const url = 'http://tetrosoft.co.in/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
  Future userLogin() async{

    String email = emailController.text;
    String password = passwordController.text;

    var url = 'https://thermogenetic-membr.000webhostapp.com/login.php';

    var data = {'email': email, 'password' : password};

    var response = await http.post(url, body: json.encode(data));

    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    users= parsed.map<User>((json) =>User.fromJson(json)).toList();
   print(response.body.toString());

    // If the Response Message is Matched.
    if(users.length !=0 )
    {
      
      Toast.show("Login succeess", context,gravity: Toast.CENTER);
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (BuildContext context) =>new HomeScreen(userdetails: users,)));
     // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(email : users[0].email)));
    }else{

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: new Text("Invalid Mail Or Password"),
            actions: <Widget>[
              FlatButton(
                child: new Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );}

  }
  @override
  initState() {

    passwordvisible=true;
    wronpass=false;
    wrongemail=false;
    SharedPreferences.getInstance()
      ..then((prefs) {
        setState(() => this._Loginprefs = prefs);

        _loadCredentials();
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double hei=MediaQuery.of(context).size.height;
    double wid=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFffffff),
      body: Center(
          child:SingleChildScrollView(
              child: Padding(padding: EdgeInsets.only(left:30,right:30,top: hei*0.1),
        child:Form(
          key: _loginFormKey,
          child:Column(
           children: <Widget>[
              Container(
                width: wid*0.6,
                child:
             Image.asset("assets/images/logo.jpg"),
              ),
             SizedBox(height: hei*0.01,),
             Image.asset("assets/images/aaa.jpg"),
             SizedBox(height: hei*0.02,),

             Container(
               height: hei*0.065,
               decoration:BoxDecoration(
                 color: Color(0xFFf0f4f7),
                 borderRadius: BorderRadius.circular(10)
               ),
               child:  Theme(data: Theme.of(context).copyWith(
                 // override textfield's icon color when selected
                 primaryColor: Color(0xFF3470de),
               ),child: TextFormField(
                 decoration: InputDecoration(
                   hintText: "Email Id",
                   border: InputBorder.none,
                   focusedBorder: InputBorder.none,
                   enabledBorder: InputBorder.none,
                   errorBorder: InputBorder.none,
                   disabledBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.mail,size: 20,),
                   // contentPadding: EdgeInsets.only(left: 30,top: 15),
                   errorText: wrongemail?"Email doesnt exists":null,


                 ),
                 controller: emailController,
                 keyboardType: TextInputType.emailAddress,

                 validator: (value) {
                   Pattern pattern =
                       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                   RegExp regex = new RegExp(pattern);
                   if (!regex.hasMatch(value)) {
                     return 'Email format is invalid';
                   } else {
                     return null;
                   }
                 },
               ),
               )
             ),
             SizedBox(height: hei*0.02,),


             Container(
               height: hei*0.065,
               decoration:BoxDecoration(
                   color: Color(0xFFf0f4f7),
                   borderRadius: BorderRadius.circular(10)
               ),
               child: Theme(data:  Theme.of(context).copyWith(
                   primaryColor: Color(0xFF3470de)),

                   child: TextFormField(
                     decoration: InputDecoration(
                         hintText: "Password",
                        // fillColor: Colors.red,
                         focusColor: Color(0xFFf0f4f7),
                        hoverColor: Color(0xFFf0f4f7),
                       border: InputBorder.none,
                       focusedBorder: InputBorder.none,
                       enabledBorder: InputBorder.none,
                       errorBorder: InputBorder.none,
                       disabledBorder: InputBorder.none,
                         prefixIcon: Icon(Icons.lock,size: 20,),
                         suffixIcon:IconButton(
                           icon:Icon(
                             passwordvisible ? Icons.visibility_off: Icons.visibility,size: 20,
                             // color: Theme.of(context).red,
                           ),
                           onPressed: (){
                             setState(() {
                               passwordvisible =!passwordvisible;
                             });
                           },
                         ),
                         errorText: wronpass?"Password wrong":null,
                         // contentPadding: EdgeInsets.only(left: 30,top: 15)
                     ),
                     controller: passwordController,
                     obscureText: passwordvisible,
                   ),
               ),
             ),







             SizedBox(height: hei*0.05,),
             GestureDetector(
               onTap: () async{
                 if (!_loginFormKey.currentState.validate()) {
                   return;
                 }
                 _loginFormKey.currentState.save();
                 if(prefEmail.isEmpty && prefPassword.isEmpty){
                   _setCredentials(emailController.text, passwordController.text);
                 }
                 userLogin();

               },
               child:
             Container(
               height: hei*0.065,
               decoration: BoxDecoration(
                 color: Color(0xFF3470de),
                   borderRadius: BorderRadius.circular(5)

               ),
               child: Center(
                 child: Row(

                   children: <Widget>[
                     SizedBox(width: wid*0.2,),
                     Text("EMPLOYEE  LOGIN",style: TextStyle(color: Colors.white,fontSize: 16),),
                     SizedBox(width: wid*0.15,),
                     Text(">",style: TextStyle(color: Colors.white,fontSize: 22),)
                   ],
                 )
                 //Text("EMPLOYEE  LOGIN",style: TextStyle(color: Colors.white,fontSize: 18),),
               ),
             )
             ),

             Padding(
                    padding: EdgeInsets.only(top: hei*0.15,left: wid*0.15),
             child:Row(
               children: <Widget>[
                 Text("@2020 Copyrights ",style: TextStyle(color: Colors.grey),),
                 InkWell(
                   onTap: (){
                    _launchURL();
                   },
                   child: Text("Tetrosoft",style: TextStyle(color: Colors.red),),
                 )
               ],
             )
             ),
           ],
      ),
        )
      )
      )
      )
    );
  }

}
