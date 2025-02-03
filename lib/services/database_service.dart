import 'dart:convert';

// import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:release/models/food.dart';
import 'package:release/models/menu.dart';
import 'package:release/models/user.dart';

import 'package:release/utils/database_constants.dart';
import 'package:release/utils/map_convertion.dart';

class DatabaseService {
  static Database? _database;

  /// Retorna a instância do banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  /// Inicializa o banco de dados
  Future<Database> _initializeDatabase() async {
    final path = join(await getDatabasesPath(), Constants.databaseName);
    return openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  /// Criação das tabelas do banco de dados
  Future<void> _createTables(Database db, int version) async {
    await Future.wait([
      db.execute(Constants.users['createTable']!),
      db.execute(Constants.foods['createTable']!),
      db.execute(Constants.menus['createTable']!), // Tabela de menus
    ]);
  }

  /// Verifica se uma entidade com o nome fornecido já existe
  Future<bool> entityExists({
    required String name,
    required String tableName,
  }) async {
    final db = await database;
    final result = await db.query(
      tableName,
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty;
  }

  /// Insere uma nova entidade no banco de dados
  Future<void> insertEntity({
    required MapConvertion model,
    required String tableName,
  }) async {
    final db = await database;
    await db.insert(
      tableName,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Retorna todas as entidades de uma tabela específica
  Future<List<Map<String, dynamic>>> fetchAllEntities({
    required String tableName,
    String? orderBy,
  }) async {
    final db = await database;
    return db.query(tableName, orderBy: orderBy);
  }

  /// Atualiza uma entidade existente
  Future<void> updateEntity({
    required MapConvertion model,
    required String tableName,
    required String idColumn,
    required dynamic idValue,
  }) async {
    final db = await database;
    await db.update(
      tableName,
      model.toMap(),
      where: '$idColumn = ?',
      whereArgs: [idValue],
    );
  }

  /// Deleta uma entidade do banco de dados
  Future<void> deleteEntity({
    required String tableName,
    required String idColumn,
    required dynamic idValue,
  }) async {
    final db = await database;
    await db.delete(
      tableName,
      where: '$idColumn = ?',
      whereArgs: [idValue],
    );
  }

  /// Busca todos os usuários
  Future<List<User>> getAllUsers() async {
    final db = await database;
    final result = await db.query(Constants.users['tableName']!);
    return result.map((userMap) => User.fromMap(userMap)).toList();
  }

  /// Busca todos os alimentos
  Future<List<Food>> getAllFoods() async {
    final db = await database;
    final result = await db.query(Constants.foods['tableName']!);
    return result.map((foodMap) => Food.fromMap(foodMap)).toList();
  }

  /// Busca o cardápio de um usuário pelo nome
  Future<Menu?> fetchMenuByUserName(String userName) async {
    final db = await database;
    final result = await db.query(
      Constants.menus['tableName']!,
      where: 'userName = ?',
      whereArgs: [userName],
    );

    if (result.isNotEmpty) {
      final menuData = result.first;

      // Converte os dados JSON para listas corretamente
      List<Food> parseFoodList(String? jsonString) {
        if (jsonString == null || jsonString.isEmpty) return [];
        final List<dynamic> decodedList = jsonDecode(jsonString);
        return decodedList
            .map((foodMap) => Food.fromMap(Map<String, dynamic>.from(foodMap)))
            .toList();
      }

      return Menu(
        userName: menuData['userName'] as String,
        breakfast: parseFoodList(menuData['breakfast'] as String?),
        lunch: parseFoodList(menuData['lunch'] as String?),
        dinner: parseFoodList(menuData['dinner'] as String?),
      );
    }
    return null;
  }

  /// Salva um novo cardápio no banco de dados
  Future<void> saveMenu(Menu menu) async {
    final db = await database;
    await db.insert(
      Constants.menus['tableName']!,
      {
        'userName': menu.userName,
        'breakfast': jsonEncode(menu.breakfast.map((food) => food.toMap()).toList()),
        'lunch': jsonEncode(menu.lunch.map((food) => food.toMap()).toList()),
        'dinner': jsonEncode(menu.dinner.map((food) => food.toMap()).toList()),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
