import 'package:cafe/cafes/Review_seat/widgets/review_widgets/review_widgets.dart';
import 'package:cafe/cafes/Review_seat/widgets/seats_widgets/seats_widgets.dart';
import 'package:cafe/cafes/Review_seat/widgets/selected_widgets/selected_widgets.dart';
import 'package:cafe/models/booking.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cafe/utils/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = '5f5e444ae62ce0ed';

class Reviews extends StatefulWidget {
  final UserInfo info;
  final String cafeName;
  final String cafeID;
  final BookingDB booking;
  const Reviews(this.info, this.cafeName, this.cafeID, this.booking);

  @override
  _ReviewsState createState() {
    return _ReviewsState(this.info, this.cafeName, this.cafeID, this.booking);
  }
}

class _ReviewsState extends State<Reviews> with SingleTickerProviderStateMixin {
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
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<BookingDB> noteList = new List();
  int count = 0;
  UserInfo info;
  BookingDB bookingDB;
  List<String> reviews = new List();
  List<int> stars = new List();
  List<String> names = new List();
  List<String> date = new List();
  String rate = '5';
  String review = 'لا تعليق';
  int countStar = 1;
  bool one = true;
  bool two = false;
  bool three = false;
  bool four = false;
  bool five = false;
  IconData starBorder = Icons.star_border;
  IconData star = Icons.star;
  Color starColor = Colors.yellow;
  Color staremptyColor = Colors.black;
  String seatSelect;
  // Switch between 3 screens
  int control = 0;
  bool reviewScreen = true;
  bool seatScreen = false;
  bool selectedScreen = false;
  int _selectedIndex = 0;
  bool hasBookinginSelected;

  String seatnum;
  String cafeName;
  String cafeID;
  String reservation;
  void getUserResrevation() async {
    final QuerySnapshot result = await Firestore.instance
        .collection('users')
        .where('phone', isEqualTo: info.phone)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      reservation = data['booked'];
    });
  }

  _ReviewsState(this.info, this.cafeName, this.cafeID, this.bookingDB);
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        control = 0;
      } else if (index == 1) {
        updateListView();
        getUserResrevation();
        control = 1;
      } else if (index == 2) {
        control = 2;
      }
    });
  }

  TabController _controller;
  @override
  void initState() {
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
    updateListView();
    //Database blocks

    if (noteList == null) {
      noteList = List<BookingDB>();
    }
    //Database blocks
    _controller = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    _interstitialAd.dispose();
    _bannerAdIOS.dispose();
    _interstitialAdIOS.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(102, 102, 255, 1),
          title: Center(
            child: Text(
              cafeName,
              style: TextStyle(
                  fontFamily: 'arbaeen',
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.rate_review,
                color: Colors.white,
              ),
              onPressed: () {
                showModalSheet(context);
              },
            ),
          ],
          bottom: TabBar(
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.comment),
                text: 'التعليقات',
              ),
              Tab(
                icon: Icon(Icons.event_seat),
                text: 'الجلسات',
              ),
              Tab(
                icon: Icon(Icons.description),
                text: 'الطلبات',
              )
            ],
            controller: _controller,
          ),
        ),
        body: Center(
          child: TabBarView(
            children: <Widget>[
              ReviewWidgets(
                cafeName,
                reviews,
                stars,
                names,
                date,
                height,
              ),
              SeatsWidgets(
                  info,
                  count,
                  updateListView,
                  _save,
                  _onItemTapped,
                  cafeName,
                  getUserResrevation,
                  reservation,
                  seatSelect),
              SelectedWidgets(
                info,
                hasBookinginSelected,
                _delete,
                _onItemTapped,
                seatnum,
                cafeName,
                reservation,
              ),
            ],
            controller: _controller,
          ),
        ));
  }

//End of screen
  void showModalSheet(BuildContext context) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            return createBox(context, state);
          },
        );
      },
    );
  }

  createBox(BuildContext context, StateSetter state) {
    return SingleChildScrollView(
      child: LimitedBox(
        maxHeight: 450,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildMainDropdown(state),
          ],
        ),
      ),
    );
  }

  Expanded buildMainDropdown(StateSetter setState) {
    return Expanded(
      child: Container(
        color: Colors.transparent,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(196, 153, 198, 0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10)),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                    child: TextField(
                      textAlign: TextAlign.end,
                      onChanged: (val) {
                        setState(() {
                          review = val;
                        });
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'أكتب تعليقك',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            one = true;
                            five = false;
                            four = false;
                            three = false;
                            two = false;
                            countStar = 1;
                          });
                        },
                        icon: Icon(
                          one ? star : starBorder,
                          color: one ? starColor : staremptyColor,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (two) {
                              five = false;
                              four = false;
                              three = false;
                              countStar = 2;
                            } else {
                              two = true;
                              countStar = 2;
                            }
                          });
                        },
                        icon: Icon(
                          two ? star : starBorder,
                          color: two ? starColor : staremptyColor,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (three) {
                              four = false;
                              five = false;
                              countStar = 3;
                            } else {
                              three = true;
                              two = true;
                              countStar = 3;
                            }
                          });
                        },
                        icon: Icon(
                          three ? star : starBorder,
                          color: three ? starColor : staremptyColor,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (four) {
                              five = false;
                              countStar = 4;
                            } else {
                              four = true;
                              three = true;
                              two = true;
                              countStar = 4;
                            }
                          });
                        },
                        icon: Icon(
                          four ? star : starBorder,
                          color: four ? starColor : staremptyColor,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (five) {
                              countStar = 5;
                            } else {
                              five = true;
                              four = true;
                              three = true;
                              two = true;
                              countStar = 5;
                            }
                          });
                        },
                        icon: Icon(
                          five ? star : starBorder,
                          color: five ? starColor : staremptyColor,
                          size: 35,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromRGBO(49, 39, 79, 0.8),
              ),
              child: InkWell(
                onTap: () async {
                  var now = new DateTime.now();
                  var date = new DateFormat("dd-MM-yyyy").format(now);
                  List<Map<String, dynamic>> maplist = [
                    {
                      'name': info.name,
                      'stars': countStar,
                      'review': review,
                      'date': date,
                    },
                  ];
                  Firestore.instance
                      .collection('cafes')
                      .document(cafeID)
                      .updateData({
                    'reviews': FieldValue.arrayUnion(maplist),
                  });
                  // getAllReviews();
                  Navigator.pop(context);
                },
                splashColor: Colors.red,
                borderRadius: BorderRadius.circular(50),
                child: Center(
                  child: Text(
                    "إرسال",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        padding: EdgeInsets.all(40.0),
      ),
    );
  }

  void updateListView() async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    await dbFuture.then((database) {
      Future<List<BookingDB>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  // Save data to database
  void _save() async {
    int result;

    // Case 2: Insert Operation
    result = await databaseHelper.insertNote(bookingDB);

    if (result != 0) {
      // Success

      debugPrint('Note Saved Successfully');
    } else {
      // Failure
      debugPrint('Problem Saving Note');
    }
  }

  void _delete() async {
    await databaseHelper.deleteNote();
  }

  List<int> cafeReviews = new List();

  // void getAllReviews() async {
  //   int count = 0;
  //   cafeReviews = [];
  //   final QuerySnapshot result =
  //       await Firestore.instance.collection('cafes').getDocuments();
  //   final List<DocumentSnapshot> documents = result.documents;
  //   documents.forEach((data) {
  //     cafeReviews.add(data['reviews'].length);
  //     int sum = 0;
  //     for (var i = 0; i < cafeReviews[count]; i++) {
  //       //should sum all the values
  //       sum += data['reviews'][i]['stars'];
  //     }
  //     Firestore.instance
  //         .collection('cafes')
  //         .document(data.documentID)
  //         .updateData(
  //             {'stars': sum.toString(), 'reviewcount': data['reviews'].length});

  //     count++;
  //   });
  // }
}
