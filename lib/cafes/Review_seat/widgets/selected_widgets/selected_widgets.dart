import 'package:cafe/cafes/Review_seat/widgets/selected_widgets/widgets/cancle.dart';
import 'package:cafe/cafes/Review_seat/widgets/selected_widgets/widgets/drinks_button.dart';
import 'package:cafe/cafes/Review_seat/widgets/selected_widgets/widgets/food_button.dart';
import 'package:cafe/cafes/Review_seat/widgets/selected_widgets/widgets/hookah_button.dart';
import 'package:cafe/cafes/Review_seat/widgets/selected_widgets/widgets/ring_button.dart';
import 'package:cafe/firebase/firebase_service.dart';
import 'package:cafe/loading/loading.dart';
import 'package:cafe/models/cart.dart';
import 'package:cafe/models/user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../../utils/database_helper.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';

class SelectedWidgets extends StatefulWidget {
  final UserInfo info;
  bool hasBookinginSelected;
  final Function _delete;
  final String seatnum;
  final String cafeName;
  final String reservation;
  TabController _controller;
  SelectedWidgets(
    this.info,
    this.hasBookinginSelected,
    this._delete,
    this.seatnum,
    this.cafeName,
    this.reservation,
    this._controller,
  );

  @override
  _SelectedWidgetsState createState() => _SelectedWidgetsState();
}

// with SingleTickerProviderStateMixin
class _SelectedWidgetsState extends State<SelectedWidgets> {
  String reserveCafe;

  bool pressed = false;

  //SQL DB----------------
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Cart> cartList = new List();
  int count;
  Cart cart;
  //------------------
  // need service
  void needService() async {
    List<String> useridList = new List();
    final QuerySnapshot result =
        await Firestore.instance.collection('faham').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      useridList.add(data['userid']);
    });
    pressed = false;
    for (var i = 0; i < useridList.length; i++) {
      if (useridList[i] == widget.info.id) {
        pressed = true;
      }
    }
  }

  //---------
  String seatID;
  // countOrderINCart
  int orderCount;
  int cartPrice = 0;
  void countOrderINCart() async {
    orderCount = cartList.length;
    cartPrice = 0;
    for (var i = 0; i < orderCount; i++) {
      cartPrice += int.parse(cartList[i].price);
    }
  }

  void cancleSeat() async {
    //Delete from SQLITE
    widget._delete();

    //Delete faham from firebase
    final QuerySnapshot result =
        await Firestore.instance.collection('faham').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      if (data['userid'] == widget.info.id) {
        String docID = data.documentID;
        Firestore.instance.collection('faham').document(docID).delete();
      }
    });
    //------------
    //Delete cart from firebase
    final QuerySnapshot cartResult =
        await Firestore.instance.collection('cart').getDocuments();
    final List<DocumentSnapshot> documentsCart = cartResult.documents;
    documentsCart.forEach((data) {
      if (data['userid'] == widget.info.id) {
        String docID = data.documentID;
        Firestore.instance.collection('cart').document(docID).delete();
      }
    });
    //----------
    needService();

    SigninFiresotre().calnceBooking(widget.cafeName, widget.info.id,
        widget.info.name, widget.info.phone, widget.seatnum);
    widget.hasBookinginSelected = false;

    SigninFiresotre().cancleupdateUser(widget.info.id);

    Firestore.instance
        .collection('seats')
        .document(widget.cafeName)
        .updateData({
      'allseats': FieldValue.arrayRemove([
        {
          'seat': '',
          'color': 'green',
          'userid': '',
          'username': '',
          'userphone': '',
        }
      ]),
    });
  }

  //Adnroiod ads unit id
  static const adUnitID = "ca-app-pub-6845451754172569/1211921737";
  final _nativeAdMob = NativeAdmob();
  //IOS ads unit id
  static const adUnitIDIOS = "ca-app-pub-6845451754172569/8931463804";
  final _nativeadMobIOS = NativeAdmob();

  // AnimationController animationController;
  // Animation<double> animationHookah;
  // Animation<double> animationDrinks;
  // Animation<double> animationFoods;
  // Animation<double> animationCancle;
  // Animation<double> ringService;

  @override
  void initState() {
    super.initState();
    _nativeAdMob.initialize(appID: "ca-app-pub-6845451754172569~9603621495");
    _nativeadMobIOS.initialize(appID: "ca-app-pub-6845451754172569~2955436171");

    //   animationController = AnimationController(
    //     vsync: this,
    //     duration: Duration(seconds: 2),
    //   );
    //   animationHookah =
    //       Tween<double>(begin: -90, end: 0).animate(animationController)
    //         ..addListener(() {
    //           setState(() {});
    //         });
    //   animationDrinks =
    //       Tween<double>(begin: 90, end: 0).animate(animationController)
    //         ..addListener(() {
    //           setState(() {});
    //         });
    //   animationFoods =
    //       Tween<double>(begin: 5, end: 0).animate(animationController)
    //         ..addListener(() {
    //           setState(() {});
    //         });
    //   animationCancle =
    //       Tween<double>(begin: -5, end: 0).animate(animationController)
    //         ..addListener(() {
    //           setState(() {});
    //         });
    //  ringService = Tween<double>(begin: 1, end: 0).animate(animationController)
    //     ..addListener(() {
    //       setState(() {});
    //     });
    //   animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    needService();
    double height = MediaQuery.of(context).size.height;
    return LayoutBuilder(
      builder: (context, constraints) {
        try {
          return Stack(
            children: <Widget>[
              Align(
                alignment: Alignment(0, -.95),
                child: RingButton(
                  pressed,
                  needService,
                  widget.info.name,
                  widget.info.id,
                  widget.hasBookinginSelected,
                  widget.info.phone,
                  widget._delete,
                ),
              ),

              Align(
                alignment: Alignment(-.50, -.52),
                child: HooakahButton(
                  widget.info.phone,
                  widget.seatnum,
                  reserveCafe,
                  seatID,
                  widget.cafeName,
                  widget._delete,
                  height,
                ),
              ),
              Align(
                alignment: Alignment(.50, -.52),
                child: DrinkButtons(
                  widget.info.phone,
                  widget.seatnum,
                  reserveCafe,
                  seatID,
                  widget.cafeName,
                  widget._delete,
                  height,
                ),
              ),
              Align(
                alignment: Alignment(.50, -.2),
                child: FoodButton(
                  widget.info.phone,
                  widget.seatnum,
                  reserveCafe,
                  seatID,
                  widget.cafeName,
                  widget._delete,
                  height,
                ),
              ),
              Align(
                alignment: Alignment(-.50, -.2),
                child: CancleButton(
                    widget._delete,
                    needService,
                    widget.info.id,
                    widget.cafeName,
                    widget.info.name,
                    widget.info.phone,
                    widget.hasBookinginSelected,
                    widget._controller),
              ),

              //------------Here Add Native ads

              Align(
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
              ),
              Align(
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
      },
    );
  }

  void showModalSheet(BuildContext context) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            return createBox(context, state);
          },
        );
      },
    );
  }

  createBox(BuildContext context, StateSetter state) {
    return SingleChildScrollView(
      child: LimitedBox(
        maxHeight: 370,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            buildMainDropdown(state),
          ],
        ),
      ),
    );
  }

  Expanded buildMainDropdown(StateSetter setState) {
    return Expanded(
      child: Container(
        color: Colors.yellow[100],
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: cartList.length,
                itemBuilder: (context, index) {
                  final cartIndex = cartList[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        title: Text(
                          cartIndex.orderName,
                          textDirection: TextDirection.rtl,
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              cartIndex.price,
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red[300],
                      ),
                      child: InkWell(
                        onTap: () async {
                          Navigator.pop(context);
                        },
                        splashColor: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                        child: Center(
                            child: Text(
                          "مسح الكل",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'topaz',
                              fontSize: 18),
                        )),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: Container(
                      height: 50,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.green[300]),
                      child: InkWell(
                        onTap: () async {
                          List<String> orderNameList = new List();
                          List<String> orderPriceList = new List();

                          for (var i = 0; i < cartList.length; i++) {
                            orderNameList.add(cartList[i].orderName);
                            orderPriceList.add(cartList[i].price);
                          }

                          SigninFiresotre().insertInCart(
                              orderNameList,
                              orderPriceList,
                              widget.cafeName,
                              widget.seatnum,
                              widget.info.name,
                              widget.info.phone);

                          Navigator.pop(context);
                        },
                        splashColor: Colors.red,
                        borderRadius: BorderRadius.circular(5),
                        child: Center(
                            child: Text(
                          "أرسل الطلب",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'topaz',
                              fontSize: 18),
                          textAlign: TextAlign.center,
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // @override
  // void dispose() {
  //   animationController.dispose();
  //   super.dispose();
  // }
}
