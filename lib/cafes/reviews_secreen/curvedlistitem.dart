import 'package:flutter/material.dart';

class CurvedListItem extends StatelessWidget {
  const CurvedListItem({
    this.title,
    this.time,
    this.icon,
    this.people,
    this.color,
    this.nextColor,
    this.review, this.stars,
  });

  final String title;
  final String time;
  final String people;
  final IconData icon;
  final Color color;
  final Color nextColor;
  final String review;
  final int stars;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: nextColor,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(80.0),
          ),
        ),
        padding: const EdgeInsets.only(
          left: 32,
          top: 80.0,
          bottom: 50,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
          
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        review,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: nextColor, fontSize: 15),
                      ),
                    ),
                    color: color,
                  ),
                  Row(children: <Widget>[
                      Icon(
              Icons.star,
              color: stars >= 1 ? Colors.yellow : Colors.grey,
            ),
            Icon(
              Icons.star,
              color: stars >= 2 ? Colors.yellow : Colors.grey,
            ),
            Icon(
              Icons.star,
              color: stars >= 3 ? Colors.yellow : Colors.grey,
            ),
            Icon(
              Icons.star,
              color: stars >= 4 ? Colors.yellow : Colors.grey,
            ),
            Icon(
              Icons.star,
              color: stars >= 5 ? Colors.yellow : Colors.grey,
            ),
                  ],)
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      title,
                      style: TextStyle(
                          color: nextColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                    Text(
                      time,
                      style: TextStyle(color: nextColor, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        
                      ],
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
