import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    String hour = DateTime.now().hour.toString();
    String minute = DateTime.now().minute.toString();
    String second = DateTime.now().second.toString();

    switch (hour) {
      case "1":
        second = "$second AM";

        break;
      case "2":
        second = "$second AM";

        break;
      case "3":
        second = "$second AM";

        break;
      case "4":
        second = "$second AM";

        break;
      case "5":
        second = "$second AM";

        break;
      case "6":
        second = "$second AM";

        break;
      case "7":
        second = "$second AM";

        break;
      case "8":
        second = "$second AM";

        break;
      case "9":
        second = "$second AM";

        break;
      case "10":
        second = "$second AM";

        break;
      case "11":
        second = "$second AM";

        break;
      case "12":
        second = "$second PM";

        break;
      case "13":
        second = "$second PM";
        hour = "1";

        break;
        break;
      case "14":
        second = "$second PM";
        hour = "2";

        break;
        break;
      case "15":
        second = "$second PM";
        hour = "3";

        break;
        break;
      case "16":
        second = "$second PM";
        hour = "4";

        break;
        break;
      case "17":
        second = "$second PM";
        hour = "5";

        break;
        break;
      case "18":
        second = "$second PM";
        hour = "6";

        break;
        break;
      case "19":
        second = "$second PM";
        hour = "7";

        break;
        break;
      case "20":
        second = "$second PM";
        hour = "8";

        break;
        break;
      case "21":
        second = "$second PM";
        hour = "9";

        break;
        break;
      case "22":
        second = "$second PM";
        hour = "10";

        break;
        break;
      case "23":
        second = "$second PM";
        hour = "11";

        break;
        break;
      case "00":
        second = "$second PM";
        hour = "12";

        break;
    }
    String time = '$hour:$minute:$second';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('time', time);
    Firestore.instance.collection('seats').document(id).updateData({
      'allseats': FieldValue.arrayRemove([
        {
          'seat': seatNum,
          'color': 'green',
          'userid': '',
          'username': '',
          'userphone': '',
          'time': '',
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
          'time': time
        }
      ]),
    });
  }

  Future calnceBooking(String id, String userid, String username,
      String userphone, String seatNum) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String time = prefs.getString('time');
    await Firestore.instance.collection('seats').document(id).updateData({
      'allseats': FieldValue.arrayRemove([
        {
          'seat': seatNum,
          'color': 'grey',
          'userid': userid,
          'username': username,
          'userphone': userphone,
          'time': time
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
          'time': '',
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
