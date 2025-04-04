import 'package:flutter/material.dart';
import 'package:carroselectricos/servicio/api_service.dart';

class CarListScreen extends StatefulWidget {
  final String token;

  const CarListScreen({super.key, required this.token});

  @override
  _CarListScreenState createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  late Future<List<Map<String, dynamic>>> cars;

  @override
  void initState() {
    super.initState();
    cars = ApiService.getCars(widget.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mis Carros Eléctricos')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Token: ${widget.token}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: cars,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar los datos'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No hay carros disponibles'));
                }

                final carList = snapshot.data!;

                return ListView.builder(
                  itemCount: carList.length,
                  itemBuilder: (context, index) {
                    final car = carList[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        leading: const Icon(Icons.electric_car, size: 40),
                        title: Text('Placa: ${car['placa']}'),
                        subtitle: Text('Conductor: ${car['conductor']}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
