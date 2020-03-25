import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'order_card.dart';

class DrinkButtons extends StatelessWidget {
  String phone, seatnum, reserveCafe, seatID, cafeName;
  bool hasBookinginSelected;
  double height;
  Color cardColor;
  DrinkButtons(
    this.phone,
    this.seatnum,
    this.reserveCafe,
    this.seatID,
    this.cafeName,
    this.height,
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topRight: Radius.circular(70)),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.grey.withOpacity(0.1), Colors.grey],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () {
                showBottomSheet(
                  context: context,
                  builder: (context) => Column(
                        children: <Widget>[
                          Container(
                            color: Colors.black,
                            child: IconButton(
                                icon: Icon(
                                  Icons.arrow_downward,
                                  color: Colors.white,
                                  size: 25,
                                ),
                                onPressed: () => Navigator.of(context).pop()),
                          ),
                          Expanded(
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.6,
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: StreamBuilder(
                                                stream: Firestore.instance
                                                    .collection('order')
                                                    .where('cafename',
                                                        isEqualTo: cafeName)
                                                    .where('section',
                                                        isEqualTo: 'مشروبات')
                                                    .snapshots(),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return Text("");
                                                  } else {
                                                    return GridView.builder(
                                                      itemCount: snapshot.data
                                                          .documents.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            print(snapshot
                                                                        .data
                                                                        .documents[
                                                                            index]
                                                                        .data[
                                                                    'order'] +
                                                                snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .data['price']);
                                                          },
                                                          child: OrderCard(
                                                            snapshot
                                                                .data
                                                                .documents[
                                                                    index]
                                                                .data['order'],
                                                            snapshot
                                                                .data
                                                                .documents[
                                                                    index]
                                                                .data['price'],
                                                          ),
                                                        );
                                                      },
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount: 3,
                                                        childAspectRatio: 3 / 2,
                                                        crossAxisSpacing: 10,
                                                        mainAxisSpacing: 10,
                                                      ),
                                                    );
                                                  }
                                                }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ));
            },
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Center(
                child: Text(
                  'مشروبات',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontFamily: "topaz"),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
