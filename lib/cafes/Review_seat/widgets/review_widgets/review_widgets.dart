import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'curvedlistitem.dart';

class ReviewWidgets extends StatelessWidget {

  final String cafeName;

  List reviews;

  List stars;

  List names;

  List date;

  final double height;

  ReviewWidgets( this.cafeName, this.reviews, this.stars,
      this.names, this.date, this.height);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Flexible(
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('cafes')
                .where('name', isEqualTo: cafeName)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text("");
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot myreview = snapshot.data.documents[index];
                    reviews = [];
                    stars = [];
                    names = [];
                    date = [];
                    for (var i = myreview['reviews'].length - 1; i >= 0; i--) {
                      reviews.add(myreview['reviews'][i]['review'].toString());
                      stars.add(myreview['reviews'][i]['stars']);
                      names.add(myreview['reviews'][i]['name'].toString());
                      date.add(myreview['reviews'][i]['date'].toString());
                    }

                    Color currentColor = Colors.black;
                    Color nextColor = Colors.white;

                    return Container(
                      height: height/1.28,
                      child: ListView.builder(
                        itemCount: reviews.length,
                        itemBuilder: (context, i) {
                          return CurvedListItem(
                            name: names[i],
                            time: date[i],
                            review: reviews[i],
                            stars: stars[i],
                            color: i % 2 == 0 ? currentColor : nextColor,
                            nextColor: i % 2 == 1 ? currentColor : nextColor,
                          );
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
