import 'package:cafe/cafes/cafes_screen.dart';
import 'package:cafe/loading/loading.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen/login.dart';
import 'models/booking.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<int> cafeReviews = new List();
  List<int> starsAvrage = new List();

  List<BookingDB> noteList = new List();

  UserInfo info;
  BookingDB bookingDB;
  var info1, db1;
  int count = 0;
  String getID;
  bool whereGo = false;
  Widget goThere = Loading();

  @override
  void initState() {
    _onsubmit();
    getAllReviews();
    isLogined().then((onValue) {
      setState(() {
        whereGo = onValue;
      });

      if (!whereGo) {
        goThere = Login();
      }
    });
    super.initState();
  }

  Future<bool> isLogined() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLogin = prefs.getBool('isLogin');
    if (isLogin == null) {
      isLogin = false;
    }
    return isLogin;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: whereGo ? CafeList(info1, db1) : goThere,
    );
  }

  void _onsubmit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    info1 = UserInfo(
      name: prefs.getString('nmae'),
      phone: prefs.getString('phone'),
      id: prefs.getString('id'),
      reviewsCount: cafeReviews,
      starsAvrage: starsAvrage,
    );
    db1 = BookingDB(
      prefs.getString('id'),
    );
  }

  void getAllReviews() async {
    int count = 0;
    cafeReviews = [];
    final QuerySnapshot result =
        await Firestore.instance.collection('cafes').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      cafeReviews.add(data['reviews'].length);
      int sum = 0;
      for (var i = 0; i < cafeReviews[count]; i++) {
        //should sum all the values
        sum += data['reviews'][i]['stars'];
      }
      Firestore.instance
          .collection('cafes')
          .document(data.documentID)
          .updateData(
              {'stars': sum.toString(), 'reviewcount': data['reviews'].length});

      count++;
    });
  }
}
