import 'package:flutter/material.dart';

class Food {
  final String _name;
  final Image _photo;
  final String _category;
  final String _type;

  Food(this._name, this._photo, this._category, this._type);

  String get name => _name;
  Image get photo => _photo;
  String get category => _category;
  String get type => _type;
}
