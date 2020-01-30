import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../animation/fadeAnimation.dart';
import '../models/user_info.dart';
import '../seatings.dart';
import 'googlemap.dart';

class CafeList extends StatefulWidget {
  final UserInfo info;

  const CafeList({Key key, this.info}) : super(key: key);
  @override
  _CafeListState createState() => _CafeListState();
}

class _CafeListState extends State<CafeList> {
  bool sort = false;
  String city;
  String filterCity;
  bool check = false;

  //To Show user Info START
  String userID;
  String userName;
  String userPhone;
  String userPassword;
  String booked;
  String seatNum;

  //To Show user Info END
  List<String> cityList = new List();
  List<dynamic> removeDoublicat = new List();
  void getallcity() async {
    cityList = [];
    removeDoublicat = [];
    final QuerySnapshot result =
        await Firestore.instance.collection('cafes').getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    documents.forEach((data) {
      cityList.add(data['city']);
    });
    setState(() {
      removeDoublicat = cityList.toSet().toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getallcity();
  }

  @override
  Widget build(BuildContext context) {
    userID = widget.info.id;
    userName = widget.info.name;
    userPhone = widget.info.phone;
    userPassword = widget.info.password;
    booked = widget.info.booked;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(child: Text("المقاهي")),
      ),
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(""),
            accountEmail: Text(""),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(
                  'https://upload.wikimedia.org/wikipedia/ar/thumb/6/68/General_Entertainment_Authority_Logo.svg/1200px-General_Entertainment_Authority_Logo.svg.png'),
            )),
          ),
          ListTile(
            title: Center(
                child: Text(
              "أختر المدينة",
              style: TextStyle(fontSize: 24),
            )),
            trailing: Icon(Icons.map),
          ),
          Container(
            height: 500,
            child: ListView.builder(
              itemCount: removeDoublicat.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Center(
                    child: ListTile(
                      title: Text(
                        removeDoublicat[index],
                        textAlign: TextAlign.center,
                      ),
                      trailing: Icon(Icons.location_city),
                      onTap: () {
                        setState(() {
                          filterCity = removeDoublicat[index];
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      )),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: Firestore.instance
              .collection('cafes')
              .where('city', isEqualTo: filterCity)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading...");
            } else {
              return GridView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  String image =
                      snapshot.data.documents[index].data['image'].toString();

                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return Seatings(
                              cafeName: snapshot
                                  .data.documents[index].data['name']
                                  .toString(),
                              info: widget.info,
                            );
                          },
                        ),
                      );
                    },
                    onLongPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) {
                            return GoogleMap();
                          },
                        ),
                      );
                    },
                    splashColor: Colors.red,
                    borderRadius: BorderRadius.circular(15),
                    child: FadeAnimation(
                      1,
                      Stack(
                        children: <Widget>[
                          Container(
                            child: Center(),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(image),
                                ),
                                borderRadius: BorderRadius.circular(15)),
                          ),
                          Positioned(
                            top: 87,
                            child: Container(
                              width: 190,
                              color: Colors.grey[200],
                              child: Text(
                                snapshot.data.documents[index].data['name']
                                        .toString() +
                                    " " +
                                    snapshot.data.documents[index].data['city']
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
