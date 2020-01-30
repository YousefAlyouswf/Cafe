import 'package:cloud_firestore/cloud_firestore.dart';

class SigninFiresotre {
  // initilaize
  final CollectionReference collectionReferenceUsers =
      Firestore.instance.collection('users');

//Functions

//Add users
  Future addUser(String name, String phone, String password) async =>
      await collectionReferenceUsers
          .document()
          .setData({'name': name, 'phone': phone, 'password': password});
//compare user
//String phone, String password
  Future compare(String phone, String password) async {
    Firestore.instance
        .collection("users")
        .where("password", isEqualTo: password)
        .where("phone", isEqualTo: phone)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => f.documentID);
    });
  }

//Update seat stauts
  Future updateBooking(String id, String userid) async =>
      await Firestore.instance.collection('sitting').document(id).updateData({
        'color': 'grey',
        'userid': userid,
      });
  Future calnceBooking(String id, String userid) async =>
      await Firestore.instance.collection('sitting').document(id).updateData({
        'color': 'green',
        'userid': '',
      });
  // Future deleteUser(String id) async =>
  //     await collectionReferenceUsers.document(id).delete();

  //Add seat to a user
  Future updateUser(String id, String sitNum) async {
    await Firestore.instance.collection('users').document(id).updateData({
      'booked': sitNum,
    });
  }

  Future cancleupdateUser(String id, String sitNum) async {
    await Firestore.instance.collection('users').document(id).updateData({
      'booked': '',
    });
  }
}
