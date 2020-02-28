import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cafe/utils/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../selected_widgets/selected_widgets.dart';

class SeatsWidgets extends StatefulWidget {
  final String cafeName;

  final UserInfo info;
  final int count;
  final Function updateListView;
  final Function _save;
  final Function _onItemTapped;
  final Function getUserResrevation;
  String reservation;
  String seatSelect;

  SeatsWidgets(
    this.info,
    this.count,
    this.updateListView,
    this._save,
    this._onItemTapped,
    this.cafeName,
    this.getUserResrevation,
    this.reservation,
    this.seatSelect,
  );

  @override
  _SeatsWidgetsState createState() =>
      _SeatsWidgetsState(this._save, this.updateListView);
}

class _SeatsWidgetsState extends State<SeatsWidgets> {
  List<String> colorSeat = new List();

  List<String> numSeat = new List();

  List<String> idSeat = new List();

  String code;
  TextEditingController controller = TextEditingController();
  final Function updateListView;
  final Function _save;
  _SeatsWidgetsState(this.updateListView, this._save);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    widget.getUserResrevation();
    return widget.count > 0 || widget.reservation != ''
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
                        return Container(
                          height: height / 2,
                          child: Center(
                            child: myBooking['cafename'] != ''
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
                                    child: Text(
                                      "حدث خطأ في عرض الجلسات يمكنك إعادة فتح البرنامج",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'topaz',
                                      ),
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
              padding: const EdgeInsets.all(15),
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('seats')
                    .document(widget.cafeName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("");
                  } else {
                    int lengthCheck = snapshot.data['allseats'].length;

                    for (var i = 0; i < lengthCheck; i++) {
                      colorSeat.add(
                          snapshot.data['allseats'][i]['color'].toString());
                      numSeat
                          .add(snapshot.data['allseats'][i]['seat'].toString());
                      idSeat.add(i.toString());
                    }
                    return GridView.builder(
                      itemCount: lengthCheck,
                      itemBuilder: (context, index) {
                        Color color;
                        bool isbooked = false;
                        if (colorSeat[index] == 'green') {
                          color = Colors.green;
                          isbooked = false;
                        } else {
                          color = Colors.grey;
                          isbooked = true;
                        }

                        return InkWell(
                          onTap: isbooked
                              ? null
                              : () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  _showDialog(context).then((onValue) {
                                    if (snapshot.data['code'] == onValue) {
                                      prefs.getString("seat");
                                      prefs.setString("seat", numSeat[index]);
                                      prefs.setString(
                                          'cafeNameForOrder', widget.cafeName);
                                      updateListView();
                                      _save();
                                      updateListView();
                                      SigninFiresotre().updateBooking(
                                        widget.cafeName,
                                        widget.info.id,
                                        widget.info.name,
                                        widget.info.phone,
                                        numSeat[index],
                                      );
                                      SigninFiresotre().updateUser(
                                        widget.info.id,
                                        numSeat[index],
                                        widget.cafeName,
                                        idSeat[index],
                                      );
                                    } else {
                                      SnackBar mySnackBar = SnackBar(
                                        content: Text(
                                          "خطأ في إدخال الكود",
                                          textAlign: TextAlign.end,
                                        ),
                                        backgroundColor: Colors.red,
                                        duration:
                                            const Duration(milliseconds: 500),
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
                                numSeat[index].toString(),
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
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                    );
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
