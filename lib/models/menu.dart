import 'dart:convert';

import 'package:release/utils/map_convertion.dart';
import 'package:release/models/food.dart';

class Menu implements MapConvertion {
  final String userName;
  final List<Food> breakfast;
  final List<Food> lunch;
  final List<Food> dinner;

  Menu({
    required this.userName,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  /// Converte o objeto em um mapa para salvar no banco de dados
  @override
  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'breakfast': jsonEncode(breakfast.map((food) => food.toMap()).toList()),
      'lunch': jsonEncode(lunch.map((food) => food.toMap()).toList()),
      'dinner': jsonEncode(dinner.map((food) => food.toMap()).toList()),
    };
  }

  /// Cria um objeto `Menu` a partir de um mapa, decodificando as listas JSON
  factory Menu.fromMap(Map<String, dynamic> map) {
    return Menu(
      userName: map['userName'] as String,
      breakfast: _decodeFoodList(map['breakfast'] as String?),
      lunch: _decodeFoodList(map['lunch'] as String?),
      dinner: _decodeFoodList(map['dinner'] as String?),
    );
  }

  /// Função auxiliar para decodificar uma lista de alimentos a partir de JSON
  static List<Food> _decodeFoodList(String? jsonString) {
    if (jsonString == null || jsonString.isEmpty) return [];
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.map((e) => Food.fromMap(e as Map<String, dynamic>)).toList();
  }
}
