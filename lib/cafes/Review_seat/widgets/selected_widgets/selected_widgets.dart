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
  String reserveCafe;
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
    double height = MediaQuery.of(context).size.height;
    return Visibility(
      visible: selectedScreen,
      child: Container(
        height: height / 1.25,
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .where('phone', isEqualTo: info.phone)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text("Loading..");
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                DocumentSnapshot myBooking = snapshot.data.documents[index];
                if (myBooking['cafename'] != '') {
                  hasBookinginSelected = true;
                } else {
                  hasBookinginSelected = false;
                  _delete();
                }
                seatnum = myBooking['booked'];
                reserveCafe = myBooking['cafename'];
                return Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        hasBookinginSelected
                            ? Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(18.0),
                                              side:
                                                  BorderSide(color: Colors.red)),
                                          color: Colors.black54,
                                          child: Text(
                                            "إلغاء الحجز",
                                            style: TextStyle(color: Colors.white),
                                          ),
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
                                      ),
                                    ),
                                    Text(
                                      " مقهى " +
                                          reserveCafe +
                                          " جلسة رقم: " +
                                          seatnum,
                                      style: TextStyle(
                                          fontSize: 18, fontFamily: 'topaz'),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      'لا تقبل الطلبات إلا في المقهى',
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 15),
                                    ),
                                    Text("قائمة الطلبات", style: TextStyle(fontFamily: 'arbaeen', fontSize:18),),
                                    Container(
                                      height: height,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: reserveCafe != cafeName
                                            ? null
                                            : StreamBuilder(
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
                                                      itemCount: snapshot.data
                                                          .documents.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return InkWell(
                                                          splashColor:
                                                              Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
                                                          child: Card(
                                                            child: InkWell(
                                                              child: Column(
                                                                children: <
                                                                    Widget>[
                                                                  Flexible(
                                                                    child: Text(
                                                                      snapshot
                                                                          .data
                                                                          .documents[
                                                                              index]
                                                                          .data['order'],
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 15,
                                                                  ),
                                                                  Text(
                                                                    "السعر: " +
                                                                        snapshot
                                                                            .data
                                                                            .documents[index]
                                                                            .data['price'] +
                                                                        " ريال",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        childAspectRatio: 3 / 2,
                                                        crossAxisSpacing: 10,
                                                        mainAxisSpacing: 10,
                                                      ),
                                                    );
                                                  }
                                                }),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                              height: height/2,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text("عفوا, لا يوجد لديك حجز", style: TextStyle(fontFamily:'topaz', fontSize: 20),),
                                    SizedBox(
                                      height: 70,
                                    ),
                                  ],
                                ),
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
