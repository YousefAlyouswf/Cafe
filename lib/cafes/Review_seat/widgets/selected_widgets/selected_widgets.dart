import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  // countOrderINCart
  int orderCount;
  int cartPrice = 0;
  void countOrderINCart() async {
    List<String> useridList = new List();
    List<String> priceList = new List();
    final QuerySnapshot result =
        await Firestore.instance.collection('cart').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      if (data['userid'] == widget.info.id) {
        useridList.add(data['userid']);
        priceList.add(data['price']);
      }
    });
    cartPrice = 0;
    orderCount = useridList.length;
    for (var i = 0; i < priceList.length; i++) {
      cartPrice += int.parse(priceList[i]);
    }
  }

  //---------
  @override
  Widget build(BuildContext context) {
    needService();
    countOrderINCart();
    double height = MediaQuery.of(context).size.height;
    return Visibility(
      visible: widget.selectedScreen,
      child: Container(
        height: height / 1.3,
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
                DocumentSnapshot myBooking = snapshot.data.documents[index];
                if (myBooking['cafename'] != '') {
                  widget.hasBookinginSelected = true;
                } else {
                  widget.hasBookinginSelected = false;
                  widget._delete();
                }
                widget.seatnum = myBooking['booked'];
                reserveCafe = myBooking['cafename'];

                return Center(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        widget.hasBookinginSelected
                            ? Container(
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Row(
                                          children: <Widget>[
                                            RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0),
                                                  side: BorderSide(
                                                      color: Colors.red),
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    Text(
                                                      "الطلبات: $orderCount",
                                                      textAlign: TextAlign.end,
                                                      textDirection:
                                                          TextDirection.rtl,
                                                    ),
                                                    Text(
                                                      "السعر: $cartPrice",
                                                      textAlign: TextAlign.end,
                                                      textDirection:
                                                          TextDirection.rtl,
                                                    ),
                                                  ],
                                                ),
                                                onPressed: () {
                                                  showModalSheet(context);
                                                }),
                                            Spacer(),
                                            RaisedButton(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    new BorderRadius.circular(
                                                        50.0),
                                                side: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              color: Colors.black54,
                                              child: Text(
                                                "إلغاء الحجز",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              onPressed: () async {
                                                //Delete from SQLITE
                                                widget._delete();

                                                //Delete faham from firebase
                                                final QuerySnapshot result =
                                                    await Firestore.instance
                                                        .collection('faham')
                                                        .getDocuments();
                                                final List<DocumentSnapshot>
                                                    documents =
                                                    result.documents;
                                                documents.forEach((data) {
                                                  if (data['userid'] ==
                                                      widget.info.id) {
                                                    String docID =
                                                        data.documentID;
                                                    Firestore.instance
                                                        .collection('faham')
                                                        .document(docID)
                                                        .delete();
                                                  }
                                                });
                                                //------------
                                                //Delete cart from firebase
                                                final QuerySnapshot cartResult =
                                                    await Firestore.instance
                                                        .collection('cart')
                                                        .getDocuments();
                                                final List<DocumentSnapshot>
                                                    documentsCart =
                                                    cartResult.documents;
                                                documentsCart.forEach((data) {
                                                  if (data['userid'] ==
                                                      widget.info.id) {
                                                    String docID =
                                                        data.documentID;
                                                    Firestore.instance
                                                        .collection('cart')
                                                        .document(docID)
                                                        .delete();
                                                  }
                                                });
                                                //----------
                                                needService();

                                                SigninFiresotre()
                                                    .cancleupdateUser(
                                                        widget.info.id,
                                                        myBooking['booked']);
                                                SigninFiresotre().calnceBooking(
                                                    myBooking['seatid'],
                                                    widget.info.id);
                                                widget.hasBookinginSelected =
                                                    false;

                                                widget._onItemTapped(1);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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
                                        : Column(
                                            children: <Widget>[
                                              Text(
                                                " مقهى " +
                                                    reserveCafe +
                                                    " جلسة رقم: " +
                                                    widget.seatnum,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontFamily: 'topaz'),
                                              ),
                                              RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(5),
                                                    side: BorderSide(
                                                        color: Colors.red)),
                                                color: Colors.blue,
                                                child: pressed
                                                    ? Text(
                                                        "من فضلك أنتظر...",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textDirection:
                                                            TextDirection.rtl,
                                                      )
                                                    : Text(
                                                        "أريد خدمة",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        textDirection:
                                                            TextDirection.rtl,
                                                      ),
                                                onPressed: () async {
                                                  needService();
                                                  countOrderINCart();
                                                  bool faham = true;
                                                  final QuerySnapshot result =
                                                      await Firestore.instance
                                                          .collection('faham')
                                                          .getDocuments();
                                                  final List<DocumentSnapshot>
                                                      documents =
                                                      result.documents;
                                                  documents.forEach((data) {
                                                    if (data['userid'] ==
                                                        widget.info.id) {
                                                      String docID =
                                                          data.documentID;
                                                      Firestore.instance
                                                          .collection('faham')
                                                          .document(docID)
                                                          .delete();
                                                      faham = false;
                                                    }
                                                  });
                                                  if (faham) {
                                                    var now = DateTime.now()
                                                        .millisecondsSinceEpoch;
                                                    SigninFiresotre().faham(
                                                        reserveCafe,
                                                        widget.seatnum,
                                                        now.toString(),
                                                        widget.info.name,
                                                        widget.info.id);
                                                    //------

                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    // Text(
                                    //   'لا تقبل الطلبات إلا في المقهى',
                                    //   style: TextStyle(
                                    //       color: Colors.red, fontSize: 15),
                                    // ),
                                    Text(
                                      "قائمة الطلبات",
                                      style: TextStyle(
                                          fontFamily: 'arbaeen', fontSize: 18),
                                    ),
                                    Container(
                                      height: height / 1.85,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: reserveCafe != widget.cafeName
                                            ? Text(
                                                "لا يمكن عرض طلبات مقهى $reserveCafe في صفحة مقهى ${widget.cafeName}")
                                            : StreamBuilder(
                                                stream: Firestore.instance
                                                    .collection('order')
                                                    .where('cafename',
                                                        isEqualTo:
                                                            widget.cafeName)
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Text("");
                                                  } else {
                                                    return GridView.builder(
                                                      itemCount: snapshot.data
                                                          .documents.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            countOrderINCart();
                                                            String order = snapshot
                                                                .data
                                                                .documents[
                                                                    index]
                                                                .data['order'];
                                                            String price = snapshot
                                                                .data
                                                                .documents[
                                                                    index]
                                                                .data['price'];

                                                            SigninFiresotre()
                                                                .addInCart(
                                                              reserveCafe,
                                                              widget.seatnum,
                                                              order,
                                                              widget.info.name,
                                                              price,
                                                              widget.info.id,
                                                            );
                                                          },
                                                          splashColor:
                                                              Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          child: Card(
                                                            child: Column(
                                                              children: <
                                                                  Widget>[
                                                                Flexible(
                                                                  child: Text(
                                                                    snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data['order'],
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 15,
                                                                ),
                                                                Text(
                                                                  "السعر: " +
                                                                      snapshot
                                                                          .data
                                                                          .documents[
                                                                              index]
                                                                          .data['price'] +
                                                                      " ريال",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        childAspectRatio: 3 / 2,
                                                        crossAxisSpacing: 10,
                                                        mainAxisSpacing: 10,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      "عفوا, لا يوجد لديك حجز",
                                      style: TextStyle(
                                          fontFamily: 'topaz', fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 70,
                                    ),
                                  ],
                                ),
                              )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void showModalSheet(BuildContext context) {
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
        maxHeight: 450,
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
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('cart')
              .where('userid', isEqualTo: widget.info.id)
              .orderBy('submit').orderBy('order')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Text("لا توجد طلبات يمكن عرضها");

            return Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) {
                      String order =
                          snapshot.data.documents[index].data['order'];
                      String price =
                          snapshot.data.documents[index].data['price'];
                      String id = snapshot.data.documents[index].documentID;
                      String submit = snapshot.data.documents[index].data['submit'];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: submit=='no'? Colors.red[100]: Colors.green[100],
                          child: ListTile(
                            title: Text(
                              order ,
                              textDirection: TextDirection.rtl,
                            ),
                            subtitle: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Text(submit=='no'?"الطلب جاهز للإرسال":" تم أستقبال الطلب",),
                                SizedBox(width: 20,),
                                Text(
                                  price,
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                            leading: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                Firestore.instance
                                    .collection('cart')
                                    .document(id)
                                    .delete();
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color.fromRGBO(49, 39, 79, 0.8),
                    ),
                    child: InkWell(
                      onTap: () async {
                        List<String> cartID = new List();
                        final QuerySnapshot result = await Firestore.instance
                            .collection('cart')
                            .where('userid', isEqualTo: widget.info.id)
                            .getDocuments();
                        final List<DocumentSnapshot> documents = result.documents;
                        documents.forEach((data) {
                          cartID.add(data.documentID);
                        });

                        for (var i = 0; i < cartID.length; i++) {
                          SigninFiresotre().updateCart(cartID[i]);
                        }
                        Navigator.pop(context);
                      },
                      splashColor: Colors.red,
                      borderRadius: BorderRadius.circular(50),
                      child: Center(
                          child: Text(
                        "أرسل الطلب",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'topaz',
                            fontSize: 25),
                      )),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
