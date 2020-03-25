import 'package:cafe/cafes/Review_seat/widgets/selected_widgets/widgets/cancle.dart';
import 'package:cafe/cafes/Review_seat/widgets/selected_widgets/widgets/drinks_button.dart';
import 'package:cafe/cafes/Review_seat/widgets/selected_widgets/widgets/food_button.dart';
import 'package:cafe/cafes/Review_seat/widgets/selected_widgets/widgets/hookah_button.dart';
import 'package:cafe/cafes/Review_seat/widgets/selected_widgets/widgets/ring_button.dart';
import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/loading/loading.dart';
import 'dart:io' show Platform;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectedWidgets extends StatefulWidget {
  bool hasBookinginSelected;
  final String seatnum;
  final String cafeName;
  final String reservation;
  final String phone;
  TabController _controller;
  SelectedWidgets(
    this.hasBookinginSelected,
    this.seatnum,
    this.cafeName,
    this.reservation,
    this._controller,
    this.phone,
  );

  @override
  _SelectedWidgetsState createState() => _SelectedWidgetsState();
}

// with SingleTickerProviderStateMixin
class _SelectedWidgetsState extends State<SelectedWidgets> {
  String reserveCafe;

  bool pressed = false;

  //------------------
  // need service
  void needService() async {
    List<String> useridList = new List();
    final QuerySnapshot result =
        await Firestore.instance.collection('faham').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      useridList.add(data['userphone']);
    });
    setState(() {
      pressed = false;
    });

    for (var i = 0; i < useridList.length; i++) {
      if (useridList[i] == widget.phone) {
        setState(() {
          pressed = true;
        });
      }
    }
  }

  //---------
  String seatID;

  //Adnroiod ads unit id
  static const adUnitID = "ca-app-pub-6845451754172569/1211921737";
  final _nativeAdMob = NativeAdmob();
  //IOS ads unit id
  static const adUnitIDIOS = "ca-app-pub-6845451754172569/8931463804";
  final _nativeadMobIOS = NativeAdmob();
  String checkIfhasSeat;
  void hasBooked() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      checkIfhasSeat = prefs.getString("seat");
    });
  }

  @override
  void initState() {
    needService();
    super.initState();

    hasBooked();
    if (Platform.isAndroid) {
      _nativeAdMob.initialize(appID: "ca-app-pub-6845451754172569~9603621495");
    } else {
      _nativeadMobIOS.initialize(
          appID: "ca-app-pub-6845451754172569~2955436171");
    }
  }

  @override
  Widget build(BuildContext context) {
    needService();
    double height = MediaQuery.of(context).size.height;
    try {
      return Stack(
        children: <Widget>[
          Align(
            alignment: Alignment(0, -.95),
            child: RingButton(
              pressed,
              needService,
              widget.hasBookinginSelected,
              widget.phone,
              checkIfhasSeat,
            ),
          ),

          Align(
            alignment: Alignment(-.50, -.52),
            child: HooakahButton(
              widget.phone,
              widget.seatnum,
              reserveCafe,
              seatID,
              widget.cafeName,
              height,
            ),
          ),
          Align(
            alignment: Alignment(.50, -.52),
            child: DrinkButtons(
              widget.phone,
              widget.seatnum,
              reserveCafe,
              seatID,
              widget.cafeName,
              height,
            ),
          ),
          Align(
            alignment: Alignment(.50, -.2),
            child: FoodButton(
              widget.phone,
              widget.seatnum,
              reserveCafe,
              seatID,
              widget.cafeName,
              height,
            ),
          ),
          Align(
            alignment: Alignment(-.50, -.2),
            child: CancleButton(needService, widget.cafeName, widget.phone,
                widget.hasBookinginSelected, widget._controller),
          ),

          //------------Here Add Native ads
          Platform.isAndroid
              ? Align(
                  alignment: Alignment(0, .7),
                  child: Container(
                    height: height * .3,
                    child: NativeAdmobBannerView(
                      adUnitID: adUnitID,
                      showMedia: true,
                      style: BannerStyle.dark,
                      contentPadding: EdgeInsets.fromLTRB(9, 8, 8, 8),
                    ),
                  ),
                )
              : Align(
                  alignment: Alignment(0, .7),
                  child: Container(
                    height: height * .3,
                    child: NativeAdmobBannerView(
                      adUnitID: adUnitIDIOS,
                      showMedia: true,
                      style: BannerStyle.dark,
                      contentPadding: EdgeInsets.fromLTRB(9, 8, 8, 8),
                    ),
                  ),
                )
        ],
      );
    } catch (e) {
      return Loading();
    }
  }
}
