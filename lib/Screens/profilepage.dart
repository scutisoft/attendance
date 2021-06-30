

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:attendance/models/user.dart';
import 'package:attendance/Screens/homepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  List<User> userdetails;
  ProfileScreen({this.userdetails});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future userLogin() async{

    String email = widget.userdetails[0].email;
    String password = widget.userdetails[0].password;

    var url = 'https://thermogenetic-membr.000webhostapp.com/login.php';

    var data = {'email': email, 'password' : password};

    var response = await http.post(Uri.parse(url), body: json.encode(data));

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
    userLogin();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          DrawerScreen(userdetails: widget.userdetails,),
          ProfilePage(userdetails: widget.userdetails,)],
      ),
    );
  }
}



class ProfilePage extends StatefulWidget {
  List<User> userdetails;
  ProfilePage({this.userdetails});
  @override
  _ProfilePageState createState() => _ProfilePageState(userdetails: userdetails);
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  List<User> userdetails;
  _ProfilePageState({this.userdetails});
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  AnimationController progresscontroller;
  Animation<double> animation;
  bool isDrawerOpen = false;

  String birthDate="";
  bool nameedit;
  bool phoneedit;
  bool designationedit;

  bool nameloader;
  bool phoneloader;
  bool designationloader;

 TextEditingController namee=new TextEditingController();
 TextEditingController phonee=new TextEditingController();
 TextEditingController designationn=new TextEditingController();
  File sampleImage;
  String imageurl;
  String imagestring;
  Image imagefrompreferences;

  Future getImage() async
  {

    File tempImage = (await ImagePicker.platform.pickImage(source: ImageSource.gallery)) as File;
    if (tempImage != null) {
      _cropImage(tempImage);
    }


  }

  _cropImage(File picked) async {
    File cropped = await ImageCropper.cropImage(
      androidUiSettings: AndroidUiSettings(
        statusBarColor: Colors.red,
        toolbarColor: Colors.red,
        toolbarTitle: "Crop Image",
        toolbarWidgetColor: Colors.white,
        showCropGrid: false,
        hideBottomControls: true
      ),
      sourcePath: picked.path,
      aspectRatioPresets: [

        CropAspectRatioPreset.square
      ],
      maxWidth: 800,
      cropStyle: CropStyle.rectangle,

    );
    if (cropped != null) {
      setState(() async{
        sampleImage = cropped;
       // imagestring=Utility.base64String(sampleImage.readAsBytesSync());
        String base64Image = base64Encode(sampleImage.readAsBytesSync());
        print(base64Image.length);
        var url = 'https://thermogenetic-membr.000webhostapp.com/profilepic.php';

        var data = {'email': userdetails[0].email, 'propic' : base64Image.toString()};

        var response = await http.post(Uri.parse(url), body: json.encode(data));
        print(response.body.toString());
        userLogin();
        });
  }

}
  TextStyle buttonTextStyle=TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
  selectDate(BuildContext context, DateTime initialDateTime,
      {DateTime lastDate}) async {
    Completer completer = Completer();
    String _selectedDateInString;
    if (Platform.isAndroid)
      showDatePicker(
          context: context,
          initialDate: initialDateTime,
          firstDate: DateTime(1970),
          lastDate: lastDate == null
              ? DateTime(initialDateTime.year + 10)
              : lastDate)
          .then((temp) {
        if (temp == null) return null;
        completer.complete(temp);
        setState(() {
        });
      });

    return completer.future;
  }

  Future userLogin() async{

    String email = userdetails[0].email;
    String password = userdetails[0].password;

    var url = 'https://thermogenetic-membr.000webhostapp.com/login.php';

    var data = {'email': email, 'password' : password};

    var response = await http.post(Uri.parse(url), body: json.encode(data));

    final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
    setState(() {
      userdetails= parsed.map<User>((json) =>User.fromJson(json)).toList();

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


    setState(() {
      nameedit=false;
      phoneedit=false;
      designationedit=false;
      nameloader=false;
      phoneloader=false;
      designationloader=false;
    });
    userLogin();

    //  isSelected = [false, false];
  }

  @override
  Widget build(BuildContext context) {
    double wid = MediaQuery.of(context).size.width;
    double hei = MediaQuery.of(context).size.height;

   // currentuser();
    namee.text=userdetails[0].name;
    namee.addListener(() {
      final text = namee.text;
      namee.value = namee.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });

    designationn.text=userdetails[0].designation;
    designationn.addListener(() {
      final text = designationn.text;
      designationn.value = designationn.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });

    phonee.text=userdetails[0].phoneno;
    phonee.addListener(() {
      final text = phonee.text;
      phonee.value = phonee.value.copyWith(
        text: text,
        selection:
        TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });

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
          child:SingleChildScrollView(
            child:Stack(
            children: <Widget>[
           Column(
              children: <Widget>[
                //SizedBox(height: hei * 0.02,),

                Container(
                  height: hei*0.2,
                  width: wid,
                //  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: <Widget>[
                      isDrawerOpen
                          ? Align(
                  alignment: Alignment(0, -0.9),
                    child: GestureDetector(
                        onTap: () {
                          setState(() {
                            xOffset = 0;
                            yOffset = 0;
                            scaleFactor = 1;
                            isDrawerOpen = false;
                          });
                        },
                        child: ClipPath(
                          clipper: CustomMenuClipper(),
                          child: Container(
                            width: 35,
                            height: 90,
                            color: Color(0xFFffffff),
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.arrow_back_ios,
                              //   progress: _animationController.view,
                              color: Colors.blue,
                              size: 25,
                            ),
                          ),
                        ))) :     Align(
                          alignment: Alignment(0, -0.9),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  xOffset = 250;
                                  yOffset = 0;
                                  scaleFactor = 1;
                                  isDrawerOpen = true;
                                });
                              },
                              child: ClipPath(
                                clipper: CustomMenuClipper(),
                                child: Container(
                                  width: 35,
                                  height: 90,
                                  color:Color(0xFFffffff),
                                  alignment: Alignment.center,
                                  child: Icon(Icons.menu,
                                    //   progress: _animationController.view,
                                    color: Colors.blue,
                                    size: 25,
                                  ),
                                ),
                              ))),


                      SizedBox(
                        width: wid*0.3,
                      ),
                      Text(
                        "Profile",
                        style: GoogleFonts.roboto(fontSize: 18,color: Colors.white),
                      ),

                    ],
                  ),
                ),
               SizedBox(height: hei*0.15,),

               Container(
                 height: hei*0.8,
                 color: Colors.white,
                  child: Column(
                     children: <Widget>[
                       SizedBox(height: hei*0.17,),
                       Padding(padding: EdgeInsets.only(left: wid*0.05,right: wid*0.05),child:
                       Row(

                         children: <Widget>[
                           Icon(Icons.email,size: 16,),
                           Text(" Email            : ",style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w400)),
                           Text(userdetails[0].email,style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w500),softWrap: true,)

                         ],
                       )
                       ),
                       Container(margin: EdgeInsets.only(left: wid*0.05,right: wid*0.05,top: wid*0.03),child:
                       Row(
                        // mainAxisSize: MainAxisSize.min,
                         mainAxisAlignment: MainAxisAlignment.center,
                         crossAxisAlignment: CrossAxisAlignment.center,
                         children: <Widget>[
                           Icon(Icons.person,size: 16,),
                           Text(" Name           : ",style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w400)),
                         ! nameedit? Text(userdetails[0].name,style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w500),softWrap: true,):Container(
                           width: wid*0.45,
                           height: 30,
                           child: TextFormField(

                            // controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length)),
                            controller: namee,


                           decoration: InputDecoration(

                             hintText: userdetails[0].name,
                              contentPadding: EdgeInsets.only(bottom: 5,left: 5),
                               focusedBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(5.0),
                                 borderSide: BorderSide(

                                   color: Colors.blue,
                                 ),
                               ),
                               enabledBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(5.0),
                                 borderSide: BorderSide(
                                   color: Colors.red,
                                  // width: 2.0,
                                 ),
                               ),
                            // hintText: name
                           ),

                          ),

                         ),
                           Spacer(),
                        ! nameedit?   IconButton(icon: Container(
                            width: 20,height: 20,
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle
                            ),
                            child: Icon(Icons.edit,size: 16,color: Colors.yellow,)),
                          onPressed: (){
                          setState(() {
                            nameedit=true;
                          });
                          },
                        ):
                        //!nameloader?
                        IconButton(icon:Container(
                            width: 20,height: 20,
                            decoration: BoxDecoration(
                                color: Colors.orangeAccent,
                                shape: BoxShape.circle
                            ),
                            child: Icon(Icons.save,size: 16,color: Colors.black,)), onPressed: () async {

                             var url = 'https://thermogenetic-membr.000webhostapp.com/profilename.php';

                             var data = {'email': userdetails[0].email, 'name' : namee.text};

                             var response = await http.post(Uri.parse(url), body: json.encode(data));

                             setState(()  async {

                           /*    var url = 'https://thermogenetic-membr.000webhostapp.com/login.php';

                               var data = {'email': userdetails[0].email, 'password' : userdetails[0].password};

                               var response = await http.post(url, body: json.encode(data));

                               final parsed = json.decode(response.body).cast<Map<String, dynamic>>();
                               userdetails= parsed.map<User>((json) =>User.fromJson(json)).toList();
                               print(response.body.toString());*/
                           userLogin();
                               setState(() {
                                nameedit=false;
                               });
                              // nameloader=false;
                             });


                        })

                         ],
                       )
                       ),
                       Padding(padding: EdgeInsets.only(left: wid*0.05,right: wid*0.05),child:
                       Row(
                         children: <Widget>[
                           Icon(Icons.phone,size: 16,),
                           Text(" Mobile No    : ",style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w400)),
                           ! phoneedit? Text(userdetails[0].phoneno!=null?userdetails[0].phoneno:"Mobile Number",style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w500),softWrap: true,)
                               :Container(
                             width: wid*0.45,
                             height: 30,
                             child: TextFormField(

                               controller: phonee,
                               decoration: InputDecoration(
                                 hintText: userdetails[0].phoneno,
                                 contentPadding: EdgeInsets.only(bottom: 5,left: 5),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(5.0),
                                   borderSide: BorderSide(

                                     color: Colors.blue,
                                   ),
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(5.0),
                                   borderSide: BorderSide(
                                     color: Colors.red,
                                     // width: 2.0,
                                   ),
                                 ),
                                 // hintText: name
                               ),
                             ),

                           ),
                           Spacer(),
                           ! phoneedit?   IconButton(icon: Container(
                               width: 20,height: 20,
                               decoration: BoxDecoration(
                                   color: Colors.blue,
                                   shape: BoxShape.circle
                               ),
                               child: Icon(Icons.edit,size: 16,color: Colors.yellow,)),
                             onPressed: (){
                               setState(() {
                                 phoneedit=true;

                               });
                             },
                           ):
                               //:!phoneloader?
                           IconButton(icon: Container(
                               width: 20,height: 20,
                               decoration: BoxDecoration(
                                   color: Colors.orangeAccent,
                                   shape: BoxShape.circle
                               ),
                               child: Icon(Icons.save,size: 16,color: Colors.black,)), onPressed: (){
                             setState(() {
                               phoneloader=true;
                             });
                             setState(() {
                               phoneedit = false;
                               phoneloader=false;
                             });

                           })
                               /*:Container(decoration:BoxDecoration(

                               shape: BoxShape.circle
                           ),width:20,height:20,child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red),backgroundColor: Colors.yellow,)
                           )*/
                         ],
                       )
                       ),
                       Padding(padding: EdgeInsets.only(left: wid*0.05,right: wid*0.05,bottom: 5),child:
                       Row(
                         children: <Widget>[
                           Icon(Icons.person_pin_circle,size: 16,),
                           Text(" Designation  : ",style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w400),),
                           ! designationedit? Text(userdetails[0].designation!=null?userdetails[0].designation:"Enter Designation",style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w500),softWrap: true,)
                               :Container(
                             width: wid*0.45,
                             height: 30,
                             child: TextFormField(

                               controller: designationn,
                               decoration: InputDecoration(
                                 hintText: userdetails[0].designation,
                                 contentPadding: EdgeInsets.only(bottom: 5,left: 5),
                                 focusedBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(5.0),
                                   borderSide: BorderSide(

                                     color: Colors.blue,
                                   ),
                                 ),
                                 enabledBorder: OutlineInputBorder(
                                   borderRadius: BorderRadius.circular(5.0),
                                   borderSide: BorderSide(
                                     color: Colors.red,
                                     // width: 2.0,
                                   ),
                                 ),
                                 // hintText: name
                               ),
                             ),

                           ),
                           Spacer(),
                           ! designationedit?   IconButton(icon:

                            Container(
                                width: 20,height: 20,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.circle
                                ),
                                child: Icon(Icons.edit,size: 16,color: Colors.yellow,)),
                             onPressed: (){
                               setState(() {
                                 designationedit=true;
                               });
                             },
                           ):
                           //!designationloader?
                           IconButton(icon:  Container(
                               width: 20,height: 20,
                               decoration: BoxDecoration(
                                   color: Colors.orangeAccent,
                                   shape: BoxShape.circle
                               ),
                               child: Icon(Icons.save,size: 16,color: Colors.black,)), onPressed: (){
                              setState(() {
                                designationloader=true;
                              });
                              setState(() {
                                designationedit = false;
                                designationloader=false;
                              });

                           })
                              /* :Container(decoration:BoxDecoration(

                               shape: BoxShape.circle
                           ),width:20,height:20,child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red),backgroundColor: Colors.yellow,)
                           )*/
                         ],
                       ),
                       ),

                       Padding(padding: EdgeInsets.only(left: wid*0.05,right: wid*0.05),child:
                       Row(
                         children: <Widget>[
                           Icon(Icons.calendar_today,size: 16,),
                           Text(" Date Of Birth : ",style: GoogleFonts.roboto(fontSize: 14,fontWeight: FontWeight.w400),),
                           Text(userdetails[0].dob!=null?userdetails[0].dob:"Select DOB",style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.w500),softWrap: true,),
                           Spacer(),
                         IconButton(
                            // iconSize: 20,
                             icon:  Container(
                                 width: 20,height: 20,
                                 decoration: BoxDecoration(
                                     color: Colors.blue,
                                     shape: BoxShape.circle
                                 ),
                                 child: Icon(Icons.edit,size: 16,color: Colors.yellow,)), onPressed: () async{
                           DateTime birthDate = await selectDate(context, DateTime.now(),
                               lastDate: DateTime.now());
                           final df = new DateFormat('dd-MM-yyyy');
                           this.birthDate = df.format(birthDate);
                             /*Firestore.instance.collection(userid).document(
                                 "details").updateData({
                               "dob": this.birthDate
                             });*/

                           })
                         ],
                       ),
                       ),

                     ],
                  ),
               )


              ],
            ),
              Positioned(
                  top: hei*0.13,
                  left: wid*0.05,
                  child: Container(
                    width: wid*0.9,
                    height: hei*0.25,
                    decoration: BoxDecoration(
                        boxShadow:  [
                          //  color: Colors.white, //background color of box
                          BoxShadow(
                            color: Color(0xFFEBEBEB),
                            blurRadius: 10.0, // soften the shadow
                            spreadRadius: 1.0, //extend the shadow
                            offset: Offset(

                              5.0, // Move to right 10  horizontally
                              15.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        SizedBox(height: hei*0.01,),
                        Stack(
                         // mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Align(
                            //   alignment: Alignment.center,
                            // child:
                           // SizedBox(width: wid*0.13,),

                            GestureDetector(onTap: (){

                              showprofilepic(context, userdetails[0].propic);
                            },child:
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.grey,
                              child: ClipOval(
                                child: new SizedBox(
                                  width: 100.0,
                                  height: 100.0,
                                 // child: Utility.imageFromBase64String(userdetails[0].propic)
                                  //Image.network(url,fit: BoxFit.cover,),
                                ),
                              ),
                            ),
                            ),

                            Positioned(
                            // right: 0.1,
                              left: 44,
                              top: 40,
                              child:
                              IconButton(

                               //   iconSize: 40,
                                  icon: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle
                                    ),
                                      width: 25,height: 25,
                                      child:Image.asset("assets/images/editicon.png",fit: BoxFit.cover,)),
                                  onPressed: (){
                               // getImage();
                              }
                              ),
                            ),
                            // ),
                            /*  Padding(padding: EdgeInsets.only(top: 0.0),
                              child: IconButton(icon: Icon(
                                Icons.add_a_photo,
                              ), onPressed: (){
                                //getImage();
                              }
                              ),
                            )*/
                          ],
                        ),

                        SizedBox(height: hei*0.01,),
                        Center(
                          child:
                          Text(userdetails[0].name,style: GoogleFonts.roboto(fontSize: 20,fontWeight: FontWeight.w700),),
                        ),
                        SizedBox(height: hei*0.01,),
                        Center(
                          child:
                          Text(userdetails[0].email,style: GoogleFonts.roboto(fontSize: 16,fontWeight: FontWeight.normal),),
                        )
                        /* Align(
                          alignment: Alignment.center,
                          child: Text(name,style: GoogleFonts.roboto(fontSize: 20,fontWeight: FontWeight.w700),),
                        )*/
                      ],
                    ),
                  )),
          ]
          ),


          )
        )

    );
  }
void showprofilepic(BuildContext context,String url){
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx)=>Scaffold(
          body: Center(
            child: Hero(tag: "My Profile", child: Utility.imageFromBase64String(url)),
          ),
        )
      )

    );
}
  }


class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;

    final width = size.width;
    final height = size.height;

    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 12, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height-12 ,0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
class Utility{

  static Image imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String),
      fit: BoxFit.cover,
    );
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
