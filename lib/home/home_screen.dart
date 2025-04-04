import 'package:flutter/material.dart';
import 'package:carroselectricos/servicio/api_service.dart';

class HomeScreen extends StatefulWidget {
  final String token;
  const HomeScreen({super.key, required this.token});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Map<String, dynamic>>> _carList;

  @override
  void initState() {
    super.initState();
    _carList = ApiService.getCars(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Carros Eléctricos')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _carList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error al cargar los datos'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay carros disponibles'));
          }

          final cars = snapshot.data!;
          return ListView.builder(
            itemCount: cars.length,
            itemBuilder: (context, index) {
              final car = cars[index];
              return ListTile(
                title: Text('Placa: ${car['placa']}'),
                subtitle: Text('Conductor: ${car['conductor']}'),
              );
            },
          );
        },
      ),
    );
  }
}
