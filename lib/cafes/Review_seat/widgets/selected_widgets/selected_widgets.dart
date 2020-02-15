import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/models/cart.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../../../utils/database_helper.dart';
import 'header_buttons.dart';
import 'order_body.dart';

class SelectedWidgets extends StatefulWidget {
  final bool selectedScreen;
  final UserInfo info;
  bool hasBookinginSelected;
  final Function _delete;
  final Function _onItemTapped;
  String seatnum;
  final String cafeName;
  final String reservation;
  SelectedWidgets(
    this.selectedScreen,
    this.info,
    this.hasBookinginSelected,
    this._delete,
    this._onItemTapped,
    this.seatnum,
    this.cafeName,
    this.reservation,
  );

  @override
  _SelectedWidgetsState createState() => _SelectedWidgetsState();
}

class _SelectedWidgetsState extends State<SelectedWidgets> {
  String reserveCafe;

  bool pressed = false;

  //SQL DB----------------
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Cart> cartList = new List();
  int count;
  Cart cart;
  //------------------
  // need service
  void needService() async {
    List<String> useridList = new List();
    final QuerySnapshot result =
        await Firestore.instance.collection('faham').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      useridList.add(data['userid']);
    });
    pressed = false;
    for (var i = 0; i < useridList.length; i++) {
      if (useridList[i] == widget.info.id) {
        pressed = true;
      }
    }
  }

  //---------
  String seatID;
  // countOrderINCart
  int orderCount;
  int cartPrice = 0;
  void countOrderINCart() async {
    orderCount = cartList.length;
    cartPrice = 0;
    for (var i = 0; i < orderCount; i++) {
      cartPrice += int.parse(cartList[i].price);
    }
  }

  void cancleSeat() async {
    //Delete from SQLITE
    widget._delete();

    //Delete faham from firebase
    final QuerySnapshot result =
        await Firestore.instance.collection('faham').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      if (data['userid'] == widget.info.id) {
        String docID = data.documentID;
        Firestore.instance.collection('faham').document(docID).delete();
      }
    });
    //------------
    //Delete cart from firebase
    final QuerySnapshot cartResult =
        await Firestore.instance.collection('cart').getDocuments();
    final List<DocumentSnapshot> documentsCart = cartResult.documents;
    documentsCart.forEach((data) {
      if (data['userid'] == widget.info.id) {
        String docID = data.documentID;
        Firestore.instance.collection('cart').document(docID).delete();
      }
    });
    //----------
    needService();

    SigninFiresotre().calnceBooking(widget.cafeName, widget.info.id,
        widget.info.name, widget.info.phone, widget.seatnum);
    widget.hasBookinginSelected = false;

    SigninFiresotre().cancleupdateUser(widget.info.id, widget.seatnum);

    Firestore.instance
        .collection('seats')
        .document(widget.cafeName)
        .updateData({
      'allseats': FieldValue.arrayRemove([
        {
          'seat': null,
          'color': 'green',
          'userid': '',
          'username': '',
          'userphone': '',
        }
      ]),
    });
    widget._onItemTapped(1);
  }

  void checkSeat() async {
    var document = Firestore.instance.document('seats/${widget.cafeName}');
    document.get().then((data) {
      for (var i = 0; i < data['allseats'].length; i++) {
        if (data['allseats'][i]['seat'] == widget.seatnum) {
          if (data['allseats'][i]['userid'] != widget.info.id) {
            cancleSeat();
            break;
          }
        }
      }
    });
  }

  String orderName;
  String price;
  String orderID;
  //---------
  @override
  Widget build(BuildContext context) {
    needService();
    countOrderINCart();
    double height = MediaQuery.of(context).size.height;
    return Visibility(
      visible: widget.selectedScreen,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            child: Column(
              children: <Widget>[
                HeaderButtons(
                  widget.seatnum,
                  cartPrice,
                  widget.reservation,
                  showModalSheet,
                  needService,
                  countOrderINCart,
                  widget._delete,
                  widget._onItemTapped,
                  pressed,
                  reserveCafe,
                  widget.cafeName,
                  widget.hasBookinginSelected,
                  widget.info.id,
                  widget.info.name,
                  widget.info.phone,
                ),
                OrderBody(
                    height,
                    widget.info.phone,
                    checkSeat,
                    widget._delete,
                    _saveCart,
                    updateListView,
                    widget.hasBookinginSelected,
                    widget.seatnum,
                    reserveCafe,
                    seatID,
                    orderName,
                    price,
                    orderID,
                    widget.cafeName),
              ],
            ),
          );
        },
      ),
    );
  }

  void showModalSheet(BuildContext context) {
    updateListView();
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            return createBox(context, state);
          },
        );
      },
    );
  }

  createBox(BuildContext context, StateSetter state) {
    return SingleChildScrollView(
      child: LimitedBox(
        maxHeight: 370,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildMainDropdown(state),
          ],
        ),
      ),
    );
  }

  Expanded buildMainDropdown(StateSetter setState) {
    return Expanded(
      child: Container(
        color: Colors.yellow[100],
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (context, index) {
                  final cartIndex = cartList[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          cartIndex.orderName,
                          textDirection: TextDirection.rtl,
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              cartIndex.price,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteCart(cartIndex.orderID);
                            updateListView();
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red[300],
                      ),
                      child: InkWell(
                        onTap: () async {
                          for (var i = 0; i < cartList.length; i++) {
                            _deleteCart(cartList[i].orderID);
                          }
                          updateListView();
                          Navigator.pop(context);
                        },
                        splashColor: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                        child: Center(
                            child: Text(
                          "مسح الكل",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'topaz',
                              fontSize: 18),
                        )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.green[300]),
                      child: InkWell(
                        onTap: () async {
                          List<String> orderNameList = new List();
                          List<String> orderPriceList = new List();

                          for (var i = 0; i < cartList.length; i++) {
                            orderNameList.add(cartList[i].orderName);
                            orderPriceList.add(cartList[i].price);
                          }

                          SigninFiresotre().insertInCart(
                              orderNameList,
                              orderPriceList,
                              widget.cafeName,
                              widget.seatnum,
                              widget.info.name,
                              widget.info.phone);

                          for (var i = 0; i < cartList.length; i++) {
                            _deleteCart(cartList[i].orderID);
                          }
                          updateListView();
                          Navigator.pop(context);
                        },
                        splashColor: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                        child: Center(
                            child: Text(
                          "أرسل الطلب",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'topaz',
                              fontSize: 18),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Cart List Function
  void updateListView() async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    await dbFuture.then((database) {
      Future<List<Cart>> noteListFuture = databaseHelper.getCartList();
      noteListFuture.then((cartList) {
        setState(() {
          this.cartList = cartList;
          this.count = cartList.length;
        });
      });
    });
  }

  // Save data to database
  void _saveCart() async {
    int result;
    Cart cart = Cart(widget.info.id, orderName, price);
    // Case 2: Insert Operation
    result = await databaseHelper.insertCart(cart);

    if (result != 0) {
      // Success

      debugPrint('cart Saved Successfully');
    } else {
      // Failure
      debugPrint('Problem Saving Login');
    }
  }

  void _deleteCart(int orderid) async {
    int result;
    result = await databaseHelper.deleteCart(orderid);
    if (result != 0) {
      // Success

      debugPrint('deleted Successfully');
    } else {
      // Failure
      debugPrint('Problem delete Login');
    }
  }
}
