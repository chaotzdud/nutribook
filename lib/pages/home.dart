import 'package:release/common_widgets/home_page_button.dart';
import 'package:flutter/material.dart';
import '../common_widgets/custom_button.dart';
import '../common_widgets/custom_app_bar.dart';
import '../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Home Page'),
      body: Center(
        child: _buildButtonList(context),
      ),
    );
  }

  Widget _buildButtonList(BuildContext context) {
    const buttons = [
      HomePageButton(label: 'Registrar Item', route: AppRoutes.registerPage),
      HomePageButton(label: 'Consultar Item', route: AppRoutes.searchPage),
      HomePageButton(label: 'Compartilhar Item', route: AppRoutes.sharePage),
      HomePageButton(label: 'Créditos', route: AppRoutes.creditsPage),
      HomePageButton(label: 'Sair', route: AppRoutes.logoutPage),
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Bem-vindo ao NutriBook',
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(height: 20),
        ...buttons.map((button) => _buildButton(button, context)),
      ],
    );
  }

  Widget _buildButton(HomePageButton button, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: CustomButton(
        label: button.label,
        onPressed: () => Navigator.pushNamed(context, button.route),
      ),
    );
  }
}

