import 'package:cloud_firestore/cloud_firestore.dart';

class SigninFiresotre {
  // initilaize
  final CollectionReference collectionReferenceUsers =
      Firestore.instance.collection('users');
//   final CollectionReference collectionReferenceReview =
//       Firestore.instance.collection('cafes');
// //Functions

//Add users
  Future addUser(String name, String phone, String password) async =>
      await collectionReferenceUsers.document().setData({
        'name': name,
        'phone': phone,
        'password': password,
        'cafename': '',
        'seatid': '',
        'booked': ''
      });

  //Add review
  // Future addReview(String review, String rate, String name, String id) async =>
  //     await collectionReferenceReview
  //         .document(id)
  //         .setData({

  //            'review': review, 'stars': rate
  //         });
//compare user
//String phone, String password
  static Future<bool> compare(String phone, String password) async {
    final QuerySnapshot result = await Firestore.instance
        .collection("users")
        .where("password", isEqualTo: password)
        .where("phone", isEqualTo: phone)
        .limit(1)
        .getDocuments();
    final List<DocumentSnapshot> ducoments = result.documents;
    return ducoments.length == 1;
  }

 
//Update seat stauts
  Future updateBooking(String id, String userid, String username,
      String userphone, String seatNum) async {

    Firestore.instance.collection('seats').document(id).updateData({
      'allseats': FieldValue.arrayRemove([
        {
          'seat': seatNum,
          'color': 'green',
          'userid': '',
          'username': '',
          'userphone': '',
        }
      ]),
    });
    Firestore.instance.collection('seats').document(id).updateData({
      'allseats': FieldValue.arrayUnion([
        {
          'seat': seatNum,
          'color': 'grey',
          'userid': userid,
          'username': username,
          'userphone': userphone,
        }
      ]),
    });
  }

  Future calnceBooking(String id, String userid, String username,
      String userphone, String seatNum) async {
    await Firestore.instance.collection('seats').document(id).updateData({
      'allseats': FieldValue.arrayRemove([
        {
          'seat': seatNum,
          'color': 'grey',
          'userid': userid,
          'username': username,
          'userphone': userphone,
        }
      ]),
    });
    await Firestore.instance.collection('seats').document(id).updateData({
      'allseats': FieldValue.arrayUnion([
        {
          'seat': seatNum,
          'color': 'green',
          'userid': '',
          'username': '',
          'userphone': '',
        }
      ]),
    });
  }

  //Cancel Duplicate reservation
  Future calncedupleBooking(String id, String userid, String username,
      String userphone, String seatNum) async {
    Firestore.instance.collection('seats').document(id).updateData({
      'allseats': FieldValue.arrayRemove([
        {
          'seat': seatNum,
          'color': 'grey',
          'userid': userid,
          'username': username,
          'userphone': userphone,
        }
      ]),
    });
    Firestore.instance.collection('seats').document(id).updateData({
      'allseats': FieldValue.arrayUnion([
        {
          'seat': seatNum,
          'color': 'green',
          'userid': '',
          'username': '',
          'userphone': '',
        }
      ]),
    });
  }

  //Add seat to a user
  Future updateUser(
      String id, String sitNum, String cafename, String seatID) async {
    await Firestore.instance.collection('users').document(id).updateData({
      'booked': sitNum,
      'cafename': cafename,
      'seatid': seatID,
    });
  }

  Future cancleupdateUser(String id) async {
    await Firestore.instance.collection('users').document(id).updateData({
      'booked': '',
      'cafename': '',
      'seatid': '',
    });
  }

  //Add Faham
  Future faham(String cafename, String seatnum, String sort, String username,
          String userid) async =>
      await Firestore.instance.collection('faham').document().setData({
        'cafename': cafename,
        'seatnum': seatnum,
        'sort': sort,
        'username': username,
        'userid': userid,
      });

  //Add in Cart
  Future addInCart(String cafename, String seatnum, String order,
          String username, String price, String userid) async =>
      await Firestore.instance.collection('cart').document().setData({
        'cafename': cafename,
        'seatnum': seatnum,
        'order': order,
        'username': username,
        'price': price,
        'userid': userid,
        'submit': 'no',
      });
  //Update in Cart
  Future insertInCart(List ordername, List orderPrice, String cafeName,
      String seatnum, String name, String phone) async {
    List<Map<String, dynamic>> maplist = [
      {
        'ordername': ordername,
        'price': orderPrice,
      },
    ];
    Firestore.instance.collection('cart').document().setData({
      'name': name,
      'phone': phone,
      'cafename': cafeName,
      'seatnum': seatnum,
      'orders': FieldValue.arrayUnion(maplist),
    });
  }
}
