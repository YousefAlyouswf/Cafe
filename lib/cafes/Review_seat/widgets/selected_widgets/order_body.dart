
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
  final String reservation;
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
      this.cafeName,
      this.reservation);
  List<String> sections = ['معسلات', 'مشروبات', 'المطعم'];
  Color cardColor;
  @override
  Widget build(BuildContext context) {
    return reservation == ''
        ? Text('')
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: GridView.builder(
                itemCount: sections.length,
                itemBuilder: (context, indexSection) {
                  if (indexSection == 0) {
                    cardColor = Colors.orange;
                  } else if (indexSection == 1) {
                    cardColor = Colors.blue;
                  } else if (indexSection == 2) {
                    cardColor = Colors.green;
                  }
                  return InkWell(
                    onTap: () {
                      showBottomSheet(
                          context: context,
                          builder: (context) => Column(
                                children: <Widget>[
                                  Container(
                                    color: Colors.red,
                                    child: IconButton(
                                      
                                        icon: Icon(Icons.arrow_downward, size: 25,),
                                        onPressed: ()=>Navigator.of(context).pop()),
                                  ),
                                  Expanded(
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.9,
                                      child: StreamBuilder(
                                        stream: Firestore.instance
                                            .collection('users')
                                            .where('phone', isEqualTo: phone)
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          if (!snapshot.hasData)
                                            return Text("Loading..");
                                          return ListView.builder(
                                            itemCount:
                                                snapshot.data.documents.length,
                                            itemBuilder: (context, index) {
                                              DocumentSnapshot myBooking =
                                                  snapshot
                                                      .data.documents[index];
                                              if (myBooking['cafename'] != '') {
                                                hasBookinginSelected = true;
                                              } else {
                                                hasBookinginSelected = false;
                                                _delete();
                                              }
                                              seatnum = myBooking['booked'];
                                              reserveCafe =
                                                  myBooking['cafename'];

                                              seatID = myBooking.documentID;

                                              return Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    hasBookinginSelected
                                                        ? Container(
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                reserveCafe !=
                                                                        cafeName
                                                                    ? Text(
                                                                        " لديك حجز في مقهى " +
                                                                            reserveCafe +
                                                                            " جلسة رقم: " +
                                                                            seatnum,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontFamily:
                                                                                'topaz'),
                                                                      )
                                                                    : Container(
                                                                        height: MediaQuery.of(context).size.height *
                                                                            0.6,
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(15.0),
                                                                          child: reserveCafe != cafeName
                                                                              ? Text("لا يمكن عرض طلبات مقهى $reserveCafe في صفحة مقهى $cafeName")
                                                                              : StreamBuilder(
                                                                                  stream: Firestore.instance.collection('order').where('cafename', isEqualTo: cafeName).where('section', isEqualTo: sections[indexSection]).snapshots(),
                                                                                  builder: (context, snapshot) {
                                                                                    if (!snapshot.hasData) {
                                                                                      return Text("");
                                                                                    } else {
                                                                                      return GridView.builder(
                                                                                        itemCount: snapshot.data.documents.length,
                                                                                        itemBuilder: (context, index) {
                                                                                          return Card(
                                                                                            child: Column(
                                                                                              children: <Widget>[
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
                                                                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                                                            height: height / 2,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "عفوا, لا يوجد لديك حجز",
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'topaz',
                                                                      fontSize:
                                                                          20),
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
                                    ),
                                  ),
                                ],
                              ));
                    },
                    child: Card(
                      color: cardColor,
                      child: Column(
                        children: <Widget>[
                          Flexible(
                            child: Center(
                              child: Text(
                                sections[indexSection],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 25),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
            ),
          );
  }
}
