import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;
 static  double height4,height10,height12,height16,height20,height25,height26,height30,height35,height40,height50,height55,height70,height80,height90,height100,height114,height130,height150,height250,height400,height600,height690;
static  double width5,width10,width12,width14,width16,width18,width20,width25,width30,width35,width40,width45,width50,width70,width80,width90,width100,width116,width120,width130,width150,width179,width186,width200,width250,width265,width400,width410,width500;
  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData.size.width;
    screenHeight = mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    height4= screenHeight*(4/960);
    height10=screenHeight*(10/960);
    height12=screenHeight*(12/960);
    height16=screenHeight*(16/960);
    height20=screenHeight*(20/960);
    height25=screenHeight*(25/960);
    height26=screenHeight*(26/960);
    height30=screenHeight*(30/960);
    height35=screenHeight*(35/960);
    height40=screenHeight*(40/960);
    height50=screenHeight*(50/960);
    height55=screenHeight*(55/960);
    height70=screenHeight*(70/960);
    height80=screenHeight*(80/960);
    height90=screenHeight*(90/960);
    height100=screenHeight*(100/960);
    height114=screenHeight*(114/960);
    height130=screenHeight*(130/960);
    height150=screenHeight*(150/960);
    height250=screenHeight*(250/960);
    height400=screenHeight*(400/960);
    height600=screenHeight*(600/960);
    height690=screenHeight*(690/960);

    width5=screenWidth*(5/600);
    width10=screenWidth*(10/600);
    width12=screenWidth*(12/600);
    width14=screenWidth*(14/600);
    width16=screenWidth*(16/600);
    width18=screenWidth*(18/600);
    width20=screenWidth*(20/600);
    width25=screenWidth*(25/600);
    width30=screenWidth*(30/600);
    width35=screenWidth*(35/600);
    width40=screenWidth*(40/600);
    width45=screenWidth*(45/600);
    width50=screenWidth*(50/600);
    width70=screenWidth*(70/600);
    width80=screenWidth*(80/600);
    width90=screenWidth*(90/600);
    width100=screenWidth*(100/600);
    width116=screenWidth*(116/600);
    width120=screenWidth*(120/600);
    width130=screenWidth*(130/600);
    width150=screenWidth*(150/600);
    width179=screenWidth*(179/600);
    width186=screenWidth*(186/600);
    width200=screenWidth*(200/600);
    width250=screenWidth*(250/600);
    width265=screenWidth*(250/600);
    width400=screenWidth*(400/600);
    width410=screenWidth*(410/600);
    width500=screenWidth*(500/600);

  }
}