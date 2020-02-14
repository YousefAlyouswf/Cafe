import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/models/cart.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

import '../../../../utils/database_helper.dart';

class SelectedWidgets extends StatefulWidget {
  final bool selectedScreen;
  final UserInfo info;
  bool hasBookinginSelected;
  final Function _delete;
  final Function _onItemTapped;
  String seatnum;
  final String cafeName;

  SelectedWidgets(
    this.selectedScreen,
    this.info,
    this.hasBookinginSelected,
    this._delete,
    this._onItemTapped,
    this.seatnum,
    this.cafeName,
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
      child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
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
                              "الطلبات: $orderCount",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.end,
                              textDirection: TextDirection.rtl,
                            ),
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
                        final List<DocumentSnapshot> documents =
                            result.documents;
                        documents.forEach((data) {
                          if (data['userid'] == widget.info.id) {
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
                          SigninFiresotre().faham(reserveCafe, widget.seatnum,
                              now.toString(), widget.info.name, widget.info.id);
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
                        widget._delete();

                        //Delete faham from firebase
                        final QuerySnapshot result = await Firestore.instance
                            .collection('faham')
                            .getDocuments();
                        final List<DocumentSnapshot> documents =
                            result.documents;
                        documents.forEach((data) {
                          if (data['userid'] == widget.info.id) {
                            String docID = data.documentID;
                            Firestore.instance
                                .collection('faham')
                                .document(docID)
                                .delete();
                          }
                        });
                        //------------
                        //Delete cart from firebase
                        final QuerySnapshot cartResult = await Firestore
                            .instance
                            .collection('cart')
                            .getDocuments();
                        final List<DocumentSnapshot> documentsCart =
                            cartResult.documents;
                        documentsCart.forEach((data) {
                          if (data['userid'] == widget.info.id) {
                            String docID = data.documentID;
                            Firestore.instance
                                .collection('cart')
                                .document(docID)
                                .delete();
                          }
                        });
                        //----------
                        needService();
                        final QuerySnapshot seat = await Firestore.instance
                            .collection('sitting')
                            .getDocuments();
                        final List<DocumentSnapshot> seatDoc = seat.documents;
                        seatDoc.forEach((data) {
                          if (data['userid'] == widget.info.id) {
                            String docID = data.documentID;

                            SigninFiresotre().calnceBooking(docID);
                            widget.hasBookinginSelected = false;
                          }
                        });

                        SigninFiresotre()
                            .cancleupdateUser(widget.info.id, widget.seatnum);
                        widget._onItemTapped(1);
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: height / 2.035,
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('users')
                    .where('phone', isEqualTo: widget.info.phone)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Text("Loading..");
                  return ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot myBooking =
                          snapshot.data.documents[index];
                      if (myBooking['cafename'] != '') {
                        widget.hasBookinginSelected = true;
                      } else {
                        widget.hasBookinginSelected = false;
                        widget._delete();
                      }
                      widget.seatnum = myBooking['booked'];
                      reserveCafe = myBooking['cafename'];

                      seatID = myBooking.documentID;

                      return Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            widget.hasBookinginSelected
                                ? Container(
                                    child: Column(
                                      children: <Widget>[
                                        reserveCafe != widget.cafeName
                                            ? Text(
                                                " لديك حجز في مقهى " +
                                                    reserveCafe +
                                                    " جلسة رقم: " +
                                                    widget.seatnum,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'topaz'),
                                              )
                                            :
                                            // : Column(
                                            //     children: <Widget>[
                                            //       Text(
                                            //         " جلسة رقم: " +
                                            //             widget.seatnum,
                                            //         style: TextStyle(
                                            //             fontSize: 20,
                                            //             fontFamily: 'topaz'),
                                            //       ),
                                            //     ],
                                            //   ),

                                            Container(
                                                height: height / 2.035,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: reserveCafe !=
                                                          widget.cafeName
                                                      ? Text(
                                                          "لا يمكن عرض طلبات مقهى $reserveCafe في صفحة مقهى ${widget.cafeName}")
                                                      : StreamBuilder(
                                                          stream: Firestore
                                                              .instance
                                                              .collection(
                                                                  'order')
                                                              .where('cafename',
                                                                  isEqualTo: widget
                                                                      .cafeName)
                                                              .snapshots(),
                                                          builder: (context,
                                                              snapshot) {
                                                            if (!snapshot
                                                                .hasData) {
                                                              return Text("");
                                                            } else {
                                                              return GridView
                                                                  .builder(
                                                                itemCount:
                                                                    snapshot
                                                                        .data
                                                                        .documents
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      orderName = snapshot
                                                                          .data
                                                                          .documents[
                                                                              index]
                                                                          .data['order'];
                                                                      price = snapshot
                                                                          .data
                                                                          .documents[
                                                                              index]
                                                                          .data['price'];
                                                                      orderID = snapshot
                                                                          .data
                                                                          .documents[
                                                                              index]
                                                                          .documentID;

                                                                      _saveCart();
                                                                      updateListView();
                                                                    },
                                                                    splashColor:
                                                                        Colors
                                                                            .red,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
                                                                    child: Card(
                                                                      child:
                                                                          Column(
                                                                        children: <
                                                                            Widget>[
                                                                          Flexible(
                                                                            child:
                                                                                Text(
                                                                              snapshot.data.documents[index].data['order'],
                                                                              textAlign: TextAlign.center,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                15,
                                                                          ),
                                                                          Text(
                                                                            "السعر: " +
                                                                                snapshot.data.documents[index].data['price'] +
                                                                                " ريال",
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                                gridDelegate:
                                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      3,
                                                                  childAspectRatio:
                                                                      3 / 2,
                                                                  crossAxisSpacing:
                                                                      10,
                                                                  mainAxisSpacing:
                                                                      10,
                                                                ),
                                                              );
                                                            }
                                                          }),
                                                ),
                                              ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    height: height / 2,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "عفوا, لا يوجد لديك حجز",
                                          style: TextStyle(
                                              fontFamily: 'topaz',
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          height: 70,
                                        ),
                                      ],
                                    ),
                                  )
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
