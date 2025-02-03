import 'package:release/models/food.dart';
import 'package:flutter/material.dart';

class MultiSelectDialog extends StatefulWidget {
  final List<Food> allItems;
  final List<Food> selectedItems;
  final int maxSelection;

  const MultiSelectDialog({
    super.key,
    required this.allItems,
    required this.selectedItems,
    required this.maxSelection,
  });

  @override
  MultiSelectDialogState createState() => MultiSelectDialogState();
}

class MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<Food> _availableItems;
  late List<Food> _selectedItems;

  @override
  void initState() {
    super.initState();
    _availableItems = widget.allItems;
    _selectedItems = List.from(widget.selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Selecione os Alimentos"),
      content: SingleChildScrollView(
        child: ListBody(
          children: _availableItems.map((Food food) {
            return CheckboxListTile(
              value: _selectedItems.contains(food),
              title: Text(food.name),
              onChanged: (bool? isSelected) {
                setState(() {
                  if (isSelected == true) {
                    if (_selectedItems.length < widget.maxSelection) {
                      _selectedItems.add(food);
                    }
                  } else {
                    _selectedItems.remove(food);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text("Cancelar"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: const Text("Confirmar"),
          onPressed: () {
            Navigator.pop(context, _selectedItems);
          },
        ),
      ],
    );
  }
}

