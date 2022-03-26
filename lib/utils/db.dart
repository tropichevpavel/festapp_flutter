
import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/services.dart';
// import 'package:milk/entities/Model.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'DateTimeExt.dart';

// ignore: camel_case_types
abstract class db {

	static Database? _db;

	static int get _version => 1;
	static bool get isNull => _db == null;

	static const String _dbName = 'app.db';

	static void init(String dbPath) async {
		if (_db != null) { return; }

		//io.Directory appDict = await getApplicationDocumentsDirectory();

		// String dbPath = path.join(appDict.path, 'data', festID, _dbName);
		//
		// if (!await io.File(dbPath).exists()) {
		// 	ByteData data = await rootBundle.load(path.join('assets', _dbName));
		// 	List<int> bytes = data.buffer.asInt8List(data.offsetInBytes, data.lengthInBytes);
		// 	await io.File(dbPath).writeAsBytes(bytes);
		// }

		_db = await openDatabase(dbPath, version: _version);
	}

	static Future<List<Map<String, dynamic>>> get(String sql) async => await _db!.rawQuery(sql);

	// static Future<int> insert (Model model) async => await _db!.insert(model.table, model.toMapDB());
	// static Future<int> update (Model model) async => await _db!.update(model.table, model.toMapDB(), where: '${model.pk} = ?', whereArgs: [model.id]);
	// static Future<int> delete (Model model) async => await _db!.delete(model.table, where: '${model.pk} = ?', whereArgs: [model.id]);

	static sync(Map<String, dynamic> data) {
		data.forEach((table, rows) async {
			for (var row in (rows as List<dynamic>)) {
				if (row.length > 1) {
					String sql = '';
					String sqlV = '';
					List<dynamic> values = [];

					row.forEach((field, value) {
						sql += ' $field,';

						sqlV += value != null ? ' ?,' : ' NULL,';
						if (value != null) values.add(value);
					});

					sql = sql.substring(0, sql.length - 1);
					sqlV = sqlV.substring(0, sqlV.length - 1);

					await _db!.rawQuery('INSERT OR REPLACE INTO $table($sql) VALUES($sqlV);', values);

				} else if (row.length == 1) {
					await _db!.rawQuery('DELETE FROM $table WHERE ${row.keys.elementAt(0)} = ?;', [row.values.elementAt(0)]);
				}
			}
		});
	}

	static getFilms() => get('SELECT filmID id, filmName name, ffImage img, filmDescription `desc` FROM films JOIN filmFrames ON filmID = filmIDfk;');
	// static getFilms() => get('SELECT name FROM sqlite_schema;');
}
