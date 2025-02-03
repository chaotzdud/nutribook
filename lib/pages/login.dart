import 'package:release/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:release/common_widgets/custom_button.dart';
import 'package:release/common_widgets/custom_text_field.dart';
import 'package:release/services/database_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>(); 
  final TextEditingController _nameController = TextEditingController(); 
  final DatabaseService _databaseService = DatabaseService(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela de Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _nameController,
                hintText: 'Digite seu nome',
                label: 'Nome',
                onChanged: (value) {},
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: 'Entrar',
                onPressed: _login,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _login() async {
  if (_formKey.currentState!.validate()) {
    String userName = _nameController.text;

    bool userExists = await _databaseService.entityExists(name: userName, tableName: 'users');

    if (userExists) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bem-vindo, $userName')));
      Navigator.pushReplacementNamed(context, AppRoutes.homePage); // Mudança aqui para AppRoutes.homePage
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuário não encontrado!')));
    }
  }
}
}
