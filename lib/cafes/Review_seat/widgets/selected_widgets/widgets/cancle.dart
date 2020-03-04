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
    this._delete,
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
          
          child: InkWell(
            child: Card(
               color: Colors.transparent,
              child: Center(
                child: Text(
                  'خروج',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, color: Colors.red, fontWeight: FontWeight.w900),
                ),
              ),
            ),
            onTap: () async {
              //Delete from SQLITE
              _delete();

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
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String seatNumer = prefs.getString("seat");
              SigninFiresotre()
                  .calnceBooking(cafeName, id, name, phone, seatNumer);

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
