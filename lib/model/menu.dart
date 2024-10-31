import 'package:nutribook/model/food.dart';
import 'package:nutribook/model/patient.dart';

class Menu {
  final Patient _patient;

  var breakfast = <Food>{};
  var lunch = <Food>{};
  var dinner = <Food>{};

  Menu(this._patient);

  String get patientName => _patient.name;

  void addFood(Food food) {
    if (food.category == 'Café da Manhã') breakfast.add(food);
    if (food.category == 'Almoço') lunch.add(food);
    if (food.category == 'Jantar') dinner.add(food);
  }

  void showMenu() {
    breakfast.forEach((element) {
      print(element.name);
    });

    lunch.forEach((element) {
      print(element.name);
    });

    dinner.forEach((element) {
      print(element.name);
    });
  }
}
