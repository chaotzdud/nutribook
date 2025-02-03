import 'package:flutter/material.dart';
import 'package:release/services/database_service.dart';
import 'package:release/common_widgets/custom_app_bar.dart';
import 'package:release/common_widgets/custom_text_field.dart';
import 'package:release/utils/database_constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  final _databaseService = DatabaseService();
  final _searchController = TextEditingController();

  String _selectedEntity = 'User'; // Entidade selecionada (User, Food ou Menu)
  List<dynamic> _entities = []; // Resultados da busca

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Consultar Entidades'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchField(),
            const SizedBox(height: 16),
            _buildEntityDropdown(),
            const SizedBox(height: 16),
            _buildSearchResults(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return CustomTextField(
      controller: _searchController,
      hintText: 'Buscar por nome...',
      onChanged: (_) => _performSearch(), label: '',
    );
  }

  Widget _buildEntityDropdown() {
    return DropdownButton<String>(
      value: _selectedEntity,
      onChanged: (String? newValue) {
        setState(() {
          _selectedEntity = newValue!;
          _clearSearch();
        });
      },
      items: const ['User', 'Food', 'Menu'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildSearchResults() {
    if (_entities.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'Entidade não encontrada',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ),
      );
    }

    return Expanded(
      child: ListView.builder(
        itemCount: _entities.length,
        itemBuilder: (context, index) {
          final entity = _entities[index];
          return _buildEntityTile(entity);
        },
      ),
    );
  }

  Widget _buildEntityTile(dynamic entity) {
    if (_selectedEntity == 'Menu') {
      // Exibição para Menu
      return ListTile(
        title: Text('Usuário: ${entity.userName}'),
        subtitle: Text(
          'Café da Manhã: ${entity.breakfast.map((e) => e.name).join(", ")}\n'
          'Almoço: ${entity.lunch.map((e) => e.name).join(", ")}\n'
          'Jantar: ${entity.dinner.map((e) => e.name).join(", ")}',
          style: const TextStyle(fontSize: 14),
        ),
      );
    }

    return ListTile(
      title: Text(entity['name']),
      subtitle: Text(_selectedEntity == 'User'
          ? 'Nascimento: ${entity['birthDate']}'
          : 'Categoria: ${entity['category']} | Tipo: ${entity['type']}'),
    );
  }

  Future<void> _performSearch() async {
    final query = _searchController.text.trim();

    if (query.isEmpty) {
      _clearSearch();
      return;
    }

    final tableName = _getTableName();
    final results = await _databaseService.fetchAllEntities(
      tableName: tableName,
      orderBy: 'name',
    );

    if (_selectedEntity == 'Menu') {
      final menus = await _databaseService.fetchMenuByUserName(query);
      setState(() {
        _entities = menus != null ? [menus] : []; // Exibe o cardápio se encontrado
      });
    } else {
      setState(() {
        _entities = results
            .where((entity) => entity['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  String _getTableName() {
    if (_selectedEntity == 'User') {
      return Constants.users['tableName']!;
    } else if (_selectedEntity == 'Food') {
      return Constants.foods['tableName']!;
    } else {
      return Constants.menus['tableName']!; // Aqui a tabela de cardápios
    }
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _entities = [];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
