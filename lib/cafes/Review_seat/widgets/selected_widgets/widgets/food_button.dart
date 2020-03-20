import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order_card.dart';

class FoodButton extends StatelessWidget {
  String phone, seatnum, reserveCafe, seatID, cafeName;
  bool hasBookinginSelected;
  double height;
  Color cardColor;
  FoodButton(
    this.phone,
    this.seatnum,
    this.reserveCafe,
    this.seatID,
    this.cafeName,
    this.height,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(bottomRight: Radius.circular(70)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.withOpacity(0.1), Colors.grey],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () {
              showBottomSheet(
                  context: context,
                  builder: (context) => Column(
                        children: <Widget>[
                          Container(
                            color: Colors.black,
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                onPressed: () => Navigator.of(context).pop()),
                          ),
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: StreamBuilder(
                                stream: Firestore.instance
                                    .collection('users')
                                    .where('phone', isEqualTo: phone)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Text("Loading..");
                                  return ListView.builder(
                                    itemCount: snapshot.data.documents.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot myBooking =
                                          snapshot.data.documents[index];
                                      if (myBooking['cafename'] != '') {
                                        hasBookinginSelected = true;
                                      } else {
                                        hasBookinginSelected = false;
                                       // _delete();
                                      }
                                      seatnum = myBooking['booked'];
                                      reserveCafe = myBooking['cafename'];

                                      seatID = myBooking.documentID;

                                      return Center(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                                                    fontSize:
                                                                        18,
                                                                    fontFamily:
                                                                        'topaz'),
                                                              )
                                                            : Container(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.6,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          15.0),
                                                                  child: reserveCafe !=
                                                                          cafeName
                                                                      ? Text(
                                                                          "لا يمكن عرض طلبات مقهى $reserveCafe في صفحة مقهى $cafeName")
                                                                      : StreamBuilder(
                                                                          stream: Firestore
                                                                              .instance
                                                                              .collection('order')
                                                                              .where('cafename', isEqualTo: cafeName)
                                                                              .where('section', isEqualTo: 'المطعم')
                                                                              .snapshots(),
                                                                          builder: (context, snapshot) {
                                                                            if (!snapshot.hasData) {
                                                                              return Text("");
                                                                            } else {
                                                                              return GridView.builder(
                                                                                itemCount: snapshot.data.documents.length,
                                                                                itemBuilder: (context, index) {
                                                                                  return InkWell(
                                                                                    onTap: () {
                                                                                      print(snapshot.data.documents[index].data['order'] + snapshot.data.documents[index].data['price']);
                                                                                    },
                                                                                    child: OrderCard(
                                                                                      snapshot.data.documents[index].data['order'],
                                                                                      snapshot.data.documents[index].data['price'],
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
                                                      children: <Widget>[
                                                        Text(
                                                          "عفوا, لا يوجد لديك حجز",
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  'topaz',
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
                            ),
                          ),
                        ],
                      ));
            },
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Center(
                child: Text(
                  'المطعم',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25, color: Colors.black, fontFamily: "topaz"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
