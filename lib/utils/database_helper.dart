// // import 'package:image_picker/image_picker.dart';
// // ignore_for_file: depend_on_referenced_packages
//
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import '../models/user.dart';
//
// class DatabaseHelper {
//   //single instance creation
//   static DatabaseHelper? _databaseHelper;
//   static Database? _database;
//
//   String userTable = 'user_table';
//   String colId = 'id';
//   String colName = 'name';
//   String colQualification = 'qualification';
//   String colAge = 'age';
//   String colPhone = 'phone';
//   String colDescription = 'description';
//   String colPhoto = 'imagePath';
//
// //named constructor for single instance
//   DatabaseHelper._createInstance();
// // Factory constructor to return the singleton instance
//   factory DatabaseHelper() {
//     _databaseHelper ??= DatabaseHelper._createInstance();
//     return _databaseHelper!;
//   }
// //getter fun
//   Future<Database> get database async {
//     _database ??= await initializeDatabase();
//     return _database!;
//   }
//
//   //initialize db
//
//   Future<Database> initializeDatabase() async {
//     String path = join(await getDatabasesPath(), 'users.db');
//
//     var usersDatabase =
//     await openDatabase(path, version: 1, onCreate: _createDb,);
//     return usersDatabase;
//   }
//
//   void _createDb(Database db, int newVersion) async {
//     await db.execute(
//         'CREATE TABLE $userTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, '
//             '$colName TEXT , $colQualification TEXT, $colAge INTEGER, '
//             '$colPhone INTEGER, $colDescription TEXT, $colPhoto TEXT)');
//   }
//
// //read
//   Future<List<Map<String, dynamic>>> getUserMapList() async {
//     Database db = await database;
//     var result = await db.query(userTable, orderBy: '$colId ASC');
//     return result;
//   }
//   Future<List<User>> getUserList() async {
//     var userMapList = await getUserMapList();
//     int count = userMapList.length;
//
//     List<User> userList = [];
//     for (int i = 0; i < count; i++) {
//       userList.add(User.fromMapObject(userMapList[i]));
//     }
//
//     return userList;
//   }
//
// //create
//   Future<int> insertUser(User user) async {
//     Database db = await database;
//     var result = await db.insert(userTable, user.toMap());
//     return result;
//   }
//
//   Future<int> updateUser(User user) async {
//     Database db = await database;
//     var result = await db.update(userTable, user.toMap(),
//         where: '$colId = ?', whereArgs: [user.id]);
//     return result;
//   }
//
//   Future<int> deleteUser(int id) async {
//     Database db = await database;
//     var result =
//     await db.rawDelete('DELETE FROM $userTable WHERE $colId = $id');
//     return result;
//   }
// }
