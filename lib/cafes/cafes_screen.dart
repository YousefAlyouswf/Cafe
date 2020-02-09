import 'package:cafe/login_screen/login.dart';
import 'package:cafe/models/booking.dart';
import 'package:cafe/utils/database_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';
import '../models/user_info.dart';
import 'Review_seat/reviews.dart';

class CafeList extends StatefulWidget {
  final UserInfo info;
  final BookingDB bookingDB;
  CafeList(this.info, this.bookingDB);

  @override
  _CafeListState createState() {
    return _CafeListState(this.info, this.bookingDB);
  }
}

class _CafeListState extends State<CafeList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<BookingDB> noteList = new List();
  List<BookingDB> loginList = new List();
  bool sort = false;
  BookingDB bookingDB;
  String city;

  String filterCity;

  bool check = false;

  String userID;

  String userName;

  String userPhone;

  String userPassword;

  String booked;

  int count;

  String seatNum;
  UserInfo info;
  List<String> cityList = new List();

  List<dynamic> removeDoublicat = new List();

  _CafeListState(this.info, this.bookingDB);
  @override
  void initState() {
    super.initState();
    updateListView();
  }

  @override
  Widget build(BuildContext context) {
    try {
      userID = widget.info.id;
      userName = widget.info.name;
      userPhone = widget.info.phone;
      userPassword = widget.info.password;
      booked = widget.info.booked;
    } catch (Ex) {}

    return WillPopScope(
      onWillPop: () {
        _deleteLogin();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.red[200],
          title: Center(
            child: Text(
              "قائمة المقاهي",
              style: TextStyle(
                  fontFamily: 'arbaeen',
                  fontWeight: FontWeight.bold,
                  fontSize: 28),
            ),
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(
                  Icons.power_settings_new,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  _deleteLogin();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ),
          ],
        ),
        // drawer: Drawer(
        //     child: ListView(
        //   children: <Widget>[
        //     UserAccountsDrawerHeader(
        //       accountName: Text(""),
        //       accountEmail: Text(""),
        //       decoration: BoxDecoration(
        //           image: DecorationImage(
        //         image: NetworkImage(
        //             'https://upload.wikimedia.org/wikipedia/ar/thumb/6/68/General_Entertainment_Authority_Logo.svg/1200px-General_Entertainment_Authority_Logo.svg.png'),
        //       )),
        //     ),
        //     ListTile(
        //       title: Center(
        //           child: Text(
        //         "المقاهي المفضلة",
        //         style: TextStyle(fontSize: 24),
        //       )),
        //       trailing: Icon(Icons.map),
        //     ),
        //   ],
        // )),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: StreamBuilder(
            stream: Firestore.instance.collection('cafes').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("Loading...");
              } else {
                return GridView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    String image =
                        snapshot.data.documents[index].data['image'].toString();
                    String cafeName =
                        snapshot.data.documents[index].data['name'].toString();
                    String cafeID = snapshot.data.documents[index].documentID;
                    int starsSum = 1;
                    int reviewsCount = 1;
                    try {
                      starsSum = widget.info.starsAvrage[index];
                      reviewsCount = widget.info.reviewsCount[index];
                    } catch (e) {}

                    double result = starsSum / reviewsCount;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) {
                                return Reviews(
                                  widget.info,
                                  cafeName,
                                  cafeID,
                                  widget.bookingDB,
                                );
                              },
                            ),
                          );
                        },
                        child: GridTile(
                          child: Image.network(
                            image,
                            fit: BoxFit.fill,
                          ),
                          footer: Container(
                            height: 70,
                            child: GridTileBar(
                              backgroundColor: Colors.black87,
                              leading: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.star,
                                    color: result >= 1
                                        ? Colors.yellow
                                        : Colors.grey,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: result >= 1.7
                                        ? Colors.yellow
                                        : Colors.grey,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: result >= 2.7
                                        ? Colors.yellow
                                        : Colors.grey,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: result >= 3.7
                                        ? Colors.yellow
                                        : Colors.grey,
                                  ),
                                  Icon(
                                    Icons.star,
                                    color: result >= 4.7
                                        ? Colors.yellow
                                        : Colors.grey,
                                  ),
                                ],
                              ),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      print(cafeID);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) {
                                            return Reviews(
                                              widget.info,
                                              cafeName,
                                              cafeID,
                                              widget.bookingDB,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                    child: Row(
                                      children: <Widget>[
                                        Text('التعليقات $reviewsCount'),
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Text(
                                          cafeName,
                                          style: TextStyle(
                                              fontFamily: 'topaz',
                                              fontSize: 23),
                                          textAlign: TextAlign.end,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  //Login Function
  void updateListView() async {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    await dbFuture.then((database) {
      Future<List<BookingDB>> noteListFuture = databaseHelper.getLoginList();
      noteListFuture.then((loginList) {
        setState(() {
          this.loginList = loginList;
          this.count = loginList.length;
          if (this.loginList.length == 0) {
            _saveLogin();
          }
        });
      });
    });
  }

  // Save data to database
  void _saveLogin() async {
    int result;

    // Case 2: Insert Operation
    result = await databaseHelper.insertLogin(bookingDB);

    if (result != 0) {
      // Success

      debugPrint('Login Saved Successfully');
    } else {
      // Failure
      debugPrint('Problem Saving Login');
    }
  }

  void _deleteLogin() async {
    int result;
    result = await databaseHelper.deleteLogin();
    if (result != 0) {
      // Success

      debugPrint('deleted Successfully');
    } else {
      // Failure
      debugPrint('Problem delete Login');
    }
  }
}
