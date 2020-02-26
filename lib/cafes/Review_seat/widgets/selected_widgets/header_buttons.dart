import 'package:cafe/firebase/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../models/user_info.dart';

class HeaderButtons extends StatelessWidget {
  final String id;
  final String name;
  final String phone;
  final int cartPrice;
  final String reservation;
  final Function needService;
  final Function _delete;
  final Function _onItemTapped;
  final bool pressed;
  final String reserveCafe;
  final String cafeName;
  bool hasBookinginSelected;
  final String seatnum;

  HeaderButtons(
    this.seatnum,
    this.cartPrice,
    this.reservation,
    this.needService,
    this._delete,
    this._onItemTapped,
    this.pressed,
    this.reserveCafe,
    this.cafeName,
    this.hasBookinginSelected,
    this.id,
    this.name,
    this.phone,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.topRight,
        child: reservation == ''
            ? Text("")
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 150,
                    child: InkWell(
                      child: pressed
                          ? Icon(
                              Icons.notifications_active,
                              size: 55,
                              color: Colors.red,
                            )
                          : Icon(
                              Icons.notifications_none,
                              size: 55,
                              color: Colors.red,
                            ),
                      onTap: () async {
                        needService();
                        bool faham = true;
                        final QuerySnapshot result = await Firestore.instance
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
                          var now = DateTime.now().millisecondsSinceEpoch;
                          SigninFiresotre().faham(
                            cafeName,
                            seat,
                            now.toString(),
                            name,
                            id,
                          );
                          //------

                        }
                      },
                    ),
                  ),
                  Spacer(),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                      side: BorderSide(color: Colors.red),
                    ),
                    color: Colors.black54,
                    child: Text(
                      "إلغاء الحجز",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () async {
                      //Delete from SQLITE
                      _delete();

                      //Delete faham from firebase
                      final QuerySnapshot result = await Firestore.instance
                          .collection('faham')
                          .getDocuments();
                      final List<DocumentSnapshot> documents = result.documents;
                      documents.forEach((data) {
                        if (data['userid'] == id) {
                          String docID = data.documentID;
                          Firestore.instance
                              .collection('faham')
                              .document(docID)
                              .delete();
                        }
                      });
                      //------------
                      //Delete cart from firebase
                      final QuerySnapshot cartResult = await Firestore.instance
                          .collection('cart')
                          .getDocuments();
                      final List<DocumentSnapshot> documentsCart =
                          cartResult.documents;
                      documentsCart.forEach((data) {
                        if (data['userid'] == id) {
                          String docID = data.documentID;
                          Firestore.instance
                              .collection('cart')
                              .document(docID)
                              .delete();
                        }
                      });
                      //----------
                      needService();
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      String seatNumer = prefs.getString("seat");
                      SigninFiresotre()
                          .calnceBooking(cafeName, id, name, phone, seatNumer);

                      hasBookinginSelected = false;

                      SigninFiresotre().cancleupdateUser(id);
                      _onItemTapped(1);
                    },
                  ),
                ],
              ),
      ),
    );
  }
}
