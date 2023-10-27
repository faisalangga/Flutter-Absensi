import 'dart:io';
import 'package:sas_hima/data/models/employee1.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const tEmployee = 'employee';
  static const tEmployeeFace = 'employeeFace';
  static const cBranch = 'cBranch';
  static const cNik = 'cNik';
  static const cNama = 'cNama';
  static const cFacepoint = 'cFacepoint';
  static const cFacepoint2 = 'cFacepoint2';
  static const cFacepoint3 = 'cFacepoint3';

  //membuat instance Databasehelper sebagai singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static late Database _database;

  Future<Database> get database async {
    _database = await _initDatabase();
    return _database;
  }

  //init path lokasi & membuka db
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  //Metode yang di panggil saat db dibuat pertama kali
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $tEmployee (
            $cBranch TEXT NOT NULL,
            $cNik TEXT PRIMARY KEY,
            $cNama TEXT NOT NULL,
            $cFacepoint TEXT NOT NULL,
            $cFacepoint2 TEXT NOT NULL,
            $cFacepoint3 TEXT NOT NULL
          )
          ''');
  }

  //metode untuk melakukan operasi insert
  Future<int> insert(List<Map<String, dynamic>> data) async {
    Database db = await instance.database;
    int count = 0;
    for (var item in data) {
      int result = await db.insert(tEmployee, item, conflictAlgorithm: ConflictAlgorithm.replace);
      count += result;
    }
    return count;
  }

  Future<List<Employee>> queryAllEmployee() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> employees = await db.query(tEmployee);
    return employees.map((u) => Employee.fromMap(u)).toList();
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(tEmployee);
  }
}