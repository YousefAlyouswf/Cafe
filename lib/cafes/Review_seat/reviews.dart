import 'package:cafe/cafes/Review_seat/widgets/review_widgets/review_widgets.dart';
import 'package:cafe/cafes/Review_seat/widgets/seats_widgets/seats_widgets.dart';
import 'package:cafe/cafes/Review_seat/widgets/selected_widgets/selected_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_admob/firebase_admob.dart';

const String testDevice = '5f5e444ae62ce0ed';

class Reviews extends StatefulWidget {
  final String cafeName;
  final String cafeID;
  const Reviews(
    this.cafeName,
    this.cafeID,
  );

  @override
  _ReviewsState createState() {
    return _ReviewsState(this.cafeName, this.cafeID);
  }
}

class _ReviewsState extends State<Reviews> with SingleTickerProviderStateMixin {
  TextEditingController controllerPhone = TextEditingController();
  String phone;
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

  bool hasBookinginSelected = false;

  String seatnum;
  String cafeName;
  String cafeID;
  String reservation;

  _ReviewsState(
    this.cafeName,
    this.cafeID,
  );

  TabController _controller;
  void checkPhoneIsEmpty() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      phone = prefs.getString('thePhone');
    });
  }

  @override
  void initState() {
    checkPhoneIsEmpty();
    getUserPhone(context);
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

    //Database blocks

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

  String errorMsg;
  void getUserPhone(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('gotPhone') != true) {
      prefs.setBool('gotPhone', false);
      prefs.setString('thePhone', null);
    }

    bool gotPhone = prefs.getBool('gotPhone');
    if (gotPhone != true) {
      _showDialog(context).then((onValue) async {
        final QuerySnapshot result =
            await Firestore.instance.collection('users').getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        bool isDublicated = false;
        documents.forEach((data) {
          for (var i = 0; i < data['all'].length; i++) {
            if (data['all'][i]['phone'] == onValue) {
              setState(() {
                isDublicated = true;
              });
            }
          }
        });
        int len = onValue.length;
        if (len != 10) {
          errorMsg = 'يجب أن يكون 10 أرقام';
          getUserPhone(context);
        } else if (isDublicated) {
          // Navigator.pop(context);
          errorMsg = 'الرقم مسجل مسبقا';
          getUserPhone(context);
        } else if (onValue == null || onValue == '') {
          //   Navigator.pop(context);
          errorMsg = 'يجب إدخال رقم الجوال';
          getUserPhone(context);
        } else {
          phone = onValue;
          prefs.setString('thePhone', onValue);
          prefs.setBool('gotPhone', true);
          await Firestore.instance
              .collection('users')
              .document('YrTwuK1qrt8D06hwfkvr')
              .updateData({
            'all': FieldValue.arrayUnion([
              {
                'phone': phone,
              },
            ]),
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red[900],
          title: Center(
            child: Text(
              cafeName,
              style: TextStyle(
                  fontFamily: 'arbaeen',
                  color: Colors.white,
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
                _controller.index = 0;
                showModalSheet(context);
              },
            ),
          ],
          bottom: TabBar(
            labelStyle: TextStyle(fontSize: 20, fontFamily: 'topaz'),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'التعليقات',
              ),
              Tab(
                text: 'الجلسات',
              ),
              Tab(
                text: 'الخدمة',
              )
            ],
            controller: _controller,
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Center(
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
                  cafeName,
                  seatSelect,
                  _controller,
                  phone,
                ),
                SelectedWidgets(
                  hasBookinginSelected,
                  seatnum,
                  cafeName,
                  reservation,
                  _controller,
                  phone,
                ),
              ],
              controller: _controller,
            ),
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
        maxHeight: MediaQuery.of(context).size.height * 0.6,
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
                      'name': "زائر",
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

  Future<String> _showDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => new _SystemPadding(
        child: new AlertDialog(
          title: Text(
            errorMsg == null ? 'أدخل رقم الجوال لمرة واحده' : errorMsg,
            textAlign: TextAlign.end,
            style:
                TextStyle(color: errorMsg == null ? Colors.blue : Colors.red),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  keyboardType: TextInputType.phone,
                  controller: controllerPhone,
                  textAlign: TextAlign.end,
                  autofocus: true,
                  decoration: new InputDecoration(
                    hintText: 'رقم الجوال',
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('إدخال'),
                onPressed: () {
                  Navigator.of(context).pop(
                    controllerPhone.text.toString(),
                  );
                })
          ],
        ),
      ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
        duration: const Duration(milliseconds: 300), child: child);
  }
}
