import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/loading/loading.dart';
import 'package:cafe/models/seats_models.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cafe/utils/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeatsWidgets extends StatefulWidget {
  final String cafeName;

  final UserInfo info;
  final int count;
  final Function updateListView;
  final Function _save;
  final Function getUserResrevation;
  String reservation;
  String seatSelect;
  TabController _controller;
  SeatsWidgets(
      this.info,
      this.count,
      this.updateListView,
      this._save,
      this.cafeName,
      this.getUserResrevation,
      this.reservation,
      this.seatSelect,
      this._controller);

  @override
  _SeatsWidgetsState createState() =>
      _SeatsWidgetsState(this._save, this.updateListView);
}

class _SeatsWidgetsState extends State<SeatsWidgets> {
  String code;
  TextEditingController controller = TextEditingController();
  final Function updateListView;
  final Function _save;
  _SeatsWidgetsState(this.updateListView, this._save);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    widget.getUserResrevation();
    return widget.count > 0 && widget.reservation != ''
        ? Container(
            height: height / 1.56999,
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
                        widget.seatSelect = myBooking['booked'];
                        updateListView();
                        return Container(
                          height: height / 2,
                          child: Center(
                            child: myBooking['cafename'] != '' &&
                                    widget.count > 0
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "لديك حجز في مقهى ${myBooking['cafename']}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 25, fontFamily: 'topaz'),
                                      ),
                                      Text(
                                        "جلسة رقم ${widget.seatSelect}",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 25, fontFamily: 'topaz'),
                                      ),
                                      SizedBox(
                                        height: 50,
                                      ),
                                      Text(
                                        "أسحب الشاشة لعرض قائمة الطلبات وطلب خدمة",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontFamily: 'topaz',
                                          color:
                                              Color.fromRGBO(102, 102, 255, 1),
                                        ),
                                      ),
                                    ],
                                  )
                                : Center(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "تم إلغاء حجزك أو حدث خطأ في التحميل",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontFamily: 'topaz',
                                          ),
                                        ),
                                        IconButton(
                                            icon: Icon(Icons.refresh),
                                            onPressed: () async {
                                              _delete();
                                              updateListView();
                                            })
                                      ],
                                    ),
                                  ),
                          ),
                        );
                      });
                }),
          )
        : Container(
            height: height / 1.57,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 50, top: 15, left: 15, right: 15),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('seats')
                    .document(widget.cafeName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("");
                  } else {
                    try {
                      List<SeatsModels> seatsModels = new List();
                      for (var i = 0;
                          i < snapshot.data['allseats'].length;
                          i++) {
                        seatsModels.add(SeatsModels(
                          snapshot.data['allseats'][i]['color'].toString(),
                          int.parse(snapshot.data['allseats'][i]['seat']),
                          snapshot.data['allseats'][i]['userid'],
                          snapshot.data['allseats'][i]['username'],
                          snapshot.data['allseats'][i]['userphone'],
                          snapshot.data['allseats'][i]['time'],
                          snapshot.data['allseats'][i]['worker'],
                          snapshot.data['allseats'][i]['workerName'],
                        ));
                      }
                      seatsModels.sort((a, b) {
                        var r = a.seat.compareTo(b.seat);

                        return r;
                      });
                      return GridView.builder(
                        itemCount: snapshot.data['allseats'].length,
                        itemBuilder: (context, index) {
                          Color color;
                          bool isbooked = false;
                          if (seatsModels[index].color.toString() == 'green') {
                            color = Colors.green;
                            isbooked = false;
                          } else {
                            color = Colors.grey;
                            isbooked = true;
                          }
                          String idSeat = index.toString();
                          String seatNum = seatsModels[index].seat.toString();
                          String worker = seatsModels[index].wroker.toString();
                          String workerName =
                              seatsModels[index].workerName.toString();
                          return InkWell(
                            onTap: isbooked
                                ? null
                                : () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    _showDialog(context).then((onValue) {
                                      if (snapshot.data['code'] == onValue) {
                                        checkIfResirved(seatNum)
                                            .then((onValue1) {
                                          if (onValue1 == false) {
                                            SnackBar mySnackBar = SnackBar(
                                              content: Text(
                                                "تم حجز الجلسة قبلك",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(fontSize: 24),
                                              ),
                                              backgroundColor: Colors.red,
                                              duration: const Duration(
                                                  milliseconds: 2000),
                                            );
                                            Scaffold.of(context)
                                                .showSnackBar(mySnackBar);
                                          } else {
                                            prefs.getString("seat");
                                            prefs.setString("seat", seatNum);
                                            prefs.setString('cafeNameForOrder',
                                                widget.cafeName);
                                            prefs.setString('worker', worker);
                                            prefs.setString(
                                                'workerName', workerName);
                                            updateListView();
                                            _save();
                                            updateListView();
                                            SigninFiresotre().updateBooking(
                                              widget.cafeName,
                                              widget.info.id,
                                              widget.info.name,
                                              widget.info.phone,
                                              seatNum,
                                            );
                                            SigninFiresotre().updateUser(
                                              widget.info.id,
                                              seatNum,
                                              widget.cafeName,
                                              idSeat,
                                            );

                                            //---------Go to selected Seats
                                            widget._controller.index = 2;
                                          }
                                        });
                                      } else {
                                        SnackBar mySnackBar = SnackBar(
                                          elevation: 0,
                                          content: Container(
                                            height: height * .5,
                                            child: Center(
                                              child: Card(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(16.0),
                                                  child: Text(
                                                    "خطأ في إدخال الكود",
                                                    textAlign: TextAlign.end,
                                                    style: TextStyle(
                                                        fontSize: 32,
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          backgroundColor: Colors.transparent,
                                          duration: const Duration(
                                              milliseconds: 1000),
                                        );
                                        Scaffold.of(context)
                                            .showSnackBar(mySnackBar);
                                      }
                                    });
                                  },
                            splashColor: Colors.purple,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              child: Center(
                                child: Text(
                                  seatNum,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
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
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                      );
                    } catch (e) {
                      return Loading();
                    }
                  }
                },
              ),
            ),
          );
  }

  void checkSeat() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String seatNumer = prefs.getString("seat");
    var document = Firestore.instance.document('seats/${widget.cafeName}');
    document.get().then((data) {
      for (var i = 0; i < data['allseats'].length; i++) {
        if (data['allseats'][i]['seat'] == seatNumer) {
          if (data['allseats'][i]['userid'] != widget.info.id) {
            cancleSeat();
            break;
          }
        }
      }
    });
  }

  DatabaseHelper databaseHelper = DatabaseHelper();

  bool hasBookinginSelected;

  void _delete() async {
    await databaseHelper.deleteNote();
  }

  void cancleSeat() async {
    //Delete from SQLITE
    _delete();
    widget.reservation = '';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String seatNumer = prefs.getString("seat");

    SigninFiresotre().calnceBooking(widget.cafeName, widget.info.id,
        widget.info.name, widget.info.phone, seatNumer);
    hasBookinginSelected = false;

    SigninFiresotre().cancleupdateUser(widget.info.id);

    Firestore.instance
        .collection('seats')
        .document(widget.cafeName)
        .updateData({
      'allseats': FieldValue.arrayRemove([
        {
          'seat': 'null',
          'color': 'green',
          'userid': '',
          'username': '',
          'userphone': '',
        }
      ]),
    });
  }

  Future<bool> checkIfResirved(String seatNumber) async {
    bool valid = true;
    final QuerySnapshot result =
        await Firestore.instance.collection('seats').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      if (data.documentID == widget.cafeName) {
        for (var i = 0; i < data['allseats'].length; i++) {
          if (seatNumber == data['allseats'][i]['seat']) {
            if (data['allseats'][i]['userid'] != '') {
              valid = false;
            }
          }
        }
      }
    });
    return valid;
  }

  Future<bool> checkIfDouplicate(String userID) async {
    bool valid = true;
    final QuerySnapshot result =
        await Firestore.instance.collection('seats').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      if (data.documentID == widget.cafeName) {
        for (var i = 0; i < data['allseats'].length; i++) {
          if (userID == data['allseats'][i]['userid']) {
            if (data['allseats'][i]['userid'] != '') {
              valid = false;
            }
          }
        }
      }
    });
    return valid;
  }

  Future<String> _showDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => new _SystemPadding(
        child: new AlertDialog(
          title: Text(
            'أدخل الكود',
            textAlign: TextAlign.end,
            style: TextStyle(color: Colors.blue),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  keyboardType: TextInputType.number,
                  controller: controller,
                  textAlign: TextAlign.end,
                  autofocus: true,
                  decoration: new InputDecoration(
                    hintText: 'الكود عند باب المقهى',
                  ),
                ),
              )
            ],
          ),
          actions: <Widget>[
            new FlatButton(
                child: const Text('خروج'),
                onPressed: () {
                  Navigator.pop(context);
                }),
            new FlatButton(
                child: const Text('إدخال'),
                onPressed: () {
                  Navigator.of(context).pop(controller.text.toString());
                })
          ],
        ),
      ),
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new AnimatedContainer(
        duration: const Duration(milliseconds: 300), child: child);
  }
}
