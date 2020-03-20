import 'package:cafe/firebase/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RingButton extends StatelessWidget {
  bool pressed, hasBookinginSelected;
  Function needService;
  String id, name, phone;

  RingButton(
    this.pressed,
    this.needService,
    this.name,
    this.id,
    this.hasBookinginSelected,
    this.phone,
  );

  void deleteSeatSelected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('seatSelected', false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      width: MediaQuery.of(context).size.width * 0.38,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(70)),
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            border: Border.all(width: 3, color: Colors.black),
          ),
          child: StreamBuilder(
              stream: Firestore.instance
                  .collection('users')
                  .where('phone', isEqualTo: phone)
                  .snapshots(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot myBooking = snapshot.data.documents[index];
                    if (myBooking['cafename'] != '') {
                      hasBookinginSelected = true;
                    } else {
                      hasBookinginSelected = false;
                       deleteSeatSelected();
                    }
                    return InkWell(
                      child: pressed
                          ? Transform.rotate(
                              angle: .5,
                              child: Icon(
                                Icons.notifications_active,
                                size: 70,
                                color: Colors.red,
                              ),
                            )
                          : Icon(
                              Icons.notifications_none,
                              size: 70,
                              color: Colors.black,
                            ),
                      onTap: !hasBookinginSelected
                          ? () {
                              SnackBar mySnackBar = SnackBar(
                                content: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .6,
                                  child: Center(
                                    child: Container(
                                      height: 50,
                                      color: Colors.red,
                                      child: Text(
                                        "لا يوجد لديك حجز",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 32,
                                            color: Colors.white,
                                            fontFamily: "topaz"),
                                      ),
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.transparent,
                                elevation: 0,
                                duration: const Duration(milliseconds: 1500),
                              );
                              Scaffold.of(context).showSnackBar(mySnackBar);
                            }
                          : () async {
                              needService();
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              String workerName = prefs.getString("workerName");
                              if (!pressed) {
                                String seat = prefs.getString("seat");

                                String cafeNameForOrder =
                                    prefs.getString('cafeNameForOrder');
                                var now = DateTime.now().millisecondsSinceEpoch;
                                SigninFiresotre().faham(
                                  cafeNameForOrder,
                                  seat,
                                  now.toString(),
                                  name,
                                  id,
                                );
                                //------

                              } else {
                                SnackBar mySnackBar = SnackBar(
                                  content: Container(
                                    height:
                                        MediaQuery.of(context).size.height * 1,
                                    child: Center(
                                      child: Card(
                                        color: Colors.red[900],
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: Text(
                                            "$workerName سوف يخدمك",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 32,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  elevation: 0,
                                  duration: const Duration(milliseconds: 2500),
                                );
                                Scaffold.of(context).showSnackBar(mySnackBar);
                              }
                            },
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}
