import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/api_service.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController cameraController = MobileScannerController();
  bool _isScanning = true;

  void _onDetect(Barcode barcode, MobileScannerArguments? args) async {
    if (!_isScanning) return;

    final String? code = barcode.rawValue;
    if (code != null) {
      setState(() => _isScanning = false);

      try {
        final auto = await ApiService.getCarroPorId(code);

        _mostrarAlerta(
          '¿Desea tomar el carro ${auto['placa']}?',
          'Conductor: ${auto['conductor']}',
        );
      } catch (e) {
        _mostrarAlerta('Error', 'No se encontró un carro con el código: $code');
      }
    }
  }

  void _mostrarAlerta(String titulo, String mensaje) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(titulo),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // cerrar escáner
            },
            child: const Text("Sí"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _isScanning = true);
              cameraController.resumeCamera();
            },
            child: const Text("No"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear QR')),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: cameraController,
              onDetect: _onDetect,
            ),
          ),
        ],
      ),
    );
  }
}
