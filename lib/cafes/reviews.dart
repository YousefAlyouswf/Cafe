import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_info.dart';

import 'package:intl/intl.dart';

class Reviews extends StatefulWidget {
  final UserInfo info;
  final String cafeName;
  final String cafeID;

  const Reviews({Key key, this.info, this.cafeName, this.cafeID})
      : super(key: key);
  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  List<String> reviews = new List();
  List<int> stars = new List();
  List<String> names = new List();
  List<String> date = new List();
  String rate = '5';
  String review = 'لا تعليق';
  int countStar = 1;
  bool one = true;
  bool two = false;
  bool three = false;
  bool four = false;
  bool five = false;
  IconData starBorder = Icons.star_border;
  IconData star = Icons.star;
  Color starColor = Colors.yellow;
  Color staremptyColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(
            child: Text(
          widget.cafeName,
          style: TextStyle(
              fontFamily: 'arbaeen', fontWeight: FontWeight.bold, fontSize: 28),
        )),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection('cafes')
                    .where('name', isEqualTo: widget.cafeName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Text("لا توجد تعليقات");
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot myreview =
                            snapshot.data.documents[index];
                        reviews = [];
                        stars = [];
                        names = [];
                        date = [];
                        for (var i = myreview['reviews'].length - 1;
                            i >= 0;
                            i--) {
                          reviews
                              .add(myreview['reviews'][i]['review'].toString());
                          stars.add(myreview['reviews'][i]['stars']);
                          names.add(myreview['reviews'][i]['name'].toString());
                          date.add(myreview['reviews'][i]['date'].toString());
                        }

                        return Container(
                          height: height / 1.5,
                          color: Colors.orange,
                          child: ListView.builder(
                            itemCount: reviews.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: <Widget>[
                                            Flexible(
                                              child: Text(
                                                reviews[i],
                                                textAlign: TextAlign.end,
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20,
                                            ),
                                            Column(
                                              children: <Widget>[
                                                Text(
                                                  names[i],
                                                  textAlign: TextAlign.end,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.blue,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(date[i]),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Icon(
                                              Icons.star,
                                              color: stars[i] >= 1
                                                  ? Colors.yellow
                                                  : Colors.grey,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: stars[i] >= 2
                                                  ? Colors.yellow
                                                  : Colors.grey,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: stars[i] >= 3
                                                  ? Colors.yellow
                                                  : Colors.grey,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: stars[i] >= 4
                                                  ? Colors.yellow
                                                  : Colors.grey,
                                            ),
                                            Icon(
                                              Icons.star,
                                              color: stars[i] >= 5
                                                  ? Colors.yellow
                                                  : Colors.grey,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                }),
          ),
          RaisedButton(
            child: Text("تقييم"),
            onPressed: () {
              showModalSheet(context);
            },
          )
        ],
      ),
    );
  }

  void showModalSheet(BuildContext context) {
    final items = [
      {
        "displayName": "Enter value",
        "type": "string",
      },
      {
        "displayName": "Source",
        "type": "list",
        "data": [
          {"id": 1, "displayId": "MO"},
          {"id": 2, "displayId": "AO"},
          {"id": 3, "displayId": "OffNet"}
        ]
      }
    ];

    showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter state) {
            return createBox(context, items, state);
          });
        });
  }

  createBox(
      BuildContext context, List<Map<String, Object>> val, StateSetter state) {
    return SingleChildScrollView(
      child: LimitedBox(
        maxHeight: 450,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildMainDropdown(val, state),
          ],
        ),
      ),
    );
  }

  Expanded buildMainDropdown(
      List<Map<String, Object>> items, StateSetter setState) {
    return Expanded(
      child: Container(
        color: Colors.red,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(196, 153, 198, 0.3),
                      blurRadius: 20,
                      offset: Offset(0, 10)),
                ],
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[200],
                        ),
                      ),
                    ),
                    child: TextField(
                      textAlign: TextAlign.end,
                      onChanged: (val) {
                        setState(() {
                          review = val;
                        });
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'أكتب تعليقك',
                          hintStyle: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          setState(() {
                            one = true;
                            five = false;
                            four = false;
                            three = false;
                            two = false;
                            countStar = 1;
                          });
                        },
                        icon: Icon(
                          one ? star : starBorder,
                          color: one ? starColor : staremptyColor,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (two) {
                              five = false;
                              four = false;
                              three = false;
                              countStar = 2;
                            } else {
                              two = true;
                              countStar = 2;
                            }
                          });
                        },
                        icon: Icon(
                          two ? star : starBorder,
                          color: two ? starColor : staremptyColor,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (three) {
                              four = false;
                              five = false;
                              countStar = 3;
                            } else {
                              three = true;
                              two = true;
                              countStar = 3;
                            }
                          });
                        },
                        icon: Icon(
                          three ? star : starBorder,
                          color: three ? starColor : staremptyColor,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (four) {
                              five = false;
                              countStar = 4;
                            } else {
                              four = true;
                              three = true;
                              two = true;
                              countStar = 4;
                            }
                          });
                        },
                        icon: Icon(
                          four ? star : starBorder,
                          color: four ? starColor : staremptyColor,
                          size: 35,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            if (five) {
                              countStar = 5;
                            } else {
                              five = true;
                              four = true;
                              three = true;
                              two = true;
                              countStar = 5;
                            }
                          });
                        },
                        icon: Icon(
                          five ? star : starBorder,
                          color: five ? starColor : staremptyColor,
                          size: 35,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color.fromRGBO(49, 39, 79, 0.8),
              ),
              child: InkWell(
                onTap: () async {
                  var now = new DateTime.now();
                  var date = new DateFormat("dd-MM-yyyy").format(now);
                  List<Map<String, dynamic>> maplist = [
                    {
                      'name': widget.info.name,
                      'stars': countStar,
                      'review': review,
                      'date': date,
                    },
                  ];
                  Firestore.instance
                      .collection('cafes')
                      .document(widget.cafeID)
                      .updateData({
                    'reviews': FieldValue.arrayUnion(maplist),
                  });
                  Navigator.pop(context);
                },
                splashColor: Colors.red,
                borderRadius: BorderRadius.circular(50),
                child: Center(
                  child: Text(
                    "إرسال",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        padding: EdgeInsets.all(40.0),
      ),
    );
  }
}
