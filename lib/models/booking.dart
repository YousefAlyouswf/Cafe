class BookingDB {
  String _userID;

  BookingDB(this._userID);

  String get userID => _userID;

  set userID(String userID) {
    this._userID = userID;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['userid'] = _userID;

    return map;
  }

  // Extract a Note object from a Map object
  BookingDB.fromMapObject(Map<String, dynamic> map) {
    this._userID = map['userid'];
  }
}
