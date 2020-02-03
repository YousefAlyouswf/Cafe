import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cafe/models/booking.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String bookingTable = 'booking';
  String colUserId = 'userid';
  String colUserName = 'userName';
  String colSeatId = 'seatid';
  String colSeatNum = 'seatnum';
  String colCafeId = 'cafeid';
  String colCafeName = 'cafename';
  DatabaseHelper._createInsctance();
  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInsctance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initlizeDatabse();
    }
    return _database;
  }

  Future<Database> initlizeDatabse() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'cafes.db';

    var bookingdb = await openDatabase(path, version: 1, onCreate: _creatDb);
    return bookingdb;
  }

  void _creatDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $bookingTable($colUserId TEXT, $colUserName TEXT, $colSeatId TEXT, $colSeatNum TEXT, $colCafeId TEXT $colCafeName TEXT)');
  }

  //Function to read from database
  Future<List<Map<String, String>>> getBookingMapList() async {
    Database db = await this.database;
    //var result = await db.rawQuery('SELECT * FROM $bookingTable');
    var result = await db.query(bookingTable);
    return result;
  }

  Future<int> insertBooking(Booking booking) async {
    Database db = await this.database;
    var result = await db.insert(bookingTable, booking.toMap());
    return result;
  }

  Future<int> deleteBooking(String userID) async {
    Database db = await this.database;
    var result = await db
        .rawDelete('DELETE FROM $bookingTable WHERE $colUserId= $userID');
    return result;
  }

  Future<List<Booking>> getBooking() async {
    var bookingMapList = await getBookingMapList();
    int count = bookingMapList.length;

    List<Booking> bookingList = List<Booking>();
    for (var i = 0; i < count; i++) {
      bookingList.add(Booking.fromMapObject(bookingMapList[i]));
    }

    return bookingList;
  }
}
