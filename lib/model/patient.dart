import 'package:flutter/material.dart';

class Patient {
  final String _name;
  final Image _photo;
  final DateTime _birthDate;

  Patient(this._name, this._photo, this._birthDate);

  String get name => _name;
  Image get photo => _photo;
  DateTime get birthDate => _birthDate;
}
