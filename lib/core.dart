
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fest_app/utils/db.dart';
import 'entities/Film.dart';


abstract class core {
	static SharedPreferences? sp;

	static initSP () async {
		sp ??= await SharedPreferences.getInstance();
		sp!.setInt('lastUpdate', sp!.getInt('lastUpdate') ?? 1);
	}

	static void enterOnFest(String festID) {

	}

	static unzip(File file, String folder) async => await extractFileToDisk(file.path, folder);

	static getFilms() async => convertData(await db.getFilms(), (j) => Film.fromJSON(j)).cast<Film>();

	static List<dynamic> convertData (List<dynamic> data, Function convert) {
		List<dynamic> convertData = [];
		for (var row in data) { convertData.add(convert(row)); }
		return convertData;
	}
}