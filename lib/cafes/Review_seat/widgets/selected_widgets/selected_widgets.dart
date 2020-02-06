import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectedWidgets extends StatelessWidget {
  final bool selectedScreen;
  final UserInfo info;
  bool hasBookinginSelected;
  final Function _delete;
  final Function _onItemTapped;
  String seatnum;

  SelectedWidgets(
    this.selectedScreen,
    this.info,
    this.hasBookinginSelected,
    this._delete,
    this._onItemTapped,
    this.seatnum,
  );
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: selectedScreen,
      child: Container(
        height: 300,
        child: StreamBuilder(
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
                          " مرحبا بك " + info.name,
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

                                      SigninFiresotre().cancleupdateUser(
                                          info.id, myBooking['booked']);
                                      SigninFiresotre().calnceBooking(
                                          myBooking['seatid'], info.id);
                                      hasBookinginSelected = false;

                                      _onItemTapped(1);
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
}
