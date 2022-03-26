
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ModalLoader extends StatefulWidget {

	const ModalLoader({Key? key}) : super(key: key);

	@override
	_ModalLoaderState createState() => _ModalLoaderState();
}

class _ModalLoaderState extends State<ModalLoader> {



	@override
	Widget build(BuildContext context) =>
		Dialog(
			child: Row(
				children: [
					Text('Выполныем вход на фестиваль'),
					Text('Скачиваем файлы...'),
					Text(''),
				],
			),
		);
}