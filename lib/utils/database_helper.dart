// import 'package:cafe/models/cart.dart';
// import 'package:sqflite/sqflite.dart';
// import 'dart:async';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:cafe/models/booking.dart';

// class DatabaseHelper {
//   static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
//   static Database _database; // Singleton Database

//   String noteTable = 'note_table1';
//   String colUserID = 'userid';

//   DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

//   factory DatabaseHelper() {
//     if (_databaseHelper == null) {
//       _databaseHelper = DatabaseHelper
//           ._createInstance(); // This is executed only once, singleton object
//     }
//     return _databaseHelper;
//   }

//   Future<Database> get database async {
//     if (_database == null) {
//       _database = await initializeDatabase();
//     }
//     return _database;
//   }

//   Future<Database> initializeDatabase() async {
//     // Get the directory path for both Android and iOS to store database.
//     Directory directory = await getApplicationDocumentsDirectory();
//     String path = directory.path + 'notes.db';

//     // Open/create the database at a given path
//     var notesDatabase =
//         await openDatabase(path, version: 1, onCreate: _createDb);
//     return notesDatabase;
//   }

//   void _createDb(Database db, int newVersion) async {
//     await db.execute('CREATE TABLE $noteTable($colUserID TEXT )');
//     await db.execute('CREATE TABLE login($colUserID TEXT )');
//     await db.execute(
//         'CREATE TABLE cart($colUserID TEXT, ordername TEXT, price TEXT, orderid INTEGER PRIMARY KEY AUTOINCREMENT)');
//   }

//   // Fetch Operation: Get all note objects from database
//   Future<List<Map<String, dynamic>>> getNoteMapList() async {
//     Database db = await this.database;

// //		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
//     var result = await db.query(noteTable);
//     return result;
//   }

//   // Insert Operation: Insert a Note object to database
//   Future<int> insertNote(BookingDB note) async {
//     Database db = await this.database;
//     var result = await db.insert(noteTable, note.toMap());
//     return result;
//   }

//   // Delete Operation: Delete a Note object from database
//   Future<int> deleteNote() async {
//     var db = await this.database;
//     int result = await db.rawDelete('DELETE FROM $noteTable');
//     return result;
//   }

//   // Get number of Note objects in database
//   Future<int> getCount() async {
//     Database db = await this.database;
//     List<Map<String, dynamic>> x =
//         await db.rawQuery('SELECT COUNT (*) from $noteTable');
//     int result = Sqflite.firstIntValue(x);
//     return result;
//   }

//   // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
//   Future<List<BookingDB>> getNoteList() async {
//     var noteMapList = await getNoteMapList(); // Get 'Map List' from database
//     int count =
//         noteMapList.length; // Count the number of map entries in db table

//     List<BookingDB> noteList = List<BookingDB>();
//     // For loop to create a 'Note List' from a 'Map List'
//     for (int i = 0; i < count; i++) {
//       noteList.add(BookingDB.fromMapObject(noteMapList[i]));
//     }

//     return noteList;
//   }

//   //User Login -------------------------------------------------

//   // Fetch Operation: Get all note objects from database
//   Future<List<Map<String, dynamic>>> getLoginMapList() async {
//     Database db = await this.database;

// //		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
//     var result = await db.query("login");
//     return result;
//   }

//   // Insert Operation: Insert a Note object to database
//   Future<int> insertLogin(BookingDB note) async {
//     Database db = await this.database;
//     var result = await db.insert("login", note.toMap());
//     return result;
//   }

//   // Delete Operation: Delete a Note object from database
//   Future<int> deleteLogin() async {
//     var db = await this.database;
//     int result = await db.rawDelete('DELETE FROM login');
//     return result;
//   }

//   // Get number of Note objects in database
//   Future<int> getLoginCount() async {
//     Database db = await this.database;
//     List<Map<String, dynamic>> x =
//         await db.rawQuery('SELECT COUNT (*) from login');
//     int result = Sqflite.firstIntValue(x);
//     return result;
//   }

//   // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
//   Future<List<BookingDB>> getLoginList() async {
//     var noteMapList = await getLoginMapList(); // Get 'Map List' from database
//     int count =
//         noteMapList.length; // Count the number of map entries in db table

//     List<BookingDB> noteList = List<BookingDB>();
//     // For loop to create a 'Note List' from a 'Map List'
//     for (int i = 0; i < count; i++) {
//       noteList.add(BookingDB.fromMapObject(noteMapList[i]));
//     }

//     return noteList;
//   }

//   //User Cart -------------------------------------------------

//   // Fetch Operation: Get all note objects from database
//   Future<List<Map<String, dynamic>>> getCartMapList() async {
//     Database db = await this.database;

// //		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
//     var result = await db.query("cart");
//     return result;
//   }

//   // Insert Operation: Insert a Note object to database
//   Future<int> insertCart(Cart note) async {
//     Database db = await this.database;
//     var result = await db.insert("cart", note.toMap());
//     return result;
//   }

//   // Delete Operation: Delete a Note object from database
//   Future<int> deleteCart(int orderid) async {
//     var db = await this.database;
//     int result = await db.rawDelete('DELETE FROM cart WHERE orderid = $orderid');
//     return result;
//   }

//   // Get number of Note objects in database
//   Future<int> getCartCount() async {
//     Database db = await this.database;
//     List<Map<String, dynamic>> x =
//         await db.rawQuery('SELECT COUNT (*) from cart');
//     int result = Sqflite.firstIntValue(x);
//     return result;
//   }

//   // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
//   Future<List<Cart>> getCartList() async {
//     var noteMapList = await getCartMapList(); // Get 'Map List' from database
//     int count =
//         noteMapList.length; // Count the number of map entries in db table

//     List<Cart> noteList = List<Cart>();
//     // For loop to create a 'Note List' from a 'Map List'
//     for (int i = 0; i < count; i++) {
//       noteList.add(Cart.fromMapObject(noteMapList[i]));
//     }

//     return noteList;
//   }
// }
