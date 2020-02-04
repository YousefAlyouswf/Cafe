import 'package:cafe/cafes/Review_seat/reviews.dart';
import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cafe/utils/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'seatings.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:cafe/models/booking.dart';

class SeatSelected extends StatefulWidget {
  final UserInfo info;
  final String cafeName;
  final String cafeID;
  final BookingDB booking;
  SeatSelected(this.info, this.cafeName, this.cafeID, this.booking);

  @override
  _SeatSelectedState createState() {
    return _SeatSelectedState(
        this.info, this.cafeName, this.cafeID, this.booking);
  }
}

class _SeatSelectedState extends State<SeatSelected> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  BookingDB note;
  List<BookingDB> noteList;
  int count = 0;
  bool hasBookinginSelected = false;
  BookingDB bookingDB;
  int _selectedIndex = 2;
  UserInfo info;
  String cafeName;
  String cafeID;
  String seatnum;
  _SeatSelectedState(this.info, this.cafeName, this.cafeID, this.bookingDB);
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return Reviews(
                cafeName: widget.cafeName,
                info: widget.info,
                cafeID: widget.cafeID,
              );
            },
          ),
        );
      } else if (index == 1) {
        navgateToSeating(BookingDB('', '', ''));
      }
    });
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<BookingDB>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    //Check list for the database

    return WillPopScope(
      onWillPop: () async => Navigator.pop(context, true),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: Center(
            child: Text(
              "معلومات الحجز",
              style: TextStyle(
                  fontFamily: 'arbaeen',
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.comment),
              title: Text('التعليقات'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_seat),
              title: Text('الجلسات'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.info),
              title: Text('الحجز'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .where('name', isEqualTo: info.name)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text("Loading..");
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (contect, index) {
                DocumentSnapshot myBooking = snapshot.data.documents[index];
                if (myBooking['cafename'] != '') {
                  hasBookinginSelected = true;
                } else {
                  hasBookinginSelected = false;
                  _delete();
                }
                seatnum = myBooking['booked'];
                return Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          " مرحبا بك " + widget.info.name,
                          style: TextStyle(fontSize: 25),
                        ),
                        hasBookinginSelected
                            ? Column(
                                children: <Widget>[
                                  Text("لديك حجز في مقهى " +
                                      myBooking['cafename'] +
                                      " جلسة رقم: " +
                                      seatnum),
                                  RaisedButton(
                                    child: Text("إلغاء الحجز"),
                                    onPressed: () {
                                      //Delete from SQLITE
                                      _delete();

                                      //Delete from firebase

                                      setState(() {
                                        SigninFiresotre().cancleupdateUser(
                                            widget.info.id,
                                            myBooking['booked']);
                                        SigninFiresotre().calnceBooking(
                                            myBooking['seatid'],
                                            widget.info.id);
                                        hasBookinginSelected = false;
                                      });
                                    },
                                  ),
                                ],
                              )
                            : Column(
                                children: <Widget>[
                                  Text("عفوا, لا يوجد لديك حجز"),
                                  SizedBox(
                                    height: 70,
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _delete() async {
    await databaseHelper.deleteNote();
  }

  void navgateToSeating(BookingDB booking) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          return Seatings(booking, widget.cafeName, widget.info, widget.cafeID);
        },
      ),
    );
  }
}
