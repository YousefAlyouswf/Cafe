import 'package:cafe/models/cart.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderBody extends StatelessWidget {
  final double height;
  final String phone;
  final Function _delete;
  bool hasBookinginSelected;
  String seatnum;
  String reserveCafe;
  String seatID;
  String orderName;
  String price;
  String orderID;
  final String cafeName;
  UserInfo info;
  OrderBody(
      this.height,
      this.phone,
      this._delete,
      this.hasBookinginSelected,
      this.seatnum,
      this.reserveCafe,
      this.seatID,
      this.orderName,
      this.price,
      this.orderID,
      this.cafeName);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      textColor: Colors.white,
      color: Color.fromRGBO(102, 102, 255, 1),
      padding: const EdgeInsets.all(8.0),
      onPressed: () {
        showBottomSheet(
            context: context,
            builder: (context) => Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('users')
                        .where('phone', isEqualTo: phone)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text("Loading..");
                      return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot myBooking =
                              snapshot.data.documents[index];
                          if (myBooking['cafename'] != '') {
                            hasBookinginSelected = true;
                          } else {
                            hasBookinginSelected = false;
                            _delete();
                          }
                          seatnum = myBooking['booked'];
                          reserveCafe = myBooking['cafename'];

                          seatID = myBooking.documentID;

                          return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                hasBookinginSelected
                                    ? Container(
                                        child: Column(
                                          children: <Widget>[
                                            reserveCafe != cafeName
                                                ? Text(
                                                    " لديك حجز في مقهى " +
                                                        reserveCafe +
                                                        " جلسة رقم: " +
                                                        seatnum,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontFamily: 'topaz'),
                                                  )
                                                : Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.6,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: reserveCafe !=
                                                              cafeName
                                                          ? Text(
                                                              "لا يمكن عرض طلبات مقهى $reserveCafe في صفحة مقهى $cafeName")
                                                          : StreamBuilder(
                                                              stream: Firestore
                                                                  .instance
                                                                  .collection(
                                                                      'order')
                                                                  .where(
                                                                      'cafename',
                                                                      isEqualTo:
                                                                          cafeName)
                                                                  .snapshots(),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (!snapshot
                                                                    .hasData) {
                                                                  return Text(
                                                                      "");
                                                                } else {
                                                                  return GridView
                                                                      .builder(
                                                                    itemCount: snapshot
                                                                        .data
                                                                        .documents
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return Card(
                                                                        child:
                                                                            Column(
                                                                          children: <
                                                                              Widget>[
                                                                            Flexible(
                                                                              child: Text(
                                                                                snapshot.data.documents[index].data['order'],
                                                                                textAlign: TextAlign.center,
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              height: 15,
                                                                            ),
                                                                            Text(
                                                                              "السعر: " + snapshot.data.documents[index].data['price'] + " ريال",
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                    gridDelegate:
                                                                        SliverGridDelegateWithFixedCrossAxisCount(
                                                                      crossAxisCount:
                                                                          3,
                                                                      childAspectRatio:
                                                                          3 / 2,
                                                                      crossAxisSpacing:
                                                                          10,
                                                                      mainAxisSpacing:
                                                                          10,
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
                                        height: height / 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "عفوا, لا يوجد لديك حجز",
                                              style: TextStyle(
                                                  fontFamily: 'topaz',
                                                  fontSize: 20),
                                            ),
                                            SizedBox(
                                              height: 70,
                                            ),
                                          ],
                                        ),
                                      )
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ));
      },
      child: Text("قائمة الطلبات", style: TextStyle(fontSize: 24),),
    );
  }
}
