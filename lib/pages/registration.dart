import 'package:flutter/material.dart';
import 'package:release/models/food.dart';
import 'package:release/models/menu.dart';
import 'package:release/models/user.dart';
import 'package:release/services/database_service.dart';
import 'package:release/common_widgets/custom_app_bar.dart';
import 'package:release/common_widgets/custom_button.dart';
import 'package:release/common_widgets/multi_select_dialog.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:release/utils/database_constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _databaseService = DatabaseService();
  bool _isLoading = false;

  // Campos de controle
  String? _selectedEntity = 'User';
  String _name = '';
  String _photo = '';
  String? _selectedCategory;
  String? _selectedType;
  String _birthDate = '';

  User? _selectedUser;
  final List<Food> _selectedBreakfastFoods = [];
  final List<Food> _selectedLunchFoods = [];
  final List<Food> _selectedDinnerFoods = [];
  List<User> _users = [];
  List<Food> _foods = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Carregar dados do banco de dados
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final users = await _databaseService.getAllUsers();
      final foods = await _databaseService.getAllFoods();
      setState(() {
        _users = users;
        _foods = foods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showAlert('Erro', 'Erro ao carregar os dados.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Registrar Item'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEntityDropdown(),
                const SizedBox(height: 20),
                ..._buildFormFields(),
                if (_selectedEntity == 'Menu') ..._buildMenuFields(),
                const SizedBox(height: 20),
                CustomButton(
                  label: 'Registrar',
                  onPressed: _register,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dropdown para selecionar tipo de entidade
  Widget _buildEntityDropdown() {
    return DropdownButton<String>(
      value: _selectedEntity,
      onChanged: (String? newValue) {
        setState(() {
          _selectedEntity = newValue!;
          _clearFields();
        });
      },
      items: const ['User', 'Food', 'Menu']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  // Retorna os campos do formulário dependendo da entidade selecionada
  List<Widget> _buildFormFields() {
    if (_selectedEntity == 'User') {
      return _buildUserFields();
    } else if (_selectedEntity == 'Food') {
      return _buildFoodFields();
    }
    return [];
  }

  // Campos para o tipo 'User'
  List<Widget> _buildUserFields() {
    return [
      _buildTextFormField(
        label: 'Nome',
        validatorMessage: 'Nome é obrigatório',
        onSaved: (value) => _name = value!,
      ),
      _buildTextFormField(
        label: 'Foto',
        validatorMessage: 'Foto é obrigatória',
        onSaved: (value) => _photo = value!,
      ),
      _buildTextFormField(
        label: 'Data de Nascimento',
        validatorMessage: 'Data de nascimento é obrigatória',
        onSaved: (value) => _birthDate = value!,
      ),
    ];
  }

  // Campos para o tipo 'Food'
  List<Widget> _buildFoodFields() {
    return [
      _buildTextFormField(
        label: 'Nome do Alimento',
        validatorMessage: 'Nome é obrigatório',
        onSaved: (value) => _name = value!,
      ),
      _buildCategoryDropdown(),
      _buildTypeDropdown(),
    ];
  }

  // Dropdown para selecionar categoria de alimento
  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: const InputDecoration(labelText: 'Categoria'),
      items: const ['Café', 'Almoço', 'Janta']
          .map((category) => DropdownMenuItem(
                value: category,
                child: Text(category),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      validator: (value) => value == null ? 'Selecione uma categoria' : null,
    );
  }

  // Dropdown para selecionar tipo de alimento
  Widget _buildTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedType,
      decoration: const InputDecoration(labelText: 'Tipo'),
      items: const ['Bebida', 'Proteína', 'Carboidrato', 'Fruta', 'Grão']
          .map((type) => DropdownMenuItem(
                value: type,
                child: Text(type),
              ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedType = value;
        });
      },
      validator: (value) => value == null ? 'Selecione um tipo' : null,
    );
  }

  // Campos para o tipo 'Menu'
  List<Widget> _buildMenuFields() {
    return [
      if (_isLoading)
        const Center(child: CircularProgressIndicator())
      else ...[
        _buildUserDropdown(),
        const SizedBox(height: 10),
        _buildMultiSelectDropdown(
          label: 'Café da Manhã',
          selectedFoods: _selectedBreakfastFoods,
        ),
        const SizedBox(height: 10),
        _buildMultiSelectDropdown(
          label: 'Almoço',
          selectedFoods: _selectedLunchFoods,
        ),
        const SizedBox(height: 10),
        _buildMultiSelectDropdown(
          label: 'Jantar',
          selectedFoods: _selectedDinnerFoods,
        ),
      ],
    ];
  }

  // Dropdown para selecionar o usuário
  Widget _buildUserDropdown() {
    return DropdownButton<User>(
      value: _selectedUser,
      hint: const Text('Selecione um Usuário'),
      onChanged: (User? newValue) {
        setState(() {
          _selectedUser = newValue;
        });
      },
      items: _users.map((user) {
        return DropdownMenuItem<User>(
          value: user,
          child: Text(user.name),
        );
      }).toList(),
    );
  }

  // Componente para seleção múltipla de alimentos
  Widget _buildMultiSelectDropdown({
    required String label,
    required List<Food> selectedFoods,
  }) {
    return GestureDetector(
      onTap: () async {
        final selected = await showDialog<List<Food>>(
          context: context,
          builder: (BuildContext context) {
            return MultiSelectDialog(
              allItems: _foods,
              selectedItems: selectedFoods,
              maxSelection: 5,
            );
          },
        );
        if (selected != null) {
          setState(() {
            selectedFoods.clear();
            selectedFoods.addAll(selected);
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        child: Text(
          selectedFoods.isEmpty
              ? 'Nenhum alimento selecionado'
              : selectedFoods.map((food) => food.name).join(', '),
          style: const TextStyle(color: Colors.black54),
        ),
      ),
    );
  }

  // Campo de texto genérico com validação
  Widget _buildTextFormField({
    required String label,
    required String validatorMessage,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      decoration: InputDecoration(labelText: label),
      validator: (value) => value!.isEmpty ? validatorMessage : null,
      onSaved: onSaved,
    );
  }

  // Função para registrar dados
  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedEntity == 'Food') {
        final food = Food(
          name: _name,
          photo: _photo,
          category: _selectedCategory!,
          type: _selectedType!,
        );
        await _databaseService.insertEntity(
          model: food,
          tableName: Constants.foods['tableName']!,
        );
      } else if (_selectedEntity == 'User') {
        final user = User(
          name: _name,
          photo: _photo,
          birthDate: _birthDate,
        );
        await _databaseService.insertEntity(
          model: user,
          tableName: Constants.users['tableName']!,
        );
      } else if (_selectedEntity == 'Menu') {
        if (_selectedUser == null || _selectedBreakfastFoods.isEmpty || _selectedLunchFoods.isEmpty || _selectedDinnerFoods.isEmpty) {
          _showAlert('Erro', 'Todos os campos precisam ser preenchidos.');
          return;
        }
        final menu = Menu(
          userName: _selectedUser!.name,
          breakfast: _selectedBreakfastFoods,
          lunch: _selectedLunchFoods,
          dinner: _selectedDinnerFoods,
        );
        await _databaseService.insertEntity(
          model: menu,
          tableName: Constants.menus['tableName']!,
        );
      }

      Fluttertoast.showToast(msg: 'Registro realizado com sucesso!');
      Navigator.pop(context); // Volta para a SharePage
    }
  }

  // Limpa os campos do formulário
  void _clearFields() {
    _name = '';
    _photo = '';
    _selectedCategory = null;
    _selectedType = null;
    _birthDate = '';
    _selectedUser = null;
    _selectedBreakfastFoods.clear();
    _selectedLunchFoods.clear();
    _selectedDinnerFoods.clear();
  }

  // Função para mostrar alertas
  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
