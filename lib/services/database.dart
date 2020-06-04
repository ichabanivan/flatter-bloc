import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class AuthInfo {
    final List<String> scope;
    final String accessToken;
    final String refreshToken;
    final List<String> resources;
    final List<String> authorities;
    final int accessTokenValiditySeconds;
    final int refreshTokenValiditySeconds;

    AuthInfo({
        this.scope,
        this.resources,
        this.authorities,
        this.accessToken,
        this.refreshToken,
        this.accessTokenValiditySeconds,
        this.refreshTokenValiditySeconds,
    });

    Map<String, dynamic> toMap() {
        final map = Map<String, dynamic>();
        map['scope'] = scope;
        map['resources'] = resources;
        map['authorities'] = authorities;
        map['accessToken'] = accessToken;
        map['refreshToken'] = refreshToken;
        map['accessTokenValiditySeconds'] = accessTokenValiditySeconds;
        map['refreshTokenValiditySeconds'] = refreshTokenValiditySeconds;
        return map;
    }

    factory AuthInfo.fromMap(Map<dynamic, dynamic> map) {
        return AuthInfo(
            scope: map['scope'],
            resources: map['resources'],
            authorities: map['authorities'],
            accessToken: map['accessToken'],
            refreshToken: map['refreshToken'],
            accessTokenValiditySeconds: map['accessTokenValiditySeconds'],
            refreshTokenValiditySeconds: map['refreshTokenValiditySeconds'],
        );
    }
}

class DatabaseService {
    static final DatabaseService instance = DatabaseService._instance();
    static Database _db;

    String table = 'user';

    String colAccessToken = 'accessToken';
    String colRefreshToken = 'refreshToken';

    // Task Tables
    // Id | Title | Date | Priority | Status
    // 0     ''      ''      ''         0
    // 2     ''      ''      ''         0
    // 3     ''      ''      ''         0

    DatabaseService._instance();
    
    Future<Database> get db async {
        if (_db == null) {
            _db = await _initDb();
        }
        return _db;
    }

    Future<Database> _initDb() async {
        Directory dir = await getApplicationDocumentsDirectory();
        String path = dir.path + '/todo_list.db';
        final todoListDb =
        await openDatabase(path, version: 1, onCreate: _createDb);
        return todoListDb;
    }

    void _createDb(Database db, int version) async {
        await db.execute('CREATE TABLE $table($colAccessToken TEXT, $colRefreshToken TEXT)');
    }

    Future<List<Map<String, dynamic>>> getList() async {
        Database db = await this.db;
        final List<Map<String, dynamic>> result = await db.query(table);
        return result;
    }

//    Future<List<Task>> getTaskList() async {
//        final List<Map<String, dynamic>> taskMapList = await getTaskMapList();
//        final List<Task> taskList = [];
//        taskMapList.forEach((taskMap) {
//            taskList.add(Task.fromMap(taskMap));
//        });
//        taskList.sort((taskA, taskB) => taskA.date.compareTo(taskB.date));
//        return taskList;
//    }

    Future<int> insertRecord(AuthInfo data) async {
        Database db = await this.db;
        final int result = await db.insert(table, data.toMap());
        return result;
    }

    Future<int> updateRecord(AuthInfo data) async {
        Database db = await this.db;
        final int result = await db.update(
            table,
            data.toMap(),
            where: '$colAccessToken = ?',
            whereArgs: [data.accessToken],
        );
        return result;
    }

    Future<int> deleteRecord(int id) async {
        Database db = await this.db;
        final int result = await db.delete(
            table,
            where: '$colAccessToken = ?',
            whereArgs: [id],
        );
        return result;
    }
}
