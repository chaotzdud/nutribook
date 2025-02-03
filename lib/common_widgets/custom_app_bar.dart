import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  
  const CustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Colors.blue, // Cor do AppBar
      elevation: 4.0, // Sombra sutil
      centerTitle: true, // Centraliza o título
      actions: const [
        // Aqui você pode adicionar ações, como ícones de configurações, etc.
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight); // Tamanho do AppBar
}
