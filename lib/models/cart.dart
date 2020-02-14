class Cart {
  String _userID;
  String _orderName;
  String _price;
  int _orderID;
  Cart(this._userID, this._orderName, this._price);

  String get userID => _userID;
  String get orderName => _orderName;
  String get price => _price;
  int get orderID => _orderID;

  set userID(String userID) {
    this._userID = userID;
  }

  set orderName(String orderName) {
    this._orderName = orderName;
  }

  set price(String price) {
    this._price = price;
  }

  set orderID(int orderID) {
    this._orderID = orderID;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    map['userid'] = _userID;
    map['ordername'] = _orderName;
    map['price'] = _price;
    map['orderid'] = _orderID;

    return map;
  }

  // Extract a Note object from a Map object
  Cart.fromMapObject(Map<String, dynamic> map) {
    this._userID = map['userid'];
    this._orderName = map['ordername'];
    this._price = map['price'];
    this._orderID = map['orderid'];
  }
}
