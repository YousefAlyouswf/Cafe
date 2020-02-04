class BookingDB {
  int _id;
  String _userID;
  String _seatID;
  String _cafeID;

  BookingDB(this._userID, this._seatID, this._cafeID);

  BookingDB.withId(this._id, this._userID, this._seatID, this._cafeID);

  int get id => _id;

  String get userID => _userID;

  String get seatID => _seatID;

  String get cafeID => _cafeID;

  set userID(String userID) {
    this._userID = userID;
  }

  set seatID(String seatID) {
    this._seatID = seatID;
  }

  set cafeID(String cafeID) {
    this._cafeID = cafeID;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['userid'] = _userID;
    map['seatid'] = _seatID;
    map['cafeid'] = _cafeID;

    return map;
  }

  // Extract a Note object from a Map object
  BookingDB.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._userID = map['userid'];
    this._seatID = map['seatid'];
    this._cafeID = map['cafeid'];
  }
}
