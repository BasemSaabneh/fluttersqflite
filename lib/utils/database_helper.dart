import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/employee.dart';

class DatabaseHelper {
  final String tableEmployee = 'employees';
  final String columnId = "id";
  final String columnAge = "age";
  final String columnName = "name";
  final String columnDepartment = "department";
  final String columnCity = "city";
  final String columnDescription = "description";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
  } //Future<Database> get

  initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'employees.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  } //initDb

  void _onCreate(Database db , int newVersion) async{
    var sql = 'CREATE TABLE $tableEmployee ($columnId INTEGER PRIMARY KEY,'
        '$columnAge TEXT,$columnName TEXT,$columnDepartment TEXT,'
        '$columnCity TEXT,$columnDescription TEXT)';
    await db.execute(sql);
  }
  Future<int> saveEmployee(Employee employee) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableEmployee, employee.toMap());
    return result;
  } //saveEmployee

  Future<List> getAllEmployees() async {
    var dbClient = await db;
    var result = await dbClient.query(tableEmployee, columns: [
      columnId,
      columnAge,
      columnName,
      columnDepartment,
      columnCity,
      columnDescription
    ]);
    return result.toList();
  } //getAllEmployees

  Future<int> getEmployeesCount() async {
    var dbClient = await db;
    var sql = 'SELECT COUNT(*) FROM $tableEmployee';
    return Sqflite.firstIntValue(await dbClient.rawQuery(sql));
  } //getEmployeesCount

  Future<Employee> getEmployee(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableEmployee,
        columns: [
          columnId,
          columnAge,
          columnName,
          columnDepartment,
          columnCity,
          columnDescription
        ],
        where: '$columnId = ?',
        whereArgs: ['$id']);

    if (result.length > 0) {
      return new Employee.fromMap(result.first);
    } else {
      return null;
    }
  } //getEmployee

  Future<int> updateEmployee(Employee employee) async {
    var dbClient = await db;
    return await dbClient.update(tableEmployee, employee.toMap(),
        where: '$columnId = ?', whereArgs: [employee.id]);
  } //updateEmployee

  Future<int> deleteEmployee(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableEmployee,
        where: '$columnId = ?', whereArgs: [id]);
  } //deleteEmployee

  Future close(int id) async {
    var dbClient = await db;
    return await dbClient. close();
  } //close


} //DatabaseHelper
