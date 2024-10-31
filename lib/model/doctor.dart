import 'package:flutter/material.dart';

class Doctor {
  final String _name;
  final Image _photo;
  final DateTime _birthDate;

  Doctor(this._name, this._photo, this._birthDate);

  String get name => _name;
  Image get photo => _photo;
  DateTime get birthDate => _birthDate;
}
