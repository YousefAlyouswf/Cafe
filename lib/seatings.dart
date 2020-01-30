import 'package:cafe/models/user_info.dart';
import 'package:cafe/singin/signin_firebase.dart';
import 'package:cafe/singin/login.dart';
import 'package:cafe/sit_selected.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'animation/fadeAnimation.dart';
import 'cafes/cafes_screen.dart';

class Seatings extends StatefulWidget {
  final String cafeName;
  final UserInfo info;
  const Seatings({Key key, this.cafeName, this.info}) : super(key: key);
  @override
  _SittingsState createState() => _SittingsState();
}

class _SittingsState extends State<Seatings> {
  //To Show user Info START
  String userID;
  String userName;
  String userPhone;
  String userPassword;
  String booked;
  String seatNum;
  //To Show user Info END
  bool sort = false;
  bool yourSeat = false;
  @override
  Widget build(BuildContext context) {
    userID = widget.info.id;
    userName = widget.info.name;
    userPhone = widget.info.phone;
    userPassword = widget.info.password;
    booked = widget.info.booked;
    return WillPopScope(
      onWillPop: () async => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return CafeList(
                info: widget.info,
              );
            },
          ),
        ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(49, 39, 79, 0.5),
          title: Center(child: Text(widget.cafeName)),
          actions: <Widget>[
            // FlatButton.icon(
            //   icon: Icon(Icons.sort),
            //   label: Text(""),
            //   onPressed: () {
            //     setState(() {
            //       if (!sort) {
            //         sort = true;
            //       } else {
            //         sort = false;
            //       }
            //     });
            //   },
            // ),
            FlatButton.icon(
              icon: Icon(Icons.exit_to_app),
              label: Text(""),
              onPressed: () {
                setState(() {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return Login();
                  }));
                });
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('sitting')
                .where('cafe', isEqualTo: widget.cafeName)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("Loading...");
              } else {
                return GridView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    Color color;
                    bool isbooked = false;
                    if (snapshot.data.documents[index].data['color'] ==
                        'green') {
                      color = Colors.green;
                      isbooked = false;
                    } else {
                      if (snapshot.data.documents[index].data['userid'] ==
                          widget.info.id) {
                        color = Colors.red;
                        yourSeat = true;
                      } else {
                        color = Colors.grey;
                        isbooked = true;
                      }
                    }

                    return InkWell(
                      onTap: isbooked
                          ? null
                          : () {
                              SigninFiresotre().updateBooking(
                                      snapshot.data.documents[index].documentID
                                          .toString(),
                                      widget.info.id);
                              SigninFiresotre().updateUser(
                                  widget.info.id,
                                  snapshot.data.documents[index].data['sit']
                                      .toString());
                              var sheetController = showBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          'رقم الجلسة: ' +
                                              snapshot.data.documents[index]
                                                  .data['sit']
                                                  .toString(),
                                          style: TextStyle(fontSize: 40),
                                        ),
                                        Text(
                                          "حجز بأسم: " + userName,
                                          style: TextStyle(fontSize: 30),
                                        ),
                                        Text(
                                          "سعر الجلسة " +
                                              snapshot.data.documents[index]
                                                  .data['price'] +
                                              " ريال",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 50,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 50),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color:
                                                Color.fromRGBO(49, 39, 79, 0.6),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              //Confirm
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) {
                                                    return SitSelected(
                                                      info: widget.info,
                                                      cafeName: widget.cafeName,
                                                    );
                                                  },
                                                ),
                                              );
                                            },
                                            splashColor: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
                                              child: Text(
                                                "تأكيد الحجز",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          height: 50,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 50),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color:
                                                Color.fromRGBO(49, 39, 79, 0.4),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            splashColor: Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: Center(
                                              child: Text(
                                                "إلغاء",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                              sheetController.closed.then((val) {
                                SigninFiresotre().calnceBooking(
                                  snapshot.data.documents[index].documentID
                                      .toString(),
                                  widget.info.id,
                                );
                                SigninFiresotre().cancleupdateUser(
                                  widget.info.id,
                                  snapshot.data.documents[index].data['sit']
                                      .toString(),
                                );
                                yourSeat = false;
                              });
                              setState(() {
                                // SigninFiresotre().updateBooking(snapshot
                                //     .data.documents[index].documentID
                                //     .toString());
                                // SigninFiresotre().updateUser(
                                //     userID,
                                //     snapshot.data.documents[index].data['sit']
                                //         .toString());
                                // Navigator.of(context)
                                //     .push(MaterialPageRoute(builder: (_) {
                                //   return SitSelected(
                                //       snapshot.data.documents[index].documentID
                                //           .toString(),
                                //       snapshot.data.documents[index].data['sit']
                                //           .toString(),
                                //       isbooked,
                                //       userID);
                                // }));
                              });
                            },
                      splashColor: Colors.purple,
                      borderRadius: BorderRadius.circular(15),
                      child: FadeAnimation(
                        1,
                        Container(
                          padding: const EdgeInsets.all(15),
                          child: Center(
                            child: Text(
                              snapshot.data.documents[index].data['sit']
                                  .toString(),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [color.withOpacity(0.1), color],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 100,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
