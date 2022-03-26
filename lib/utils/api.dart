
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

// ignore: camel_case_types
class api {

	// ignore: constant_identifier_names
	static const String GET = 'get', POST = 'post', PUT = 'put', DELETE = 'delete';
	static const String apiURL = 'https://festapp.ru/api/v1';

	static String? festID = 'suzdal2022', token = '';

	static getFestivalZIP() => _downloadFile('https://festcontent.ru/fests/suzdal2022/pack.zip', 'suzdal2022.zip');

	static getDBUpdate(int lastUpdate) => doRequest('$apiURL/sync/$lastUpdate', GET);

	static Future<Map<String, dynamic>> doRequest(String url, String type, {String? body}) async {
		final uri = Uri.parse(url);
		Map<String, String> headers = {};
		if (token != null) {headers.addAll({'X-Authorization': token!});}
		if (body != null) {headers.addAll({'Content-Type': 'application/json'});}

		debugPrint(url);
		if (body != null) debugPrint(body);

		Response response = type == POST ? await http.post(uri, headers: headers, body: body) :
							type == PUT ? await http.put(uri, headers: headers, body: body) :
							type == DELETE ? await http.delete(uri) :
							await http.get(uri);

		debugPrint(response.body);

		if (response.statusCode == 200) {
			return json.decode(response.body);
		}

		Map<String, dynamic> resp = {
			'status': 470,
			'message': 'где то упало'
		};

		return resp;
	}

	static Future<File?> _downloadFile(String url, String filename) async {
		Response response = await http.get(Uri.parse(url));
		if (response.statusCode == 200) {
			File file = File(path.join((await getApplicationDocumentsDirectory()).path, filename));
			await file.writeAsBytes(response.bodyBytes);
			return file;
		}
		return null;
	}
}