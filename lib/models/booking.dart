class Booking {
  String _userID;
  String _userName;
  String _seatID;
  String _seatNum;
  String _cafeID;
  String _cafeName;

  Booking(
    this._userID,
    this._userName,
    this._seatID,
    this._seatNum,
    this._cafeID,
    this._cafeName,
  );

  String get userID => _userID;
  String get userName => _userName;
  String get seatID => _seatID;
  String get seatNum => _seatNum;
  String get cafeID => _cafeID;
  String get cafeName => _cafeName;

  set userID(String userID) {
    this._userID = userID;
  }

  set userName(String userName) {
    this._userName = userName;
  }

  set seatID(String seatID) {
    this._seatID = seatID;
  }

  set seatNum(String seatNum) {
    this._seatNum = seatNum;
  }

  set cafeID(String cafeID) {
    this._cafeID = cafeID;
  }

  set cafeName(String cafeName) {
    this._cafeName = cafeName;
  }

//Convert info booking into map object
  Map<String, String> toMap() {
    var map = Map<String, String>();
    map['userID'] = _userID;
    map['userName'] = _userName;
    map['seatID'] = _seatID;
    map['seatNum'] = _seatNum;
    map['cafeID'] = _cafeID;
    map['cafeName'] = _cafeName;

    return map;
  }

  // convert map object to booking String
  Booking.fromMapObject(Map<String, String> map) {
    this._userID = map['userID'];
    this._userName = map['userName'];
    this._seatID = map['seatID'];
    this._seatNum = map['seatNum'];
    this._cafeID = map['cafeID'];
    this._cafeName = map['cafeName'];
  }
}
