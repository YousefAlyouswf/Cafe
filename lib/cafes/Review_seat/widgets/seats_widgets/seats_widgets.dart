import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/loading/loading.dart';
import 'package:cafe/models/seats_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SeatsWidgets extends StatefulWidget {
  final String cafeName;
  final String phone;
  String seatSelect;
  final TabController _controller;

  SeatsWidgets(this.cafeName, this.seatSelect, this._controller, this.phone);

  @override
  _SeatsWidgetsState createState() => _SeatsWidgetsState();
}

class _SeatsWidgetsState extends State<SeatsWidgets> {
  String code;
  TextEditingController controllerCode = TextEditingController();
  String reservation;
  bool result;
  void checkIfSeatSelected() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      result = prefs.getBool('seatSelected');
      reservation = prefs.getString('reservation');
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    checkIfSeatSelected();
    // widget.getUserResrevation();
    return Container(
      height: height / 1.57,
      child: Padding(
        padding:
            const EdgeInsets.only(bottom: 50, top: 15, left: 15, right: 15),
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
                for (var i = 0; i < snapshot.data['allseats'].length; i++) {
                  seatsModels.add(SeatsModels(
                    snapshot.data['allseats'][i]['color'].toString(),
                    int.parse(snapshot.data['allseats'][i]['seat']),
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
                    String status;
                    bool isbooked = false;
                    if (seatsModels[index].color.toString() == 'green') {
                      color = Colors.green;
                      isbooked = false;
                      status = 'متاح';
                    } else {
                      color = Colors.grey;
                      isbooked = true;
                      status = 'محجوز';
                    }
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
                              String checkIfhasSeat = prefs.getString("seat");
                              String cafeName =
                                  prefs.getString('cafeNameForOrder');
                              if (checkIfhasSeat == null ||
                                  checkIfhasSeat == '') {
                                toBookSeat(
                                  context,
                                  snapshot.data['code'],
                                  seatNum,
                                  worker,
                                  workerName,
                                  height,
                                  prefs,
                                );
                              } else {
                                SnackBar mySnackBar = SnackBar(
                                  elevation: 0,
                                  content: Container(
                                    height: height * .5,
                                    child: Center(
                                      child: Card(
                                        color: Colors.transparent,
                                        elevation: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            children: <Widget>[
                                              Text(
                                                "لديك حجز في مقهى $cafeName جلسة رقم $checkIfhasSeat",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.red),
                                              ),
                                              Text(
                                                "لإلغاء الحجز",
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.red),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.cancel,
                                                  size: 55,
                                                  color: Colors.red,
                                                ),
                                                onPressed: () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  prefs.setBool(
                                                      'seatSelected', false);

                                                  //Delete faham from firebase
                                                  final QuerySnapshot result =
                                                      await Firestore.instance
                                                          .collection('faham')
                                                          .getDocuments();
                                                  final List<DocumentSnapshot>
                                                      documents =
                                                      result.documents;
                                                  documents.forEach((data) {
                                                    if (data['userphone'] ==
                                                        widget.phone) {
                                                      String docID =
                                                          data.documentID;
                                                      Firestore.instance
                                                          .collection('faham')
                                                          .document(docID)
                                                          .delete();
                                                    }
                                                  });
                                                  //------------

                                                  String seatNumer =
                                                      prefs.getString("seat");
                                                  String cafeNameForCancle =
                                                      prefs.getString(
                                                          'cafeNameForOrder');
                                                  SigninFiresotre()
                                                      .calnceBooking(
                                                          cafeNameForCancle,
                                                          widget.phone,
                                                          seatNumer);

                                                  hasBookinginSelected = false;
                                                  prefs.setString("seat", null);
                                                  Scaffold.of(context)
                                                      .hideCurrentSnackBar();
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  backgroundColor: Colors.transparent,
                                  duration: const Duration(milliseconds: 5000),
                                );
                                Scaffold.of(context).showSnackBar(mySnackBar);
                              }
                            },
                      splashColor: Colors.purple,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Text(
                                seatsModels[index].workerName,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                            ),
                            Center(
                              child: Text(
                                seatNum,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Center(
                              child: Text(
                                status,
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black38),
                              ),
                            ),
                          ],
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
                    childAspectRatio: 1.2,
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

  bool hasBookinginSelected;

  Future<bool> checkIfResirved(String seatNumber) async {
    bool valid = true;
    final QuerySnapshot result =
        await Firestore.instance.collection('seats').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      if (data.documentID == widget.cafeName) {
        for (var i = 0; i < data['allseats'].length; i++) {
          if (seatNumber == data['allseats'][i]['seat']) {
            if (data['allseats'][i]['userphone'] != '') {
              valid = false;
            }
          }
        }
      }
    });
    return valid;
  }

  void toBookSeat(
      BuildContext context,
      String code,
      String seatNum,
      String worker,
      String workerName,
      double height,
      SharedPreferences prefs) async {
    _showDialog(context).then((onValue) {
      if (code == onValue) {
        checkIfResirved(seatNum).then((onValue1) {
          if (onValue1 == false) {
            SnackBar mySnackBar = SnackBar(
              elevation: 0,
              content: Container(
                height: height * .5,
                child: Center(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "تم حجز الجلسة قبلك",
                        textAlign: TextAlign.end,
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              backgroundColor: Colors.transparent,
              duration: const Duration(milliseconds: 3000),
            );
            Scaffold.of(context).showSnackBar(mySnackBar);
          } else {
            prefs.getString("seat");
            prefs.setString("seat", seatNum);
            prefs.setString('cafeNameForOrder', widget.cafeName);
            prefs.setString('worker', worker);
            prefs.setString('workerName', workerName);
            prefs.setBool('seatSelected', true);
            SigninFiresotre().updateBooking(
              widget.cafeName,
              seatNum,
              widget.phone,
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
                    style: TextStyle(fontSize: 32, color: Colors.red),
                  ),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          duration: const Duration(milliseconds: 1000),
        );
        Scaffold.of(context).showSnackBar(mySnackBar);
      }
    });
  }

  Future<String> _showDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (_) => new _SystemPadding(
        child: new AlertDialog(
          title: Text(
            'تأكيد الحجز',
            textAlign: TextAlign.end,
            style: TextStyle(color: Colors.blue),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          content: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextField(
                  keyboardType: TextInputType.number,
                  controller: controllerCode,
                  textAlign: TextAlign.end,
                  autofocus: true,
                  decoration: new InputDecoration(
                    hintText: 'الكود في المقهى',
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
                  Navigator.of(context).pop(
                    controllerCode.text.toString(),
                  );
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
