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
  String seatSelect;
  List<String> colorSeat = new List();
  List<String> numSeat = new List();
  List<String> idSeat = new List();
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
    this.seatSelect,
  );

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    getUserResrevation();
    return Visibility(
      visible: seatScreen,
      child: count > 0 || reservation != ''
          ? Container(
              height: height / 1.56999,
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
                          seatSelect = myBooking['booked'];
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
                                    "جلسة رقم $seatSelect",
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
              height: height / 1.57,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('seats')
                      .document(cafeName)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Text("");
                    } else {
                      int lengthCheck = snapshot.data['allseats'].length;

                      for (var i = 0; i < lengthCheck; i++) {
                        colorSeat.add(
                            snapshot.data['allseats'][i]['color'].toString());
                        numSeat.add(
                            snapshot.data['allseats'][i]['seat'].toString());
                        idSeat.add(i.toString());
                      }
                      return GridView.builder(
                        itemCount: lengthCheck,
                        itemBuilder: (context, index) {
                          Color color;
                          bool isbooked = false;
                          if (colorSeat[index] == 'green') {
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
                                      cafeName,
                                      info.id,
                                      info.name,
                                      info.phone,
                                      numSeat[index],
                                    );
                                    SigninFiresotre().updateUser(
                                      info.id,
                                      numSeat[index],
                                      cafeName,
                                      idSeat[index],
                                    );

                                    _onItemTapped(2);
                                  },
                            splashColor: Colors.purple,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              child: Center(
                                child: Text(
                                  numSeat[index].toString(),
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
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
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
