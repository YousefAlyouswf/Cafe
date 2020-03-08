import 'package:cafe/cafes/cafes_screen.dart';
import 'package:cafe/loading/loading.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cafe/utils/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqlite_api.dart';
import 'login_screen/login.dart';
import 'models/booking.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<int> cafeReviews = new List();
  List<int> starsAvrage = new List();
  DatabaseHelper databaseHelper = DatabaseHelper();

  List<BookingDB> noteList = new List();

  UserInfo info;
  BookingDB bookingDB;
  var info1, db1;
  int count = 0;
  String getID;
  bool whereGo = false;
  Widget goThere = Loading();

  void getCurrentPosition() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print("--------------------------------------------------$position");
  }

  @override
  void initState() {
    getCurrentPosition();
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
    updateListView();

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: whereGo ? CafeList(info1, db1) : goThere,
    );
  }

  void updateListView() async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    await dbFuture.then((database) {
      Future<List<BookingDB>> noteListFuture = databaseHelper.getLoginList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
          if (this.noteList.length > 0) {
            getID = this.noteList[0].userID;
            _onsubmit();
          }
        });
      });
    });
  }

  void _onsubmit() async {
    final QuerySnapshot userinfo =
        await Firestore.instance.collection('users').getDocuments();
    final List<DocumentSnapshot> documents = userinfo.documents;

    documents.forEach((data) {
      if (data.documentID.toString() == getID) {
        setState(() {
          info1 = UserInfo(
            name: data['name'],
            phone: data['phone'],
            id: data.documentID,
            reviewsCount: cafeReviews,
            starsAvrage: starsAvrage,
          );
          db1 = BookingDB(
            data.documentID,
          );
        });
      }
    });
    // if (count > 0) {
    //   Navigator.of(context).push(
    //     MaterialPageRoute(
    //       builder: (_) {
    //         return CafeList(info1, db1);
    //       },
    //     ),
    //   );
    // }
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
