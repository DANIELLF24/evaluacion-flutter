import 'package:flutter/material.dart';
import 'package:carroselectricos/servicio/api_service.dart';
import 'package:carroselectricos/screen/car_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = '';

  Future<void> login() async {
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();
    
    String? token = await ApiService.login(username, password);
    
    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CarListScreen(token: token)),
      );
    } else {
      setState(() {
        errorMessage = 'Usuario o contraseña incorrectos';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: login,
              child: const Text('Ingresar'),
            ),
            if (errorMessage.isNotEmpty) 
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(errorMessage, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
