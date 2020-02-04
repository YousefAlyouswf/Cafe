import 'package:cafe/animation/fadeAnimation.dart';
import 'package:cafe/cafes/Review_seat/reviews.dart';
import 'package:cafe/cafes/Review_seat/seat_selected.dart';
import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cafe/utils/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cafe/models/booking.dart';
import 'package:sqflite/sqlite_api.dart';

class Seatings extends StatefulWidget {
  final String cafeName;
  final UserInfo info;
  final String cafeID;
  final BookingDB booking;
  Seatings(this.booking, this.cafeName, this.info, this.cafeID);

  @override
  _SittingsState createState() {
    return _SittingsState(this.booking, this.cafeName, this.info, this.cafeID);
  }
}

class _SittingsState extends State<Seatings> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  BookingDB note;
  String cafeName;
  UserInfo info;
  String cafeID;
  _SittingsState(this.note, this.cafeName, this.info, this.cafeID);
//To Show user Info START
  String userID;
  String userName;
  String userPhone;
  String userPassword;
  String booked;
  String seatNum;
  //To Show user Info END

  String seatID;
  bool sort = false;
  bool yourSeat = false;
  //Temporrary Code----------------------------------

  List<BookingDB> noteList = new List();
  int count = 0;

  //Temporrary Code----------------------------------
  int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return Reviews(
                cafeName: widget.cafeName,
                info: widget.info,
                cafeID: widget.cafeID,
              );
            },
          ),
        );
      } else if (index == 2) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return SeatSelected(widget.info, widget.cafeName, widget.cafeID,
                  BookingDB('', '', ''));
            },
          ),
        );
      }
    });
  }

  
  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    userName = info.name;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(
          child: Text(
            widget.cafeName,
            style: TextStyle(
                fontFamily: 'arbaeen',
                fontWeight: FontWeight.bold,
                fontSize: 28),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            title: Text('التعليقات'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event_seat),
            title: Text('الجلسات'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text('الحجز'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: count > 0
          ? Center(child: Text('عفوا, يوجد لديك حجز'))
          : Padding(
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
                          color = Colors.grey;
                          isbooked = true;
                        }
                        updateListView();
                        return InkWell(
                          onTap: isbooked
                              ? null
                              : () {
                                  SigninFiresotre().updateBooking(
                                      snapshot.data.documents[index].documentID
                                          .toString(),
                                      widget.info.id,
                                      widget.info.name,
                                      widget.info.phone);
                                  SigninFiresotre().updateUser(
                                    widget.info.id,
                                    snapshot.data.documents[index].data['sit']
                                        .toString(),
                                    widget.cafeName,
                                    snapshot.data.documents[index].documentID
                                        .toString(),
                                  );
                                  var sheetController = showBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        //Database blocks
                                        note.userID = info.id;
                                        note.seatID = snapshot
                                            .data.documents[index].data['sit']
                                            .toString();
                                        note.cafeID = widget.cafeID;
                                        if (noteList == null) {
                                          noteList = List<BookingDB>();
                                        }
                                        //Database blocks
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
                                                color: Color.fromRGBO(
                                                    49, 39, 79, 0.6),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  // prepare to save information in SQLITE

                                                  _save();
                                                  //Confirm
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (_) {
                                                        updateListView();
                                                        
                                                        return SeatSelected(
                                                            widget.info,
                                                            widget.cafeName,
                                                            widget.cafeID,
                                                            BookingDB(
                                                                '', '', ''));
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
                                                color: Color.fromRGBO(
                                                    49, 39, 79, 0.4),
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
    );
  }

  // Convert the String priority in the form of integer before saving it to Database

  // Convert int priority to String priority and display it to user in DropDown

  // Save data to database
  void _save() async {
    int result;

    // Case 2: Insert Operation
    result = await databaseHelper.insertNote(note);

    if (result != 0) {
      // Success
      debugPrint('Note Saved Successfully');
    } else {
      // Failure
      debugPrint('Problem Saving Note');
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<BookingDB>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList) {
        setState(() {
          this.noteList = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}
