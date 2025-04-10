import 'package:flutter/material.dart';
import '../services/api_service.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  List<dynamic> carros = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    cargarCarros();
  }

  void cargarCarros() async {
    try {
      final lista = await ApiService.getCarros();
      setState(() {
        carros = lista;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Carros')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: carros.length,
              itemBuilder: (context, index) {
                final auto = carros[index];
                return ListTile(
                  leading: const Icon(Icons.electric_car),
                  title: Text('Placa: ${auto['placa']}'),
                  subtitle: Text('Conductor: ${auto['conductor']}'),
                );
              },
            ),
    );
  }
}
