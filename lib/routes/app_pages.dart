import 'package:release/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:release/pages/registration.dart';
import 'package:release/pages/home.dart';
import 'package:release/pages/search.dart';
import 'package:release/pages/share.dart';

import 'app_routes.dart';

class AppPages {
  /// Gera as rotas da aplicação com base no nome fornecido.
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routes = <String, WidgetBuilder>{
      AppRoutes.loginPage: (_) => const LoginPage(),
      AppRoutes.homePage: (_) => const HomePage(),
      AppRoutes.registerPage: (_) => const RegisterPage(),
      AppRoutes.searchPage: (_) => const SearchPage(),
      AppRoutes.sharePage: (_) => const SharePage(),
      // AppRoutes.creditsPage: (_) => const CreditsPage(),
      AppRoutes.logoutPage: (_) => const LoginPage(), // Verificar se faz sentido ter o mesmo widget.
    };

    // Retorna a rota correspondente ou nula se não encontrada.
    final pageBuilder = routes[settings.name];
    if (pageBuilder != null) {
      return MaterialPageRoute(builder: pageBuilder);
    }

    // Retorna nulo para rotas desconhecidas.
    return null;
  }
}
