import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/user_info.dart';

class Reviews extends StatefulWidget {
  final UserInfo info;
  final String cafeName;

  const Reviews({Key key, this.info, this.cafeName}) : super(key: key);
  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  List<String> reviews = new List();
  List<int> stars = new List();
  List<String> names = new List();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(
            child: Text(
          "تقييم الزوار",
          style: TextStyle(
              fontFamily: 'arbaeen', fontWeight: FontWeight.bold, fontSize: 28),
        )),
      ),
      body: StreamBuilder(
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
                  DocumentSnapshot myreview = snapshot.data.documents[index];
                  reviews = [];
                  stars = [];
                  names = [];
                  for (var i = 0; i < myreview['reviews'].length; i++) {
                    reviews.add(myreview['reviews'][i]['review'].toString());
                    stars.add(myreview['reviews'][i]['stars']);
                    names.add(myreview['reviews'][i]['name'].toString());
                  }
                  return Container(
                    height: height/1.5,
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
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        reviews[i],
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Text(
                                        names[i],
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
    );
  }
}
