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

  final String cafeName;

  SelectedWidgets(
    this.selectedScreen,
    this.info,
    this.hasBookinginSelected,
    this._delete,
    this._onItemTapped,
    this.seatnum,
    this.cafeName,
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
                            ? Container(
                                child: Column(
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
                                    Text("قائمة الطلبات"),
                                    Container(
                                      height: 1500,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: StreamBuilder(
                                            stream: Firestore.instance
                                                .collection('order')
                                                .where('cafename',
                                                    isEqualTo: cafeName)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Text("");
                                              } else {
                                                return GridView.builder(
                                                  itemCount: snapshot
                                                      .data.documents.length,
                                                  itemBuilder: (context, index) {
                                                    return InkWell(
                                                      child: Card(
                                                        color: Colors.red,
                                                        child: Text(
                                                          snapshot
                                                              .data
                                                              .documents[index]
                                                              .data['order'],
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  gridDelegate:
                                                      SliverGridDelegateWithMaxCrossAxisExtent(
                                                    maxCrossAxisExtent: 100,
                                                    childAspectRatio:1,
                                                    crossAxisSpacing: 30,
                                                    mainAxisSpacing: 20,
                                                  ),
                                                );
                                              }
                                            }),
                                      ),
                                    )
                                  ],
                                ),
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
