
import 'dart:async';
import 'dart:io';

import 'package:fest_app/entities/Film.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:fest_app/utils/api.dart';
import 'package:fest_app/core.dart';
import 'package:fest_app/utils/db.dart';

import 'package:path/path.dart' as path;

class MainPage extends StatefulWidget {
	const MainPage({Key? key}) : super(key: key);

	@override
	_MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

	List<Film> films = [];
	String loadBtn = 'Войти на фестиваль';
	String appDir = '';

	@override
	Widget build(BuildContext context) =>
		Scaffold(
			appBar: AppBar(title: Text('FestApp')),
			body: Column(
				children: [
					ElevatedButton(onPressed: () => _startLoadZIP(), child: Text(loadBtn)),
					ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/qr'), child: Text('Сканировать QRCode')),
					ElevatedButton(onPressed: () => _removeFestFile() , child: Text('Выйти с фестиваля')),
					Visibility(
						visible: films.isEmpty,
						child: const Text('Список фильмов пуст! войдите на фестиваль')
					),
					Expanded(
						child: ListView.builder(
							itemCount: films.length,
							itemBuilder: (c, i) => ListTile(
								leading: appDir.isEmpty ? null : Image.file(File(path.join(appDir, 'data', 'suzdal2022', 'img', 'films', '${films[i].img}_preview.jpg'))),
								title: Text(films[i].name),
							)))
				]
			)
		);

	void _startLoadZIP() async {
		appDir = (await getApplicationDocumentsDirectory()).path;
		String festDir = path.join(appDir, 'data', 'suzdal2022');
		String dbPath = path.join(festDir, 'app.db');

		if (await File(dbPath).exists()) {
			debugPrint('${await File(dbPath).length()}');
			db.init(dbPath);



			films = await core.getFilms();
		} else {
			setState(() { loadBtn = 'Загрузка...'; });

			int i = 1;

			Timer t = Timer.periodic(Duration(milliseconds: 500), (timer) {
				setState(() { loadBtn = 'Загрузка${i % 3 == 0 ? '...' : i % 2 == 0 ? '..' : '.'}'; i++;});
			});


			File? file = await api.getFestivalZIP();

			t.cancel();

			if (file == null)
				loadBtn = 'Ошибка при загрузке!';
			else {
				loadBtn = 'Получилось!  размер - ${await file.length()}';
				await core.unzip(file, festDir);

				db.init(dbPath);

				films = await core.getFilms();
			}
		}

		setState(() {});
	}

	void _removeFestFile() async {
		await Directory(path.join(appDir, 'data', 'suzdal2022')).delete(recursive: true);
		loadBtn = 'Войти на фестиваль';
		films = [];
		setState(() {});
	}
}