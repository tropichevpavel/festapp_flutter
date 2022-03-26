
import 'package:fest_app/pages/qrcodePage.dart';
import 'package:flutter/material.dart';

import 'pages/mainPage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
	const MyApp({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) =>
		MaterialApp(
			routes: {
				'/': (BuildContext context) => const MainPage(),
				'/qr': (BuildContext context) => const QRCodePage(),
			},
			onGenerateRoute: (routeSettings) {
				var path = routeSettings.name!.split('/');

				// if (path[1] == "docs") {
				// 	return MaterialPageRoute(
				// 		builder: (context) => DocPage(int.parse(path[2])),
				// 		settings: routeSettings,
				// 	);
				// }
			},
		);
}
