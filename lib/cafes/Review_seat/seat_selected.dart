import 'package:cafe/cafes/Review_seat/reviews.dart';
import 'package:cafe/cafes/cafes_screen.dart';
import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cafe/utils/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'seatings.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cafe/models/booking.dart';

class SeatSelected extends StatefulWidget {
  final UserInfo info;
  final String cafeName;
  final String cafeID;

  const SeatSelected({Key key, this.info, this.cafeName, this.cafeID})
      : super(key: key);
  @override
  _SeatSelectedState createState() => _SeatSelectedState();
}

class _SeatSelectedState extends State<SeatSelected> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Booking> bookList;
  Booking booking;
  int count = 0;
  bool hasBookinginSelected = false;

  int _selectedIndex = 2;
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return Seatings(
                cafeName: widget.cafeName,
                info: widget.info,
                cafeID: widget.cafeID,
              );
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) {
            return CafeList(
              info: widget.info,
            );
          },
        ),
      ),
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
              .where('name', isEqualTo: widget.info.name)
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
                }
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
                                      myBooking['booked']),
                                  RaisedButton(
                                    child: Text("إلغاء الحجز"),
                                    onPressed: () {
//Delete from SQLITE

                                      _delete(context, booking);
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
                            : Text("عفوا, لا يوجد لديك حجز")
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

  void _delete(BuildContext context, Booking booking) async {
    int result = await databaseHelper.deleteBooking(booking.userID);
    if (result != 0) {
      _showSnackBar(context, "تم الغاء الحجز بنجاح");
    }
  }

  void _showSnackBar(BuildContext context, String s) {
    final snackbar = SnackBar(
      content: Text(s),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }
}
