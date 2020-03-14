import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String orderName;
  final String orderPrice;

  const OrderCard(this.orderName, this.orderPrice);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
              child: Text(
                orderName,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
          Text(
            orderPrice + " ريال",
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }
}
