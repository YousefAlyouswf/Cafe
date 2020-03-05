import 'package:cafe/firebase/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RingButton extends StatelessWidget {
  bool pressed, hasBookinginSelected;
  Function needService, _delete;
  String id, name, phone;

  RingButton(
    this.pressed,
    this.needService,
    this.name,
    this.id,
    this.hasBookinginSelected,
    this.phone,
    this._delete,
  );
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
                      _delete();
                    }
                    return InkWell(
                      child: pressed
                          ? Transform.rotate(
                              angle: .5,
                              child: Icon(
                                Icons.notifications_active,
                                size: 85,
                                color: Colors.red,
                              ),
                            )
                          : Icon(
                              Icons.notifications_none,
                              size: 85,
                              color: Colors.black,
                            ),
                      onTap: !hasBookinginSelected
                          ? () {
                              SnackBar mySnackBar = SnackBar(
                                content: Container(
                                  height:
                                      MediaQuery.of(context).size.height * .3,
                                  child: Center(
                                    child: Text(
                                      "لا يوجد لديك حجز",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                          fontSize: 32,
                                          color: Colors.red,
                                          fontFamily: "topaz"),
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
                              bool faham = true;
                              final QuerySnapshot result = await Firestore
                                  .instance
                                  .collection('faham')
                                  .getDocuments();
                              final List<DocumentSnapshot> documents =
                                  result.documents;
                              documents.forEach((data) {
                                if (data['userid'] == id) {
                                  String docID = data.documentID;
                                  Firestore.instance
                                      .collection('faham')
                                      .document(docID)
                                      .delete();
                                  faham = false;
                                }
                              });
                              if (faham) {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
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
