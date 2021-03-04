import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:class10/Books.dart';
import 'package:class10/splash.dart';
import 'chapterpage.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:launch_review/launch_review.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NCERT Solutions for class 6',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
 class MyHomePage extends StatefulWidget {
   @override
   _MyHomePageState createState() => _MyHomePageState();
 }

 class _MyHomePageState extends State<MyHomePage> {
   final keyIsFirstLoaded = 'is_first_loaded';
   _MyHomePageState(){
     _firstloaded();
     _nativeAdController.reloadAd(forceRefresh: true);
   }

   _firstloaded() async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     bool isFirstLoaded = prefs.getBool(keyIsFirstLoaded);
     if (isFirstLoaded == null) {
       prefs.setInt("clicks", 0);
       prefs.setBool(keyIsFirstLoaded, false);
     }

   }

   @override
   void initState() {
     FirebaseAdMob.instance
         .initialize(appId: "ca-app-pub-6216078565461407~4546710593");
     myInterstitial = buildInterstitialAd()..load();
     _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
     _nativeAdController.reloadAd(forceRefresh: true);

   }

   InterstitialAd myInterstitial;

   InterstitialAd buildInterstitialAd() {
     return InterstitialAd(
       //adUnitId: InterstitialAd.testAdUnitId,
       adUnitId: "ca-app-pub-6216078565461407/3178477930",
       listener: (MobileAdEvent event) {
         if (event == MobileAdEvent.failedToLoad) {
           myInterstitial..load();
         } else if (event == MobileAdEvent.closed) {
           myInterstitial = buildInterstitialAd()..load();
         }
         print(event);
       },
     );
   }

   void showInterstitialAd() {
     myInterstitial.show();
   }

   @override
   void dispose() {
     super.dispose();
     _subscription.cancel();
     _nativeAdController.dispose();
   }

   void _onStateChanged(AdLoadState state) {
     switch (state) {
       case AdLoadState.loading:
         setState(() {
           _height = 0;
         });
         break;

       case AdLoadState.loadCompleted:
         setState(() {
           _height = 120;
         });
         break;

       default:
         break;
     }
   }
   static const _adUnitID = "ca-app-pub-6216078565461407/3007087548";
   final _nativeAdController = NativeAdmobController();
   double _height = 0;
   StreamSubscription _subscription;


   Future<bool> _onBackPressed() {
     return showDialog(
       context: context,
       builder: (context) => new AlertDialog(
         title: new Text('Are you sure?'),
         content: new Text('Do you want to exit an App'),
         actions: <Widget>[
           new FlatButton(
             onPressed: () => Navigator.of(context).pop(false),
             child: new Text('No'),
           ),
           new FlatButton(
             onPressed: () => Navigator.of(context).pop(true),
             child: new Text('Yes'),
           ),
         ],
       ),
     ) ??
         false;
   }

   @override
   Widget build(BuildContext context) {
     return WillPopScope(
       onWillPop: _onBackPressed,
       child: Scaffold(
         appBar: AppBar(
           title: Text("Ncert Solutions for class 10"),
           backgroundColor: Colors.indigo,
           actions: <Widget>[
             PopupMenuButton(
                 itemBuilder: (context) => [
                   PopupMenuItem(
                     value: 1,
                     child: Text("Rate app"),
                   ),
                   PopupMenuItem(
                     value: 2,
                     child: Text("Share"),
                   ),
                   PopupMenuItem(
                     value: 3,
                     child: Text("More Apps"),
                   ),
                 ],
                 onSelected: (val) {
                   if (val == 1) {
                     LaunchReview.launch(
                       androidAppId: "com.ncertsolutions.class10",
                     );
                   }

                   else if (val == 3) {
                     launch(
                         "https://play.google.com/store/apps/developer?id=SoftDroid+Tech ");
                   } else {
                     Share.share(
                         "Install NCERT Solutions for class 10th\nhttps://play.google.com/store/apps/details?id=com.ncertsolutions.class10 ");
                   }
                 })
           ],
         ),
         body: ListView(
           padding: const EdgeInsets.all(16.0),
           children: <Widget>[
             Row(
               children: <Widget>[
                 Expanded(
                   child: GestureDetector(
                     onTap: () async{
                       SharedPreferences pref=await SharedPreferences.getInstance();
                       int click=pref.getInt("clicks");
                       pref.setInt("clicks",click+1 );
                       if((click+1)%4==0){
                         showInterstitialAd();
                       }
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => Books("English")),
                       ).then((_){
                       });
                     },
                     child: _buildWikiCategory('assets/images/english.png', "English",
                         Colors.deepOrange.withOpacity(0.7)),
                   ),
                 ),
                 const SizedBox(width: 16.0),
                 Expanded(
                   child: GestureDetector(
                     onTap: () async{
                       SharedPreferences pref=await SharedPreferences.getInstance();
                       int click=pref.getInt("clicks");
                       pref.setInt("clicks",click+1 );
                       if((click+1)%4==0){
                         showInterstitialAd();
                       }
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => Books("Hindi")),
                       );
                     },
                     child: _buildWikiCategory('assets/images/hindi.png', "Hindi",Colors.tealAccent[400]
                         ),
                   ),
                 ),
               ],
             ),
             const SizedBox(height: 16.0),
             Row(
               children: <Widget>[
                 Expanded(
                   child: GestureDetector(
                     onTap: () async{
                       SharedPreferences pref=await SharedPreferences.getInstance();
                       int click=pref.getInt("clicks");
                       pref.setInt("clicks",click+1 );
                       if((click+1)%4==0){
                         showInterstitialAd();
                       }
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => Chapters("Maths","")),
                       );
                     },
                     child: _buildWikiCategory('assets/images/maths.png', "Mathematics",
                         Colors.indigo.withOpacity(0.7)),
                   ),
                 ),
                 const SizedBox(width: 16.0),
                 Expanded(
                   child: GestureDetector(
                     onTap: () async{
                       SharedPreferences pref=await SharedPreferences.getInstance();
                       int click=pref.getInt("clicks");
                       pref.setInt("clicks",click+1 );
                       if((click+1)%4==0){
                         showInterstitialAd();
                       }
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => Chapters("Science","")),
                       );
                     },
                     child: _buildWikiCategory(
                         'assets/images/science.png', "Science", Colors.orange.withOpacity(0.6)),
                   ),
                 ),
               ],
             ),
             const SizedBox(height: 16.0),
             Row(
               children: <Widget>[
                 Expanded(
                   child: GestureDetector(
                     onTap: () async{
                       SharedPreferences pref=await SharedPreferences.getInstance();
                       int click=pref.getInt("clicks");
                       pref.setInt("clicks",click+1 );
                       if((click+1)%4==0){
                         showInterstitialAd();
                       }
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => Books("Social Science")),
                       );
                     },
                     child: _buildWikiCategory('assets/images/geopraphy.png', "Social Science",
                         //- Social and Political Life
                         Colors.red.withOpacity(0.7)),
                   ),
                 ),
                 const SizedBox(width: 16.0),
                 Expanded(
                   child: GestureDetector(

                     child: Container()
                     //Geography- The Earth: Our Habitat
                   ),
                 ),
               ],
             ),


             const SizedBox(height: 16.0),
             Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      height: _height,
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(bottom: 20.0),
                      child: NativeAdmob(
                        adUnitID: _adUnitID,
                        controller: _nativeAdController,
                        loading: Container(),
                      ),
                    ),
                  )
                ],
             ),
           ],
         ),
       ),
     );
   }

   Stack _buildWikiCategory(String icon, String label, Color color) {
     return Stack(
       children: <Widget>[
         Container(
           padding: const EdgeInsets.all(26.0),
           alignment: Alignment.centerRight,
           child: Opacity(
               opacity: 0.3,
               child:

               Tab(
                 icon: Container(
                   child: Image(
                     image: AssetImage(
                       icon,
                     ),
                     fit: BoxFit.cover,
                   ),
                   height: 50,
                   width: 50,
                 ),
               )
           ),
           decoration: BoxDecoration(
             color: color,
             borderRadius: BorderRadius.circular(20.0),
           ),
         ),
         Padding(
           padding: const EdgeInsets.all(16.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
//               Icon(
//                 icon,
//                 color: Colors.white,
//               ),
               Tab(
                 icon: Container(
                   child: Image(
                     image: AssetImage(
                       icon,
                     ),
                     fit: BoxFit.cover,
                   ),
                   height: 30,
                   width: 30,
                 ),
               ),
//               const SizedBox(height: 16.0),
               Text(
                 label,
                 style: TextStyle(
                   color: Colors.white,
                   fontWeight: FontWeight.bold,
                 ),
               ),
             ],
           ),
         )
       ],
     );
   }
 }
