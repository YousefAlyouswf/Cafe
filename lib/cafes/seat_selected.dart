import 'package:cafe/cafes/reviews_secreen/reviews.dart';
import 'package:cafe/firebase/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_info.dart';
import 'seatings.dart';

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
            return Seatings(
              info: widget.info,
              cafeName: widget.cafeName,
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
                                        setState(() {
                                          SigninFiresotre().cancleupdateUser(
                                              widget.info.id,
                                              myBooking['booked']);
                                          SigninFiresotre().calnceBooking(
                                              myBooking['seatid'],
                                              widget.info.id);
                                          hasBookinginSelected = false;
                                        });
                                      })
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
}
