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
    final QuerySnapshot result =
        await Firestore.instance.collection('faham').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      setState(() {
        if (data['userid'] == widget.info.id) {
          pressed = true;
        } else {
          pressed = false;
        }
      });
    });
  }

  //---------
  @override
  Widget build(BuildContext context) {
    needService();
     needService();
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
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      50.0),
                                              side: BorderSide(
                                                  color: Colors.red)),
                                          color: Colors.black54,
                                          child: Text(
                                            "إلغاء الحجز",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () async {
                                            //Delete from SQLITE
                                            widget._delete();

                                            //Delete from firebase
                                            final QuerySnapshot result =
                                                await Firestore.instance
                                                    .collection('faham')
                                                    .getDocuments();
                                            final List<DocumentSnapshot>
                                                documents = result.documents;
                                            documents.forEach((data) {
                                              if (data['userid'] ==
                                                  widget.info.id) {
                                        
                                                String docID = data.documentID;
                                                Firestore.instance
                                                    .collection('faham')
                                                    .document(docID)
                                                    .delete();
                                              }
                                            });

                                            SigninFiresotre().cancleupdateUser(
                                                widget.info.id,
                                                myBooking['booked']);
                                            SigninFiresotre().calnceBooking(
                                                myBooking['seatid'],
                                                widget.info.id);
                                            widget.hasBookinginSelected = false;

                                            widget._onItemTapped(1);
                                          },
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
                                                          onTap: () {},
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
}
