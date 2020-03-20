import 'package:cafe/firebase/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CancleButton extends StatelessWidget {
  Function _delete, needService;
  String id, cafeName, name, phone;
  bool hasBookinginSelected;
  TabController _controller;
  CancleButton(
    this.needService,
    this.id,
    this.cafeName,
    this.name,
    this.phone,
    this.hasBookinginSelected,
    this._controller,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(70)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red[900].withOpacity(0.1), Colors.red[900]],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Center(
                child: Text(
                  'خروج',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.w900),
                ),
              ),
            ),
            onTap: () async {
              //Delete from SQLITE
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setBool('seatSelected', false);

              //Delete faham from firebase
              final QuerySnapshot result =
                  await Firestore.instance.collection('faham').getDocuments();
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
              final QuerySnapshot cartResult =
                  await Firestore.instance.collection('cart').getDocuments();
              final List<DocumentSnapshot> documentsCart = cartResult.documents;
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

              String seatNumer = prefs.getString("seat");
              String cafeNameForCancle = prefs.getString('cafeNameForOrder');
              SigninFiresotre()
                  .calnceBooking(cafeNameForCancle, id, name, phone, seatNumer);

              hasBookinginSelected = false;

              SigninFiresotre().cancleupdateUser(id);
              _controller.index = 1;
            },
          ),
        ),
      ),
    );
  }
}
