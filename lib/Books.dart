import 'dart:async';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:class10/chapterpage.dart';

class Books extends StatefulWidget {
  var subject;
  Books(s) {
    this.subject = s;
  }
  @override
  _BooksState createState() => _BooksState(this.subject);
}

class _BooksState extends State<Books> {
  var subject, books;
  var eng = ["First Flight", "Footprints Without Feet"];
  var ss = ["India and the Contemporary World II","Contemporary India II","Democratic Politics II","Understanding Economic Development","Disaster Management"];
  var hindi = ["क्षितिज भाग 2","कृतिका भाग 2","स्पर्श भाग 2"];

  _BooksState(s) {
    subject = s;
    if (subject == "English") {
      books = eng;
    }
    else if(subject=="Social Science"){
      books=ss;
    }
    else if(subject=="Hindi"){
      books=hindi;
    }
    _nativeAdController.reloadAd(forceRefresh: true);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
      ),
      body: Column(children: <Widget>[
        Expanded(
          flex: _height == 0 ? 10 : 9,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 30,
              mainAxisSpacing: 10,
              childAspectRatio:0.5 ,
              children: List.generate(books.length, (index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: Card(
                            elevation: 10.0,
                            child:
                                Image.asset("assets/images/${books[index]}.jpg")),
                        onTap: () async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          int click = pref.getInt("clicks");
                          pref.setInt("clicks", click + 1);
                          if ((click + 1) % 4 == 0) {
                            showInterstitialAd();
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Chapters(subject,books[index])),
                          );
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(books[index],style: TextStyle(fontSize: 16),)
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
        Expanded(
          flex: _height == 0 ? 0 : 1,
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
        ),
      ]),
    );
  }
}
