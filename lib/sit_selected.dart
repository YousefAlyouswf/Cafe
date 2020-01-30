import 'package:flutter/material.dart';
import 'models/user_info.dart';
import 'seatings.dart';

class SitSelected extends StatefulWidget {
  final UserInfo info;
  final String cafeName;
  const SitSelected({Key key, this.info, this.cafeName}) : super(key: key);
  @override
  _SitSelectedState createState() => _SitSelectedState();
}

class _SitSelectedState extends State<SitSelected> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return Seatings(
                info: widget.info,
                cafeName: widget.cafeName,
              );
            },
          ),
        ),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("تأكيد الحجز"),
          ),
        ),
        body: Center(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  " مرحبا بك " + widget.info.name,
                  style: TextStyle(fontSize: 25),
                ),
                Text('يمكنك الطلب عن طريق التطبيق ليتم تحظير طلبك'),
                Text("لديك حجز في مقهى:"+widget.cafeName+" جلسة رقم: "+widget.info.booked)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
