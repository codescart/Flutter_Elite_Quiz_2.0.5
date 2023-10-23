import 'package:flutter/material.dart';
import 'package:flutterquiz/app/appLocalization.dart';
import 'package:flutterquiz/ui/styles/colors.dart';
import 'package:flutterquiz/ui/widgets/customBackButton.dart';
import 'package:flutterquiz/ui/widgets/customRoundedButton.dart';
import 'package:flutterquiz/ui/widgets/roundedAppbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class deposit_Money extends StatefulWidget {
  const deposit_Money({Key? key}) : super(key: key);

  @override
  State<deposit_Money> createState() => _deposit_MoneyState();
}

class _deposit_MoneyState extends State<deposit_Money> {
  TextEditingController amount=TextEditingController();
  @override
  Widget build(BuildContext context) {

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(child: Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  // gradient: LinearGradient(
                  //     colors: [lightblue,bgcolor],
                  //     begin: Alignment.bottomCenter,
                  //     end: Alignment.topCenter
                  // )
                color: Colors.white
              )
          ),
          automaticallyImplyLeading: false,
          leading: CustomBackButton(),
          centerTitle: true,
          title: Text(   "Deposit Money",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: primaryColor,
            ), )
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: height/20,vertical:height*0.06),
            child: Row(
              children: [
                Container(width: width*0.1,height: height*0.07,alignment: Alignment.center,
                    decoration: BoxDecoration(border:Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5)
                        ),color: Colors.grey.shade300),
                    child: Text("₹",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),)
                ),
                Container(
                  width: width*0.6,height: height*0.07,
                  decoration: BoxDecoration(border:Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5)
                    ),),
                  child: TextField(
                      controller: amount,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
                          border: InputBorder.none,hintText: "Enter amount",
                          hintStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.w400))
                  ),
                ),
              ],
            )
            // TextField(
            //   // controller: phoneCon,
            //   style: RighteousMedium.copyWith(fontSize: heights * 0.019, color: Colors.white),
            //   decoration: InputDecoration(
            //       contentPadding: EdgeInsets.symmetric(vertical: heights/50), // Adjust padding as needed
            //       counter: Offstage(),
            //       enabledBorder: const OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(12.0)),
            //         borderSide: BorderSide(color: Colors.white, width: 2),
            //       ),
            //       focusedBorder: const OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(12.0)),
            //         borderSide: BorderSide(color: Colors.white, width: 2),
            //       ),
            //       border: const OutlineInputBorder(
            //         borderSide: BorderSide(color: Colors.white),
            //         borderRadius: BorderRadius.all(
            //           Radius.circular(12.0),
            //         ),
            //       ),
            //       focusedErrorBorder: const OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(12.0)),
            //         borderSide: BorderSide(color: Color(0xFFF65054)),
            //       ),
            //       errorBorder: const OutlineInputBorder(
            //         borderRadius: BorderRadius.all(Radius.circular(12.0)),
            //         borderSide: BorderSide(color: Color(0xFFF65054)),
            //       ),
            //       prefixIcon: Row(
            //         mainAxisSize: MainAxisSize.min,
            //         children: [
            //           SizedBox(width: widths/60,),
            //           Text("₹",style:TextStyle ),
            //           SizedBox(width: widths/60,),
            //           // Icon(Icons.phone,color: Colors.white),
            //           // Image.asset(AppAsset.imagesTextfiled),
            //         ],
            //
            //       ),
            //
            //       hintText: "Enter Ammount",
            //       hintStyle: RighteousMedium.copyWith(fontSize: heights * 0.019, color: Colors.white.withOpacity(0.6)),
            //       fillColor:  Color(0xff010a40).withOpacity(0.9),
            //       filled: true
            //
            //   ),
            //   // keyboardType: TextInputType.number,
            //   // maxLength: 10,
            //
            // ),
          ),

          CustomRoundedButton(
            widthPercentage: 0.4,
            backgroundColor: Theme.of(context).primaryColor,
            buttonTitle:
                "Add Coins",
            radius: 15.0,
            showBorder: false,
            titleColor: Theme.of(context).backgroundColor,
            fontWeight: FontWeight.bold,
            textSize: 17.0,
            onTap: () async{
              final am=amount.text;
              final prefs = await SharedPreferences.getInstance();
              final userid=prefs.getString("userId");
              final url = 'https://bappatest.wishufashion.com/bappa_phonepay/amount.php?auth=NTM1NDU0MzUyNDUyNDM1NjQyMzY1Mg==&amount=$am&userid=$userid';
              if (await canLaunch(url)) {
              await launch(url, forceWebView: true, enableJavaScript: true);
              } else {
              throw 'Could not launch $url';
              }
            },
            height: 50.0,
          ),

          // ElevatedButton(
          //     onPressed: (){}, child: Text("Deposit"))

        ],
      ),
    ));
  }
}
