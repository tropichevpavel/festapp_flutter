
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodePage extends StatefulWidget {
	const QRCodePage({Key? key}) : super(key: key);

	@override
	_QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {

	Barcode? result;
	QRViewController? controller;
	final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

	@override
	void reassemble() {
		super.reassemble();
		if (Platform.isAndroid) {
			controller!.pauseCamera();
		}
		controller!.resumeCamera();
	}

	@override
	Widget build(BuildContext context) =>
		Scaffold(
			appBar: AppBar(title: Text('FestApp')),
			body: Column(
				children: [
					Expanded(flex: 4, child: _QRView()),
					Expanded(flex: 1, child: Text(result != null ? 'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}' : 'Scan a code'))
				]
			)
		);

	Widget _QRView() {
		var scanArea = (MediaQuery.of(context).size.width < 400 ||
			MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;

		return QRView(
			key: qrKey,
			onQRViewCreated: _onQRViewCreated,
			overlay: QrScannerOverlayShape(
				borderColor: Colors.red,
				borderRadius: 10,
				borderLength: 30,
				borderWidth: 10,
				cutOutSize: scanArea),
			onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
		);
	}

	void _onQRViewCreated(QRViewController controller) {
		setState(() { this.controller = controller; });
		controller.scannedDataStream.listen((scanData) => setState(() { result = scanData; }));
	}

	void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
		debugPrint('${DateTime.now().toIso8601String()}_onPermissionSet $p');
		if (!p) {
			ScaffoldMessenger.of(context).showSnackBar(
				const SnackBar(content: Text('no Permission')),
			);
		}
	}

	@override
	void dispose() {
		controller?.dispose();
		super.dispose();
	}
}