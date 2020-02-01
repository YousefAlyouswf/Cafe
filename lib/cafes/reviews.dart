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
                        for (var i = myreview['reviews'].length-1; i >= 0; i--) {
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
              showModalBottomSheet(
                  context: context,
                  builder: (builder) {
                    return Container(
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
                                        hintStyle:
                                            TextStyle(color: Colors.grey)),
                                  ),
                                ),
                                DropdownButton<String>(
                                  value: rate,
                                  onChanged: (String rateSelected) {
                                    setState(() {
                                      rate = rateSelected;
                                    });
                                  },
                                  items: <String>[
                                    '5',
                                    '4',
                                    '3',
                                    '2',
                                    '1'
                                  ].map<DropdownMenuItem<String>>((String val) {
                                    return DropdownMenuItem<String>(
                                      value: val,
                                      child: Row(
                                        children: <Widget>[
                                          Text(
                                            val,
                                            style:
                                                TextStyle(fontFamily: 'topaz'),
                                          ),
                                          SizedBox(
                                            width: 25,
                                          ),
                                          Icon(
                                            Icons.star,
                                            color: Colors.yellow,
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
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
                                var date =
                                    new DateFormat("dd-MM-yyyy").format(now);
                                var timeToOrder = now.millisecondsSinceEpoch;
                                List<Map<String, dynamic>> maplist = [
                                  {
                                    'name': widget.info.name,
                                    'stars': int.parse(rate),
                                    'review': review,
                                    'date': date,
                                    'time': timeToOrder
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
                    );
                  });
            },
          )
        ],
      ),
    );
  }
}
