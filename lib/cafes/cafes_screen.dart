import 'package:progress_dialog/progress_dialog.dart';
import 'package:cafe/loading/loading.dart';
import 'package:cafe/login_screen/login.dart';
import 'package:cafe/models/booking.dart';
import 'package:cafe/models/cafe_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_info.dart';
import 'Review_seat/reviews.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = '5f5e444ae62ce0ed';

class CafeList extends StatefulWidget {
  final UserInfo info;
  final BookingDB bookingDB;
  CafeList(this.info, this.bookingDB);

  @override
  _CafeListState createState() {
    return _CafeListState(this.info, this.bookingDB);
  }
}

class _CafeListState extends State<CafeList> {
  //Progress dialog
  ProgressDialog pr;
  //Admob-----------------------
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    nonPersonalizedAds: true,
    keywords: <String>[
      'Game',
      'Mario',
      'Hotel',
      'Summer',
      'Travel',
      'Mobile',
      'Business',
      'Technology'
    ],
  );

  BannerAd _bannerAd;
  BannerAd _bannerAdIOS;
  InterstitialAd _interstitialAd;
  InterstitialAd _interstitialAdIOS;

  BannerAd createBannerAd() {
    return BannerAd(
        adUnitId: "ca-app-pub-6845451754172569/5930942121",
        //Change BannerAd adUnitId with Admob ID
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  BannerAd createBannerAdIOS() {
    return BannerAd(
        adUnitId: "ca-app-pub-6845451754172569/6339792193",
        //Change BannerAd adUnitId with Admob ID
        size: AdSize.banner,
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("BannerAd $event");
        });
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
        adUnitId: "ca-app-pub-6845451754172569/6501787765",
        //Change Interstitial AdUnitId with Admob ID
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("IntersttialAd $event");
        });
  }

  InterstitialAd createInterstitialAdIOS() {
    return InterstitialAd(
        adUnitId: "ca-app-pub-6845451754172569/6380510014",
        //Change Interstitial AdUnitId with Admob ID
        targetingInfo: targetingInfo,
        listener: (MobileAdEvent event) {
          print("IntersttialAd $event");
        });
  }

  //----------------------------
  List<String> citis = new List();
  String citySelected = '';
  List<BookingDB> noteList = new List();
  List<BookingDB> loginList = new List();
  bool sort = false;
  BookingDB bookingDB;
  String city;

  String filterCity;

  bool check = false;

  String userID;

  String userName;

  String userPhone;

  String userPassword;

  String booked;

  int count;

  String seatNum;
  UserInfo info;
  List<String> cityList = new List();

  List<dynamic> removeDoublicat = new List();

  _CafeListState(this.info, this.bookingDB);

  double getLong;
  double getLat;
  String yourCafes;
  List<CafeLocation> cafeLocation = new List();
  //get user Location
  void getCurrentPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    getLong = position.longitude;
    getLat = position.latitude;

    final QuerySnapshot result =
        await Firestore.instance.collection('cafes').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      double long = double.parse(data['long']);
      double lat = double.parse(data['lat']);
      cafeLocation.add(CafeLocation(long, lat, data['city']));
    });

    for (var i = 0; i < cafeLocation.length; i++) {
      if (getLong.toInt() == cafeLocation[i].long.toInt() &&
              getLat.toInt() == cafeLocation[i].lat.toInt() ||
          getLong.toInt() - 1 == cafeLocation[i].long.toInt() &&
              getLat.toInt() == cafeLocation[i].lat.toInt() ||
          getLong.toInt() == cafeLocation[i].long.toInt() &&
              getLat.toInt() - 1 == cafeLocation[i].lat.toInt() ||
          getLong.toInt() + 1 == cafeLocation[i].long.toInt() &&
              getLat.toInt() == cafeLocation[i].lat.toInt() ||
          getLong.toInt() == cafeLocation[i].long.toInt() &&
              getLat.toInt() + 1 == cafeLocation[i].lat.toInt() ||
          getLong.toInt() + 1 == cafeLocation[i].long.toInt() &&
              getLat.toInt() + 1 == cafeLocation[i].lat.toInt() ||
          getLong.toInt() - 1 == cafeLocation[i].long.toInt() &&
              getLat.toInt() - 1 == cafeLocation[i].lat.toInt()) {
        yourCafes = cafeLocation[i].city;
      }
    }
  }

  @override
  void initState() {
    getCurrentPosition();
    //android admob appid

    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-6845451754172569~9603621495");
    //ios appid admob
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-6845451754172569~2955436171");
    //Change appId With Admob Id
    _bannerAd = createBannerAd()
      ..load()
      ..show();
    _bannerAdIOS = createBannerAdIOS()
      ..load()
      ..show();
    super.initState();
  }



  static Future<void> openMap(String latitude, String longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context, type: ProgressDialogType.Normal);

    pr.style(
        message: '...أنتظر قليلا',
        progressWidget: Container(
          height: 200,
        ));

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () => null,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: Center(
            child: Text(
              "قائمة المقاهي",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'arbaeen',
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setBool('isLogin', false);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              UserAccountsDrawerHeader(
                margin: EdgeInsets.all(0),
                accountName: Text(""),
                accountEmail: Text(""),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assests/images/logo.jpg'),
                  fit: BoxFit.fill,
                )),
              ),
              Container(
                color: Colors.white,
                child: ListTile(
                  title: Center(
                      child: Text(
                    "أختر المدينه",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  )),
                  trailing: Icon(Icons.map),
                  subtitle: Container(
                    height: height / 1.5,
                    child: StreamBuilder(
                        stream:
                            Firestore.instance.collection('cafes').snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Text("Loading...");
                          } else {
                            citis.add("المقاهي القريبة");
                            for (var i = 0;
                                i < snapshot.data.documents.length;
                                i++) {
                              citis
                                  .add(snapshot.data.documents[i].data['city']);
                            }
                            var cityFilter = citis.toSet().toList();
                            return ListView.builder(
                              itemCount: cityFilter.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      citySelected = cityFilter[index];
                                      if (citySelected == 'المقاهي القريبة') {
                                        citySelected = '';

                                        getCurrentPosition();
                                      }
                                    });
                                    Navigator.pop(context);
                                    //---------------
                                  },
                                  child: Card(
                                    color: Colors.red[900],
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Text(
                                        cityFilter[index],
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      )),
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 50),
          child: StreamBuilder(
            stream: citySelected != ''
                ? Firestore.instance
                    .collection('cafes')
                    .orderBy('reviewcount', descending: true)
                    .where('city', isEqualTo: citySelected)
                    .snapshots()
                : Firestore.instance
                    .collection('cafes')
                    .orderBy('reviewcount', descending: true)
                    .where('city', isEqualTo: yourCafes)
                    .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Loading());
              } else {
                try {
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      String image = snapshot
                          .data.documents[index].data['image']
                          .toString();
                      String cafeName = snapshot
                          .data.documents[index].data['name']
                          .toString();
                      String branch = snapshot
                          .data.documents[index].data['branch']
                          .toString();

                      String starsSumF = snapshot
                          .data.documents[index].data['stars']
                          .toString();

                      String reviewsCountF = snapshot
                          .data.documents[index].data['reviewcount']
                          .toString();
                      String cafeID = snapshot.data.documents[index].documentID;

                      try {} catch (e) {}

                      double result =
                          int.parse(starsSumF) / int.parse(reviewsCountF);
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          onTap: () {
                            // createInterstitialAd()
                            //   ..load()
                            //   ..show();
                            createInterstitialAdIOS()
                              ..load()
                              ..show();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) {
                                  return Reviews(
                                    widget.info,
                                    cafeName,
                                    cafeID,
                                    widget.bookingDB,
                                  );
                                },
                              ),
                            );
                          },
                          child: GridTile(
                            child: Image.network(
                              image,
                              fit: BoxFit.fill,
                            ),
                            header: Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    String lat = snapshot
                                        .data.documents[index].data['lat'];
                                    String long = snapshot
                                        .data.documents[index].data['long'];
                                    openMap(lat, long);
                                  }),
                            ),
                            footer: Container(
                              height: height / 12,
                              child: GridTileBar(
                                backgroundColor: Colors.black54,
                                leading: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      color: result >= 1
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: result >= 1.7
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: result >= 2.7
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: result >= 3.7
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                    Icon(
                                      Icons.star,
                                      color: result >= 4.7
                                          ? Colors.yellow
                                          : Colors.grey,
                                    ),
                                  ],
                                ),
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        print(cafeID);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) {
                                              return Reviews(
                                                widget.info,
                                                cafeName,
                                                cafeID,
                                                widget.bookingDB,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            'التعليقات ${int.parse(reviewsCountF)}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          SizedBox(
                                            width: width / 10,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                cafeName,
                                                style: TextStyle(
                                                    fontFamily: 'topaz',
                                                    fontSize: 23,
                                                    color: Colors.white),
                                                textAlign: TextAlign.end,
                                              ),
                                              Text(
                                                branch,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white),
                                                textAlign: TextAlign.end,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                  );
                } catch (e) {
                  return Loading();
                }
              }
            },
          ),
        ),
      ),
    );
  }

 

  
}
