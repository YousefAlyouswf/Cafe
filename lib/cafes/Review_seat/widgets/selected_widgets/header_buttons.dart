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
  final Function showModalSheet;
  final Function needService;
  final Function countOrderINCart;
  final Function _delete;
  final Function _onItemTapped;
  final bool pressed;
  final String reserveCafe;
  final String cafeName;
  bool hasBookinginSelected;

  String seatnum;
  HeaderButtons(
    this.cartPrice,
    this.reservation,
    this.showModalSheet,
    this.needService,
    this.countOrderINCart,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                      color: Color.fromRGBO(0, 141, 114, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        side: BorderSide(color: Colors.red, width: 2),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "أضغط لأتمام الطلب",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.rtl,
                          ),
                          Text(
                            "السعر: $cartPrice ريال",
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.end,
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      onPressed: () {
                        showModalSheet(context);
                      }),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5),
                        side: BorderSide(color: Colors.red)),
                    color: Colors.blue,
                    child: pressed
                        ? Text(
                            "من فضلك أنتظر...",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                          )
                        : Text(
                            "أريد خدمة",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                          ),
                    onPressed: () async {
                      needService();
                      countOrderINCart();
                      bool faham = true;
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
                          faham = false;
                        }
                      });
                      if (faham) {
                        var now = DateTime.now().millisecondsSinceEpoch;
                        SigninFiresotre().faham(
                          reserveCafe,
                          seatnum,
                          now.toString(),
                          name,
                          id,
                        );
                        //------

                      }
                    },
                  ),
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
