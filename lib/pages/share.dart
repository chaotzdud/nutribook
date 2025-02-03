import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:release/models/user.dart';
import 'package:release/models/food.dart';
import 'package:release/models/menu.dart';
import 'package:release/services/database_service.dart';
import 'package:release/utils/database_constants.dart';
import 'package:release/common_widgets/custom_app_bar.dart';

class SharePage extends StatefulWidget {
  const SharePage({super.key});

  @override
  SharePageState createState() => SharePageState();
}

class SharePageState extends State<SharePage> {
  final _databaseService = DatabaseService();
  String _selectedEntity = 'User'; // Opções: 'User', 'Food', 'Menu'
  List<dynamic> _entities = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Compartilhar Itens'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEntityDropdown(),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildEntityList(),
          ],
        ),
      ),
    );
  }

  // Dropdown para selecionar a entidade (User, Food ou Menu)
  Widget _buildEntityDropdown() {
    return DropdownButton<String>(
      value: _selectedEntity,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedEntity = newValue;
            _loadEntities();
          });
        }
      },
      items: const ['User', 'Food', 'Menu'].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  // Constrói a lista de entidades carregadas
  Widget _buildEntityList() {
    if (_entities.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            'Nenhuma entidade encontrada',
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

  // Método genérico para construir os tiles das entidades
  Widget _buildEntityTile(dynamic entity) {
    return ListTile(
      title: Text(_getEntityTitle(entity)),
      subtitle: Text(_getEntitySubtitle(entity)),
      trailing: IconButton(
        icon: const Icon(Icons.share),
        onPressed: () => _shareEntity(entity),
      ),
    );
  }

  // Obtém o título da entidade baseado no tipo
  String _getEntityTitle(dynamic entity) {
    if (entity is User) {
      return entity.name;
    } else if (entity is Food) {
      return entity.name;
    } else if (entity is Menu) {
      return 'Menu de ${entity.userName}';
    }
    return 'Entidade desconhecida';
  }

  // Obtém a legenda da entidade baseada no tipo
  String _getEntitySubtitle(dynamic entity) {
    if (entity is User) {
      return 'Nascimento: ${entity.birthDate}';
    } else if (entity is Food) {
      return 'Categoria: ${entity.category} | Tipo: ${entity.type}';
    } else if (entity is Menu) {
      return 'Café: ${entity.breakfast.length} itens | Almoço: ${entity.lunch.length} itens | Jantar: ${entity.dinner.length} itens';
    }
    return 'Informação não disponível';
  }

  // Carrega as entidades do banco de dados com base na seleção
  Future<void> _loadEntities() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final tableName = _getTableName();
      String? orderBy;

      // Ordena apenas para tabelas que possuem a coluna "name"
      if (_selectedEntity == 'User' || _selectedEntity == 'Food') {
        orderBy = 'name';
      }

      final results = await _databaseService.fetchAllEntities(
        tableName: tableName,
        orderBy: orderBy,
      );

      setState(() {
        _entities = results.map((entity) {
          if (_selectedEntity == 'User') {
            return User.fromMap(entity);
          } else if (_selectedEntity == 'Food') {
            return Food.fromMap(entity);
          } else if (_selectedEntity == 'Menu') {
            return Menu.fromMap(entity);
          }
          return null;
        }).whereType<dynamic>().toList();
      });
    } catch (e) {
      _showErrorDialog();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Exibe uma mensagem de erro ao carregar as entidades
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: const Text('Ocorreu um erro ao carregar os dados.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Compartilha a entidade selecionada
  void _shareEntity(dynamic entity) {
    final message = _buildShareMessage(entity);
    Share.share(message);
  }

  // Constrói a mensagem a ser compartilhada com base no tipo de entidade
  String _buildShareMessage(dynamic entity) {
    if (entity is User) {
      return 'Nome: ${entity.name}\nData de Nascimento: ${entity.birthDate}';
    } else if (entity is Food) {
      return 'Nome: ${entity.name}\nCategoria: ${entity.category}\nTipo: ${entity.type}';
    } else if (entity is Menu) {
      final breakfastItems = entity.breakfast.map((food) => food.name).join(', ');
      final lunchItems = entity.lunch.map((food) => food.name).join(', ');
      final dinnerItems = entity.dinner.map((food) => food.name).join(', ');
      return 'Menu de ${entity.userName}:\nCafé da manhã: $breakfastItems\nAlmoço: $lunchItems\nJantar: $dinnerItems';
    }
    return 'Entidade desconhecida';
  }

  // Retorna o nome da tabela com base no tipo de entidade
  String _getTableName() {
    switch (_selectedEntity) {
      case 'User':
        return Constants.users['tableName']!;
      case 'Food':
        return Constants.foods['tableName']!;
      case 'Menu':
        return Constants.menus['tableName']!;
      default:
        throw Exception('Entidade desconhecida');
    }
  }
}
