import 'package:cafe/animation/fadeAnimation.dart';
import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SeatsWidgets extends StatelessWidget {
  final String cafeName;

  final bool seatScreen;
  final UserInfo info;
  final int count;
  final Function updateListView;
  final Function _save;
  final Function _onItemTapped;
  final Function getUserResrevation;
  final String reservation;
  SeatsWidgets(
    this.seatScreen,
    this.info,
    this.count,
    this.updateListView,
    this._save,
    this._onItemTapped,
    this.cafeName,
    this.getUserResrevation,
    this.reservation,
  );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    getUserResrevation();
    return Visibility(
      visible: seatScreen,
      child: count > 0 || reservation != ''
          ? Container(
              height: height / 1.5,
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
                          DocumentSnapshot myBooking =
                              snapshot.data.documents[index];
                          return Container(
                            height: height / 2,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "لديك حجز في مقهى ${myBooking['cafename']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25, fontFamily: 'topaz'),
                                  ),
                                  Text(
                                    "جلسة رقم ${myBooking['booked']}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 25, fontFamily: 'topaz'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }),
            )
          : Container(
              height: 300,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('sitting')
                      .where('cafe', isEqualTo: cafeName).orderBy('color')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("");
                    } else {
                      return GridView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          Color color;
                          bool isbooked = false;
                          if (snapshot.data.documents[index].data['color'] ==
                              'green') {
                            color = Colors.green;
                            isbooked = false;
                          } else {
                            color = Colors.grey;
                            isbooked = true;
                          }

                          return InkWell(
                            onTap: isbooked
                                ? null
                                : () async {
                                    updateListView();
                                    _save();
                                    updateListView();
                                    SigninFiresotre().updateBooking(
                                        snapshot
                                            .data.documents[index].documentID
                                            .toString(),
                                        info.id,
                                        info.name,
                                        info.phone);
                                    SigninFiresotre().updateUser(
                                      info.id,
                                      snapshot.data.documents[index].data['sit']
                                          .toString(),
                                      cafeName,
                                      snapshot.data.documents[index].documentID
                                          .toString(),
                                    );

                                    _onItemTapped(2);
                                  },
                            splashColor: Colors.purple,
                            borderRadius: BorderRadius.circular(15),
                            child: FadeAnimation(
                              1,
                              Container(
                                padding: const EdgeInsets.all(15),
                                child: Center(
                                  child: Text(
                                    snapshot.data.documents[index].data['sit']
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [color.withOpacity(0.1), color],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
    );
  }
}
