import 'package:flutter/material.dart';

class CurvedListItem extends StatelessWidget {
  const CurvedListItem({
    this.name,
    this.time,
    this.icon,
    this.people,
    this.color,
    this.nextColor,
    this.review,
    this.stars,
  });

  final String name;
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
      padding: EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
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
                  Spacer(),
                  Column(
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.black),
                      ),
                      Text(
                        time,
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.person),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  review,
                  style: TextStyle(color: Colors.black),
                  textDirection: TextDirection.rtl,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


